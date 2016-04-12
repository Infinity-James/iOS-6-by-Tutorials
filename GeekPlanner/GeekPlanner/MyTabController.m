//
//  MyTabController.m
//  GeekPlanner
//
//  Created by James Valaitis on 21/03/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "Conference.h"
#import "MainController.h"
#import "MyTabController.h"
#import "RemindersController.h"

@interface MyTabController ()

@end

@implementation MyTabController

#pragma mark - Convenience & Helper Methods

- (NSMutableArray *)getConferences
{
	NSArray *conferenceDetails				= [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"conferences" ofType:@"plist"]];
    NSMutableArray *conferences				= [[NSMutableArray alloc] initWithCapacity:conferenceDetails.count];
	
    for (NSDictionary *dictionary in conferenceDetails)
	{
        Conference *conference				= [[Conference alloc] init];
        conference.name						= [dictionary objectForKey:@"Name"];
        conference.imageName				= [dictionary objectForKey:@"ImageName"];
        conference.startDate				= [dictionary objectForKey:@"StartDate"];
        conference.endDate					= [dictionary objectForKey:@"EndDate"];
        [conferences addObject:conference];
    }
	
	return conferences;
}

#pragma mark - Initialisation

/**
 *	called to initialise a class instance
 */
- (id)init
{
	if (self = [super init])
	{
		MainController *mainController		= [[MainController alloc] init];
		RemindersController *reminders		= [[RemindersController alloc] initWithStyle:UITableViewStyleGrouped];
		
		mainController.conferences			= [self getConferences];
		mainController.title				= @"Conferences";
		reminders.title						= @"Reminders";
		
		UINavigationController *navigation	= [[UINavigationController alloc] initWithRootViewController:mainController];
		
		navigation.tabBarItem				= [[UITabBarItem alloc] initWithTitle:@"Conferences" image:nil tag:1];
		reminders.tabBarItem				= [[UITabBarItem alloc] initWithTitle:@"Reminders" image:nil tag:2];
		
		self.viewControllers				= @[navigation, reminders];
	}
	
	return self;
}

@end
