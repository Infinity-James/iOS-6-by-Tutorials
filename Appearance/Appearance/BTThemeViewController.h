//
//  BTMasterViewController.h
//  AppearanceChapter
//
//  Created by Adam Burkepile on 7/16/12.
//  Copyright (c) 2012 Adam Burkepile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTThemeViewController : UITableViewController
@property (nonatomic,strong) NSArray* themes;
- (IBAction)ibaCancel:(id)sender;
@end
