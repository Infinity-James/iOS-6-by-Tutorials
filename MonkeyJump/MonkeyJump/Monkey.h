//
//  Monkey.h
//  MonkeyJump
//
//  Created by Kauserali on 27/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConstants.h"
#import "GameElement.h"

@interface Monkey : GameElement
@property (nonatomic) int lives;
@property (nonatomic, readwrite) MonkeyState state;
- (void) changeState:(MonkeyState) newState;
@end
