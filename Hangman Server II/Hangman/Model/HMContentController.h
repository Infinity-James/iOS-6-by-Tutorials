//
//  HMContentController.h
//  Hangman
//
//  Created by Ray Wenderlich on 7/12/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const HMContentControllerCurrentThemeDidChangeNotification;
UIKIT_EXTERN NSString *const HMContentControllerCurrentWordsDidChangeNotification;
UIKIT_EXTERN NSString *const HMContentControllerHintsDidChangeNotification;
UIKIT_EXTERN NSString *const HMContentControllerUnlockedThemesDidChangeNotification;
UIKIT_EXTERN NSString *const HMContentControllerUnlockedWordsDidChangeNotification;

@class HMTheme;
@class HMWords;

@interface HMContentController : NSObject

+ (HMContentController *)sharedInstance;

- (NSArray *) unlockedThemes;
- (NSArray *) unlockedWords;

@property (nonatomic, strong) HMTheme * currentTheme;
@property (nonatomic, strong) HMWords * currentWords;
@property (nonatomic, assign) int hints;

- (void)unlockThemeWithDirURL:(NSURL *)dirURL;
- (void)unlockWordsWithDirURL:(NSURL *)dirURL;
- (void)unlockContentWithDirURL:(NSURL *)dirURL;

@end