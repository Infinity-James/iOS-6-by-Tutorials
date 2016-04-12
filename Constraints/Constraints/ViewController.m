//
//  ViewController.m
//  Constraints
//
//  Created by James Valaitis on 04/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)buttonTapped:(UIButton *)button
{
	if ([[button titleForState:UIControlStateNormal] isEqualToString:@"X"])
		[button setTitle:@"This is a long title man." forState:UIControlStateNormal];
	else
		[button setTitle:@"X" forState:UIControlStateNormal];
}

@end
