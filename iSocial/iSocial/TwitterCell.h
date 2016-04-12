//
//  TwitterCell.h
//  iSocial
//
//  Created by James Valaitis on 08/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterCell : UITableViewCell

@property (nonatomic, weak) IBOutlet	UILabel			*tweetLabel;
@property (nonatomic, weak) IBOutlet	UIImageView		*userImageView;
@property (nonatomic, weak) IBOutlet	UILabel			*usernameLabel;

@end
