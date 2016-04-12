//
//  GameLayer.m
//  MonkeyJump
//
//  Created by Kauserali on 27/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Croc.h"
#import "GameLayer.h"
#import "GameOverScene.h"
#import "GameTrackingObject.h"
#import "GhostMonkey.h"
#import "HedgeHog.h"
#import "HudLayer.h"
#import "Monkey.h"
#import "SimpleAudioEngine.h"
#import "Snake.h"
#import "UtilityMethods.h"

#define kSpriteBatchNodeTag			1
#define kBackgroundImage1Tag		2
#define kBackgroundImage2Tag		3
#define kMonkeyTag					4
#define kGhostMonkeyTag				5

#define kBackgroundScrollSpeed		170
#define kMonkeySpeed				20

@interface GameLayer()
{
    BOOL				_jumping, _isInvincible;
    CGFloat				_distance;
    double				_nextSpawn;
    CGSize				_winSize;
    
    HudLayer			*_hudLayer;
    CCSpriteBatchNode	*_spriteBatchNode;
    Monkey				*_monkey;
    
    float				_difficultyMeasure;
	
	double				_startTime;
	long				_seed;
	
	GameTrackingObject	*_gameTrackingObject;
	
	GhostMonkey			*_ghostMonkey;
}

@property (nonatomic, copy)	GameTrackingObject	*challengerGame;

@end

@implementation GameLayer

- (id) initWithHud:(HudLayer*) hud
{
    if (self = [super init])
	{
		_seed						= time(NULL);
		srand(_seed);
        _hudLayer					= hud;
        _difficultyMeasure			= 1;
		_gameTrackingObject			= [[GameTrackingObject alloc] init];
		_gameTrackingObject.seed	= _seed;
    }
	
    return self;
}

- (id)initWithHud:(HudLayer *)hud andGameTrackingObject:(GameTrackingObject *)gameTrackingObject
{
	if (self = [self initWithHud:hud])
	{
		self.challengerGame			= gameTrackingObject;
		_seed						= gameTrackingObject.seed;
		srand(_seed);
		_gameTrackingObject.seed	= _seed;
	}
	
	return self;
}

- (void) onEnter
{
    [super onEnter];
    _winSize						= [CCDirector sharedDirector].winSize;
    
    CCSprite *background1			= [CCSprite spriteWithFile:@"bg_repeat.png"];
    background1.position			= ccp(background1.contentSize.width/2, background1.contentSize.height/2);
    [background1 setTag:kBackgroundImage1Tag];
    [self addChild:background1];
    
    CCSprite *background2			= [CCSprite spriteWithFile:@"bg_repeat.png"];
    background2.position			= ccp(background2.contentSize.width + background2.contentSize.width/2, background2.contentSize.height/2);
    [background2 setTag:kBackgroundImage2Tag];
    [self addChild:background2];
    
    _spriteBatchNode				= [CCSpriteBatchNode batchNodeWithFile:@"game_assets.png"];
    [_spriteBatchNode setTag:kSpriteBatchNodeTag];
    [self addChild:_spriteBatchNode];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"game_assets.plist"];
    
    _monkey							= [Monkey spriteWithSpriteFrameName:@"monkey_run1.png"];
    _monkey.position				= ccp(0.125 * _winSize.width, 0.271 * _winSize.height);
    [_monkey setTag:kMonkeyTag];
    [_spriteBatchNode addChild:_monkey];
	
	if (self.challengerGame)
	{
		_ghostMonkey				= [GhostMonkey spriteWithSpriteFrameName:@"monkey_ghost_run1.png"];
		_ghostMonkey.position		= ccp(0.125 * _winSize.width, 0.271 * _winSize.height);
		[_ghostMonkey setTag:kGhostMonkeyTag];
		[_spriteBatchNode addChild:_ghostMonkey];
	}
}

- (void) onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    
    [_monkey changeState:kWalking];
    self.isTouchEnabled				= YES;
	
	_startTime						= [[NSDate date] timeIntervalSince1970];
	
	if (self.challengerGame)
	{
		[_ghostMonkey changeState:kWalking];
		[self schedule:@selector(updateGhostMonkeyMoves:)];
	}
	
    [self scheduleUpdate];
}

- (void)doneJump
{
    _jumping						= NO;
    [_monkey changeState:kWalking];
}

- (void)doneGhostJump
{
	[_ghostMonkey changeState:kWalking];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_jumping)
	{
        _jumping = YES;
		
		[_gameTrackingObject addJumpTime:([[NSDate date] timeIntervalSince1970] - _startTime)];
		
        [[SimpleAudioEngine sharedEngine] playEffect:@"jump.wav"];
        
        CCJumpBy *jumpAction		= [CCJumpBy actionWithDuration:1.2 position:ccp(0,0) height:120 jumps:1];
        CCCallFunc *doneJumpAction	= [CCCallFunc actionWithTarget:self selector:@selector(doneJump)];
        CCSequence *sequenceAction	= [CCSequence actions:jumpAction,doneJumpAction, nil];
        
        [_monkey changeState:kJumping];
        [_monkey runAction:[CCSpawn actions:jumpAction,sequenceAction, nil]];
    }
    
}

#pragma mark - Update Method

- (void)update:(ccTime)deltaTime
{    
    _distance						+= kMonkeySpeed * deltaTime;
    [_hudLayer updateDistanceLabel:_distance];
    
    CGFloat xOffset = kBackgroundScrollSpeed * (-1) * deltaTime;
    
    CCSprite *background1			= (CCSprite*)[self getChildByTag:kBackgroundImage1Tag];
    CCSprite *background2			= (CCSprite*)[self getChildByTag:kBackgroundImage2Tag];
    
    if (background1.position.x < (background1.contentSize.width/2 * -1))
        background1.position		= ccp((background2.position.x + background2.contentSize.width/2) +
										  background1.contentSize.width/2, background1.contentSize.height/2);

    if (background2.position.x < (background2.contentSize.width/2 * -1)) 
        background2.position		= ccp((background1.position.x + background1.contentSize.width/2) +
										  background2.contentSize.width/2, background2.contentSize.height/2);

    background1.position			= ccp(background1.position.x + xOffset, background1.position.y);
    background2.position			= ccp(background2.position.x + xOffset, background2.position.y);
    
    double curTime					= [[NSDate date] timeIntervalSince1970];
    if (curTime > _nextSpawn)
	{
        int enemyType				= arc4random() % 3;
        
        CCSprite *enemySprite;
        
        if (enemyType == kSnakeEnemyType)
		{
            enemySprite				= [Snake spriteWithSpriteFrameName:@"enemy_snake_crawl1.png"];
            [enemySprite runAction:[CCRepeatForever actionWithAction:
                                    [CCAnimate actionWithAnimation:((Snake*)enemySprite).crawlAnim]]];
        }
		else if(enemyType == kCrocEnemyType)
		{
            enemySprite				= [Croc spriteWithSpriteFrameName:@"enemy_croc_walk1.png"];
            [enemySprite runAction:[CCRepeatForever actionWithAction:
                                    [CCAnimate actionWithAnimation:((Croc*)enemySprite).walkAnim]]];
        }
		else if(enemyType == kHedgeHogEnemyType)
		{
            enemySprite				= [HedgeHog spriteWithSpriteFrameName:@"enemy_hedgehog_walk1.png"];
            [enemySprite runAction:[CCRepeatForever actionWithAction:
                                    [CCAnimate actionWithAnimation:((HedgeHog*)enemySprite).walkAnim]]];
        }
		
        enemySprite.position		= ccp(_winSize.width + enemySprite.contentSize.width/2, 0.22 * _winSize.height);
        [enemySprite runAction:[CCSequence actions:
                                [CCMoveBy actionWithDuration:3 position:ccp(- _winSize.width - enemySprite.contentSize.width, 0)],
                                [CCCallFuncN actionWithTarget:self selector:@selector(enemyMovedOffScreen:)],
                                nil]];
        [_spriteBatchNode addChild:enemySprite];
        
        float randomInterval		= 4/_difficultyMeasure; //permissible value between 4 & 1.8 1--->2.22
        _nextSpawn					= curTime + randomInterval;
        
        if (_difficultyMeasure < 2.22)
            _difficultyMeasure		= _difficultyMeasure + 0.122;
    }
    
    //check for collisions
    if (!_isInvincible)
	{
        for (CCSprite *sprite in _spriteBatchNode.children)
		{
            if (sprite.tag == kMonkeyTag || sprite.tag == kGhostMonkeyTag)	continue;
			
            else
			{
                float insetAmtX		= 10;
                float insetAmtY		= 10;
                CGRect enemyRect	= CGRectInset(sprite.boundingBox, insetAmtX, insetAmtY);
				
                if (CGRectIntersectsRect(_monkey.boundingBox, enemyRect))
				{
                    _isInvincible	= YES;
                    _monkey.lives	-= 1;
					
					[_gameTrackingObject addHitTime:([[NSDate date] timeIntervalSince1970] - _startTime)];
                    
                    [_hudLayer updateLivesLabel:_monkey.lives];
					
                    if (_monkey.lives <= 0)
					{
                        _monkey.position = ccp(0.125 * _winSize.width, 0.271 * _winSize.height);
                        [_monkey changeState:kDead];
                        self.isTouchEnabled = NO;
                        [self unscheduleUpdate];
                        [self scheduleOnce:@selector(monkeyDead) delay:0.5];
                        return;
                    }
                    
                    [[SimpleAudioEngine sharedEngine] playEffect:@"hurt.mp3"];
                    id action = [CCSequence actions:[CCBlink actionWithDuration:1.5 blinks:4],
                              [CCShow action],
                              [CCCallFunc actionWithTarget:self selector:@selector(doneTakingDamage)], nil];
                    [_monkey runAction:action];
                    
                    [_hudLayer updateLivesLabel:_monkey.lives];
                    break;
				}
            }
        }
    }
}

- (void)updateGhostMonkeyMoves:(ccTime)deltaTime
{
	double currentTimeSinceStart	= [[NSDate date] timeIntervalSince1970] - _startTime;
	
	[self.challengerGame.jumpTimingSinceStartOfGame enumerateObjectsUsingBlock:^(NSNumber *jumpTime, NSUInteger idx, BOOL *stop)
	{
		if (jumpTime.doubleValue <= currentTimeSinceStart)
		{
			*stop					= YES;
			[self.challengerGame.jumpTimingSinceStartOfGame removeObject:jumpTime];
			
			CCJumpBy *jumpAction	= [CCJumpBy actionWithDuration:1.2 position:ccp(0, 0) height:120 jumps:1];
			CCCallFunc *doneJump	= [CCCallFunc actionWithTarget:self selector:@selector(doneGhostJump)];
			CCSequence *sequenceAct	= [CCSequence actions:jumpAction, doneJump, nil];
			
			[_ghostMonkey changeState:kJumping];
			[_ghostMonkey runAction:sequenceAct];
		}
	}];
	
	[self.challengerGame.hitTimingSinceStartOfGame enumerateObjectsUsingBlock:^(NSNumber *hitTime, NSUInteger idx, BOOL *stop)
	{
		if (hitTime.doubleValue <= currentTimeSinceStart)
		{
			[self.challengerGame.hitTimingSinceStartOfGame removeObject:hitTime];
			*stop					= YES;
			
			id action				= [CCSequence actions:[CCBlink actionWithDuration:1.5 blinks:4],
															[CCShow action],
															[CCCallFunc actionWithTarget:self
																				selector:@selector(doneGhostTakingDamage)], nil];
			
			[_ghostMonkey runAction:action];
			
			_ghostMonkey.lives		-= 1;
			
			if (_ghostMonkey.lives <= 0)
			{
				_ghostMonkey.position	= ccp(0.125 * _winSize.width, 0.271 * _winSize.height);
				[_ghostMonkey changeState:kDead];
				[self unschedule:@selector(updateGhostMonkeyMoves:)];
				[self scheduleOnce:@selector(ghostMonkeyDead) delay:0.5];
			}
		}
	}];
}

- (void) monkeyDead
{
	[[GameKitHelper sharedGameKitHelper] submitScore:(int64_t)_distance inCategory:kHighScoreLeaderboardCategory];
    [[CCDirector sharedDirector] replaceScene:[[GameOverScene alloc] initWithScore:(int64_t)_distance andGameTrackingObject:_gameTrackingObject]];
	[UtilityMethods reportAchievementsForDistance:(int64_t)_distance];
}

- (void)ghostMonkeyDead
{
	[_ghostMonkey removeFromParentAndCleanup:YES];
}


- (void) doneTakingDamage
{
    _isInvincible					= NO;
    [_monkey changeState:kWalking];
}

- (void)doneGhostTakingDamage
{
	[_ghostMonkey changeState:kWalking];
}

- (void) enemyMovedOffScreen:(id) sender {
    CCSprite *enemy = (CCSprite*) sender;
    [enemy removeFromParentAndCleanup:YES];
}

@end










































