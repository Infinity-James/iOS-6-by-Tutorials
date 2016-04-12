#import "CharacterViewController.h"
#import "CharacterCell.h"
#import "Character.h"
#import "CharacterDetailViewController.h"
#import "HeaderView.h"
#import "WoWApiClient.h"
#import "WoWUtils.h"
#import "Guild.h"
#import "SetttingsViewController.h"

@interface CharacterViewController ()
@end

@implementation CharacterViewController
{
    NSArray *_sectionNames;
    Guild *_guild;
    
    NSString *_guildName;
    NSString *_realmName;
    
    UIPopoverController *_settingsPopoverController;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // store these later in NSUserDefaults
        _guildName = @"Dream Catchers";
        _realmName = @"Borean Tundra";
    }
    return self;
}

-(void)reloadCharactersFromRealm:(NSString *)aRealmName guildName:(NSString *)aGuildName
{    
    [self setNetworkActivityIndicatorVisible:YES];
        
    [[WoWApiClient sharedClient] guildWithName:aGuildName onRealm:aRealmName success:^(Guild *guild) {
        
        [self setNetworkActivityIndicatorVisible:NO];
        
        _guild = guild;

        // set title
        self.title = guild.name;
        
        // AFNetworking returns this block on the main thread
        [self.collectionView reloadData];
        
    } error:^(NSError *error) {
        
        [self setNetworkActivityIndicatorVisible:NO];
        
        NSString *errorMessage = [NSString stringWithFormat:@"There was a problem loading Guild %@ on realm %@",aGuildName,aRealmName];
        UIAlertView *loadAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [loadAlert show];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
   
    self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    
    NSArray *allClasses = @[
        WowClassTypeDeathKnight,
        WowClassTypeDruid,
        WowClassTypeHunter,
        WowClassTypeMage,
        WowClassTypePaladin,
        WowClassTypePriest,
        WowClassTypeRogue,
        WowClassTypeWarrior
    ];

    //
    // Sort the section names alphabetically
    //
    _sectionNames = [allClasses sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    
    //
    // load characters and guild info for the selected / configured guild & realm name
    //
    [self reloadCharactersFromRealm:_realmName guildName:_guildName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_sectionNames count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // get array from guild dict
    NSArray *charactersForClassType = [_guild membersByWowClassTypeName:_sectionNames[section]];
    return [charactersForClassType count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CharacterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CharacterCell"
                                                               forIndexPath:indexPath];
    //
    // get the specific character for the section
    //
    Character *character = [_guild membersByWowClassTypeName:_sectionNames[indexPath.section]][indexPath.row];
    [cell configureCellWithCharacter:character];
    
    return cell;
} 


#pragma mark - UICollectionViewDelegate


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
          viewForSupplementaryElementOfKind:(NSString *)kind
                                atIndexPath:(NSIndexPath *)indexPath
{
    HeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                withReuseIdentifier:@"HEADER_CELL"
                                                                       forIndexPath:indexPath];
    headerView.classTypeName.text = _sectionNames[indexPath.section];
    return headerView;
}

#pragma mark - Storyboard segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CharacterDetail"]) {
        
        CharacterCell *selectedCell = (CharacterCell *)sender;
        CharacterDetailViewController *detailController = segue.destinationViewController;
        detailController.character = selectedCell.character;
        
    } else if ([segue.identifier isEqualToString:@"Settings"]) {
        
        if (_settingsPopoverController != nil &&
            _settingsPopoverController.popoverVisible) {
            [_settingsPopoverController dismissPopoverAnimated:NO];
        }
        
        _settingsPopoverController = ((UIStoryboardPopoverSegue *)segue).popoverController;
        _settingsPopoverController.delegate = self;
        
        SetttingsViewController *settings = segue.destinationViewController;
        settings.guildName.text = _guildName;
        settings.realmName.text = _realmName;
    }
}

- (void)setNetworkActivityIndicatorVisible:(BOOL)visible
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = visible;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"dismiss popover");
    
    
    // get the new settings
    
    SetttingsViewController *settings = (SetttingsViewController*)popoverController.contentViewController;
    
    
    
    _realmName = settings.realmName.text;
    _guildName = settings.guildName.text;
    
    NSLog(@"%@ %@",settings.guildName.text, settings.realmName.text);
//    _settingsPopoverController = nil;
    
    [self reloadCharactersFromRealm:_realmName guildName:_guildName];
}


@end
