//
//  ViewController.m
//  StoryboardLayout
//
//  Created by James Valaitis on 04/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	NSLog(@"%@", [[UIWindow keyWindow] _autolayoutTrace]);
}

@end
