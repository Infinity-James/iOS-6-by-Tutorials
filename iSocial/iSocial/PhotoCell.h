//
//  PhotoCell.h
//  iSocial
//
//  Created by James Valaitis on 08/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "FacebookCell.h"

@interface PhotoCell : FacebookCell

@property (nonatomic, weak) IBOutlet	UILabel			*messageLabel;
@property (nonatomic, weak) IBOutlet	UIImageView		*pictureImageView;
@property (nonatomic, weak) IBOutlet	UILabel			*usernameLabel;

@end
