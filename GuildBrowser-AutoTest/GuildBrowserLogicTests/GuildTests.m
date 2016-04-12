//
//  GuildTests.m
//  GuildBrowser
//
//  Created by James Valaitis on 05/04/2013.
//  Copyright (c) 2013 Charlie Fulton. All rights reserved.
//

#import <OCMock/OCMock.h>
#import "Character.h"
#import "Guild.h"
#import "GuildTests.h"
#import "TestSemaphor.h"
#import "WoWApiClient.h"

@implementation GuildTests
{
	Guild								*_guild;
	NSDictionary						*_testGuildData;
}

/**
 *
 */
- (void)setUp
{
	NSURL *dataServiceURL				= [[NSBundle bundleForClass:self.class] URLForResource:@"guild" withExtension:@"json"];
	NSData *sampleData					= [NSData dataWithContentsOfURL:dataServiceURL];
	NSError *error;
	id json								= [NSJSONSerialization JSONObjectWithData:sampleData options:kNilOptions error:&error];
	_testGuildData						= json;
}

/**
 *
 */
- (void)tearDown
{
	_guild								= nil;
	_testGuildData						= nil;
}

/**
 *
 */
- (void)testCreatingGuildDataFromWOWAPIClient
{
	//	create mock object that will be used like a real instance of the wowapiclient
	id mockWOWAPIClient					= [OCMockObject mockForClass:[WoWApiClient class]];
	
	//	define what shoud happen when we call the guildwithname method on the mock object
	[[[mockWOWAPIClient stub] andDo:^(NSInvocation *invocation)
	{
		//	create block variable to pass in
		void (^successBlock)(Guild *guild);
		
		//	get reference to success block from call to our stub method (arguments start at index 2)
		[invocation getArgument:&successBlock atIndex:4];
		
		//	create guild instance using the sumlated json data
		Guild *testData					= [[Guild alloc] initWithGuildData:_testGuildData];
		
		//	guild instance is passed into success block we got reference to above
		successBlock(testData);
		
		//	this is the method we stub and we give it any argument
	}] guildWithName:[OCMArg any] onRealm:[OCMArg any] success:[OCMArg any] error:[OCMArg any]];
	
	//	string used to wait for block to complete
	NSString *semaphoreKey				= @"membersLoaded";
	
	//	now call the stubbed out client by calling the real method
	[mockWOWAPIClient guildWithName:@"Dream Catchers"
							onRealm:@"Borean Tundra"
							success:^(Guild *guild)
	{
		//	guild object will be set up and ready to use
		_guild							= guild;
		
		//	allows test to continue by lifting semaphore key and satisfying running loop wait on it to lift
		[[TestSemaphor sharedInstance] lift:semaphoreKey];
	}
							  error:^(NSError *error)
	{
		//	if test failed we still lift the key so that it can continue
		[[TestSemaphor sharedInstance] lift:semaphoreKey];
	}];
	
	//	this is where we stop the code until the key is lifted
	[[TestSemaphor sharedInstance] waitForKey:semaphoreKey];
	
	//	data has either been received or failed so we find out
	STAssertNotNil(_guild, @"");
	STAssertEqualObjects(_guild.name, @"Dream Catchers", nil);
	STAssertTrue(_guild.members.count == ((NSArray *)[_testGuildData valueForKey:@"members"]).count, nil);
	
	//	now validate each type of class was loaded in correct order
	
	//	15
	
	//	validate one death knight ordered by level, achievement points
	NSArray *characters					= [_guild membersByWowClassTypeName:WowClassTypeDeathKnight];
	STAssertEqualObjects(((Character *)characters[0]).name, @"Lixiu", nil);
	
	//	validate thre druids prdered by level, achievement points
	characters							= [_guild membersByWowClassTypeName:WowClassTypeDruid];
	STAssertEqualObjects(((Character *)characters[0]).name, @"Elassa", nil);
	STAssertEqualObjects(((Character *)characters[1]).name, @"Ivymoon", nil);
	STAssertEqualObjects(((Character *)characters[2]).name, @"Everybody", nil);
}

@end