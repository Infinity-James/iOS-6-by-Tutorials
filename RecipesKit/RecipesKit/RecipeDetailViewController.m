//
//  RecipeDetailViewController.m
//  RecipesKit
//
//  Created by Felipe on 8/6/12.
//  Copyright (c) 2012 Felipe Last Marsetti. All rights reserved.
//

#import "AppDelegate.h"
#import "Image.h"
#import "PhotosController.h"
#import "RecipeDetailViewController.h"
#import "ServingsController.h"

@interface RecipeDetailViewController () <UIActionSheetDelegate, UIPageViewControllerDataSource, UITextFieldDelegate>

@property (nonatomic, strong)			UIBarButtonItem			*actionButton;
@property (nonatomic, strong)			UIBarButtonItem			*cameraButton;
@property (nonatomic, strong)			UIBarButtonItem			*doneButton;
@property (nonatomic, strong)			UIImagePickerController	*imagePickerController;
@property (nonatomic, weak) IBOutlet	UITextView				*notesTextView;
@property (nonatomic, weak)				UIPageViewController	*pageController;
@property (nonatomic, weak) IBOutlet	UIScrollView			*scrollView;
@property (nonatomic, weak) IBOutlet	UIButton				*servingsButton;
@property (nonatomic, weak) IBOutlet	UITextField				*titleTextField;

@end

@implementation RecipeDetailViewController

#pragma mark - Autorotation

/**
 *	returns all of the interface orientations that the view controller supports
 */
- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Action & Selector Methods

/**
 *
 */
- (void)actionTapped
{
	NSString *titleString					= [NSString stringWithFormat:@"I just made a delicious %@ recipe using RecipesKit.", self.recipe.title];
	
	UIImage *activityImage;
	
	if (self.recipe.images.count)
	{
		Image *image						= self.recipe.images.anyObject;
		activityImage						= image.image;
	}
	
	NSArray *items							= @[titleString];
	
	if (activityImage)						items = @[titleString, activityImage];
	
	UIActivityViewController *activitySheet	= [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
	
	[self presentViewController:activitySheet animated:YES completion:nil];
}

/**
 *
 */
- (void)cameraTapped
{
	UIActionSheet *actionSheet				= [[UIActionSheet alloc] initWithTitle:@""
																delegate:self
													   cancelButtonTitle:@"Cancel"
												  destructiveButtonTitle:@"Delete All Images"
													   otherButtonTitles:@"Select Image", nil];
	
	[actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

/**
 *	called when the done button is tapped
 *
 *	@param	segue
 */
- (IBAction)doneTapped:(UIStoryboardSegue *)segue
{
	ServingsController *servingsController	= segue.sourceViewController;
	NSNumber *servings						= @([servingsController.pickerView selectedRowInComponent:0] + 1);
	
	self.recipe.servings					= servings;
	
	AppDelegate *appDelegate				= [UIApplication sharedApplication].delegate;
	[appDelegate saveContext];
}

/**
 *
 */
- (void)localDoneTapped
{
	if (self.notesTextView.isFirstResponder)		[self.notesTextView resignFirstResponder];
	else if (self.titleTextField.isFirstResponder)	[self.titleTextField resignFirstResponder];
	
	self.recipe.title					= self.titleTextField.text;
	self.recipe.notes					= self.notesTextView.text;
}

#pragma mark - Convenience & Helper Methods

/**
 *
 */
- (void)addButtons
{
	self.actionButton						= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																		   target:self action:@selector(actionTapped)];
	self.cameraButton						= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
																		   target:self action:@selector(cameraTapped)];
	self.doneButton							= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																		   target:self action:@selector(localDoneTapped)];
	
	self.navigationItem.rightBarButtonItems	= @[self.cameraButton, self.actionButton];
}

/**
 *
 */
- (void)setupFields
{
	self.notesTextView.text					= self.recipe.notes;
	[self.servingsButton setTitle:self.recipe.servingsString forState:UIControlStateNormal];
	[self.servingsButton setTitle:self.recipe.servingsString forState:UIControlStateHighlighted];
	self.titleTextField.text				= self.recipe.title;
}

#pragma mark - Notification Methods

/**
 *
 */
- (void)keyboardWillHide
{
	self.navigationItem.rightBarButtonItems	= @[self.cameraButton, self.actionButton];
	
	self.scrollView.contentSize				= CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
	self.scrollView.frame					= self.view.bounds;
}

/**
 *
 */
- (void)keyboardWillShow:(NSNotification *)userInfo
{
	self.navigationItem.rightBarButtonItems	= @[self.doneButton, self.actionButton];
	
	CGRect keyboardFrame					= [userInfo.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	NSLog(@"%@", NSStringFromCGRect(keyboardFrame));
	self.scrollView.contentSize				= CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
	self.scrollView.frame					= CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height - keyboardFrame.size.height);
}

#pragma mark - Properties

- (void)setRecipe:(Recipe *)newRecipe
{
    // Only set the new recipe if it's not the same one that's currently stored
    if (_recipe != newRecipe)
    {
        _recipe = newRecipe;
    }
}

#pragma mark - Segue Methods

/**
 *	notifies view controller that segue is about to be performed
 *
 *	@param	segue						segue object containing information about the view controllers involved
 *	@param	sender						object that initiated the segue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue
				 sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"pageViewController"])
	{
		if (!self.recipe.images.count)	return;
		
		self.pageController				= segue.destinationViewController;
		self.pageController.dataSource	= self;
		
		PhotosController *photos		= [self.storyboard instantiateViewControllerWithIdentifier:@"PhotosController"];
		photos.index					= 0;
		
		Image *image					= self.recipe.images.allObjects[0];
		photos.image					= image.image;
		
		[self.pageController setViewControllers:@[photos] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
	}
}

#pragma mark - UIActionSheetDelegate Methods

/**
 *	sent to the delegate when the user clicks a button on an action sheet
 *
 *	@param	actionSheet					action sheet containing the button
 *	@param	buttonIndex					position of the clicked button
 */
- (void) actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex)
	{
		case 0:	[self.recipe removeImages:self.recipe.images];	[self.navigationController popToRootViewControllerAnimated:YES];	break;
		case 1:	[self presentViewController:self.imagePickerController animated:YES completion:nil];								break;
	}
}

#pragma mark - UIImagePickerControllerDelegate Methods

/**
 *	tells the delegate that the user picked a still image or movie
 *
 *	@param	picker						controller object managing the image picker interface
 *	@param	info						dictionary containing the original image and edited image, or filesystem URL for a movie
 */
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	//	retrieve edited picture
	UIImage *selectedImage				= info[UIImagePickerControllerEditedImage];
	
	//	calculate picture ratio
	CGFloat actualHeight				= selectedImage.size.height;
	CGFloat actualWidth					= selectedImage.size.height;
	CGFloat imageRatio					= actualWidth / actualHeight;
	CGFloat maximumRatio				= 320.0f / 180.0f;
	
	if (imageRatio != maximumRatio)
	{
		if (imageRatio < maximumRatio)
		{
			imageRatio					= 480.0f / actualHeight;
			actualWidth					= imageRatio * actualWidth;
			actualHeight				= 480.0f;
		}
		else
		{
			imageRatio					= 320.0f / actualWidth;
			actualHeight				= imageRatio * actualHeight;
			actualWidth					= 320.0f;
		}
	}
	
	//	crop image according to calculated ratio
	CGRect rect							= CGRectMake(0.0f, 0.0f, actualWidth, actualHeight);
	
	UIGraphicsBeginImageContext(rect.size);
	[selectedImage drawInRect:rect];
	UIImage *croppedImage				= UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//	image entity is inserted into managed object context and added to recipe image set
	Image *image						= [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:self.managedObjectContext];
	image.image							= croppedImage;
	
	[self.recipe addImagesObject:image];
	
	//	save the context (saves commited to core data)
	NSError *error;
	[self.managedObjectContext save:&error];
	
	if (error)							NSLog(@"Append Data Save Error = %@", error.localizedDescription);
	
	//	dismiss image picker and take user back yo recipe list
	[self dismissViewControllerAnimated:NO completion:nil];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UIPageViewControllerDataSource Methods

/**
 *	returns the view controller after the given view controller
 *
 *	@param	pageViewController			page view controller
 *	@param	viewController				view controller that the user navigated away from
 */
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
	   viewControllerAfterViewController:(UIViewController *)viewController
{
	PhotosController *previousController= (PhotosController *)viewController;
	NSUInteger pagesCount				= self.recipe.images.count;
	
	pagesCount--;
	
	if (previousController.index == pagesCount)	return nil;
	
	PhotosController *photosController	= [self.storyboard instantiateViewControllerWithIdentifier:@"PhotosController"];
	photosController.index				= previousController.index + 1;
	photosController.image				= [self.recipe.images.allObjects[photosController.index] image];
	
	return photosController;
}

/**
 *	returns the view controller before the given view controller
 *
 *	@param	pageViewController			page view controller
 *	@param	viewController				view controller that the user navigated away from
 */
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
	  viewControllerBeforeViewController:(UIViewController *)viewController
{
	PhotosController *previousController= (PhotosController *)viewController;
	
	if (previousController.index == 0)	return nil;
	
	PhotosController *photosController	= [self.storyboard instantiateViewControllerWithIdentifier:@"PhotosController"];
	photosController.index				= previousController.index - 1;
	photosController.image				= [self.recipe.images.allObjects[photosController.index] image];
	
	return photosController;
}


/**
 *	returns the number of items to be reflected in the page indicator
 *
 *	@param pageViewController			page view controller
 */
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
	return self.recipe.images.count;
}

/**
 *	returns the index of the selected item to be reflected in the page indicato
 *
 *	@param pageViewController			page view controller
 */
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
	PhotosController *photosController	= pageViewController.viewControllers.lastObject;
	
	return photosController.index;
}

#pragma mark - UITextFieldDelegate Methods

/**
 *	asks delegate if the text field should process the pressing of the return button
 *
 *	@param	textField					text field whose return button was pressed
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	return YES;
}

#pragma mark - View Lifecycle

/**
 *	sent to the view controller when the app receives a memory warning
 */
- (void)didReceiveMemoryWarning
{
	if (!self.view.window)
	{
		self.actionButton				= nil;
		self.cameraButton				= nil;
		self.doneButton					= nil;
		self.imagePickerController		= nil;
		self.notesTextView				= nil;
		self.pageController				= nil;
		self.scrollView					= nil;
		self.servingsButton				= nil;
		self.titleTextField				= nil;
		self.view						= nil;
	}
	
	[super didReceiveMemoryWarning];
}

/**
 *	notifies the view controller that its view was added to a view hierarchy
 */
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self setupFields];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self addButtons];
	
	self.pageController.view.backgroundColor	= [UIColor clearColor];
	self.imagePickerController					= [[UIImagePickerController alloc] init];
	self.imagePickerController.allowsEditing	= YES;
	self.imagePickerController.delegate			= (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)self;
	self.imagePickerController.sourceType		= UIImagePickerControllerSourceTypePhotoLibrary;
}

/**
 *	notifies the view controller that its view is about to be removed from the view hierarchy
 *
 *	@param	animated					whether the view needs to be removed from the window with an animation
 */
- (void)viewWillDisappear:(BOOL)animated
{
	[self localDoneTapped];
	
	[(AppDelegate *)[UIApplication sharedApplication].delegate saveContext];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super viewWillDisappear:animated];
}

@end