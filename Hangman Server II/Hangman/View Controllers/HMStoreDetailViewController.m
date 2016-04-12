//
//  HMStoreDetailViewController.m
//  Hangman
//
//  Created by Ray Wenderlich on 7/12/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "HangmanIAPHelper.h"
#import "HMStoreDetailViewController.h"
#import "IAPProduct.h"
#import "IAPProductInfo.h"
#import "IAPProductPurchase.h"
#import "PrettyBytes.h"

@interface HMStoreDetailViewController ()
{
	NSNumberFormatter	*_priceFormatter;
}

@property (weak, nonatomic) IBOutlet	UILabel				*titleLabel;
@property (weak, nonatomic) IBOutlet	UILabel				*priceLabel;
@property (weak, nonatomic) IBOutlet	UILabel				*versionLabel;
@property (weak, nonatomic) IBOutlet	UITextView			*descriptionTextView;
@property (weak, nonatomic) IBOutlet	UILabel				*statusLabel;
@property (weak, nonatomic) IBOutlet	UIProgressView		*progressView;
@property (weak, nonatomic) IBOutlet	UIButton			*pauseButton;
@property (weak, nonatomic) IBOutlet	UIButton			*resumeButton;
@property (weak, nonatomic) IBOutlet	UIButton			*cancelButton;

@end

@implementation HMStoreDetailViewController

#pragma mark - Action & Selector Methods

- (void)buyTapped:(id)sender
{
	NSLog(@"Buy button tapped.");
	[[HangmanIAPHelper sharedInstance] buyProduct:self.product];
}

- (IBAction)cancelTapped:(id)sender
{
	[[HangmanIAPHelper sharedInstance] cancelDownloads:@[self.product.skDownload]];
}

- (IBAction)pauseTapped:(id)sender
{
	[[HangmanIAPHelper sharedInstance] pauseDownloads:@[self.product.skDownload]];
}

- (void)refresh
{
	self.title						= _product.skProduct.localizedTitle;
	self.titleLabel.text			= _product.skProduct.localizedTitle;
	self.descriptionTextView.text	= _product.skProduct.localizedDescription;
	[_priceFormatter setLocale:_product.skProduct.priceLocale];
	self.priceLabel.text			= [_priceFormatter stringFromNumber:_product.skProduct.price];
	
	if (self.product.skProduct.downloadable)
	{
		NSInteger numberOfBytes		= [self.product.skProduct.downloadContentLengths[0] integerValue];
		NSString *bytesString		= prettyBytes(numberOfBytes);
		self.versionLabel.text		= [NSString stringWithFormat:@"Version %@ (%@)", self.product.skProduct.downloadContentVersion, bytesString];
	}
	else
		self.versionLabel.text		= @"Version 1.0";
	
	if (_product.allowedToPurchase)
	{
		UIBarButtonItem *buyButton	= [[UIBarButtonItem alloc] initWithTitle:@"Buy" style:UIBarButtonItemStyleBordered target:self action:@selector(buyTapped:)];
		[self.navigationItem setRightBarButtonItem:buyButton animated:YES];
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
	}
	
	else
		[self.navigationItem setRightBarButtonItem:nil animated:NO];
	
	self.pauseButton.hidden			= YES;
	self.resumeButton.hidden		= YES;
	self.cancelButton.hidden		= YES;
	
	if (self.product.purchaseInProgress)
	{
		self.statusLabel.hidden		= NO;
		
		if (self.product.skDownload)
		{
			self.pauseButton.hidden		= NO;
			self.resumeButton.hidden	= NO;
			self.cancelButton.hidden	= NO;
			
			switch (self.product.skDownload.downloadState)
			{
				case SKDownloadStateActive:
				{
					self.statusLabel.text = self.product.skDownload.timeRemaining >= 0 ?
					[NSString stringWithFormat:@"Active (%0.2fs remaining)", self.product.skDownload.timeRemaining] : @"Active";
					break;
				}
					
				case SKDownloadStateWaiting:
				{
					self.statusLabel.text = self.product.skDownload.timeRemaining >= 0 ?
					[NSString stringWithFormat:@"Waiting (%0.2fs remaining)", self.product.skDownload.timeRemaining] : @"Waiting";
					break;
				}
					
				case SKDownloadStateFinished:	self.statusLabel.text	= @"Download Finished.";	break;
				case SKDownloadStateFailed:		self.statusLabel.text	= @"Download Failed.";		break;
				case SKDownloadStatePaused:		self.statusLabel.text	= @"Download Paused.";		break;
				case SKDownloadStateCancelled:	self.statusLabel.text	= @"Download Cancelled.";	break;
				default:						self.statusLabel.text	= @"Unexpected State.";		break;
			}
			
			self.progressView.progress			= self.product.progress;
		}
		
		else
		{
			self.statusLabel.text				= @"Installing...";
			self.progressView.progress			= self.product.progress;
		}
	}
	
	else if (!self.product.purchase.consumable && self.product.purchase)
	{
		self.statusLabel.hidden					= NO;
		self.progressView.hidden				= YES;
		
		if (self.product.skProduct.downloadContentVersion && ![self.product.skProduct.downloadContentVersion isEqualToString:self.product.purchase.contentVersion])
			self.statusLabel.text				= @"Update Available, Please Restore";
		else
			self.statusLabel.text				= @"Installed";
	}
	
	else if (!self.product.purchase.consumable)
	{
		self.statusLabel.hidden					= NO;
		self.progressView.hidden				= YES;
		
		NSInteger newValue						= [[NSUserDefaults standardUserDefaults] integerForKey:self.product.info.consumableIdentifier];
		self.statusLabel.text					= [NSString stringWithFormat:@"Current value: %d", newValue];
	}
	
	else
		self.statusLabel.hidden	= YES,			self.progressView.hidden	= YES;
}

- (IBAction)resumeTapped:(id)sender
{
	[[HangmanIAPHelper sharedInstance] resumeDownloads:@[self.product.skDownload]];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Set background color
    self.view.backgroundColor	= [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
			
	_priceFormatter				= [[NSNumberFormatter alloc] init];
	[_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.statusLabel.hidden		= YES;
	[self refresh];
	
	[self.product addObserver:self forKeyPath:@"purchaseInProgress" options:kNilOptions context:nil];
	[self.product addObserver:self forKeyPath:@"purchase" options:kNilOptions context:nil];
	[self.product addObserver:self forKeyPath:@"progress" options:kNilOptions context:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[self.product removeObserver:self forKeyPath:@"purchaseInProgress" context:nil];
	[self.product removeObserver:self forKeyPath:@"purchase" context:nil];
	[self.product removeObserver:self forKeyPath:@"progress" context:nil];
}

#pragma mark - NSKeyValueObserving Methods

/**
 *	receive this messsage message when the value at the specified key path relative to the given object has changed
 *
 *	@param	keyPath					key path, relative to object, to the value that has changed
 *	@param	object					source object of the key path
 *	@param	change					dictionary that describing changes made to the value of the property at the key path
 *	@param	context					value provided when receiver registered to receive key-value observation notifications
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	[self refresh];
}

@end

























































