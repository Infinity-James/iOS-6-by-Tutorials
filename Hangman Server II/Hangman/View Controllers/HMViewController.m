//
//  HMViewController.m
//  Hangman
//
//  Created by Ray Wenderlich on 7/10/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "HMViewController.h"
#import "HMGame.h"
#import "HMTheme.h"
#import <AVFoundation/AVFoundation.h>
#import "HMContentController.h"
#import "HMWords.h"
#import "UIImage+RWExtensions.h"

@interface HMViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *standImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *displayedCharsLabel;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (strong, nonatomic) UITextField *hiddenTextField;
@property (weak, nonatomic) IBOutlet UIImageView *hangmanImageView;
@end

@implementation HMViewController {
    float _oldConstant;
    HMGame * _game;
    AVAudioPlayer * _correctSoundPlayer;
    AVAudioPlayer * _incorrectSoundPlayer;
    AVAudioPlayer * _winSoundPlayer;
    AVAudioPlayer * _loseSoundPlayer;
    HMTheme * _curGameTheme;
    HMWords * _curGameWords;
}

@synthesize standImageView;
@synthesize hiddenTextField;
@synthesize bottomConstraint;
@synthesize displayedCharsLabel;
@synthesize hintLabel = _hintLabel;

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set background color
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    // Set up audio session
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryAmbient error:NULL];
	[audioSession setActive:YES error:NULL];
    
    // Create hidden text field
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    self.hiddenTextField = textField;
    self.hiddenTextField.hidden = YES;
    self.hiddenTextField.delegate = self;
    [self.hiddenTextField addTarget:self action:@selector(hiddenTextFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.hiddenTextField];      
    
    // Add tap recognizer
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.displayedCharsLabel.userInteractionEnabled = YES;
    [self.displayedCharsLabel addGestureRecognizer:tapRecognizer];
    
    // Create new game
    _game = [[HMGame alloc] init];
        
    // Load default words and theme
    [self setup];

}

- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer {
    [self.hiddenTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Add observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentThemeChanged:) name:HMContentControllerCurrentThemeDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentWordsChanged:) name:HMContentControllerCurrentWordsDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hintsChanged:) name:HMContentControllerHintsDidChangeNotification object:nil];
    
    // Refresh view
    [self refresh];
    
    // Reset game if theme changed
    HMTheme * theme = [HMContentController sharedInstance].currentTheme;
    HMWords * words = [HMContentController sharedInstance].currentWords;
    if (theme != _curGameTheme || words != _curGameWords) {
        [self setup];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.hiddenTextField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)currentThemeChanged:(NSNotification *)notification {
    [self setup];
}

- (void)currentWordsChanged:(NSNotification *)notification {
    [self setup];
}

- (void)hintsChanged:(NSNotification *)notification {
    [self refresh];
}

#pragma mark - Game Logic

- (void)setup {

    HMTheme * theme = [HMContentController sharedInstance].currentTheme;

    _correctSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:theme.correctSoundURL error:nil];
	[_correctSoundPlayer prepareToPlay];

    _incorrectSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:theme.incorrectSoundURL error:nil];
	[_incorrectSoundPlayer prepareToPlay];
    
    _winSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:theme.winSoundURL error:nil];
	[_winSoundPlayer prepareToPlay];
    
    _loseSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:theme.loseSoundURL error:nil];
	[_loseSoundPlayer prepareToPlay];
    
    [self newGame:nil];
}

- (void)newGame:(id)arg {
    
    HMTheme * theme = [HMContentController sharedInstance].currentTheme;
    HMWords * words = [HMContentController sharedInstance].currentWords;
    _curGameTheme = theme;
    _curGameWords = words;
    [_game newGameWithWords:words maxWrongGuesses:theme.maxWrongGuesses];
    
    NSLog(@"New game.  Hidden word: %@", _game.wordToGuess);
    
    [self refresh];
}

- (void)refresh {
    
    // Display the word (uncovered so far)
    NSAttributedString * attString = [[NSAttributedString alloc] initWithString:_game.displayedChars attributes:@{NSKernAttributeName : @10.0}];
    self.displayedCharsLabel.attributedText = attString;
    
    // Set appropriate image from theme
    HMTheme * theme = [HMContentController sharedInstance].currentTheme;
    NSURL * imageURL = [theme imageURLForWrongGuesses:_game.wrongGuesses];
    if (imageURL) {
        self.hangmanImageView.image = [UIImage rw_imageWithContentsOfURL:imageURL];
    } else {
        self.hangmanImageView.image = nil;
    }
    
    // Show game status
    if (_game.gameState == GameStateWon) {
        self.hintLabel.text = @"You Win!";
    } else if (_game.gameState == GameStateLost) {
        self.hintLabel.text = @"You Lose.";
    } else {
        self.hintLabel.text = [NSString stringWithFormat:@"Hints Left: %d", [HMContentController sharedInstance].hints];
    }
    
}

- (void)checkForWin {
    if (_game.gameState == GameStateWon) {
        int hints = [HMContentController sharedInstance].hints;
        [[HMContentController sharedInstance] setHints:hints + 1]; // You get a free hint when you win a game
        [_winSoundPlayer play];
        [self performSelector:@selector(newGame:) withObject:nil afterDelay:2.0];
    } else if (_game.gameState == GameStateLost) {
        [_loseSoundPlayer play];
        [self performSelector:@selector(newGame:) withObject:nil afterDelay:2.0];
    }
}

- (void)getHint {
    
    if (_game.gameState != GameStatePlaying) {
        NSLog(@"Can't get a hint now!");
        return;
    }
    
    if ([HMContentController sharedInstance].hints <= 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Out of hints!" message:@"You are out of hints!  Visit the store to buy more." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    int hints = [HMContentController sharedInstance].hints;
    [[HMContentController sharedInstance] setHints:hints - 1];
    [_game getHint];
    [_correctSoundPlayer play];
    [self checkForWin];
    [self refresh];
}

- (void)guess:(NSString *)character {
    
    if (_game.gameState != GameStatePlaying) {
        NSLog(@"Can't guess now!");
        return;
    }
    
    BOOL success = [_game guess:character];
    
    if (success) {
        [_correctSoundPlayer play];
    } else {
        [_incorrectSoundPlayer play];
    }
        
    [self checkForWin];    
    [self refresh];
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary * info = [notification userInfo];
    NSNumber * duration = info[UIKeyboardAnimationDurationUserInfoKey];
    CGRect kbRect = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    float kbHeight;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        kbHeight = kbRect.size.height;
    else
        kbHeight = kbRect.size.width;
        
    _oldConstant = bottomConstraint.constant;
    [bottomConstraint setConstant:kbHeight + _oldConstant];
    [UIView animateWithDuration:duration.floatValue animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary * info = [notification userInfo];
    NSNumber * duration = info[UIKeyboardAnimationDurationUserInfoKey];
    
    [bottomConstraint setConstant:_oldConstant];
    [UIView animateWithDuration:duration.floatValue animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITextField handling

- (void)hiddenTextFieldValueChanged:(id)sender {
  
    // Get character typed and reset
    NSString * character = self.hiddenTextField.text;
    self.hiddenTextField.text = nil;
    
    [self guess:character];    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Callbacks

- (IBAction)getHintTapped:(id)sender {
    [self getHint];
}

@end
