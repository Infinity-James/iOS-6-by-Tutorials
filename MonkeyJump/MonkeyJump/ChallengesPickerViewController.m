//
//  ChallengesPickerViewController.m
//  MonkeyJump
//
//  Created by Kauserali on 22/08/12.
//
//

#import "ChallengesPickerViewController.h"
#import "GameTrackingEngine.h"
#import "GameKitHelper.h"
#import "GameScene.h"

#define kChallengeKey	@"ChallengeKey"
#define kPlayerKey		@"PlayerKey"

@interface ChallengesPickerViewController () <GameKitHelperProtocol>
{
    NSMutableDictionary *_dataSource;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ChallengesPickerViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
        [[GameKitHelper sharedGameKitHelper] setDelegate:self];
        [[GameKitHelper sharedGameKitHelper] loadChallenges];
        _dataSource = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
																	 style:UIBarButtonItemStylePlain
																	target:self
																	action:@selector(cancelButtonPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[GameKitHelper sharedGameKitHelper] setDelegate:nil];
}

- (void)cancelButtonPressed:(id) sender
{
   [[GameKitHelper sharedGameKitHelper] setDelegate:nil];
    
    if (self.cancelButtonPressedBlock != nil)
        self.cancelButtonPressedBlock();
}

#pragma mark - GameKitHelperProtocol

- (void) onChallengesReceived:(NSArray *)challenges
{
	NSMutableArray *playerIds = @[].mutableCopy;
        
    [challenges enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
	{
        if ([obj isKindOfClass:[GKScoreChallenge class]])
		{
            GKScoreChallenge *challenge = (GKScoreChallenge*)obj;
            
            if (!_dataSource[challenge.issuingPlayerID])
			{
                _dataSource[challenge.issuingPlayerID] = [NSMutableDictionary dictionary];
                [playerIds addObject:challenge.issuingPlayerID];
            }
            
            (_dataSource[challenge.issuingPlayerID])[kChallengeKey] = challenge;
        }
    }];
    
    [[GameKitHelper sharedGameKitHelper] getPlayerInfo:playerIds];
    [self.tableView reloadData];
}

- (void) onPlayerInfoReceived:(NSArray *)players
{
    [players enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
	{
        GKPlayer *player = (GKPlayer*)obj;
        
        if (_dataSource[player.playerID] == nil)
            _dataSource[player.playerID] = [NSMutableDictionary dictionary];
		
        (_dataSource[player.playerID])[kPlayerKey] = player;
        
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier		= @"Cell identifier";
    
    static int PlayerImageTag			= 1;
    static int PlayerNameTag			= 2;
    static int ChallengeTextTag			= 3;
    
    UITableViewCell *tableViewCell		= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!tableViewCell)
	{
        tableViewCell					= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        tableViewCell.selectionStyle	= UITableViewCellSelectionStyleGray;
        
        UILabel *playerName				= [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 150, 44)];
        playerName.tag					= PlayerNameTag;
        playerName.textColor			= [UIColor whiteColor];
        playerName.font					= [UIFont systemFontOfSize:18];
        
        playerName.backgroundColor		= [UIColor clearColor];
        
        playerName.textAlignment		= UIControlContentVerticalAlignmentCenter;
        [tableViewCell addSubview:playerName];
        
        UIImageView *playerImage		= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        playerImage.tag					= PlayerImageTag;
        [tableViewCell addSubview:playerImage];
        
        UILabel *challengeTextLabel		= [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 240, tableViewCell.frame.size.height)];
        
        challengeTextLabel.tag			= ChallengeTextTag;
        challengeTextLabel.backgroundColor =
            [UIColor clearColor];
        challengeTextLabel.textColor = [UIColor whiteColor];
        [tableViewCell.contentView
            addSubview:challengeTextLabel];
        
    }
    NSDictionary *dict =
        [_dataSource allValues][indexPath.row];
    
    GKChallenge *challenge = dict[kChallengeKey];
    GKPlayer *player = dict[kPlayerKey];
    
    [player
         loadPhotoForSize:GKPhotoSizeSmall
         withCompletionHandler:
         ^(UIImage *photo, NSError *error) {
             if (!error) {
                 UIImageView *playerImage =
                 (UIImageView*)[tableView
                                viewWithTag:PlayerImageTag];
                 playerImage.image = photo;
             } else {
                 NSLog(@"Error loading image");
             }
     }];
    
    UILabel *playerName =
    (UILabel*)[tableViewCell
               viewWithTag:PlayerNameTag];
    playerName.text = player.displayName;
    
    UILabel *challengeTextLabel =
        (UILabel*)[tableViewCell
                   viewWithTag:ChallengeTextTag];
    challengeTextLabel.text = challenge.message;
    return tableViewCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [_dataSource allValues][indexPath.row];
    GKScoreChallenge *challenge = dict[kChallengeKey];
    
    if (self.challengeSelectedBlock != nil) {
        //1
        GameKitHelper *gameKitHelper =
        [GameKitHelper sharedGameKitHelper];
        
        //2
        gameKitHelper.delegate = nil;
        
        //3
        self.challengeSelectedBlock(challenge);
    }
}
@end
