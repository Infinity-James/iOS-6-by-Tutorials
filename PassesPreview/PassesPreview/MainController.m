//
//  MainController.m
//  PassesPreview
//
//  Created by James Valaitis on 24/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import <PassKit/PassKit.h>
#import "MainController.h"

#define kCellIdentifier			@"PassCell"

@interface MainController () <PKAddPassesViewControllerDelegate>
{
	NSMutableArray				*_passes;
}

@end

@implementation MainController

#pragma mark - Convenience Methods

- (void)openPassWithName:(NSString *)name
{
	//	get the file path to the pass
	NSString *passFile			= [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:name];
	NSLog(@"Pass File: %@", passFile);
	
	NSError *error;
	
	//	get the pass data and use it to get the pass itself
	NSData *passData			= [NSData dataWithContentsOfFile:passFile];
	PKPass *newPass				= [[PKPass alloc] initWithData:passData error:&error];
	
	if (error)
	{
		[[[UIAlertView alloc] initWithTitle:@"Pass Error"
									message:error.localizedDescription
								   delegate:nil
						  cancelButtonTitle:@"Fine"
						  otherButtonTitles:nil] show];
		return;
	}
	
	//	initialise a pass adding controller using our grabbed pass and set ourselves as the delegate
	PKAddPassesViewController *addController	= [[PKAddPassesViewController alloc] initWithPass:newPass];
	addController.delegate		= self;
	
	[self presentViewController:addController animated:YES completion:nil];
}

- (void)setupPassKit
{
	//	check if the user actually has passbook availability
	if (![PKPassLibrary isPassLibraryAvailable])
		[[[UIAlertView alloc] initWithTitle:@"Error"
									message:@"Passkit not available."
								   delegate:nil
						  cancelButtonTitle:@"What A Shame"
						  otherButtonTitles: nil] show];
	
	//	initialise objects
	_passes						= @[].mutableCopy;
	
	//	load the passes from the resource folder
	NSString *resourcePath		= [NSBundle mainBundle].resourcePath;
	
	NSArray *passFiles			= [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcePath
																					  error:nil];
	
	//	loop over all of the resource files
	for (NSString *passFile in passFiles)
		if ([passFile hasSuffix:@".pkpass"])
			[_passes addObject:passFile];
	
	//	if there's only one pass just skip to showing it
	if (_passes.count == 1)
		[self openPassWithName:_passes.lastObject];
}

#pragma mark - PKAddPassesViewControllerDelegate Methods

/**
 *	sent to the delegate after the add-passes view controller has finished
 *
 *	@param	controller				the view controller that has finished	
 */
- (void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
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
	UITableViewCell *cell				= [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
	
	cell.textLabel.text					= [(NSString *)_passes[indexPath.row] stringByDeletingPathExtension];
	
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
	return _passes.count;
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
	//	open the selected pass
	NSString *passName					= _passes[indexPath.row];
	[self openPassWithName:passName];
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - View Lifecycle

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
	
	[self setupPassKit];
}

@end
