//
//  GameOverLayer.m
//  MonkeyJump
//
//  Created by Kauserali on 27/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConstants.h"
#import "GameOverLayer.h"
#import "GameScene.h"
#import "GameTrackingObject.h"
#import "MenuScene.h"

#define kReplayButtonTag 1
#define kMainMenuButtonTag 2
#define kChallengeFriendsButtonTag 3
#define kShareScoreButtonTag 4

@interface GameOverLayer()
{
	GameTrackingObject		*_gameTrackingObject;
    int64_t					_score;
}
	
@end

@implementation GameOverLayer

- (id) initWithScore:(int64_t)score andGameTrackingObject:(GameTrackingObject *)gameTrackingObject
{
    if (self = [super init])
	{
        _score				= score;
		_gameTrackingObject	= gameTrackingObject;
    }
	
    return self;
}

- (void) onEnter
{
    [super onEnter];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCSprite *background			= [CCSprite spriteWithFile:@"bg_menu.png"];
    background.position				= ccp(winSize.width * 0.5, winSize.height * 0.5);
    [self addChild:background];
    
    CCLabelBMFont *playerScore		= [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Your score %lld", _score]
															 fntFile:@"jungle_yellow.fnt"];
    playerScore.position			= ccp(winSize.width * 0.5, winSize.height * 0.7);
    [self addChild:playerScore];
    
    CCLabelBMFont *replay			= [CCLabelBMFont labelWithString:@"Replay" fntFile:@"jungle.fnt"];
    CCLabelBMFont *mainMenu			= [CCLabelBMFont labelWithString:@"Main menu" fntFile:@"jungle.fnt"];
    CCLabelBMFont *challenge		= [CCLabelBMFont labelWithString:@"Challenge friends" fntFile:@"jungle.fnt"];
    CCLabelBMFont *shareScore		= [CCLabelBMFont labelWithString:@"Share score" fntFile:@"jungle.fnt"];
    
    CCMenuItemLabel *replayGameItem	= [CCMenuItemLabel itemWithLabel:replay target:self selector:@selector(menuButtonPressed:)];
    replayGameItem.tag				= kReplayButtonTag;
    replayGameItem.scale			= 0.7;
    replayGameItem.position			= ccp(winSize.width * 0.2, winSize.height * 0.5);
    
    CCMenuItemLabel *mainMenuItem	= [CCMenuItemLabel itemWithLabel:mainMenu target:self selector:@selector(menuButtonPressed:)];
    mainMenuItem.tag				= kMainMenuButtonTag;
    mainMenuItem.scale				= 0.7;
    mainMenuItem.position			= ccp(winSize.width * 0.2, winSize.height * 0.35);
    
    CCMenuItemLabel *challengeItem	= [CCMenuItemLabel itemWithLabel:challenge target:self selector:@selector(menuButtonPressed:)];
    challengeItem.tag				= kChallengeFriendsButtonTag;
    challengeItem.scale				= 0.7;
    challengeItem.position			= ccp(winSize.width * 0.7, winSize.height * 0.5);
    
    CCMenuItemLabel *shareScoreItem	= [CCMenuItemLabel itemWithLabel:shareScore target:self selector:@selector(menuButtonPressed:)];
    shareScoreItem.tag				= kShareScoreButtonTag;
    shareScoreItem.scale			= 0.7;
    shareScoreItem.position			= ccp(winSize.width * 0.7, winSize.height * 0.35);
    
    CCMenu *menu					= [CCMenu menuWithItems:replayGameItem, mainMenuItem, challengeItem, shareScoreItem, nil];
    menu.position					= CGPointZero;
    [self addChild:menu];
    
}

- (void) menuButtonPressed:(id) sender
{
    CCMenuItemLabel *menuItem		= (CCMenuItemLabel*) sender;
    if (menuItem.tag == kReplayButtonTag)
        [[CCDirector sharedDirector] replaceScene:[CCTransitionProgressRadialCCW transitionWithDuration:1.0 scene:[[GameScene alloc] init]]];
	
    else if(menuItem.tag == kChallengeFriendsButtonTag)
        [[GameKitHelper sharedGameKitHelper] showFriendsPickerControllerForScore:[NSNumber numberWithInt:_score]
														 withGameTrackingObject:_gameTrackingObject];
	
    else if(menuItem.tag == kMainMenuButtonTag)
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0
																					 scene:[[MenuScene alloc] init] withColor:ccWHITE]];
	
    else if (menuItem.tag == kShareScoreButtonTag)
        [[GameKitHelper sharedGameKitHelper] shareScore:_score
										   forCategory:kHighScoreLeaderboardCategory];
    
}

@end











































