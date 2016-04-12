//
//  BTPhotoViewController.m
//  AppearanceChapter
//
//  Created by Adam Burkepile on 7/16/12.
//  Copyright (c) 2012 Adam Burkepile. All rights reserved.
//

#import "BTPhotoViewController.h"
#import "BTEditorViewController.h"
#import "ThemeManager.h"

@interface BTPhotoViewController ()

@end

@implementation BTPhotoViewController
@synthesize ibPhoto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ibPhoto.image = [UIImage imageWithData:self.photoData];
	
	[ThemeManager customiseView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"displayEditor"]) {
        BTEditorViewController* dvc = [segue destinationViewController];
        UIImage* image = [UIImage imageWithData:self.photoData];
        UIImage* resizedImage = [image resizeToFrame:CGSizeMake(400.0, 400.0)];
    
        dvc.photoData = UIImagePNGRepresentation(resizedImage);
    }
}

@end


@implementation UIImage (Resizing)

CGSize calculateProportionalResize(CGSize originalSize, CGSize frameSize) {
    float x1 = originalSize.width;
    float y1 = originalSize.height;
    float x2 = frameSize.width;
    float y2 = frameSize.height;
    
    float deltaX = x2 / x1;
    float deltaY = y2 / y1;
    
    float delta = deltaX < deltaY ? deltaX : deltaY;
    
    return CGSizeMake(floorf(delta*x1), floorf(delta*y1));
}

- (UIImage *)resizeToFrame:(CGSize)newSize {
    return [self resizeToSize:calculateProportionalResize([self size],newSize)];
}
- (UIImage *)resizeToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end