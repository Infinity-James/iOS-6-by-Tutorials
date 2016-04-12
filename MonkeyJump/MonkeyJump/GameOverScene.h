//
//  GameOverScene.h
//  MonkeyJump
//
//  Created by Kauserali on 27/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

@class GameTrackingObject;

@interface GameOverScene : CCScene

- (id)  initWithScore:(int64_t)score
andGameTrackingObject:(GameTrackingObject *)gameTrackingObject;

@end
