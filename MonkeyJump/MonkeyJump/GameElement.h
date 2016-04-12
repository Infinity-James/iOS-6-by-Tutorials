//
//  GameElement.h
//  MonkeyJump
//
//  Created by Kauserali on 02/08/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConstants.h"

@interface GameElement : CCSprite
@property GameElementType gameElementType;

- (CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName andClassName:(NSString*)className;
@end
