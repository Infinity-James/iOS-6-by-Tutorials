//
//  WebController.m
//  iSocial
//
//  Created by James Valaitis on 08/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "WebController.h"

@interface WebController ()

@property (nonatomic, weak) IBOutlet	UIWebView	*webView;

@end

@implementation WebController

#pragma mark - Action & Selector Methods

- (IBAction)done
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - View Lifecycle

/**
 *	sent to the view controller when the app receives a memory warning
 */
- (void)didReceiveMemoryWarning
{
	if (!self.view.window)
	{
		self.initialURLString	= nil;
		self.webView			= nil;
	}
	
	[super didReceiveMemoryWarning];
}

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	NSURL *url					= [NSURL URLWithString:self.initialURLString];
    NSURLRequest *request		= [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

@end
