//
//  RemindersController.m
//  GeekPlanner
//
//  Created by James Valaitis on 21/03/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "EventKitController.h"
#import "RemindersController.h"

static NSString *const kCellIdentifier	= @"ReminderCell";

@interface RemindersController ()
{
	EventKitController					*_eventKitController;
}

@end

@implementation RemindersController

#pragma mark - Convenience & Helper Methods

/**
 *	refresh the table view
 */
- (void)refreshView
{
	[self.tableView reloadData];
}

/**
 *
 */
- (void)remindersPermissionGranted
{
	[_eventKitController startBroadcastingModelChangedNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:kRemindersChangedNotification object:_eventKitController];
	[_eventKitController fetchAllConferenceReminders];
}

#pragma mark - Initialisation

/**
 *	deallocates the memory occupied by the receiver
 */
- (void)dealloc
{
	[_eventKitController stopBroadcastingModelChangedNotifications];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *	called to initialise a class instance
 */
- (id)initWithStyle:(UITableViewStyle)style
{
	if (self = [super initWithStyle:style])
	{
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
 *	asks the data source to verify that the given row is editable
 *
 *	@param	tableView					table-view object requesting this information
 *	@param	indexPath					index path locating a row in table view
 */
- (BOOL)	tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
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
	
	EKReminder *reminder				= (EKReminder *)_eventKitController.reminders[indexPath.row];
	cell.textLabel.text					= reminder.title;
	
	if (reminder.completed)				cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else								cell.accessoryType = UITableViewCellAccessoryNone;
	
	return cell;
}

/**
 *	called to commit the insertion or deletion of a specified row in the receiver
 *
 *	@param	tableView					table view object requesting the insertion or deletion
 *	@param	editingStyle				cell editing style corresponding to a insertion or deletion
 *	@param	indexPath					index path of row requesting editing
 */
- (void) tableView:(UITableView *)				tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)				indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
	return _eventKitController.reminders.count;
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
	UITableViewCell *selectedCell		= [tableView cellForRowAtIndexPath:indexPath];
	BOOL isCompleted					= (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark);
	selectedCell.accessoryType			= isCompleted ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;

	[_eventKitController reminder:_eventKitController.reminders[indexPath.row] setCompletionFlagTo:!isCompleted];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - View Lifecycle

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
	self.tableView.separatorStyle		= UITableViewCellSeparatorStyleNone;
	
	_eventKitController				= [[EventKitController alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remindersPermissionGranted)
												 name:kRemindersAccessGrantedNotification object:_eventKitController];
}

@end