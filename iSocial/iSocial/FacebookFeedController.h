//
//  FacebookFeedController.h
//  iSocial
//
//  Created by James Valaitis on 08/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#define kFacebookMessageCellIdentifier		@"MessageCell"
#define kFacebookPhotoCellIdentifier		@"PhotoCell"

@interface FacebookFeedController : UITableViewController

- (NSString *)feedString;
- (NSString *)titleString;

@end
