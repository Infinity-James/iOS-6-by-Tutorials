//
//  UIImage+RWExtensions.h
//  Hangman
//
//  Created by Ray Wenderlich on 7/11/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RWExtensions)

- (id)rw_initWithContentsOfURL:(NSURL *)url;
+ (UIImage *)rw_imageWithContentsOfURL:(NSURL *)url;

@end
