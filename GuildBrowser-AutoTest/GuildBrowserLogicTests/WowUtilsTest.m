//
//  WowUtilsTest.m
//  GuildBrowser
//
//  Created by James Valaitis on 05/04/2013.
//  Copyright (c) 2013 Charlie Fulton. All rights reserved.
//

#import "WoWUtils.h"
#import "WowUtilsTest.h"

@implementation WowUtilsTest

- (void)testCharacterClassNameLookup
{
	STAssertEqualObjects(@"Warrior", [WoWUtils classFromCharacterType:1], @"ClassType should be 'Warrior'");
	STAssertFalse([@"Mage" isEqualToString:[WoWUtils classFromCharacterType:2]], nil);
	STAssertTrue([@"Paladin" isEqualToString:[WoWUtils classFromCharacterType:2]], nil);
}

- (void)testRaceTypeLookup
{
	STAssertEqualObjects(@"Human", [WoWUtils raceFromRaceType:1], nil);
	STAssertEqualObjects(@"Orc", [WoWUtils raceFromRaceType:2], nil);
	STAssertFalse([@"Night Elf" isEqualToString:[WoWUtils raceFromRaceType:45]], nil);
}

- (void)testQualityLookup
{
	STAssertEqualObjects(@"Grey", [WoWUtils qualityFromQualityType:1], nil);
	STAssertFalse([@"Purple" isEqualToString:[WoWUtils qualityFromQualityType:10]], nil);
}

@end