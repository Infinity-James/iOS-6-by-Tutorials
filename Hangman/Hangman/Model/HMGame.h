//
//  HMGame.h
//  Hangman
//
//  Created by Ray Wenderlich on 7/11/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum GameState {
    GameStateNone = 0,
    GameStatePlaying,
    GameStateWon,
    GameStateLost
} GameState;

@class HMWords;

@interface HMGame : NSObject

@property (readonly, strong) NSString * wordToGuess;
@property (readonly, strong) NSMutableString * displayedChars;
@property (readonly, assign) GameState gameState;
@property (readonly, assign) int wrongGuesses;
@property (readonly, assign) int maxWrongGuesses;

- (void)newGameWithWords:(HMWords *)words maxWrongGuesses:(int)maxWrongGuesses;
- (BOOL)guess:(NSString *)character;
- (void)getHint;

@end
