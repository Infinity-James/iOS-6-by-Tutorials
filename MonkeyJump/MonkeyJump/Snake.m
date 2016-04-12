//
//  Snake.m
//  MonkeyJump
//
//  Created by Kauserali on 02/08/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Snake.h"

@implementation Snake

- (id) initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect {
    self = [super initWithTexture:texture rect:rect];
    if (self) {
        self.gameElementType = kSnake;
        [self setCrawlAnim:[self loadPlistForAnimationWithName:@"crawlAnim" andClassName:NSStringFromClass([self class])]];
    }
    return self;
}
@end
