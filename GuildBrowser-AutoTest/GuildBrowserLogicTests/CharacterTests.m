//
//  CharacterTests.m
//  GuildBrowser
//
//  Created by James Valaitis on 05/04/2013.
//  Copyright (c) 2013 Charlie Fulton. All rights reserved.
//

#import "Character.h"
#import "CharacterTests.h"
#import "Item.h"

@implementation CharacterTests
{
	NSDictionary						*_characterDetailJSON;
	Character							*_testDude;
}

/**
 *
 */
- (void)setUp
{
	NSURL *dataServiceURL				= [[NSBundle bundleForClass:self.class] URLForResource:@"character" withExtension:@"json"];
	
	NSData *sampleData					= [NSData dataWithContentsOfURL:dataServiceURL];
	
	NSError *error;
	
	id json								= [NSJSONSerialization JSONObjectWithData:sampleData options:kNilOptions error:&error];
	
	STAssertNotNil(json, @"Invalid Test Data.");
	
	_characterDetailJSON				= json;
	_testDude							= [[Character alloc] initWithCharacterDetailData:_characterDetailJSON];
}

/**
 *
 */
- (void)tearDown
{
	_characterDetailJSON				= nil;
	_testDude							= nil;
}

/**
 *
 */
- (void)testCreateCharacterFromDetailJSON
{
	Character *testDudeA				= [[Character alloc] initWithCharacterDetailData:_characterDetailJSON];
	STAssertNotNil(testDudeA, @"Could not create character from the detail JSON.");
	
	Character *testDudeB				= [[Character alloc] initWithCharacterDetailData:nil];
	STAssertNotNil(testDudeB, @"Could not create character from nil data.");
}

- (void)testCreateCharacterFromDetailJSONProps
{
	STAssertEqualObjects(_testDude.thumbnail, @"borean-tundra/171/40508075-avatar.jpg", @"Thumbnail URL is incorrect.");
	STAssertEqualObjects(_testDude.name, @"Hagrel", @"name is wrong.");
	STAssertEqualObjects(_testDude.battleGroup, @"Emberstorm", @"battlegroup is wrong.");
	STAssertEqualObjects(_testDude.realm, @"Borean Tundra", @"realm is wrong.");
	STAssertEqualObjects(_testDude.achievementPoints, @3130, @"achievement points is wrong.");
	STAssertEqualObjects(_testDude.level,@85, @"level is wrong.");
	STAssertEqualObjects(_testDude.classType, @"Warrior", @"class type is wrong.");
	STAssertEqualObjects(_testDude.race, @"Human", @"race is wrong.");
	STAssertEqualObjects(_testDude.gender, @"Male", @"gener is wrong.");
	STAssertEqualObjects(_testDude.averageItemLevel, @379, @"avg item level is wrong.");
	STAssertEqualObjects(_testDude.averageItemLevelEquipped, @355, @"avg item level is wrong.");
}

-(void)testCreateCharacterFromDetailJSONValidateItems
{
	STAssertEqualObjects(_testDude.neckItem.name,@"Stoneheart Choker", @"Name is wrong.");
	STAssertEqualObjects(_testDude.wristItem.name,@"Vicious Pyrium Bracers", @"Name is wrong.");
	STAssertEqualObjects(_testDude.waistItem.name,@"Girdle of the Queen's Champion", @"Name is wrong.");
	STAssertEqualObjects(_testDude.handsItem.name,@"Time Strand Gauntlets", @"Name is wrong.");
	STAssertEqualObjects(_testDude.shoulderItem.name,@"Temporal Pauldrons", @"Name is wrong.");
	STAssertEqualObjects(_testDude.chestItem.name,@"Ruthless Gladiator's Plate Chestpiece", @"Name is wrong.");
	STAssertEqualObjects(_testDude.fingerItem1.name,@"Thrall's Gratitude", @"Name is wrong.");
	STAssertEqualObjects(_testDude.fingerItem2.name,@"Breathstealer Band", @"Name is wrong.");
	STAssertEqualObjects(_testDude.shirtItem.name,@"Black Swashbuckler's Shirt", @"Name is wrong.");
	STAssertEqualObjects(_testDude.tabardItem.name,@"Tabard of the Wildhammer Clan", @"Name is wrong.");
	STAssertEqualObjects(_testDude.headItem.name,@"Vicious Pyrium Helm", @"Neck name is wrong.");
	STAssertEqualObjects(_testDude.backItem.name,@"Cloak of the Royal Protector", @"Neck name is wrong.");
	STAssertEqualObjects(_testDude.legsItem.name,@"Bloodhoof Legguards", @"Neck name is wrong.");
	STAssertEqualObjects(_testDude.feetItem.name,@"Treads of the Past", @"Neck name is wrong.");
	STAssertEqualObjects(_testDude.mainHandItem.name,@"Axe of the Tauren Chieftains", @"Neck name is wrong.");
	STAssertEqualObjects(_testDude.offHandItem.name,nil, @"Offhand should be nil.");
	STAssertEqualObjects(_testDude.trinketItem1.name,@"Rosary of Light", @"Neck name is wrong.");
	STAssertEqualObjects(_testDude.trinketItem2.name,@"Bone-Link Fetish", @"Neck name is wrong.");
	STAssertEqualObjects(_testDude.rangedItem.name,@"Ironfeather Longbow", @"Neck name is wrong.");
}

@end
