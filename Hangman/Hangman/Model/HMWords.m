//
//  HMWords.m
//  Hangman
//
//  Created by Ray Wenderlich on 7/12/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "HMWords.h"

@implementation HMWords {
    NSArray * _words;
}

+ (BOOL)wordsAtURL:(NSURL *)url {
    NSURL * plistURL = [url URLByAppendingPathComponent:@"words.plist"];
    return [[NSFileManager defaultManager] fileExistsAtPath:plistURL.path];
}

- (id)initWithDirURL:(NSURL *)url {
    if ((self = [super init])) {

        _dirURL = url;
       
        NSURL * plistURL = [url URLByAppendingPathComponent:@"words.plist"];
        NSDictionary * dict = [NSDictionary dictionaryWithContentsOfURL:plistURL];
        if (dict == nil) return nil;
    
        _name = dict[@"name"];
        _words = dict[@"words"];
    }
    return self;
}

- (int)count {
    return _words.count;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return _words[idx];
}

@end
