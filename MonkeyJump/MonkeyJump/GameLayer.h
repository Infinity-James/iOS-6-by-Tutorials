//
//  GameLayer.h
//  MonkeyJump
//
//  Created by Kauserali on 27/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

@class HudLayer;

@interface GameLayer : CCLayer

- (id)initWithHud:(HudLayer*) hud;
- (id)initWithHud:(HudLayer *)hud andGameTrackingObject:(GameTrackingObject *)gameTrackingObject;

@end
