//
//  MainController.m
//  GeekPlanner
//
//  Created by James Valaitis on 21/03/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "Conference.h"
#import "ConferenceCell.h"
#import "DetailController.h"
#import "MainController.h"

static NSString *const kCellIdentifier	= @"ConferenceCell";

@interface MainController ()

@end

@implementation MainController {}

#pragma mark - Initialisation

/**
 *	called to initialise a class instance
 */
- (id)init
{
	if (self = [super init])
	{
		[self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];;
	}
	
	return self;
}

#pragma mark - UITableViewDataSource Methods

/**
 *	as the data source, we must define how many sections we want the table view to have
 *
 *	@param	tableView					the table view for which are defining the sections number
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

/**
 *	create and return the cells for each row of the table view
 *
 *	@param	tableView					the table view for which we are creating cells
 *	@param	indexPath					the index path of the row we are creating a cell for
 */
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ConferenceCell *cell				= [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
	
	Conference *conference				= self.conferences[indexPath.row];
	
	cell.nameLabel.text					= conference.name;
	cell.imageView.image				= [UIImage imageNamed:conference.imageName];
	
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
	return self.conferences.count;
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
	DetailController *detailController	= [[DetailController alloc] init];
	detailController.conference			= self.conferences[indexPath.row];
	[self.navigationController pushViewController:detailController animated:YES];	
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
	return 80.0f;
}

@end