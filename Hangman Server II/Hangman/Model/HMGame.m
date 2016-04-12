//
//  HMGame.m
//  Hangman
//
//  Created by Ray Wenderlich on 7/11/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "HMGame.h"
#import "HMWords.h"

@implementation HMGame {
    NSMutableSet * _guessedChars;
}

- (void)newGameWithWords:(HMWords *)words maxWrongGuesses:(int)maxWrongGuesses {
    
    // Reset game
    _gameState = GameStatePlaying;
    _guessedChars = [NSMutableSet set];
    _wrongGuesses = 0;
    _maxWrongGuesses = maxWrongGuesses;
    
    // Get random word
    int randomIdx = arc4random() % words.count;
    _wordToGuess = words[randomIdx];
    _wordToGuess = [_wordToGuess uppercaseString];
    
    // Refresh calculations
    [self refresh];
    
}

- (void)refresh {
    
    // Calculate string to display, and keep track if there are any missing chars
    BOOL missingChar = NO;
    _displayedChars = [[NSMutableString alloc] initWithCapacity:_wordToGuess.length];
    for(int i = 0; i < _wordToGuess.length; ++i) {
        
        unichar curChar = [_wordToGuess characterAtIndex:i];
        NSString * curCharStr = [NSString stringWithFormat:@"%c", curChar];
        if ([_guessedChars containsObject:curCharStr]) {
            [_displayedChars appendString:curCharStr];
        } else {
            [_displayedChars appendString:@"_"];
            missingChar = YES;
        }
    }
    
    // Check win/lose
    if (!missingChar) {
        _gameState = GameStateWon;
    } else if (_wrongGuesses >= _maxWrongGuesses) {
        _gameState = GameStateLost;
        _displayedChars = [_wordToGuess mutableCopy];
    }

}

- (BOOL)guess:(NSString *)character {
    
    // Check state
    NSAssert(_gameState == GameStatePlaying, @"Unexpected state");
    
    // False if already guessed
    if ([_guessedChars containsObject:character]) {
        _wrongGuesses++;
        [self refresh];
        return FALSE;
    }
    
    // Check to see if found
    BOOL found = [_wordToGuess rangeOfString:character].location != NSNotFound;
    if (!found) {
        _wrongGuesses++;
    }
    
    // Add to guessed chars and refresh
    [_guessedChars addObject:character];
    [self refresh];
    return found;
    
}

- (void)getHint {
    
    // Check state
    NSAssert(_gameState == GameStatePlaying, @"Unexpected state");

    // Find first character not guessed, and add it to guessed characters list
    for(int i = 0; i < _wordToGuess.length; ++i) {
        
        unichar curChar = [_wordToGuess characterAtIndex:i];
        NSString * curCharStr = [NSString stringWithFormat:@"%c", curChar];
        if (![_guessedChars containsObject:curCharStr]) {
            [_guessedChars addObject:curCharStr];
            break;
        }
    }
    
    [self refresh];
    
}

@end
