//
//  BatmanTheme.h
//  Appearance
//
//  Created by James Valaitis on 28/03/2013.
//  Copyright (c) 2013 Adam Burkepile. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ThemeManager.h"

#pragma mark - Default Theme Public Interface

@interface DefaultTheme : NSObject <Theme>
{
	NSArray								*_coloursForGradient;
}

@end

#pragma mark - Gradient Layer Public Interface

@interface GradientLayer : CAGradientLayer

@end