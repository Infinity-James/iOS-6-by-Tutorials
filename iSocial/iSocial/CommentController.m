//
//  CommentController.m
//  iSocial
//
//  Created by James Valaitis on 08/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "CommentController.h"
#import "TwitterCell.h"

#define kTwitterCellIdentifier @"TwitterCell"

@interface CommentController ()

@property (atomic, strong)	NSMutableDictionary	*imagesDictionary;

@end

@implementation CommentController

#pragma mark - View Lifecycle

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.tableView registerNib:[UINib nibWithNibName:kTwitterCellIdentifier bundle:nil] forCellReuseIdentifier:kTwitterCellIdentifier];
	
	self.imagesDictionary		= @{}.mutableCopy;
	self.title					= @"Comments";
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
	//	repurpose the twitter cell as a cell to view comments
	TwitterCell *cell				= [tableView dequeueReusableCellWithIdentifier:kTwitterCellIdentifier forIndexPath:indexPath];
	
	NSDictionary *currentComment	= self.commentsArray[indexPath.row];
	NSDictionary *currentUser		= currentComment[@"from"];
	
	CGRect tweetFrame				= cell.tweetLabel.frame;
	
	cell.usernameLabel.text			= currentUser[@"name"];
	cell.tweetLabel.text			= currentComment[@"message"];
	cell.tweetLabel.frame			= CGRectMake(tweetFrame.origin.x, tweetFrame.origin.y,
												 tweetFrame.size.width, [self heightForCellAtIndex:indexPath.row] - 55);
	
	NSString *userID				= currentUser[@"id"];
	
	if (!(cell.userImageView.image = self.imagesDictionary[userID]))
	{
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
		^{
			NSString *pictureURL	= currentUser[[NSString stringWithFormat:@"%@/%@/picture?type=small",
												   @"https://graph.facebook.com", userID]];
			NSURL *imageURL			= [NSURL URLWithString:pictureURL];
			
			__block NSData *imageData;
			
			dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
			^{
				imageData			= [NSData dataWithContentsOfURL:imageURL];
				UIImage *image		= [UIImage imageWithData:imageData];
				
				self.imagesDictionary[userID]	= image;
				
				dispatch_sync(dispatch_get_main_queue(),
				^{
					cell.userImageView.image	= image;
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
	return self.commentsArray.count;
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

#pragma mark - Utlity Methods

- (CGFloat)heightForCellAtIndex:(NSUInteger)index
{
	NSDictionary *comment		= self.commentsArray[index];
	
	CGFloat cellHeight			= 50;
	CGFloat width				= [UIScreen mainScreen].bounds.size.width;
	
	NSString *message			= comment[@"message"];
	
	CGSize labelHeight			= [message sizeWithFont:[UIFont systemFontOfSize:25.0f] constrainedToSize:CGSizeMake(width - 68, 500)];
	
	cellHeight					+= labelHeight.height;
	
	return cellHeight;
}

@end








































































