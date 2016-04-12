//
//  FontsController.h
//  RichEditor
//
//  Created by James Valaitis on 22/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

@protocol FontsControllerDelegate <NSObject>

- (void)selectedFontName:(NSString *)fontName withSize:(NSNumber *)fontSize;

@end

@interface FontsController : UIViewController

@property (nonatomic, weak)		UIViewController<FontsControllerDelegate>	*delegate;
@property (nonatomic, strong)	UIFont										*preselectedFont;

@end
