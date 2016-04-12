//
//  BTPhotoViewController.h
//  AppearanceChapter
//
//  Created by Adam Burkepile on 7/16/12.
//  Copyright (c) 2012 Adam Burkepile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTPhotoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *ibPhoto;
@property (nonatomic, strong) NSData* photoData;
@end


@interface UIImage (Resizing)
- (UIImage *)resizeToFrame:(CGSize)newSize;
- (UIImage *)resizeToSize:(CGSize)newSize;
@end