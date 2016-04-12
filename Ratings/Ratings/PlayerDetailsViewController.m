#import "AppDelegate.h"
#import "PlayerDetailsViewController.h"
#import "GamePickerViewController.h"
#import "Player.h"

static NSString *const	kDelegateKey					= @"Delegate";
static NSString *const	kGameKey						= @"Game";
static NSString *const	kPlayerIDKey					= @"PlayerID";
static NSString *const	kPlayerNameKey					= @"PlayerName";

@interface PlayerDetailsViewController () <GamePickerViewControllerDelegate, UIActionSheetDelegate, UIViewControllerRestoration>

@property (strong, nonatomic) IBOutlet	UITextField		*nameTextField;
@property (strong, nonatomic) IBOutlet	UILabel			*detailLabel;
@property (strong, nonatomic) IBOutlet	UIButton		*deleteButton;

@end

@implementation PlayerDetailsViewController
{
	UIActionSheet							*_actionSheet;
	NSString								*_game;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		_game = @"Chess";
	}
	return self;
}

- (void)registerBackgroundNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationDidEnterBackground:)
												 name:UIApplicationDidEnterBackgroundNotification
											   object:nil];
}

- (void)unregisterBackgroundNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationDidEnterBackgroundNotification
												  object:nil];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
	[_actionSheet dismissWithClickedButtonIndex:_actionSheet.cancelButtonIndex animated:NO];
}

#pragma mark - UIViewControllerRestoration Methods

/**
 *	asks the receiver to provide the view controller that corresponds to the specified identifier information
 *
 *	@param	identifierComponents			array of nsstrings corresponding to the restoration ids of desired view controller and ancestors
 *	@param	coder							keyed archiver containing the app’s saved state information
 */
+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents
															coder:(NSCoder *)coder
{
	PlayerDetailsViewController *viewController;
	NSString *playerID;
	NSString *identifier					= identifierComponents.lastObject;
	UIStoryboard *storyboard				= [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
	AppDelegate *appDelegate				= (AppDelegate *)[UIApplication sharedApplication].delegate;
	
	if (storyboard)
		if ((viewController = [storyboard instantiateViewControllerWithIdentifier:identifier]))
			if ((playerID = [coder decodeObjectForKey:kPlayerIDKey]))
				viewController.playerToEdit	= [appDelegate playerWithID:playerID];
	
	return viewController;
}

#pragma mark - Initialisation

/**
 *	deallocates the memory occupied by the receiver
 */
- (void)dealloc
{
	[self unregisterBackgroundNotifications];
}

#pragma mark - View Lifecycle

/**
 *	prepares the receiver for service after it has been loaded from an interface builder archive, or nib file
 */
- (void)awakeFromNib
{
	[super awakeFromNib];
	self.restorationClass					= self.class;
	[self registerBackgroundNotifications];
}



- (void)viewDidLoad
{
	[super viewDidLoad];
	
	if (self.playerToEdit != nil)
	{
		self.title = @"Edit Player";
		self.nameTextField.text = self.playerToEdit.name;
		_game = self.playerToEdit.game;
	}
	else
	{
		self.deleteButton.hidden = YES;
	}

	self.detailLabel.text = _game;

	UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.nameTextField action:@selector(resignFirstResponder)];
	recognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:recognizer];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"PickGame"])
	{
		GamePickerViewController *gamePickerViewController = segue.destinationViewController;
		gamePickerViewController.delegate = self;
		gamePickerViewController.game = _game;
	}
}

- (IBAction)cancel:(id)sender
{
	[self.delegate playerDetailsViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
	if (self.playerToEdit != nil)
	{
		self.playerToEdit.name = self.nameTextField.text;
		self.playerToEdit.game = _game;

		[self.delegate playerDetailsViewController:self didEditPlayer:self.playerToEdit];
	}
	else
	{
		Player *player = [[Player alloc] init];
		player.name = self.nameTextField.text;
		player.game = _game;
		player.rating = 1;

		[self.delegate playerDetailsViewController:self didAddPlayer:player];
	}
}

- (IBAction)deletePressed:(id)sender
{
	_actionSheet = [[UIActionSheet alloc]
		initWithTitle:@"Are you sure?"
		delegate:self
		cancelButtonTitle:@"Cancel"
		destructiveButtonTitle:@"Delete"
		otherButtonTitles:nil];

	[_actionSheet showFromRect:self.deleteButton.frame inView:self.view animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
		[self.nameTextField becomeFirstResponder];
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
	_game								= [coder decodeObjectForKey:kGameKey];
	NSString *playerName				= [coder decodeObjectForKey:kPlayerNameKey];
	if (playerName)						self.nameTextField.text = playerName;
	
	if (!_game|| !_game.length)
		_game							= @"Chess";
	
	self.detailLabel.text				= _game;
	
	[self.view layoutIfNeeded];
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
	[coder encodeObject:_game forKey:kGameKey];
	[coder encodeObject:self.nameTextField.text forKey:kPlayerNameKey];
	[coder encodeObject:self.playerToEdit.playerID forKey:kPlayerIDKey];
}

#pragma mark - GamePickerViewControllerDelegate

- (void)gamePickerViewController:(GamePickerViewController *)controller didSelectGame:(NSString *)game
{
	self.detailLabel.text = _game = game;
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != actionSheet.cancelButtonIndex)
	{
		[self.delegate playerDetailsViewController:self didDeletePlayer:self.playerToEdit];
	}
	
	_actionSheet						= nil;
}

@end