//
//  ViewController.m
//  FlickrSearch
//
//  Created by James Valaitis on 06/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "Flickr.h"
#import "FlickrCell.h"
#import "FlickrPhoto.h"
#import "FlickrPhotoController.h"
#import "FlickrPhotoHeader.h"
#import "MainController.h"
#import "SimpleFlowLayout.h"

#define FlickrCellID					@"FlickrCell"
#define FlickrPhotoHeaderID				@"FlickrPhotoHeader"

@interface MainController () <MFMailComposeViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet	UICollectionView				*collectionView;
@property (nonatomic, weak) IBOutlet	UISegmentedControl				*layoutSegmentedControl;
@property (nonatomic, weak) IBOutlet	UIBarButtonItem					*shareButton;
@property (nonatomic, weak) IBOutlet	UITextField						*textField;
@property (nonatomic, weak) IBOutlet	UIToolbar						*toolbar;

@property (nonatomic, strong)			Flickr							*flickr;
@property (nonatomic, strong)			UICollectionViewFlowLayout		*layoutOne;
@property (nonatomic, strong)			SimpleFlowLayout				*layoutTwo;
@property (nonatomic, strong)			UILongPressGestureRecognizer	*longPressGestureRecogniser;
@property (nonatomic, strong)			NSMutableArray					*searches;
@property (nonatomic, strong)			NSMutableDictionary				*searchResults;
@property (nonatomic, strong)			NSMutableArray					*selectedPhotos;
@property (nonatomic, assign)			BOOL							sharing;

@end

@implementation MainController

#pragma mark - Action & Selector Methods

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)recogniser
{
	if (recogniser.state == UIGestureRecognizerStateRecognized)
	{
		CGPoint tapPoint				= [recogniser locationInView:self.collectionView];
		NSIndexPath *item				= [self.collectionView indexPathForItemAtPoint:tapPoint];
		
		if (item)
		{
			NSString *searchTerm		= self.searches[item.item];
			[self.searchResults removeObjectForKey:searchTerm];
			
			[self.collectionView performBatchUpdates:
			^{
				[self.collectionView deleteItemsAtIndexPaths:@[item]];
			} completion:nil];
		}
	}
}

- (IBAction)layoutSelectionTapped
{
	switch (self.layoutSegmentedControl.selectedSegmentIndex)
	{
		case 0:
		default:
			self.collectionView.collectionViewLayout	= self.layoutOne;
			[self.collectionView removeGestureRecognizer:self.longPressGestureRecogniser];
			break;
		case 1:
			self.collectionView.collectionViewLayout	= self.layoutTwo;
			[self.collectionView addGestureRecognizer:self.longPressGestureRecogniser];
			break;
		case 2:		break;
		case 3:		break;
	}
	
	[self.collectionView reloadData];
	[self.collectionView setContentOffset:CGPointZero animated:NO];
	
	NSLog(@"View layout is now: %@.", self.collectionView.collectionViewLayout);
}

- (IBAction)shareButtonTapped:(UIBarButtonItem *)shareButton
{
	if (!self.sharing)
	{
		self.sharing					= YES;
		[shareButton setStyle:UIBarButtonItemStyleDone];
		[shareButton setTitle:@"Done"];
		[self.collectionView setAllowsMultipleSelection:YES];
	}
	
	else
	{
		self.sharing					= NO;
		[shareButton setStyle:UIBarButtonItemStyleBordered];
		[shareButton setTitle:@"Share"];
		[self.collectionView setAllowsMultipleSelection:NO];
		
		if (self.selectedPhotos.count)
			[self showMailComposerAndSend];
		
		for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems)
			[self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
		
		[self.selectedPhotos removeAllObjects];
	}
}

#pragma mark - Convenience Methods

- (void)customiseView
{
	self.view.backgroundColor			= [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork"]];
	
	UIImage *navigationBarImage			= [[UIImage imageNamed:@"navbar"] resizableImageWithCapInsets:UIEdgeInsetsMake(27, 27, 27, 27)];
	UIImage *shareButtonImage			= [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
	UIImage *textFieldImage				= [[UIImage imageNamed:@"search_field"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
	
	[self.toolbar setBackgroundImage:navigationBarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
	[self.shareButton setBackgroundImage:shareButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[self.textField setBackground:textFieldImage];
}

- (void)setupLayouts
{
	self.layoutOne						= [[UICollectionViewFlowLayout alloc] init];
	self.layoutOne.scrollDirection		= UICollectionViewScrollDirectionVertical;
	self.layoutOne.headerReferenceSize	= CGSizeMake(0, 90);
	self.layoutTwo						= [[SimpleFlowLayout alloc] init];
	self.layoutTwo.scrollDirection		= UICollectionViewScrollDirectionVertical;
}

- (void)showMailComposerAndSend
{
	if ([MFMailComposeViewController canSendMail])
	{
		MFMailComposeViewController *mailComposer;
		mailComposer					= [[MFMailComposeViewController alloc] init];
		
		[mailComposer setMailComposeDelegate:self];
		
		[mailComposer setSubject:@"Check out these Flickr Photos"];
		
		NSMutableString *emailBody		= @"".mutableCopy;
		
		for (FlickrPhoto *flickrPhoto in self.selectedPhotos)
		{
			NSString *url				= [Flickr flickrPhotoURLForFlickrPhoto:flickrPhoto size:@"m"];
			[emailBody appendFormat:@"<div><img src='%@'></div><br />", url];
		}
		
		[mailComposer setMessageBody:emailBody isHTML:YES];
		
		[mailComposer setModalPresentationStyle:UIModalPresentationFormSheet];
		
		[self presentViewController:mailComposer animated:YES completion:nil];
	}
	
	else
	{
		[[[UIAlertView alloc] initWithTitle:@"Mail Failure"
									message:@"Your device doesn't support in-app email."
								   delegate:nil cancelButtonTitle:@"Okay"
						  otherButtonTitles:nil] show];
	}
}

#pragma mark - MFMailComposerViewControllerDelegate Methods

/**
 *	user wants to dismiss the mail composition view
 *
 *	@param	controller					view controller object managing the mail composition view
 *	@param	result						result of user's action
 *	@param	error						if error occurred this object contains the details
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError *)error
{
	[controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource Methods

/**
 *	as the data source we return the cell that corresponds to the specified item in the collection view
 *
 *	@param	collectionView				object representing the collection view requesting this information
 *	@param	indexPath					index path that specifies the location of the item
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	FlickrCell *flickrCell				= [collectionView dequeueReusableCellWithReuseIdentifier:FlickrCellID forIndexPath:indexPath];
	FlickrPhoto *photo;
	
	if (collectionView == self.collectionView)
	{
		if (collectionView.collectionViewLayout == self.layoutTwo)
		{
			NSString *searchTerm		= self.searches[indexPath.item];
			photo						= self.searchResults[searchTerm][0];
		}
		
		else
		{
			NSString *searchTerm		= self.searches[indexPath.section];
			photo						= self.searchResults[searchTerm][indexPath.item];
		}
	}
	
	flickrCell.photo					= photo;
	
	return flickrCell;
}

/**
 *	as the data source we return number of items in the specified section
 *
 *	@param	collectionView				object representing the collection view requesting this information
 *	@param	section						index identifying section in collection view
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView
	 numberOfItemsInSection:(NSInteger)section
{
	if (collectionView == self.collectionView)
	{
		if (collectionView.collectionViewLayout == self.layoutTwo)
			return self.searches.count;
		
		NSString *searchTerm				= self.searches[section];
		return [self.searchResults[searchTerm] count];
	}
	
	else
		return 0;
}

/**
 *	asks the collection view to provide a supplementary view to display in the collection view
 *
 *	@param	collectionView				object representing the collection view requesting this information
 *	@param	kind						the kind of supplementary view to provide
 *	@param	indexPath					index path that specifies the location of the new supplementary view
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
		   viewForSupplementaryElementOfKind:(NSString *)kind
								 atIndexPath:(NSIndexPath *)indexPath
{
	FlickrPhotoHeader *headerView	= [collectionView dequeueReusableSupplementaryViewOfKind:kind
																			 withReuseIdentifier:FlickrPhotoHeaderID
																					forIndexPath:indexPath];
	
	NSString *searchTerm;
	
	if (collectionView == self.collectionView)
		searchTerm					= self.searches[indexPath.section];
	
	[headerView setSearchText:searchTerm];
	
	NSLog(@"Search Term: %@ /n Cell: %@", searchTerm, headerView);
	
	return headerView;
}

/**
 *	returns number of sections in collection view
 *
 *	@param	collectionView				object representing the collection view requesting this information
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	if (collectionView == self.collectionView)
	{
		if (collectionView.collectionViewLayout == self.layoutTwo)
			return 1;
		else
			return self.searches.count;
	}
	
	return 0;
}

#pragma mark - UICollectionViewDelegate Methods

/**
 *	called when the item at the specified index path was deselected
 *
 *	@param	collectionview				collection view object that is notifying us of the selection change
 *	@param	indexPath					index path of the cell that was deselected
 */
- (void)	collectionView:(UICollectionView *)collectionView
didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *searchTerm				= self.searches[indexPath.section];
	FlickrPhoto *photo					= self.searchResults[searchTerm][indexPath.item];
	
	[self.selectedPhotos removeObject:photo];
}


/**
 *	called when the item at the specified index path was selected
 *
 *	@param	collectionview				collection view object that is notifying us of the selection change
 *	@param	indexPath					index path of the cell that was selected
 */
- (void)  collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *searchTerm;
	FlickrPhoto *photo;
	
	if (!self.sharing)
	{
		if (collectionView == self.collectionView)
		{
			if (collectionView.collectionViewLayout == self.layoutTwo)
			{
				searchTerm						= self.searches[indexPath.item];
				photo							= self.searchResults[searchTerm][0];
				
			}
			else
			{
				searchTerm						= self.searches[indexPath.section];
				photo							= self.searchResults[searchTerm][indexPath.item];
			}
			FlickrPhotoController *flickrPhoto	= [[FlickrPhotoController alloc] initWithNibName:@"FlickrPhotoController" bundle:nil];
			flickrPhoto.flickrPhoto				= photo;
			flickrPhoto.modalPresentationStyle	= UIModalPresentationFormSheet;
			[self presentViewController:flickrPhoto animated:YES completion:nil];
			[collectionView deselectItemAtIndexPath:indexPath animated:YES];
		}
	}
	
	else
	{
		searchTerm						= self.searches[indexPath.section];
		photo							= self.searchResults[searchTerm][indexPath.item];
		[self.selectedPhotos addObject:photo];
	}
}

#pragma mark - UICollectionViewFlowLayoutDelegate Methods

/**
 *	returns margins to apply to content in the specified section
 *
 *	@param	collectionView				collection view object displaying the flow layout
 *	@param	collectionViewLayout		layout object requesting the information
 *	@param	section						index number of the section whose insets are needed
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
						layout:(UICollectionViewLayout *)collectionViewLayout
		insetForSectionAtIndex:(NSInteger)section
{
	return UIEdgeInsetsMake(50, 20, 50, 20);
}

/**
 *	returns the size of the specified item’s cell
 *
 *	@param	collectionView				collection view object displaying the flow layout
 *	@param	collectionViewLayout		layout object requesting the information
 *	@param	indexPath					index path of the item
 */
- (CGSize)collectionView:(UICollectionView *)collectionView
				  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *searchTerm;
	FlickrPhoto *photo;
	
	if (collectionView == self.collectionView)
	{
		if (collectionViewLayout == self.layoutTwo)
		{
			searchTerm						= self.searches[indexPath.item];
			photo							= self.searchResults[searchTerm][0];
		}
		else
		{
			searchTerm						= self.searches[indexPath.section];
			photo							= self.searchResults[searchTerm][indexPath.item];
		}
	}
	
	CGSize returnSize					= photo.thumbnail.size.width > 0.0f ? photo.thumbnail.size : CGSizeMake(100, 100);
	returnSize.height					+= 35;
	returnSize.width					+= 35;
	
	return returnSize;
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.flickr searchFlickrForTerm:textField.text completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error)
	{
		if (results && results.count)
		{
			if (![self.searches containsObject:searchTerm])
			{
				NSLog(@"Found %d photos matching %@", results.count, searchTerm);
				[self.searches insertObject:searchTerm atIndex:0];
				self.searchResults[searchTerm]	= results;
			}
			
			dispatch_async(dispatch_get_main_queue(),
			^{
				if (self.collectionView.collectionViewLayout == self.layoutTwo)
				{
					[self.collectionView performBatchUpdates:
					^{
						[self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:(self.searches.count - 1) inSection:0]]];
					}
					completion:^(BOOL finished)
					{
						
					}];
				}
				
				else
				{
					[self.collectionView performBatchUpdates:
					^{
						[self.collectionView insertSections:[NSIndexSet indexSetWithIndex:0]];
					}
					completion:nil];
				}
			});
		}
		
		else
			NSLog(@"Error searching Flickr: %@", error.localizedDescription);
	}];
	
	[textField resignFirstResponder];
	
	return YES;
}

#pragma mark - View Lifecycle

/**
 *	notifies the view controller that its view was added to a view hierarchy
 */
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self layoutSelectionTapped];
}

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.collectionView setDataSource:self];
	[self.collectionView setDelegate:self];
	[self.textField setDelegate:self];
	
	self.searches						= @[].mutableCopy;
	self.searchResults					= @{}.mutableCopy;
	self.selectedPhotos					= @[].mutableCopy;
	self.flickr							= [[Flickr alloc] init];
	
	self.longPressGestureRecogniser		= [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
	
	[self.collectionView registerNib:[UINib nibWithNibName:FlickrCellID bundle:nil] forCellWithReuseIdentifier:FlickrCellID];
	[self.collectionView registerNib:[UINib nibWithNibName:FlickrPhotoHeaderID bundle:nil]
		  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
				 withReuseIdentifier:FlickrPhotoHeaderID];
	
	[self setupLayouts];
	
	[self customiseView];
}

@end
