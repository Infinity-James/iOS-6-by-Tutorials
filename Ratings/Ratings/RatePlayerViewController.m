
#import "RatePlayerViewController.h"
#import "Player.h"

static NSString *const	kDelegateKey		= @"Delegate";
NSString *const			kPlayerIDKey		= @"PlayerID";

@implementation RatePlayerViewController

#pragma mark - Action & Selector Methods

- (IBAction)rateAction:(UIButton *)sender
{
	self.player.rating					= sender.tag;
	[self.delegate ratePlayerViewController:self didPickRatingForPlayer:self.player];
}

#pragma mark - Autorotation

/**
 *	returns whether the view controller’s contents should auto rotate
 */
- (BOOL)shouldAutorotate
{
	return YES;
}

/**
 *	returns all of the interface orientations that the view controller supports
 */
- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - State Preservation & Restoration Methods

/**
 *	decodes and restores state-related information for the view controller
 *
 *	@param	coder						coder object to use to decode the state of the view
 */
- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
	[super decodeRestorableStateWithCoder:coder];
	
	self.delegate						= [coder decodeObjectForKey:kDelegateKey];
}

/**
 *	encodes state-related information for the view controller
 *
 *	@param	coder						coder object to use to encode the state of the view controller
 */
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
	[super encodeRestorableStateWithCoder:coder];
	
	[coder encodeObject:self.delegate forKey:kDelegateKey];
	[coder encodeObject:self.player.playerID forKey:kPlayerIDKey];
}

#pragma mark - View Lifecycle

/**
 *	notifies the view controller that its view is about to be added to a view hierarchy
 *
 *	@param	animated					whether the view needs to be added to the window with an animation
 */
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.title							= self.player.name;
}

@end