//
//  ColourController.h
//  RichEditor
//
//  Created by James Valaitis on 22/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

@protocol ColourControllerDelegate <NSObject>

- (void)selectedColour:(UIColor *)colour;

@end

@interface ColourController : UITableViewController

@property (nonatomic, weak)	UIViewController<ColourControllerDelegate>	*delegate;

@end
