//
//  RWViewController.m
//  FullScreenImageViewer
//
//  Created by Matt Galloway on 18/07/2012.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "RWViewController.h"

@interface RWViewController ()
@property (nonatomic, weak) IBOutlet UITextView *textView;
@end

@implementation RWViewController

- (void)openTextURL:(NSURL*)url {
    NSString *text = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    self.textView.text = text;
}

- (void)aboutTapped:(id)sender {
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *versionString = [NSString stringWithFormat:@"Version: %@ - %@",
                               [bundleInfo objectForKey:@"CFBundleVersion"],
                               [bundleInfo objectForKey:@"CFBundleShortVersionString"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"About"
                                                    message:versionString
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)doneTapped:(id)sender {
    [self.textView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"About"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(aboutTapped:)];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneTapped:)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[spacer, doneButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
