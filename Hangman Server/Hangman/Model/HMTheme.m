//
//  HMTheme.m
//  Hangman
//
//  Created by Ray Wenderlich on 7/11/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "HMTheme.h"

@implementation HMTheme {
    NSMutableArray * _imageURLs;
}

+ (BOOL)themeAtURL:(NSURL *)url {
    NSURL * plistURL = [url URLByAppendingPathComponent:@"theme.plist"];
    return [[NSFileManager defaultManager] fileExistsAtPath:plistURL.path];
}

- (id)initWithDirURL:(NSURL *)url {
    if ((self = [super init])) {

        _dirURL = url;
        
        NSURL * plistURL = [url URLByAppendingPathComponent:@"theme.plist"];
        NSDictionary * dict = [NSDictionary dictionaryWithContentsOfURL:plistURL];
        if (dict == nil) return nil;
        
        _name = dict[@"name"];
        
        NSString * correctSoundString = dict[@"correctSound"];
        if (correctSoundString) {
            _correctSoundURL = [url URLByAppendingPathComponent:correctSoundString];
        }
        NSString * incorrectSoundString = dict[@"incorrectSound"];
        if (incorrectSoundString) {
            _incorrectSoundURL = [url URLByAppendingPathComponent:incorrectSoundString];
        }
        NSString * winSoundString = dict[@"winSound"];
        if (winSoundString) {
            _winSoundURL = [url URLByAppendingPathComponent:winSoundString];
        }
        NSString * loseSoundString = dict[@"loseSound"];
        if (loseSoundString) {
            _loseSoundURL = [url URLByAppendingPathComponent:loseSoundString];
        }
        
        _imageURLs = [NSMutableArray array];
        NSArray * imageStrings = dict[@"images"];
        [imageStrings enumerateObjectsUsingBlock:^(NSString * imageString, NSUInteger idx, BOOL *stop) {
            [_imageURLs addObject:[url URLByAppendingPathComponent:imageString]];
        }];
        
    }
    return self;
}

- (int)maxWrongGuesses {
    return _imageURLs.count;
}

- (NSURL *)imageURLForWrongGuesses:(int)wrongGuesses {
    if (wrongGuesses == 0) {
        return nil;
    }
    return _imageURLs[wrongGuesses-1];
}

@end
