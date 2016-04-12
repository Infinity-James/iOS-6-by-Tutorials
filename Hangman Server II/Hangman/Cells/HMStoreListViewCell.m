//
//  HMStoreListViewCell.m
//  Hangman
//
//  Created by Ray Wenderlich on 7/16/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "HMStoreListViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation HMStoreListViewCell

- (void)awakeFromNib {
    
    float radius = 12.0;
    
    self.iconImageView.hidden = NO;
    [self.iconImageView.layer setMasksToBounds:YES];
    [self.iconImageView.layer setBorderColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8].CGColor];
    [self.iconImageView.layer setBorderWidth:1.0];
    [self.iconImageView.layer setCornerRadius:radius];
    
    [self.outerImageView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.outerImageView.layer setShadowOffset:CGSizeMake(0, 3)];
    [self.outerImageView.layer setShadowOpacity:0.3];
    [self.outerImageView.layer setShadowRadius:3.0];
    [self.outerImageView.layer setCornerRadius:radius];

}

@end
