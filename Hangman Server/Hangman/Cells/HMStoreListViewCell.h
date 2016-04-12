//
//  HMStoreListViewCell.h
//  Hangman
//
//  Created by Ray Wenderlich on 7/16/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMStoreListViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *outerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
