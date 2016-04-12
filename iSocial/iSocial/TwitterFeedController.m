//
//  TwitterFeedController.m
//  iSocial
//
//  Created by James Valaitis on 08/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "AppDelegate.h"
#import "TwitterCell.h"
#import "TwitterFeedController.h"

#define kTwitterCellIdentifier @"TwitterCell"

@interface TwitterFeedController ()

@property (atomic, strong)	NSArray				*tweetsArray;
@property (atomic, strong)	NSMutableDictionary	*imagesDictionary;

@end

@implementation TwitterFeedController

#pragma mark - Convenience Methods

- (CGFloat)heightForCellAtIndex:(NSInteger)row
{
	NSDictionary *tweet		= self.tweetsArray[row];
	CGFloat cellHeight		= 55;
	
	NSString *tweetText		= tweet[@"text"];
	
	CGSize labelHeight		= [tweetText sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(690, 250)];
	
	cellHeight				+= labelHeight.height;
	
	return cellHeight;
}

#pragma mark - Handling Twitter Account

- (void)refreshTwitterFeed
{
	//	create a request used to connect to twitter's api and get 50 items from the user's feed
	SLRequest *request				= [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET
						URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"] parameters:@{@"count" : @"50"}];
	
	AppDelegate *appDelegate		= [UIApplication sharedApplication].delegate;
	
	//	get the user's twitter account to perform an authenticated request
	request.account					= appDelegate.twitterAccount;
	
	[request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
	{
		if (error)
		{
			[appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error reading your Twitter feed: %@", error.localizedDescription]];
		}
		
		//	if it succeeded we oarse the json response and store it in an array
		else
		{
			NSError *jsonError;
			NSArray *responseJSON	= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
			
			if (jsonError)
				[appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error reading your Twitter feed: %@", jsonError.localizedDescription]];
			
			//	if everything was fine we store the json and initialise the images dictionary then reload table on main thread
			else
			{
				self.tweetsArray		= responseJSON;
				
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
	TwitterCell *cell					= [tableView dequeueReusableCellWithIdentifier:kTwitterCellIdentifier forIndexPath:indexPath];
	
	//	retrieve dictioanry corresponding to current tweet from tweets array and current user object
	NSDictionary *currentTweet			= [self.tweetsArray objectAtIndex:indexPath.row];
	NSDictionary *currentUser			= currentTweet[@"user"];
	
	//	populate cell and set frame of tweet text according to length of tweet
	cell.usernameLabel.text				= currentUser[@"name"];
	cell.tweetLabel.text				= currentTweet[@"text"];
	cell.tweetLabel.frame				= CGRectMake(cell.tweetLabel.frame.origin.x, cell.tweetLabel.frame.origin.y,
													 cell.tweetLabel.frame.size.width, [self heightForCellAtIndex:indexPath.row] - 55);
	
	//	create easy way to access username of tweet
	NSString *userName					= cell.usernameLabel.text;
	
	//	if we have not already stored user's image we fetch it
	if (!(cell.userImageView.image		= self.imagesDictionary[userName]))
	{
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
		^{
			NSURL *imageURL				= [NSURL URLWithString:[currentUser objectForKey:@"profile_image_url"]];
			
			__block NSData *imageData;
			
			//	download image before returning from block which means it won't try to fetch multiple images
			dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
			^{
				imageData				= [NSData dataWithContentsOfURL:imageURL];
				
				//	add image to dictioanry for later use
				[self.imagesDictionary setObject:[UIImage imageWithData:imageData] forKey:userName];
				
				//	update cell image with the image we fetched
				dispatch_sync(dispatch_get_main_queue(),
				^{
					cell.userImageView.image	= self.imagesDictionary[cell.usernameLabel.text];
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
	return self.tweetsArray.count;
}

#pragma mark - UITableViewDelegate Methods

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
		self.imagesDictionary	= nil;
		self.tweetsArray		= nil;
	}
}

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.tableView registerNib:[UINib nibWithNibName:kTwitterCellIdentifier bundle:nil] forCellReuseIdentifier:kTwitterCellIdentifier];
	
	UIRefreshControl *refreshControl	= [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(refreshTwitterFeed) forControlEvents:UIControlEventValueChanged];
	self.refreshControl					= refreshControl;
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
											 selector:@selector(refreshTwitterFeed)
												 name:kTwitterAccountAccessGranted
											   object:nil];
	
	AppDelegate *appDelegate			= [UIApplication sharedApplication].delegate;
	
	if (appDelegate.twitterAccount)
		[self refreshTwitterFeed];
	
	else
		[appDelegate getTwitterAccount];
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
