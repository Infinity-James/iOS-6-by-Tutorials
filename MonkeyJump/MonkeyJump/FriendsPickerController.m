//
//  FriendsPickerController.m
//  MonkeyJump
//
//  Created by James Valaitis on 14/01/2013.
//
//

#import "FriendsPickerController.h"
#import "UtilityMethods.h"

#define kCheckMarkTag		4

#define kIsChallengedKey	@"isChallenged"
#define kPlayerKey			@"player"
#define kScoreKey			@"score"

@interface FriendsPickerController () <GameKitHelperProtocol, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
	NSMutableDictionary		*_dataSource;
	GameTrackingObject		*_gameTrackingObject;
	NSNumber				*_score;
}

@property (nonatomic, weak) IBOutlet	UITableView		*tableView;
@property (nonatomic, weak) IBOutlet	UITextField		*challengeTextField;

@end

@implementation FriendsPickerController

#pragma mark - Action & Selector Methods

- (void)cancelButtonPressed
{
	if (self.cancelButtonBlock)
		self.cancelButtonBlock();
}

- (void)challengeButtonPressed
{
	//	check if the message has been entered and if so we go through each player to see if they have been selected
	if (self.challengeTextField.text.length)
	{
		NSMutableArray *playerIDs		= @[].mutableCopy;
		NSArray *allValues				= _dataSource.allValues;
		
		//	if a player is selected we add them to the list of players to challenge
		for (NSDictionary *dictionary in allValues)
		{
			if ([dictionary[kIsChallengedKey] boolValue] == YES)
			{
				GKPlayer *player		= dictionary[kPlayerKey];
				[playerIDs addObject:player.playerID];
			}
		}
		
		//	we send the player the challenge if there are any
		if (playerIDs.count)
			[[GameKitHelper sharedGameKitHelper] sendPlayers:playerIDs
											scoreChallenges:(int64_t)_score
												withMessage:self.challengeTextField.text
									  andGameTrackingObject:_gameTrackingObject];
	
		//	if there is something to be done after issuing the challenge we do it
		if (self.challengeButtonBlock)
			self.challengeButtonBlock();
	}
	
	//	if the player did not write a challenge message we make it obvious that this is what needs to be done
	else
	{
		self.challengeTextField.layer.borderWidth	= 2;
		self.challengeTextField.layer.borderColor	= [UIColor redColor].CGColor;
	}
}

#pragma mark - Convenience & Helper Methods

- (void)addButtons
{
	UIBarButtonItem *cancelButton		= [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
																		   style:UIBarButtonItemStylePlain
																		  target:self
																		  action:@selector(cancelButtonPressed)];
	
	UIBarButtonItem *challengeButton	= [[UIBarButtonItem alloc] initWithTitle:@"Challenge"
																		   style:UIBarButtonItemStylePlain
																	     target:self
																	     action:@selector(challengeButtonPressed)];
	
	[self.navigationItem setLeftBarButtonItem:cancelButton];
	[self.navigationItem setRightBarButtonItem:challengeButton];
}

#pragma mark - GameKitHelperProtocol Methods

- (void)onFriendsScoresReceived:(NSArray *)scores
{
	//	this will hold the ids of the friends of the local player
	NSMutableArray *playerIDs			= @[].mutableCopy;
	
	//	for each score an dictioanry in the data source is created and the player id is stored in the above array
	[scores enumerateObjectsUsingBlock:^(GKScore *score, NSUInteger idx, BOOL *stop)
	{
		if (!_dataSource[score.playerID])
		{
			_dataSource[score.playerID]	= @{}.mutableCopy;
			[playerIDs addObject:score.playerID];
		}
		
		//	if the score is less than the local player's score this is marked in data source
		if (score.value < _score.intValue)
			(_dataSource[score.playerID])[kIsChallengedKey]	= @YES;
		
		//	the score is is stored in data source dictionary
		(_dataSource[score.playerID])[kScoreKey]			= score;
	}];
	
	//	we then get the details of each friend
	[[GameKitHelper sharedGameKitHelper] getPlayerInfo:playerIDs];
	[self.tableView reloadData];
}

- (void)onPlayerInfoRecieved:(NSArray *)players
{
	//	enumerate through all the players and if for some reason they don't already have an entry we create one and store the info
	[players enumerateObjectsUsingBlock:^(GKPlayer *player, NSUInteger idx, BOOL *stop)
	{
		if (!_dataSource[player.playerID])
			_dataSource[player.playerID]			= @{}.mutableCopy;
		
		(_dataSource[player.playerID])[kPlayerKey]	= player;
	}];
	
	[self.tableView reloadData];
}

#pragma mark - Initialisation

- (id)  initWithScore:(NSNumber *)score
andGameTrackingObject:(GameTrackingObject *)gameTrackingObject
{
	if (self = [super initWithNibName:@"FriendsPickerView" bundle:nil])
	{
		_dataSource			= @{}.mutableCopy;
		_gameTrackingObject	= gameTrackingObject;
		_score				= score;
		
		[[GameKitHelper sharedGameKitHelper] setDelegate:self];
		[[GameKitHelper sharedGameKitHelper] findScoresOfFriendsToChallenge];
	}
	
	return self;
}

#pragma mark - UITableViewDataSource Methods

/**
 *	create and return the cells for each row of the table view
 *
 *	@param	tableView					the table view for which we are creating cells
 *	@param	indexPath					the index path of the row we are creating a cell for
 */
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier		= @"FriendCell";
	static int ScoreLabelTag			= 1;
	static int PlayerImageTag			= 2;
	static int PlayerNameTag			= 3;
	
	UITableViewCell *cell				= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (!cell)
	{
		cell							= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.selectionStyle				= UITableViewCellSelectionStyleGray;
		cell.textLabel.textColor		= [UIColor whiteColor];
		
		UILabel *playerName				= [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 150, 44)];
		playerName.tag					= PlayerNameTag;
		playerName.font					= [UIFont systemFontOfSize:18];
		playerName.backgroundColor		= [UIColor clearColor];
		playerName.textAlignment		= UIControlContentVerticalAlignmentCenter;
		[cell addSubview:playerName];
		
		UIImageView *playerImage		= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
		playerImage.tag					= PlayerImageTag;
		[cell addSubview:playerImage];
		
		UILabel *scoreLabel				= [[UILabel alloc] initWithFrame:CGRectMake(365, 0, 30, cell.frame.size.height)];
		scoreLabel.tag					= ScoreLabelTag;
		scoreLabel.backgroundColor		= [UIColor clearColor];
		scoreLabel.textColor			= [UIColor whiteColor];
		[cell.contentView addSubview:scoreLabel];
		
		UIImageView *checkmark			= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
		checkmark.tag					= kCheckMarkTag;
		checkmark.hidden				= YES;
		CGRect frame					= checkmark.frame;
		frame.origin					= CGPointMake(tableView.frame.size.width - 16, 13);
		checkmark.frame					= frame;
		[cell.contentView addSubview:checkmark];
	}
	
	NSDictionary *dictionary			= _dataSource.allValues[indexPath.row];
	GKScore *score						= dictionary[kScoreKey];
	GKPlayer *player					= dictionary[kPlayerKey];
	NSNumber *number					= dictionary[kIsChallengedKey];
	
	UIImageView *checkmark				= (UIImageView *)[cell viewWithTag:kCheckMarkTag];
	
	if (number.boolValue)
		checkmark.hidden				= NO;
	else
		checkmark.hidden				= YES;
	
	NSLog(@"Trying to load photo for player: %@", player);
	
	if (player)
	{
		[player loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo, NSError *error)
		{
			if (photo)
			{
				UIImageView *playerImage	= (UIImageView *)[cell viewWithTag:PlayerImageTag];
				
				[UtilityMethods runOnMainThreadSync:
				^{
					playerImage.image		= photo;
				}];
			}
			else if (error)
				NSLog(@"Error loading the player image: %@", error.localizedDescription);
		 }];
	}
	
	UILabel *playerName					= (UILabel *)[cell viewWithTag:PlayerNameTag];
	playerName.text						= player.displayName;
	
	UILabel *scoreLabel					= (UILabel *)[cell viewWithTag:ScoreLabelTag];
	scoreLabel.text						= score.formattedValue;
	
	return cell;
}

/**
 *	define how many rows for each section there are in this table view
 *
 *	@param	tableView					the table view for which we are creating cells
 *	@param	section						the particular section for which we must define the rows
 */
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return _dataSource.count;
}

#pragma mark - UITableViewDelegate Methods

/**
 *	handle the fact that a cell was just selected
 *
 *	@param	tableView					the table view containing selected cell
 *	@param	indexPath					the index path of the cell that was selected
 */
- (void)	  tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	BOOL isChallenged					= NO;
	
	UITableViewCell *cell				= [tableView cellForRowAtIndexPath:indexPath];
	UIImageView *checkmark				= (UIImageView *)[cell viewWithTag:kCheckMarkTag];
	
	if (!checkmark.isHidden)
		checkmark.hidden				= YES;
	else
		checkmark.hidden				= NO, isChallenged	= YES;
	
	NSMutableDictionary *dictionary		= _dataSource.allValues[indexPath.row];
	
	dictionary[kIsChallengedKey]		= @(isChallenged);
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - View Lifecycle

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.tableView setDataSource:self];
	[self.tableView setDelegate:self];
	
	[self addButtons];
}

@end







































