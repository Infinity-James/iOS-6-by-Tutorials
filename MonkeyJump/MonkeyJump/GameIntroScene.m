//
//  GameIntroScene.m
//  MonkeyJump
//
//  Created by Kauserali on 02/08/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameIntroScene.h"
#import "GameIntroLayer.h"

@implementation GameIntroScene
- (id) init {
    self = [super init];
    if (self) {
        GameIntroLayer *gameIntroLayer = [GameIntroLayer node];
        [self addChild:gameIntroLayer];
    }
    return self;
}
@end
