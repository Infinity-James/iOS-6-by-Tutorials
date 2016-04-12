
#import "PlayersViewController.h"
#import "Player.h"
#import "PlayerCell.h"
#import "PlayerDetailsViewController.h"
#import "RatePlayerViewController.h"

@interface PlayersViewController () <PlayerDetailsViewControllerDelegate, RatePlayerViewControllerDelegate, UIDataSourceModelAssociation>

@end

@implementation PlayersViewController
{
	BOOL								_needsUpdate;
}

#pragma mark - UIDataSourceModelAssociation Methods

/**
 *	returns the current index of the data object with the specified identifier
 *
 *	@param identifier					identifier for the requested data object
 *	@param view							view into which the object is being inserted
 */
- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier
												 inView:(UIView *)view
{
	NSUInteger index					= [self indexOfPlayerWithID:identifier];
	
	if (index != NSNotFound)
		return [NSIndexPath indexPathForRow:index inSection:0];
	
	return nil;
}

/**
 *	returns the string that uniquely identifies the data at the specified location in the view
 *
 *	@param	index						index path to the requested data object
 *	@param	view						view that contains the data object
 */
- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)index
											inView:(UIView *)view
{
	return ((Player *)self.players[index.row]).playerID;
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

	if (_needsUpdate)
		[self.tableView reloadData];

	_needsUpdate = YES;
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

#pragma mark - Convenience & Helper Methods

/**
 *	returns an image for a number rating
 *
 *
 */
- (UIImage *)imageForRating:(int)rating
{
	switch (rating)
	{
		case 1: return [UIImage imageNamed:@"1StarSmall"];
		case 2: return [UIImage imageNamed:@"2StarsSmall"];
		case 3: return [UIImage imageNamed:@"3StarsSmall"];
		case 4: return [UIImage imageNamed:@"4StarsSmall"];
		case 5: return [UIImage imageNamed:@"5StarsSmall"];
	}
	return nil;
}

- (NSInteger)indexOfPlayerWithID:(NSString *)playerID
{
	__block NSUInteger index			= NSNotFound;
	
	[_players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop)
	{
		if ([player.playerID isEqualToString:playerID])
			index = idx,				*stop = YES;
	}];
	
	return index;
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
	if ([segue.identifier isEqualToString:@"AddPlayer"])
	{
		UINavigationController *navigationController				= segue.destinationViewController;
		PlayerDetailsViewController *playerDetailsViewController	= navigationController.viewControllers[0];
		playerDetailsViewController.delegate						= self;
	}
	
	else if ([segue.identifier isEqualToString:@"EditPlayer"])
	{
		UINavigationController *navigationController				= segue.destinationViewController;
		PlayerDetailsViewController *playerDetailsViewController	= navigationController.viewControllers[0];
		playerDetailsViewController.delegate						= self;

		NSIndexPath *indexPath										= [self.tableView indexPathForCell:sender];
		Player *player												= (self.players)[indexPath.row];
		playerDetailsViewController.playerToEdit					= player;
	}
	
	else if ([segue.identifier isEqualToString:@"RatePlayer"])
	{
		RatePlayerViewController *ratePlayerViewController			= segue.destinationViewController;
		ratePlayerViewController.delegate							= self;

		NSIndexPath *indexPath										= [self.tableView indexPathForCell:sender];
		Player *player												= self.players[indexPath.row];
		ratePlayerViewController.player								= player;
	}	
}

/**
 *	determines whether the seque with the specified identifier should be triggered
 *
 *	@param	identifier					string that identifies the triggered segue
 *	@param	sender						object that initiated the segue
 */
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier
								  sender:(id)sender
{
	return NO;
}

#pragma mark - UITableViewDataSource Methods

/**
 *	as the data source, we must define how many sections we want the table view to have
 *
 *	@param	tableView					the table view for which are defining the sections number
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

/**
 *	create and return the cells for each row of the table view
 *
 *	@param	tableView					the table view for which we are creating cells
 *	@param	indexPath					the index path of the row we are creating a cell for
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PlayerCell *cell = (PlayerCell *)[tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];

	Player *player = (self.players)[indexPath.row];
	cell.nameLabel.text = player.name;
	cell.gameLabel.text = player.game;
	cell.ratingImageView.image = [self imageForRating:player.rating];

    return cell;
}

/**
 *	called to commit the insertion or deletion of a specified row in the receiver
 *
 *	@param	tableView					table view object requesting the insertion or deletion
 *	@param	editingStyle				cell editing style corresponding to a insertion or deletion
 *	@param	indexPath					index path of row requesting editing
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		[self.players removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}   
}

/**
 *	define how many rows for each section there are in this table view
 *
 *	@param	tableView					the table view for which we are creating cells
 *	@param	section						the particular section for which we must define the rows
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.players.count;
}

#pragma mark - PlayerDetailsViewControllerDelegate Methods

- (void)playerDetailsViewControllerDidCancel:(PlayerDetailsViewController *)controller
{
	_needsUpdate = NO;
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playerDetailsViewController:(PlayerDetailsViewController *)controller didAddPlayer:(Player *)player
{
	[self.tableView reloadData];
	[self.players addObject:player];

	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.players.count - 1 inSection:0];
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

	_needsUpdate = NO;
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playerDetailsViewController:(PlayerDetailsViewController *)controller didEditPlayer:(Player *)player
{
	NSUInteger index = [self.players indexOfObject:player];
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

	_needsUpdate = NO;
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playerDetailsViewController:(PlayerDetailsViewController *)controller didDeletePlayer:(Player *)player
{
	NSUInteger index = [self.players indexOfObject:player];
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];

	[self.players removeObjectAtIndex:indexPath.row];
	[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

	_needsUpdate = NO;
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RatePlayerViewControllerDelegate Methods

- (void)ratePlayerViewController:(RatePlayerViewController *)controller didPickRatingForPlayer:(Player *)player
{
	NSUInteger index = [self.players indexOfObject:player];
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

	_needsUpdate = NO;
	[self.navigationController popViewControllerAnimated:YES];
}

@end
