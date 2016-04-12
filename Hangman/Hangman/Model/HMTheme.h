//
//  HMTheme.h
//  Hangman
//
//  Created by Ray Wenderlich on 7/11/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMTheme : NSObject

@property (nonatomic, readonly, strong) NSURL * dirURL;
@property (nonatomic, readonly, strong) NSString * name;
@property (nonatomic, readonly, strong) NSURL * correctSoundURL;
@property (nonatomic, readonly, strong) NSURL * incorrectSoundURL;
@property (nonatomic, readonly, strong) NSURL * winSoundURL;
@property (nonatomic, readonly, strong) NSURL * loseSoundURL;

+ (BOOL)themeAtURL:(NSURL *)url;
- (id)initWithDirURL:(NSURL *)url;
- (int)maxWrongGuesses;
- (NSURL *)imageURLForWrongGuesses:(int)wrongGuesses;


@end
