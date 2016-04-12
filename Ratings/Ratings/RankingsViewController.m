
#import "RankingsViewController.h"
#import "Player.h"
#import "RatePlayerViewController.h"

static NSString *const	kRequiredRatingKey	= @"RequiredRating";

@interface RankingsViewController () <UITableViewDataSource, UITableViewDelegate, RatePlayerViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation RankingsViewController
{
	NSMutableArray *_rankedPlayers;
	int _requiredRating;
	BOOL _needsUpdate;
}

#pragma mark - View Lifecycle

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];

	_requiredRating = 5;
	_needsUpdate = YES;
}

/**
 *	notifies the view controller that its view is about to be added to a view hierarchy
 *
 *	@param	animated					whether the view needs to be added to the window with an animation
 */
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (_needsUpdate || !_rankedPlayers)
		[self updateRankedPlayers];

	_needsUpdate = YES;
}

#pragma mark - Action & Selector Methods

- (IBAction)done:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)segmentedControlChanged:(UISegmentedControl *)sender
{
	_requiredRating = (sender.selectedSegmentIndex == 0) ? 5 : 1;
	[self updateRankedPlayers];
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
	return UIInterfaceOrientationMaskAll;
}

#pragma mark - Convenience & Helper Methods

- (void)updateRankedPlayers
{
	_rankedPlayers = [self playersWithRating:_requiredRating];
	[self.tableView reloadData];
}

- (NSMutableArray *)playersWithRating:(int)rating
{
	NSMutableArray *rankedPlayers = [NSMutableArray arrayWithCapacity:[self.players count]];

	for (Player *player in self.players)
	{
		if (player.rating == rating)
			[rankedPlayers addObject:player];
	}

	[rankedPlayers sortUsingComparator:^NSComparisonResult(Player *player1, Player* player2)
	{
		return [player1.name localizedStandardCompare:player2.name];
	}];
	
	return rankedPlayers;
}

#pragma mark - RatePlayerViewControllerDelegate

- (void)ratePlayerViewController:(RatePlayerViewController *)controller didPickRatingForPlayer:(Player *)player
{
	NSUInteger index = [_rankedPlayers indexOfObject:player];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	
	if (player.rating != _requiredRating)
	{
		[_rankedPlayers removeObjectAtIndex:index];
		[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
	else
	{
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	
	_needsUpdate = NO;
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Segue Methods

/**
 *	notifies view controller that segue is about to be performed
 *
 *	@param	segue						segue object containing information about the view controllers involved
 *	@param	sender						object that initiated the segue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"RatePlayer"])
	{
		RatePlayerViewController *ratePlayerViewController = segue.destinationViewController;
		ratePlayerViewController.delegate = self;

		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		Player *player = _rankedPlayers[indexPath.row];
		ratePlayerViewController.player = player;
	}
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
	
	_requiredRating						= [coder decodeIntegerForKey:kRequiredRatingKey];
	
	if (_requiredRating < 1 || _requiredRating > 5)
		_requiredRating					= 5;
	
	self.segmentedControl.selectedSegmentIndex	= (_requiredRating == 5) ? 0 : 1;
}

/**
 *	encodes state-related information for the view controller
 *
 *	@param	coder						coder object to use to encode the state of the view controller
 */
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
	[super encodeRestorableStateWithCoder:coder];
	
	[coder encodeInteger:_requiredRating forKey:kRequiredRatingKey];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_rankedPlayers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

	Player *player = _rankedPlayers[indexPath.row];
	cell.textLabel.text = player.name;
	cell.detailTextLabel.text = player.game;

    return cell;
}

@end
