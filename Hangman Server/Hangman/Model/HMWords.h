//
//  HMWords.h
//  Hangman
//
//  Created by Ray Wenderlich on 7/12/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMWords : NSObject

@property (nonatomic, readonly, strong) NSURL * dirURL;
@property (nonatomic, readonly, strong) NSString * name;

+ (BOOL)wordsAtURL:(NSURL *)url;
- (id)initWithDirURL:(NSURL *)url;
- (int)count;
- (id)objectAtIndexedSubscript:(NSUInteger)idx;

@end
