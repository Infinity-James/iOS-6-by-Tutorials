//
//  MessageCell.h
//  iSocial
//
//  Created by James Valaitis on 08/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "FacebookCell.h"

@interface MessageCell : FacebookCell

@property (nonatomic, weak) IBOutlet	UILabel	*messageLabel;
@property (nonatomic, weak) IBOutlet	UILabel	*toLabel;
@property (nonatomic, weak) IBOutlet	UILabel	*usernameLabel;

@end
