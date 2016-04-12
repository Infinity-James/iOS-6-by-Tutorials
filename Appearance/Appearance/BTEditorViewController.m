//
//  BTEditorViewController.m
//  AppearanceChapter
//
//  Created by Adam Burkepile on 7/16/12.
//  Copyright (c) 2012 Adam Burkepile. All rights reserved.
//

#import "BTEditorViewController.h"
#import "ThemeManager.h"

@interface BTEditorViewController ()

@end

@implementation BTEditorViewController
@synthesize ibPhoto;
@synthesize ibProgressView;
@synthesize ibUploadButton;
@synthesize ibBrightnessStepper;
@synthesize ibSepiaSwitch;
@synthesize ibDoneLabel;

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
	
	[ThemeManager customiseButton:ibUploadButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.ibPhoto.image = [UIImage imageWithData:self.photoData];
	
	[ThemeManager customiseView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ibaDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ibaUpload:(id)sender {
    [ibUploadButton setEnabled:NO];
    [ibProgressView setProgress:0.0 animated:NO];
    [ibProgressView setHidden:NO];
    [ibProgressView setAlpha:1.0];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [ibProgressView setProgress:0.1 animated:YES];
        });
        sleep(1.0);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [ibProgressView setProgress:0.8 animated:YES];
        });
        sleep(1.0);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [ibProgressView setProgress:1.0 animated:YES];
        });
        
        sleep(1.0);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [ibDoneLabel setHidden:NO];
            [ibDoneLabel setAlpha:0.0];
            [UIView animateWithDuration:1.0 animations:^{ [ibDoneLabel setAlpha:1.0]; [ibProgressView setAlpha:0.0]; } completion:^(BOOL finished) {
                sleep(1.0);
                [ibDoneLabel setHidden:YES];
                [ibProgressView setHidden:YES];
                [ibProgressView setProgress:0.0 animated:NO];
                
                [ibUploadButton setEnabled:YES];
            }];
        });
    });
}

- (IBAction)ibaChangeImage:(id)sender {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *beginImage = [CIImage imageWithData:self.photoData];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", [NSNumber numberWithDouble:self.ibBrightnessStepper.value], nil];
    CIFilter *sepiaFilter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey, filter.outputImage, @"inputIntensity", [NSNumber numberWithFloat:1.0], nil];
    
    
    CIImage *outputImage = self.ibSepiaSwitch.on ? [sepiaFilter outputImage] : [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    [self.ibPhoto setImage:newImg];
    CGImageRelease(cgimg);
}
@end
