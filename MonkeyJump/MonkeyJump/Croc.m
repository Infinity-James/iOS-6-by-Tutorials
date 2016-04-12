//
//  Croc.m
//  MonkeyJump
//
//  Created by Kauserali on 02/08/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Croc.h"
@implementation Croc

- (id) initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect {
    self = [super initWithTexture:texture rect:rect];
    if (self) {
        self.gameElementType = kCroc;
        [self setWalkAnim:[self loadPlistForAnimationWithName:@"walkAnim" andClassName:NSStringFromClass([self class])]];
    }
    return self;
}
@end
