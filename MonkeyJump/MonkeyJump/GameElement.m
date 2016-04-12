//
//  GameElement.m
//  MonkeyJump
//
//  Created by Kauserali on 02/08/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameElement.h"

@implementation GameElement

- (CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName andClassName:(NSString*)className {
    
    CCAnimation *animationToReturn = nil;
    NSString *fullFileName = [NSString stringWithFormat:@"%@.plist",className];
    NSString *plistPath;
    
    // 1: Get the Path to the plist file
    NSString *rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES)[0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle]
                     pathForResource:className ofType:@"plist"];
    }
    
    // 2: Read in the plist file
    NSDictionary *plistDictionary =
    [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // 3: If the plistDictionary was null, the file was not found.
    if (plistDictionary == nil) {
        CCLOG(@"Error reading plist: %@.plist", className);
        return nil; // No Plist Dictionary or file found
    }
    
    // 4: Get just the mini-dictionary for this animation
    NSDictionary *animationSettings =
    plistDictionary[animationName];
    if (animationSettings == nil) {
        CCLOG(@"Could not locate AnimationWithName:%@",animationName);
        return nil;
    }
    
    // 5: Get the delay value for the animation
    float animationDelay =
    [animationSettings[@"delay"] floatValue];
    animationToReturn = [CCAnimation animation];
    [animationToReturn setDelayPerUnit:animationDelay];
    
    // 6: Add the frames to the animation
    NSString *animationFramePrefix =
    animationSettings[@"filenamePrefix"];
    NSString *animationFrames =
    animationSettings[@"animationFrames"];
    NSArray *animationFrameNumbers =
    [animationFrames componentsSeparatedByString:@","];
    
    for (NSString *frameNumber in animationFrameNumbers) {
        NSString *frameName =
        [NSString stringWithFormat:@"%@%@.png",
         animationFramePrefix,frameNumber];
        [animationToReturn addSpriteFrame:
         [[CCSpriteFrameCache sharedSpriteFrameCache]
          spriteFrameByName:frameName]];
    }
    return animationToReturn;
}
@end
