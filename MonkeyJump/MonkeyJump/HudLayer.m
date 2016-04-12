//
//  HudLayer.m
//  MonkeyJump
//
//  Created by Kauserali on 27/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HudLayer.h"

#define kDistanceCountLabelTag 1
#define kLivesCountLabelTag 2

@interface HudLayer() {
    CCLabelTTF *_distanceCountLabel, *_livesCountLabel;
}
@end

@implementation HudLayer

- (void) onEnter {
    [super onEnter];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    _distanceCountLabel = [CCLabelTTF labelWithString:@"0m" dimensions:CGSizeMake(50, 15) hAlignment:kCCTextAlignmentLeft fontName:@"Arial" fontSize:15];
    [_distanceCountLabel setColor:ccWHITE];
    _distanceCountLabel.position = ccp(_distanceCountLabel.contentSize.width/2 + 10, winSize.height - _distanceCountLabel.contentSize.height/2 - 10);
    [_distanceCountLabel setTag:kDistanceCountLabelTag];
    [self addChild:_distanceCountLabel];
    
    _livesCountLabel = [CCLabelTTF labelWithString:@"Lives: 3" dimensions:CGSizeMake(100, 17) hAlignment:kCCTextAlignmentLeft fontName:@"Arial" fontSize:17];
    [_livesCountLabel setColor:ccWHITE];
    _livesCountLabel.position = ccp(winSize.width - _livesCountLabel.contentSize.width/2 - 10, winSize.height - _livesCountLabel.contentSize.height/2 - 10);
    [_livesCountLabel setTag:kLivesCountLabelTag];
    [self addChild:_livesCountLabel];
}

- (void) updateDistanceLabel:(int) distance {
    [_distanceCountLabel setString:[NSString stringWithFormat:@"%d m", distance]];
}

- (void) updateLivesLabel:(int) lives {
    [_livesCountLabel setString:[NSString stringWithFormat:@"Lives: %d", lives]];
}
@end
