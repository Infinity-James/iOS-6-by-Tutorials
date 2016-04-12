//
//  EventKitController.m
//  GeekPlanner
//
//  Created by James Valaitis on 21/03/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "EventKitController.h"

NSString *const kEventsAccessGrantedNotification		= @"EventsAccessGranted";
NSString *const kRemindersAccessGrantedNotification		= @"RemindersAccessGranted";
NSString *const kRemindersChangedNotification			= @"RemindersModelChangedNotification";
static NSString *const kRemindersCalendarTitle			= @"Conference Reminders";

@interface EventKitController ()
{
	dispatch_queue_t				_fetchQueue;
}

@end

@implementation EventKitController

#pragma mark - Event Methods

/**
 *	convenience method for adding event with given name, and times
 *
 *	@param	eventName				name of the event to add
 *	@param	startDate				when the event begins
 *	@param	endDate					when the event ends
 */
- (void)addEventWithName:(NSString *)eventName
			   startTime:(NSDate *)startDate
			  andEndTime:(NSDate *)endDate
{
	if (!_eventAccess)	{ NSLog(@"No event access.");	return; }
	
	//	create an event and save it to the calendar
	[self saveEvent:[self getEventWithName:eventName startTime:startDate andEndTime:endDate]];
}

/**
 *	convenience method for adding a repeating event with given name, and times
 *
 *	@param	eventName				name of the event to add
 *	@param	startDate				when the event begins
 *	@param	endDate					when the event ends
 */
- (void)addRecurringEventWithName:(NSString *)eventName
						startTime:(NSDate *)startDate
					   andEndTime:(NSDate *)endDate
{
	//	create an event
	EKEvent *event					= [self getEventWithName:eventName startTime:startDate andEndTime:endDate];
	
	//	add the recurrence rule
	EKRecurrenceRule *rule			= [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:1 end:nil];
	
	event.recurrenceRules			= @[rule];
	
	//	save the event to the calendar
	[self saveEvent:event];
}

/**
 *	convenience method for getting an event with given name, and times
 *
 *	@param	eventName				name of the event to add
 *	@param	startDate				when the event begins
 *	@param	endDate					when the event ends
 */
- (void)deleteEventWithName:(NSString *)eventName
				  startTime:(NSDate *)startDate
				 andEndTime:(NSDate *)endDate
{
	if (!_eventAccess)				{ NSLog(@"No event access."); return; }
	
	dispatch_async(_fetchQueue,
	^{
		//	create a predicate to find the ekevent to delete
		NSPredicate *predicate		= [self.eventStore predicateForEventsWithStartDate:startDate
																		  endDate:endDate
																		calendars:@[self.eventStore.defaultCalendarForNewEvents]];
		NSArray *events				= [self.eventStore eventsMatchingPredicate:predicate];
	   
		//	post filter the events array with another predicate for the title of the vent
		NSPredicate *titlePredicate	= [NSPredicate predicateWithFormat:@"title matches %@", eventName];
		events						= [events filteredArrayUsingPredicate:titlePredicate];
	   
		//	delete each event
		NSError *error;
	   
		for (EKEvent *event in events)
			[self.eventStore removeEvent:event span:event.hasRecurrenceRules ? EKSpanFutureEvents : EKSpanThisEvent commit:NO error:&error];
	   
		BOOL success				= [self.eventStore commit:&error];
	   
		if (!success)				NSLog(@"There was an error saving the event: %@", error);
   });
	
	if (!_eventAccess)				{ NSLog(@"No event access."); return; }
}

/**
 *	convenience method for getting an event with given name, and times
 *
 *	@param	eventName				name of the event to add
 *	@param	startDate				when the event begins
 *	@param	endDate					when the event ends
 */
- (EKEvent *)getEventWithName:(NSString *)eventName
					startTime:(NSDate *)startDate
				   andEndTime:(NSDate *)endDate
{
	//	create an event
	EKEvent *event					= [EKEvent eventWithEventStore:self.eventStore];
	
	//	set the title
	event.title						= eventName;
	
	//	set the start and end ate
	event.startDate					= startDate;
	event.endDate					= endDate;
	
	//	set alarm
	EKAlarm *alarm					= [EKAlarm alarmWithRelativeOffset:-1800];
	[event addAlarm:alarm];
	
	//	add a note
	event.notes						= @"This will be exciting.";
	
	//	specify the calender to store the event
	event.calendar					= self.eventStore.defaultCalendarForNewEvents;
	
	return event;
}

/**
 *	save event to calendar database
 *
 *	@param	event					event to save
 */
- (void)saveEvent:(EKEvent *)event
{
	NSError *error;
	BOOL success					= [self.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
	
	if (!success)					NSLog(@"There was an error saving the event: %@", error);
}

#pragma mark - Initialisation

/**
 *	called to initialise a class instance
 */
- (id)init
{
	if (self = [super init])
	{
		//	this is the connection the calendar database that we need
		_eventStore					= [[EKEventStore alloc] init];
		
		//	use the event store to request access to the user's events and reminders
		[_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
		{
			_eventAccess			= granted;
			
			if (!_eventAccess)		NSLog(@"Event access not granted: %@", error);
			else					[[NSNotificationCenter defaultCenter] postNotificationName:kEventsAccessGrantedNotification object:self];
		}];
		
		[_eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error)
		{
			_reminderAccess			= granted;
			
			if (!_reminderAccess)	NSLog(@"Reminder access not granted: %@", error);
			else					[[NSNotificationCenter defaultCenter] postNotificationName:kRemindersAccessGrantedNotification object:self];
		}];
		
		_fetchQueue					= dispatch_queue_create("com.geekPlanner.fetchQueue", DISPATCH_QUEUE_SERIAL);
	}
	
	return self;
}

#pragma mark - Notifications

/**
 *	listens for notifications from event kit
 */
- (void)startBroadcastingModelChangedNotifications
{
	//	when there is a broadcast from event kit we call to fetch the conference reminders in case of updates
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(fetchAllConferenceReminders)
												 name:EKEventStoreChangedNotification
											   object:self.eventStore];
}

/**
 *
 */
- (void)stopBroadcastingModelChangedNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Reminder Methods

/**
 *	adds a reminder with a given title and due date
 *
 *	@param	title					the title of the reminder to add
 *	@param	dueDate					the time the reminder need sto be completed by
 */
- (void)addReminderWithTitle:(NSString *)title
					 dueTime:(NSDate *)dueDate
{
	if (!_reminderAccess)			{ NSLog(@"No reminder access."); return; }
	
	//	create a reminder
	EKReminder *reminder			= [EKReminder reminderWithEventStore:self.eventStore];
	
	//	set the title
	reminder.title					= title;
	
	//	set the calendar
	reminder.calendar				= [self calendarForReminders];
	
	//	extract nsdatecomponents from due date
	NSCalendar *calendar			= [NSCalendar currentCalendar];
	
	NSUInteger unitFlags			= NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	
	NSDateComponents *dueComponents	= [calendar components:unitFlags fromDate:dueDate];
	
	//	set the due date
	reminder.dueDateComponents		= dueComponents;
	
	//	save the reminder
	NSError *error;
	BOOL success					= [self.eventStore saveReminder:reminder commit:YES error:&error];
	if (!success)					NSLog(@"An error was encountered whilst saving the reminder: %@", error);
}

/**
 *
 */
- (EKCalendar *)calendarForReminders
{
	//	search for a reminders calendar that has already been created
	for (EKCalendar *calendar in [self.eventStore calendarsForEntityType:EKEntityTypeReminder])
		if ([calendar.title isEqualToString:kRemindersCalendarTitle])
			return calendar;
	
	//	if no reminders calendar has been created then we create one and save it to the database before returning it
	EKCalendar *remindersCalendar	= [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:self.eventStore];
	remindersCalendar.title			= kRemindersCalendarTitle;
	remindersCalendar.source		= self.eventStore.defaultCalendarForNewReminders.source;
	
	//	save the calendar
	NSError *error;
	BOOL success					= [self.eventStore saveCalendar:remindersCalendar commit:YES error:&error];
	if (!success)					{ NSLog(@"An error was encountered whilst saving the reminders calendar: %@", error); return nil; }
	
	return remindersCalendar;
}

/**
 *
 */
- (void)fetchAllConferenceReminders
{
	//	fetch the reminders in our specific calendar from calendar database 
	NSPredicate *predicate			= [self.eventStore predicateForRemindersInCalendars:@[[self calendarForReminders]]];
	[self.eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
	{
		self.reminders				= reminders.mutableCopy;
		[[NSNotificationCenter defaultCenter] postNotificationName:kRemindersChangedNotification object:self];
	}];
}

/**
 *
 */
- (void)reminder:(EKReminder *)reminder setCompletionFlagTo:(BOOL)completionFlag
{
	//	set completed flag
	reminder.completed				= completionFlag;
	
	//	save reminder to database
	NSError *error;
	BOOL success					= [self.eventStore saveReminder:reminder commit:YES error:&error];
	if (!success)					NSLog(@"There was an error editing the reminder.");
}

@end