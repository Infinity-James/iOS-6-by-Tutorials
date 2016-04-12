//
//  DynamicController.h
//  VisualCodeConstraints
//
//  Created by James Valaitis on 05/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

@interface UIWindow (AutolayoutTestingDynamic)

+ (UIWindow *)keyWindow;
- (NSString *)_autolayoutTrace;

@end

@interface DynamicController : UIViewController

@end
