//
//  EventKitController.h
//  GeekPlanner
//
//  Created by James Valaitis on 21/03/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import <EventKit/EventKit.h>

extern NSString *const kEventsAccessGrantedNotification;
extern NSString *const kRemindersAccessGrantedNotification;
extern NSString *const kRemindersChangedNotification;

@interface EventKitController : NSObject

@property (nonatomic, assign, readonly)	BOOL			eventAccess;
@property (nonatomic, strong, readonly)	EKEventStore	*eventStore;
@property (nonatomic, assign, readonly) BOOL			reminderAccess;
@property (nonatomic, strong)			NSMutableArray	*reminders;

- (void)addEventWithName:(NSString *)eventName
			   startTime:(NSDate *)startDate
			  andEndTime:(NSDate *)endDate;
- (void)addRecurringEventWithName:(NSString *)eventName
						startTime:(NSDate *)startDate
					   andEndTime:(NSDate *)endDate;
- (void)addReminderWithTitle:(NSString *)title
					 dueTime:(NSDate *)dueDate;
- (void)deleteEventWithName:(NSString *)eventName
				  startTime:(NSDate *)startDate
				 andEndTime:(NSDate *)endDate;
- (void)fetchAllConferenceReminders;
- (void)   reminder:(EKReminder *)reminder
setCompletionFlagTo:(BOOL)completionFlag;
- (void)startBroadcastingModelChangedNotifications;
- (void)stopBroadcastingModelChangedNotifications;

@end