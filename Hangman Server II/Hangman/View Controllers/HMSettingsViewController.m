//
//  HMSettingsViewController.m
//  Hangman
//
//  Created by Ray Wenderlich on 7/12/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "HMSettingsViewController.h"
#import "HMContentController.h"
#import "HMTheme.h"
#import "HMWords.h"

@interface HMSettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *wordsLabel;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;

@end

@implementation HMSettingsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)refresh {
    self.wordsLabel.text = [HMContentController sharedInstance].currentWords.name;
    self.themeLabel.text = [HMContentController sharedInstance].currentTheme.name;
}

@end
