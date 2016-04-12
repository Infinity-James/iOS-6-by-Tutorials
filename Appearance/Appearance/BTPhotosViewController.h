//
//  BTDetailViewController.h
//  AppearanceChapter
//
//  Created by Adam Burkepile on 7/16/12.
//  Copyright (c) 2012 Adam Burkepile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTPhotosViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)ibaAddPhoto:(id)sender;
@end
