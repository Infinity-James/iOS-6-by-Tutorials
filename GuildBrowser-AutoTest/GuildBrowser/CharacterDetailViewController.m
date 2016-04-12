#import "CharacterDetailViewController.h"
#import "Character.h"
#import "UIImageView+AFNetworking.h"
#import "WoWApiClient.h"
#import "WowItemView.h"
#import "Item.h"

@interface CharacterDetailViewController ()
@end

@implementation CharacterDetailViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)configureItemViews:(Character*)character
{
    [_headView configureWithItem:character.headItem];
    [_neckView configureWithItem:character.neckItem];
    [_shoulderView configureWithItem:character.shoulderItem];
    [_backView configureWithItem:character.backItem];
    [_chestView configureWithItem:character.chestItem];
    [_shirtView configureWithItem:character.shirtItem];
    [_tabardView configureWithItem:character.tabardItem];
    [_wristView configureWithItem:character.wristItem];
    [_handsView configureWithItem:character.handsItem];
    [_waistView configureWithItem:character.waistItem];
    [_legsView configureWithItem:character.legsItem];
    [_feetView configureWithItem:character.feetItem];
    [_finger1View configureWithItem:character.fingerItem1];
    [_finger2View configureWithItem:character.fingerItem2];
    [_trinket1View configureWithItem:character.trinketItem1];
    [_trinket2View configureWithItem:character.trinketItem2];
    [_mainHandView configureWithItem:character.mainHandItem];
    [_offHandView configureWithItem:character.offHandItem];
    [_rangedView configureWithItem:character.rangedItem];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
        
    _name.text = _character.name;
    
    
    // get character detail's
    [self.characterProfileImage setImageWithURL: [NSURL URLWithString:[_character profileImageUrl]]];
    [self setNetworkActivityIndicatorVisible:YES];
    
    [[WoWApiClient sharedClient] characterWithName:_character.name onRealm:_character.realm success:^(Character *characterWithDetails) {

        [self setNetworkActivityIndicatorVisible:NO];
        [self configureItemViews:characterWithDetails];
        
                                               
       _averageItemLevel.text = [characterWithDetails.averageItemLevel stringValue];
       _avgItemLevelEquipped.text = [characterWithDetails.averageItemLevelEquipped stringValue];
       _selectedSpec.text = [NSString stringWithFormat: @"%@",characterWithDetails.classType];

                                               
       // not every character has a title selected
       if (characterWithDetails.title) {
           // title has a %s in it, so convert NSString to a c string (1d array of char's)
           const char *namePtr = [characterWithDetails.name cStringUsingEncoding:NSUTF8StringEncoding];
           _name.text = [NSString stringWithFormat:characterWithDetails.title, namePtr];
       }        
        
    } error:^(NSError *error) {
        [self setNetworkActivityIndicatorVisible:NO];
        [self configureItemViews:nil];
        
        NSString *errorMessage = [NSString stringWithFormat:@"There was a problem loading detail info for %@",_character.name];
        UIAlertView *loadAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [loadAlert show];
    }];    
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

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setNetworkActivityIndicatorVisible:(BOOL)visible
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = visible;
}


@end
