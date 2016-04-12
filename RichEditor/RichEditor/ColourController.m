//
//  ColourController.m
//  RichEditor
//
//  Created by James Valaitis on 22/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "ColourController.h"

#define kCellIdentifier		@"ColourCell"

@interface ColourController ()
{
	NSArray			*_coloursDataSource;
	NSArray			*_coloursNames;
}

@end

@implementation ColourController

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
	UITableViewCell *cell				= [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
	
	NSDictionary *attribute				= @{NSForegroundColorAttributeName : _coloursDataSource[indexPath.row]};
	
	cell.textLabel.attributedText		= [[NSAttributedString alloc] initWithString:_coloursNames[indexPath.row] attributes:attribute];
	
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
	return _coloursDataSource.count;
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
	[self.delegate selectedColour:_coloursDataSource[indexPath.row]];
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View Lifecycle

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title				= @"Colour Picker";
	
	_coloursDataSource		= @[[UIColor colorWithRed:0.106 green:0.490 blue:0.035 alpha:1.0],
								[UIColor colorWithRed:0.129 green:0.243 blue:0.725 alpha:1.0],
								[UIColor colorWithRed:0.725 green:0.129 blue:0.298 alpha:1.0],
								[UIColor colorWithRed:0.941 green:0.604 blue:0.020 alpha:1.0],
								[UIColor colorWithRed:0.941 green:0.020 blue:0.929 alpha:1.0],
								[UIColor colorWithRed:0.373 green:0.235 blue:0.035 alpha:1.0],
								[UIColor blackColor]];
	
	_coloursNames			= @[@"Green", @"Blue", @"Red", @"Orange", @"Pink", @"Brown", @"Black"];
	
	[self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
}

@end

































































