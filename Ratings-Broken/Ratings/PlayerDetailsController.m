//
//  PlayerDetailsController.m
//  Ratings
//
//  Created by James Valaitis on 21/11/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import "Player.h"
#import "PlayerDetailsController.h"

@interface PlayerDetailsController () <UIActionSheetDelegate>
{
	IBOutlet UIButton					*_deleteButton;
	NSString							*_game;
}

@end

@implementation PlayerDetailsController {}

#pragma mark - Initialisation

/**
 *	allows the decoding of object when initialising
 *
 *	@param	aDecoder					the object used to decode our properties
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		_game							= @"Chess";
	}
	
	return self;
}

#pragma mark - UIActionSheetDelegate Methods

/**
 *	sent to the delegate after an action sheet is dismissed from the screen
 *
 *	@param	actionSheet					action sheet that was dismissed
 *	@param	buttonIndex					index of the button that was clicked
 */
- (void)	  actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == actionSheet.cancelButtonIndex)	return;
	
	[self.delegate playerDetails:self didDeletePlayer:self.playerToEdit];
}

#pragma mark - View Lifecycle

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	if (self.playerToEdit)
	{
		self.title						= @"Edit Player";
		self.nameTextField.text			= self.playerToEdit.name;
		_game							= self.playerToEdit.game;
		_deleteButton.hidden			= NO;
	}
	else
	{
		_deleteButton.hidden			= YES;
	}
	
	self.detailLabel.text				= _game;
}

#pragma mark - Action & Selector Methods

- (IBAction)cancel:(id)sender
{
	[self.delegate playerDetailsDidCancel:self];
}

- (IBAction)deletePlayer
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"Are you sure?"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:@"Delete"
								  otherButtonTitles:nil];
	
	[actionSheet showFromRect:_deleteButton.frame inView:self.view animated:YES];
}

- (IBAction)done:(id)sender
{
	if (self.playerToEdit)
	{
		self.playerToEdit.name			= self.nameTextField.text;
		self.playerToEdit.game			= _game;
		
		[self.delegate playerDetails:self didEditPlayer:self.playerToEdit];
	}
	
	else
	{
		Player *player					= [[Player alloc] init];
		player.name						= self.nameTextField.text;
		player.game						= _game;
		player.rating					= 1;
		
		[self.delegate playerDetails:self didAddPlayer:player];
	}
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"PickGame"])
	{
		GamePickerController *gamePickerController;
		gamePickerController			= segue.destinationViewController;
		[gamePickerController setDelegate:self];
		[gamePickerController setGame:_game];
	}
}

#pragma mark - GamePickerControllerDelegate Methods

- (void)gamePickerViewController:(GamePickerController *)controller
				   didSelectGame:(NSString *)theGame
{
	_game								= theGame;
	self.detailLabel.text				= _game;
	[self.navigationController popViewControllerAnimated:YES];
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
	if (indexPath.section == 0)
		[self.nameTextField becomeFirstResponder];
}

@end
