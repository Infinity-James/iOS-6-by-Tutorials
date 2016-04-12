//
//  ViewController.h
//  StoryboardLayout
//
//  Created by James Valaitis on 04/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (AutoLayoutDebug)

+ (UIWindow *)	keyWindow;
- (NSString *)	_autolayoutTrace;

@end

@interface ViewController : UIViewController

@end
