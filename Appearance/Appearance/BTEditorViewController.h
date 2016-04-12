//
//  BTEditorViewController.h
//  AppearanceChapter
//
//  Created by Adam Burkepile on 7/16/12.
//  Copyright (c) 2012 Adam Burkepile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTEditorViewController : UIViewController

@property (nonatomic, strong) NSData* photoData;
@property (weak, nonatomic) IBOutlet UIImageView *ibPhoto;
@property (weak, nonatomic) IBOutlet UIProgressView *ibProgressView;
@property (weak, nonatomic) IBOutlet UIButton *ibUploadButton;
@property (weak, nonatomic) IBOutlet UIStepper *ibBrightnessStepper;
@property (weak, nonatomic) IBOutlet UISwitch *ibSepiaSwitch;
@property (weak, nonatomic) IBOutlet UILabel *ibDoneLabel;
- (IBAction)ibaDone:(id)sender;
- (IBAction)ibaUpload:(id)sender;
- (IBAction)ibaChangeImage:(id)sender;
@end
