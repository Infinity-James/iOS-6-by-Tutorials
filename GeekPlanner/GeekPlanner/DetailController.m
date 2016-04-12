//
//  DetailController.m
//  GeekPlanner
//
//  Created by James Valaitis on 21/03/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "Conference.h"
#import "DetailController.h"
#import "EventKitController.h"

static NSString *const kCellIdentifier	= @"EventKitCell";

@interface DetailController () <UITableViewDataSource, UITableViewDelegate>
{
    NSDateFormatter				*_dateFormatter;
	EventKitController			*_eventKitController;
	NSArray						*_eventTableSections;
}

@property (nonatomic, strong)	UILabel			*endDate, *name, *startDate;
@property (nonatomic, strong)	UILabel			*endDateLabel, *nameLabel, *startDateLabel;
@property (nonatomic, strong)	UIImageView		*image;
@property (nonatomic, strong)	UITableView		*tableView;

@end

@implementation DetailController {}

#pragma mark - Convenience & Helper Methods

/**
 *
 */
- (void)addSubviews
{
	[self.view addSubview:self.endDate];
	[self.view addSubview:self.endDateLabel];
	[self.view addSubview:self.image];
	[self.view addSubview:self.name];
	[self.view addSubview:self.nameLabel];
	[self.view addSubview:self.startDate];
	[self.view addSubview:self.startDateLabel];
	[self.view addSubview:self.tableView];
}

/**
 *	we do this so layout constraints work
 */
- (void)removeTranslationOfAutoresizingMasks
{
	self.endDate.translatesAutoresizingMaskIntoConstraints			= NO;
	self.endDateLabel.translatesAutoresizingMaskIntoConstraints		= NO;
	self.image.translatesAutoresizingMaskIntoConstraints			= NO;
	self.name.translatesAutoresizingMaskIntoConstraints				= NO;
	self.nameLabel.translatesAutoresizingMaskIntoConstraints		= NO;
	self.startDate.translatesAutoresizingMaskIntoConstraints		= NO;
	self.startDateLabel.translatesAutoresizingMaskIntoConstraints	= NO;
	self.tableView.translatesAutoresizingMaskIntoConstraints		= NO;
}

/**
 *	initialise all the views
 */
- (void)initialiseViews
{
	self.endDate					= [[UILabel alloc] init];
	self.endDateLabel				= [[UILabel alloc] init];
	self.name						= [[UILabel alloc] init];
	self.nameLabel					= [[UILabel alloc] init];
	self.startDate					= [[UILabel alloc] init];
	self.startDateLabel				= [[UILabel alloc] init];
	self.image						= [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.conference.imageName]];
}

/**
 *
 */
- (void)performEventOperations
{
	NSIndexPath *indexPath					= self.tableView.indexPathForSelectedRow;
	
	switch (indexPath.row)
	{
		case 0:	[_eventKitController addEventWithName:self.conference.name
											startTime:self.conference.startDate
										   andEndTime:self.conference.endDate];				break;
		case 1: [_eventKitController addRecurringEventWithName:self.conference.name
													 startTime:self.conference.startDate
													andEndTime:self.conference.endDate];	break;
		case 2: [_eventKitController deleteEventWithName:self.conference.name
											   startTime:self.conference.startDate
											  andEndTime:self.conference.endDate];			break;
	}
}

/**
 *
 */
- (void)performReminderOperations
{
	NSIndexPath *indexPath					= self.tableView.indexPathForSelectedRow;
	
	switch (indexPath.row)
	{
		case 0: [_eventKitController addReminderWithTitle:[NSString stringWithFormat:@"Buy your %@ ticket.", self.conference.name]
												  dueTime:[NSDate date]];
		case 1:
		{
			//	create instance of calendar and date components then set day component to -1
			NSCalendar *calendar				= [NSCalendar currentCalendar];
			NSDateComponents *oneDayComponents	= [[NSDateComponents alloc] init];
			oneDayComponents.day				= -1;
			
			//	add nsdatecomponents to start date of conference which subtracts a day for us
			NSDate *dayBeforeEvent				=  [calendar dateByAddingComponents:oneDayComponents toDate:self.conference.startDate options:kNilOptions];
			
			//	add the reminder for the day before the event reminding user to get ready
			[_eventKitController addReminderWithTitle:[NSString stringWithFormat:@"Pack your bags and get ready for %@", self.conference.name]
											  dueTime:dayBeforeEvent];
		}
	}
}

/**
 *	add label content and customise it
 */
- (void)setLabelContent
{
	self.nameLabel.text					= @"Name:";
	self.startDateLabel.text			= @"Start Date:";
	self.endDateLabel.text				= @"End Date:";
	
	self.nameLabel.font					= self.startDateLabel.font		= self.endDateLabel.font		= [UIFont fontWithName:@"Futura" size:12.0f];
	self.nameLabel.textColor			= self.startDateLabel.textColor	= self.endDateLabel.textColor	= [UIColor redColor];
	
	self.name.text						= self.conference.name;
	self.startDate.text					= [_dateFormatter stringFromDate:self.conference.startDate];
	self.endDate.text					= [_dateFormatter stringFromDate:self.conference.endDate];
}

/**
 *	intialises and configures the table view
 */
- (void)setUpTableView
{
	self.tableView						= [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
	self.tableView.dataSource			= self;
	self.tableView.delegate				= self;
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}

/**
 *	sets up the instance variables used for the view
 */
- (void)setUpVariables
{
	_eventTableSections					= @[@[@"Add event to calendar", @"Add a recurring event", @"Remove all of these events"],
										@[@"Add a reminder to buy a ticket", @"Add a reminder to pack your bags"]];
	
	_dateFormatter						= [[NSDateFormatter alloc] init];
	[_dateFormatter setLocale:[NSLocale currentLocale]];
	[_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
}

/**
 *	handles the setting up of our various views
 */
- (void)setUpViews
{
	self.title							= self.conference.name;
	
	[self initialiseViews];
	[self setLabelContent];
	[self setUpTableView];
	[self addSubviews];
	[self removeTranslationOfAutoresizingMasks];
}

#pragma mark - Initialisation

/**
 *	called to initialise a class instance
 */
- (id)init
{
	if (self = [super init])
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
	return _eventTableSections.count;
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
	
	cell.textLabel.text					= ((NSArray *)_eventTableSections[indexPath.section])[indexPath.row];
	
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
	return ((NSArray *)_eventTableSections[section]).count;
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
	if (!_eventKitController)			_eventKitController = [[EventKitController alloc] init];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performEventOperations)
												 name:kEventsAccessGrantedNotification object:_eventKitController];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performReminderOperations)
												 name:kRemindersAccessGrantedNotification object:_eventKitController];
	
	switch (indexPath.section)
	{
		case 0:	[self performEventOperations];		break;
		case 1:	[self performReminderOperations];	break;
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIViewController Methods

/**
 *	called when the view controller’s view needs to update its constraints
 */
- (void)updateViewConstraints
{
	[super updateViewConstraints];
	
	//	remove all constraints
	[self.view removeConstraints:self.view.constraints];
	
	//	objects to be used in creating constraints
	NSLayoutConstraint *constraint;
	NSArray *constraints;
	NSDictionary *viewsDictionary;
	
	//	dictionary of views to apply constraints to
	viewsDictionary						= NSDictionaryOfVariableBindings(_endDate, _endDateLabel, _image, _name, _nameLabel, _startDate, _startDateLabel, _tableView);
	
	//	sort out image position
	constraint							= [NSLayoutConstraint constraintWithItem:self.image attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
													   toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:15.0f];
	[self.view addConstraint:constraint];
	
	constraint							= [NSLayoutConstraint constraintWithItem:self.image attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
													   toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:20.0f];
	[self.view addConstraint:constraint];
	
	//	sort out description labels
	constraint							= [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
													   toItem:self.image attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:8.0f];
	[self.view addConstraint:constraint];
	
	constraint							= [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
													   toItem:self.image attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
	[self.view addConstraint:constraint];
	
	constraints							= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_nameLabel]-(10)-[_startDateLabel]-(10)-[_endDateLabel]"
																options:NSLayoutFormatAlignAllLeading metrics:nil views:viewsDictionary];
	[self.view addConstraints:constraints];
	
	//	add the detail labels with the information and align with other labels as wella s each other
	constraints							= [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_startDateLabel]-(10)-[_startDate]"
																options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary];
	[self.view addConstraints:constraints];
	
	constraint							= [NSLayoutConstraint constraintWithItem:self.name attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
													   toItem:self.nameLabel attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
	[self.view addConstraint:constraint];
	
	constraint							= [NSLayoutConstraint constraintWithItem:self.endDate attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
													   toItem:self.endDateLabel attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
	[self.view addConstraint:constraint];
	
	constraints							= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_name]-(10@50)-[_startDate]-(10@50)-[_endDate]"
																options:NSLayoutFormatAlignAllLeading metrics:nil views:viewsDictionary];
	[self.view addConstraints:constraints];
	
	//	add the tableview
	
	constraints							= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_image]-(20)-[_tableView]-|"
																options:kNilOptions metrics:nil views:viewsDictionary];
	[self.view addConstraints:constraints];
	
	constraints							= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_tableView]-|"
																options:kNilOptions metrics:nil views:viewsDictionary];
	[self.view addConstraints:constraints];
}

#pragma mark - View Lifecycle


/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setUpVariables];
	[self setUpViews];
}

@end