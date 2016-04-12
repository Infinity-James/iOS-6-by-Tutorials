
#import "GamePickerViewController.h"

static NSString *const	kDelegateKey			= @"Delegate";
static NSString *const	kIndexKey				= @"Selected Index";

@implementation GamePickerViewController
{
	NSArray *_games;
	NSInteger _selectedIndex;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	_games = @[
		@"Angry Birds",
		@"Backgammon",
		@"Battleship",
		@"Checkers",
		@"Chess",
		@"Go",
		@"Hearts",
		@"Hide and Seek",
		@"Mahjong",
		@"Master Mind",
		@"Monopoly",
		@"Risk",
		@"Rummy",
		@"Russian Roulette",
		@"Snakes and Ladders",
		@"Snap!",
		@"Spin the Bottle",
		@"Tag",
		@"Texas Hold'em Poker",
		@"Tic-Tac-Toe",
		@"Twister",
		@"Video Poker",
		@"Yahtzee",
		];

	_selectedIndex = [_games indexOfObject:self.game];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameCell"];
	cell.textLabel.text = _games[indexPath.row];

	if (indexPath.row == _selectedIndex)
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
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
	_selectedIndex						= [coder decodeIntegerForKey:kIndexKey];
	
	[self.tableView reloadData];
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
	[coder encodeInteger:_selectedIndex forKey:kIndexKey];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if (_selectedIndex != NSNotFound)
	{
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

	_selectedIndex = indexPath.row;

	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;

	NSString *game = _games[indexPath.row];
	[self.delegate gamePickerViewController:self didSelectGame:game];
}

@end
