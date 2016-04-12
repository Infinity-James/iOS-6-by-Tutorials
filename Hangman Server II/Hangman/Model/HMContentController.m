//
//  HMContentController.m
//  Hangman
//
//  Created by Ray Wenderlich on 7/12/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "HMContentController.h"
#import "HMTheme.h"
#import "HMWords.h"

NSString *const HMContentControllerCurrentThemeDidChangeNotification = @"HMContentControllerCurrentThemeDidChangeNotification";
NSString *const HMContentControllerCurrentWordsDidChangeNotification = @"HMContentControllerCurrentWordsDidChangeNotification";
NSString *const HMContentControllerHintsDidChangeNotification = @"HMContentControllerHintsDidChangeNotification";
NSString *const HMContentControllerUnlockedThemesDidChangeNotification = @"HMContentControllerUnlockedThemesDidChangeNotification";
NSString *const HMContentControllerUnlockedWordsDidChangeNotification = @"HMContentControllerUnlockedWordsDidChangeNotification";

@implementation HMContentController {
    NSMutableArray * _unlockedThemes;
    NSMutableArray * _unlockedWords;
}

+ (HMContentController *)sharedInstance {
    static dispatch_once_t once;
    static HMContentController * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if ((self = [super init])) {
        _unlockedThemes = [NSMutableArray array];
        _unlockedWords = [NSMutableArray array];
        
        NSURL * resourceURL = [NSBundle mainBundle].resourceURL;
        [self unlockThemeWithDirURL:[resourceURL URLByAppendingPathComponent:@"Stickman"]];
        [self unlockWordsWithDirURL:[resourceURL URLByAppendingPathComponent:@"EasyWords"]];
//		[self unlockThemeWithDirURL:[resourceURL URLByAppendingPathComponent:@"robot"]];
//		[self unlockThemeWithDirURL:[resourceURL URLByAppendingPathComponent:@"zombie"]];

        BOOL hasRunBefore = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasRunBefore"];
        if (!hasRunBefore) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasRunBefore"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self setHints:20];
        }
    }
    return self;
}

- (int)hints {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"com.razeware.hangman.hints"];
}

- (void)setHints:(int)hints {
    [[NSUserDefaults standardUserDefaults] setInteger:hints forKey:@"com.razeware.hangman.hints"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:HMContentControllerHintsDidChangeNotification object:nil userInfo:nil];
}

- (void)setCurrentTheme:(HMTheme *)currentTheme {
    _currentTheme = currentTheme;
    [[NSNotificationCenter defaultCenter] postNotificationName:HMContentControllerCurrentThemeDidChangeNotification object:nil];
}

- (void)setCurrentWords:(HMWords *)currentWords {
    _currentWords = currentWords;
    [[NSNotificationCenter defaultCenter] postNotificationName:HMContentControllerCurrentWordsDidChangeNotification object:nil];
}

- (NSArray *)unlockedThemes {
    return _unlockedThemes;
}

- (NSArray *)unlockedWords {
    return _unlockedWords;
}

- (void)unlockThemeWithDirURL:(NSURL *)dirURL {

    HMTheme * theme = [[HMTheme alloc] initWithDirURL:dirURL];
    
    // Make sure we don't already have theme
    BOOL found = FALSE;
    for (int i = 0; i < _unlockedThemes.count; ++i) {
        HMTheme * curTheme = _unlockedThemes[i];
        if ([theme.name isEqualToString:curTheme.name]) {
            NSLog(@"Theme already unlocked, replacing...");
            if (self.currentTheme == curTheme) {
                self.currentTheme = theme;
            }
            _unlockedThemes[i] = theme;
            found = TRUE;
            break;
        }
    }
    if (!found) {
        // Unlock new theme
        [_unlockedThemes addObject:theme];
    }
    if (!self.currentTheme) {
        self.currentTheme = theme;
    }
            
    // Notify observers
    [[NSNotificationCenter defaultCenter] postNotificationName:HMContentControllerUnlockedThemesDidChangeNotification object:self];
}

- (void)unlockWordsWithDirURL:(NSURL *)dirURL {
    
    // Unlock new words
    HMWords * words = [[HMWords alloc] initWithDirURL:dirURL];

    // Make sure we don't already have words
    BOOL found = FALSE;
    for (int i = 0; i < _unlockedWords.count; ++i) {
        HMWords * curWords = _unlockedWords[i];
        if ([words.name isEqualToString:curWords.name]) {
            NSLog(@"Words already unlocked, replacing...");
            if (self.currentWords == curWords) {
                self.currentWords = words;
            }
            _unlockedWords[i] = words;
            found = TRUE;
            break;
        }
    }
    if (!found) {
        // Unlock new theme
        [_unlockedWords addObject:words];
    }
    if (!self.currentWords) {
        self.currentWords = words;
    }
    
    // Notify observers
    [[NSNotificationCenter defaultCenter] postNotificationName:HMContentControllerUnlockedWordsDidChangeNotification object:self];
}

- (void)unlockContentWithDirURL:(NSURL *)dirURL {
    
    if ([HMTheme themeAtURL:dirURL]) {
        [self unlockThemeWithDirURL:dirURL];
    } else if ([HMWords wordsAtURL:dirURL]) {
        [self unlockWordsWithDirURL:dirURL];
    } else {
        NSLog(@"Unexpected content!");
    }
    
}

@end
