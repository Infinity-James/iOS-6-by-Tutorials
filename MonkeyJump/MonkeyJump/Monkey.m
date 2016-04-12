//
//  Monkey.m
//  MonkeyJump
//
//  Created by Kauserali on 27/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Monkey.h"

#define kWalkAnimationTag 1
#define kJumpAnimationTag 2

@interface Monkey()
@property (nonatomic, strong) CCAnimation *walkAnim;
@property (nonatomic, strong) CCAnimation *jumpAnim;
@end

@implementation Monkey

- (id) initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect {
    self = [super initWithTexture:texture rect:rect];
    if (self) {
        self.lives = 3;
        self.gameElementType = kMonkey;
        [self initAnimations];
    }
    return self;
}

#pragma mark -
- (void) initAnimations {
    [self setWalkAnim:[self loadPlistForAnimationWithName:@"walkAnim" andClassName:NSStringFromClass([self class])]];
    [self setJumpAnim:[self loadPlistForAnimationWithName:@"jumpAnim" andClassName:NSStringFromClass([self class])]];
}

- (void) doneTakingDamage {
    [self changeState:kWalking];
}

- (void) changeState:(MonkeyState) newState {
    if (_state == newState)
        return;
    
    _state = newState;
    
    id action = nil;

    if (newState == kWalking) {
        [self stopActionByTag:kJumpAnimationTag];
        action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:self.walkAnim]];
        [action setTag:kWalkAnimationTag];
    } else if(newState == kJumping) {
        [self stopActionByTag:kWalkAnimationTag];
        action = [CCAnimate actionWithAnimation:self.jumpAnim];
        [action setTag:kJumpAnimationTag];
    } else if(newState == kDead) {
        [self stopAllActions];
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"monkey_dead.png"]];
    }
    if (action != nil) {
        [self runAction:action];
    }
}
@end
