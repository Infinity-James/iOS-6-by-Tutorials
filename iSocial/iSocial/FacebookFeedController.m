//
//  FacebookFeedController.m
//  iSocial
//
//  Created by James Valaitis on 08/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "AppDelegate.h"
#import "CommentController.h"
#import "FacebookCell.h"
#import "FacebookFeedController.h"
#import "MessageCell.h"
#import "PhotoCell.h"
#import "WebController.h"

@interface FacebookFeedController ()

@property (atomic, strong)	NSArray				*feedArray;
@property (atomic, strong)	NSMutableDictionary	*imagesDictionary;

@end

@implementation FacebookFeedController

#pragma mark - Convenience Methods

- (NSString *)feedString
{
	return @"https://graph.facebook.com/me/home";
}

- (CGFloat)heightForCellAtIndex:(NSInteger)row
{
	NSDictionary *feedItem			= self.feedArray[row];
	
	CGFloat cellHeight				= 0;
	
	CGFloat width					= [UIScreen mainScreen].bounds.size.width;
		
	NSString *itemType				= feedItem[@"type"];
	
	if ([itemType isEqualToString:@"status"])
	{
		cellHeight					= 50;
		
		NSString *facebookText		= feedItem[@"message"];
		
		CGSize messageHeight		= [facebookText sizeWithFont:[UIFont systemFontOfSize:15.0f]
											   constrainedToSize:CGSizeMake(width - 98, 500)];
		
		cellHeight					+= messageHeight.height < 20 ? 20 : messageHeight.height;
		
		NSArray *toArray			= feedItem[@"to"][@"data"];
		
		if (toArray.count > 0)
		{
			NSString *toString		= [self toLabelStringFromArray:toArray];
			
			CGSize toLabelHeight	= [toString sizeWithFont:[UIFont italicSystemFontOfSize:15.0f]
										   constrainedToSize:CGSizeMake(width - 98, 500)];
			
			cellHeight				+= toLabelHeight.height < 20 ? 20 : toLabelHeight.height;
		}
	}
	
	else if ([itemType isEqualToString:@"link"])
	{
		cellHeight					= 50;
		
		NSString *description		= feedItem[@"name"];
		
		CGSize descriptionHeight	= [description sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(width - 98, 500)];
		
		cellHeight					+= descriptionHeight.height < 20 ? 20 : descriptionHeight.height;
		
		NSString *messageString;
		
		if ((messageString = feedItem[@"message"]))
		{
			CGSize messageHeight	= [messageString sizeWithFont:[UIFont italicSystemFontOfSize:15.0f]
												constrainedToSize:CGSizeMake(width, 500)];
			
			cellHeight				+= messageHeight.height < 20 ? 20 : messageHeight.height;
		}
	}
	
	else if ([itemType isEqualToString:@"photo"] || [itemType isEqualToString:@"video"])
	{
		cellHeight					= 50;
		
		NSString *description		= feedItem[@"name"];
		
		CGSize descriptionHeight	= [description sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(width, 500)];
		
		cellHeight					+= descriptionHeight.height < 20 ? 20 : descriptionHeight.height;
	}
	
	return cellHeight;
}

- (CGFloat)heightForString:(NSString *)string
				  withFont:(UIFont *)font
		 constrainedToSize:(CGSize)constrainSize
{
	CGSize stringHeight			= [string sizeWithFont:font constrainedToSize:constrainSize];
	
	return stringHeight.height;
}

- (NSString *)titleString
{
	return @"Feed";
}

- (NSString *)toLabelStringFromArray:(NSArray *)toArray
{	
	NSMutableString *toString	= [@"To: " mutableCopy];
	
	for (int i = 0; i < toArray.count; i++)
	{
		[toString appendString:toArray[i][@"name"]];
		
		if (i < toArray.count - 1)
			[toString appendString:@", "];
	}
	
	//	i do this just to play it safe with the mutable string to immutable string deal
	return [NSString stringWithString:toString];
}

#pragma mark - Handle Facebook Data

- (void)refreshFacebookFeed
{
	SLRequest *request			= [SLRequest requestForServiceType:SLServiceTypeFacebook
													 requestMethod:SLRequestMethodGET
															   URL:[NSURL URLWithString:[self feedString]]
														parameters:@{@"limit" : @"30"}];
	
	AppDelegate *appDelegate	= [UIApplication sharedApplication].delegate;
	
	request.account				= appDelegate.facebookAccount;
	
	//	perform authorized request on separate thread with completion handler
	[request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
	{
		if (error)
			[appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"Error reading Facebook feed: %@", error.localizedDescription]];
		
		//	if no errors we parse json response data
		else
		{
			NSError *jsonError;
			
			NSDictionary *responseJSON	= [NSJSONSerialization JSONObjectWithData:responseData
														options:NSJSONReadingAllowFragments error:&jsonError];
			
			if (jsonError)
				[appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"Error reading Facebook feed: %@",
													  jsonError.localizedDescription]];
			
			//	if we successfully parsed json response data...
			else
			{
				NSMutableArray *cleanFeedArray	= @[].mutableCopy;
				
				//	for every json item we check it's type
				for (NSDictionary *item in responseJSON[@"data"])
				{
					NSString *itemType	= item[@"type"];
					
					//	if it is a status update, a link, a photo or a video we add it to our array of feed objects
					if ([itemType isEqualToString:@"status"] || [itemType isEqualToString:@"link"] ||
						[itemType isEqualToString:@"photo"] || [itemType isEqualToString:@"video"])
					{
						if ([itemType isEqualToString:@"status"])
							if (!item[@"message"])		continue;
						
						[cleanFeedArray addObject:item];
					}
				}
				
				//	we store the selected feed items and initialise our images dictionary
				self.feedArray			= [NSArray arrayWithArray:cleanFeedArray];
				self.imagesDictionary	= @{}.mutableCopy;
				
				dispatch_async(dispatch_get_main_queue(),
				^{
					[self.tableView reloadData];
				});
			}
		}
	}];
}

#pragma mark - UITableViewDataSource Methods

/**
 *	create and return the cells for each row of the table view
 *
 *	@param	tableView					the table view for which we are creating cells
 *	@param	indexPath					the index path of the row we are creating a cell for
 */
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FacebookCell *cell;
	cell.userImageView.image	= nil;
	
	//	in the feed we pull the current item's user id
	NSDictionary *currentItem	= [self.feedArray objectAtIndex:indexPath.row];
	NSDictionary *currentUser	= currentItem[@"from"];
	NSString *currentUserID		= currentUser[@"id"];
	
	//	depending on the type of item it is, we format the cell differently
	NSString *currentItemType	= currentItem[@"type"];
	
	//	if this is a status item, we display it in a message cell and format correctly
	if ([currentItemType isEqualToString:@"status"])
	{
		MessageCell *messageCell		= [tableView dequeueReusableCellWithIdentifier:kFacebookMessageCellIdentifier forIndexPath:indexPath];
		
		//	get the poster's username and the update
		messageCell.usernameLabel.text	= currentItem[@"from"][@"name"];
		messageCell.messageLabel.text	= currentItem[@"message"];
		
		//	due to leangth that facebook messages can be, we must calculate label's height accordingly
		CGFloat messageLabelHeight		= [self heightForString:currentItem[@"message"] withFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(messageCell.messageLabel.frame.size.width, 500)];
			
		messageCell.messageLabel.frame	= CGRectMake(messageCell.messageLabel.frame.origin.x, messageCell.messageLabel.frame.origin.y,
													 messageCell.messageLabel.frame.size.width, messageLabelHeight);
		
		//	if the status is directed to specific people we lable it accordingly
		NSArray *toArray				= currentItem[@"to"][@"data"];
		
		if (toArray.count > 0)
		{
			messageCell.toLabel.hidden	= NO;
			messageCell.toLabel.text	= [self toLabelStringFromArray:toArray];
			messageCell.toLabel.frame	= CGRectMake(messageCell.toLabel.frame.origin.x, messageCell.toLabel.frame.origin.y,
													 messageCell.toLabel.frame.size.width, [self heightForString:messageCell.toLabel.text
																										withFont:[UIFont systemFontOfSize:15.0f]
																							   constrainedToSize:CGSizeMake
																							(messageCell.frame.size.width - 98, 500)]);
		}
		
		else
			messageCell.toLabel.hidden	= YES;
		
		//	if the status has comments we show them
		int commentCount				= ((NSArray *)currentItem[@"comments"][@"data"]).count;
		
		if (commentCount > 0)
		{
			messageCell.accessoryType	= UITableViewCellAccessoryDisclosureIndicator;
			messageCell.selectionStyle	= UITableViewCellSelectionStyleBlue;
			[messageCell setUserInteractionEnabled:YES];
		}
		
		else
		{
			messageCell.accessoryType	= UITableViewCellAccessoryNone;
			messageCell.selectionStyle	= UITableViewCellSelectionStyleNone;
			[messageCell setUserInteractionEnabled:NO];
		}
		
		//	once set up is complete we assign it to the main cell pointer
		cell							= messageCell;
	}
	
	else if ([currentItemType isEqualToString:@"link"])
	{
		MessageCell *messageCell		= [tableView dequeueReusableCellWithIdentifier:kFacebookMessageCellIdentifier forIndexPath:indexPath];
		messageCell.usernameLabel.text	= currentItem[@"from"][@"name"];
		messageCell.messageLabel.text	= currentItem[@"name"];
		
		CGFloat width				= messageCell.messageLabel.frame.size.width;
		
		CGFloat descriptionLabelHeight	= [self heightForString:currentItem[@"name"]
													   withFont:[UIFont systemFontOfSize:15.0f]
											  constrainedToSize:CGSizeMake(width, 500)];
		
		CGPoint origin					= messageCell.messageLabel.frame.origin;
		messageCell.messageLabel.frame	= CGRectMake(origin.x, origin.y, width, descriptionLabelHeight);
		
		//	if there's a message we repurpose the 'to label' to display it
		if (currentItem[@"message"])
		{
			messageCell.toLabel.hidden	= NO;
			messageCell.toLabel.text	= currentItem[@"message"];
			origin						= messageCell.toLabel.frame.origin;
			width						= messageCell.toLabel.frame.size.width;
			messageCell.toLabel.frame	= CGRectMake(origin.x, origin.y, width, [self heightForString:messageCell.toLabel.text
																						     withFont:[UIFont italicSystemFontOfSize:15.0f]
																				    constrainedToSize:CGSizeMake(width, 500)]);
		}
		
		else
			messageCell.toLabel.hidden	= YES;
		
		//	allow it to be selected to display the link
		messageCell.accessoryType		= UITableViewCellAccessoryDisclosureIndicator;
		messageCell.selectionStyle		= UITableViewCellSelectionStyleBlue;
		[messageCell setUserInteractionEnabled:YES];
		
		cell							= messageCell;
	}
	
	else if ([currentItemType isEqualToString:@"photo"] || [currentItemType isEqualToString:@"video"])
	{
		PhotoCell *photoCell			= [tableView dequeueReusableCellWithIdentifier:kFacebookPhotoCellIdentifier forIndexPath:indexPath];
		
		//	configure cell message and user
		photoCell.usernameLabel.text	= currentItem[@"from"][@"name"];
		photoCell.messageLabel.text		= currentItem[@"name"];
		
		CGFloat width					= photoCell.messageLabel.frame.size.width;
		CGPoint origin					= photoCell.messageLabel.frame.origin;
		
		//	set height of cell according to message size
		CGFloat descriptionLabelHeight	= [self heightForString:currentItem[@"name"]
													   withFont:[UIFont systemFontOfSize:15.0f]
											  constrainedToSize:CGSizeMake(width, 500)];
		
		photoCell.messageLabel.frame	= CGRectMake(origin.x, origin.y, width, descriptionLabelHeight);
		
		//	allow cell to be selected to show photo larger
		photoCell.accessoryType			= UITableViewCellAccessoryDisclosureIndicator;
		photoCell.selectionStyle		= UITableViewCellSelectionStyleBlue;
		[photoCell setUserInteractionEnabled:YES];
		
		//	on separate thread we pull the image for this cell
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
		^{
			NSString *pictureURL		= currentItem[@"picture"];
			NSURL *imageURL				= [NSURL URLWithString:pictureURL];
			
			__block NSData *imageData;
			
			dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
			^{
				imageData					= [NSData dataWithContentsOfURL:imageURL];
				UIImage *pictureImage		= [UIImage imageWithData:imageData];
				
				NSLog(@"Fetching posted image data.");
				
				dispatch_sync(dispatch_get_main_queue(),
				^{
					photoCell.pictureImageView.image	= pictureImage;
					NSLog(@"Updating with a posted image.");
				});
			});
		});
		
		cell							= photoCell;
	}
	
	//	if we have the photo for this user already we use it, if not we fetch it
	if (!(cell.userImageView.image	= self.imagesDictionary[currentUserID]))
	{
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
		^{
			NSString *pictureURL	= [NSString stringWithFormat:@"%@/%@/picture?type=small", @"https://graph.facebook.com", currentUser[@"id"]];
			NSURL *imageURL			= [NSURL URLWithString:pictureURL];
			
			__block NSData *imageData;
			
			//	synchronously fetch the photo then update on the main thread (so we don't do more than one a time)
			dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
			^{
				imageData			= [NSData dataWithContentsOfURL:imageURL];
				UIImage *userImage	= [UIImage imageWithData:imageData];
				
				NSLog(@"Fetching the user images with data.");
				
				self.imagesDictionary[currentUserID]	= userImage;
				
				NSLog(@"Just updated the image dictionary: %@", self.imagesDictionary[currentUserID]);
				
				dispatch_sync(dispatch_get_main_queue(),
				^{
					NSLog(@"Updating the user images now.");
					cell.userImageView.image	= userImage;
				});
			});
		});
	}
	
	return cell;
}

/**
 *	define how many rows for each section there are in this table view
 *
 *	@param	tableView					the table view for which we are creating cells
 *	@param	section						the particular section for which we must define the rows
 */
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return self.feedArray.count;
}

#pragma mark - UITableViewDelegate Methods

/**
 *	handle the fact that a cell was just selected
 *
 *	@param	tableView					the table view containing selected cell
 *	@param	indexPath					the index path of the cell that was selected
 */
- (void)	  tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *selectedItem		= self.feedArray[indexPath.row];
	
	NSString *itemType				= selectedItem[@"type"];
	
	if ([itemType isEqualToString:@"status"])
	{
		NSDictionary *itemComments	= selectedItem[@"comments"];
		
		int commentCount			= ((NSArray *)itemComments[@"data"]).count;
		
		if (commentCount > 0)
		{
			CommentController *commentController	= [[CommentController alloc] initWithNibName:@"CommentView" bundle:nil];
			commentController.commentsArray			= itemComments[@"data"];
			[self.navigationController pushViewController:commentController animated:YES];
		}
	}
	
	else if ([itemType isEqualToString:@"link"] || [itemType isEqualToString:@"photo"] || [itemType isEqualToString:@"video"])
	{
		NSString *urlString				= selectedItem[@"link"];
		
		WebController *webController	= [[WebController alloc] initWithNibName:@"WebView" bundle:nil];
		webController.initialURLString	= urlString;
		
		[self presentViewController:webController animated:YES completion:nil];
	}
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 *	define the height of the cell
 *
 *	@param	tableView					the view which owns the cell for which we need to define the height
 *	@param	indexPath					index path of the cell
 */
- (CGFloat)	  tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [self heightForCellAtIndex:indexPath.row];
}

#pragma mark - View Lifecycle

/**
 *	sent to the view controller when the app receives a memory warning
 */
- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	
	if (!self.view.window)
	{
		self.view				= nil;
	}
}

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.tableView registerNib:[UINib nibWithNibName:kFacebookMessageCellIdentifier bundle:nil]
		 forCellReuseIdentifier:kFacebookMessageCellIdentifier];
	[self.tableView registerNib:[UINib nibWithNibName:kFacebookPhotoCellIdentifier bundle:nil]
		 forCellReuseIdentifier:kFacebookPhotoCellIdentifier];
	
	UIRefreshControl *refreshControl	= [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(refreshFacebookFeed) forControlEvents:UIControlEventValueChanged];
	self.refreshControl					= refreshControl;
	
	self.title							= [self titleString];
}

/**
 *	notifies the view controller that its view is about to be added to a view hierarchy
 *
 *	@param	animated					whether the view needs to be added to the window with an animation
 */
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(refreshFacebookFeed)
												 name:kFacebookAccountAccessGranted
											   object:nil];
	
	AppDelegate *appDelegate			= [UIApplication sharedApplication].delegate;
	
	if (appDelegate.facebookAccount)
		[self refreshFacebookFeed];
	
	else
		[appDelegate getFacebookAccount];
}

/**
 *	notifies the view controller that its view is about to be removed from the view hierarchy
 *
 *	@param	animated					whether the view needs to be removed from the window with an animation
 */
- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super viewWillDisappear:animated];
}

@end




































































