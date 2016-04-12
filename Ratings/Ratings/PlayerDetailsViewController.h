
@class PlayerDetailsViewController;
@class Player;

@protocol PlayerDetailsViewControllerDelegate <NSObject>

- (void)playerDetailsViewControllerDidCancel:(PlayerDetailsViewController *)controller;
- (void)playerDetailsViewController:(PlayerDetailsViewController *)controller didAddPlayer:(Player *)player;
- (void)playerDetailsViewController:(PlayerDetailsViewController *)controller didEditPlayer:(Player *)player;
- (void)playerDetailsViewController:(PlayerDetailsViewController *)controller didDeletePlayer:(Player *)player;

@end

@interface PlayerDetailsViewController : UITableViewController

@property (nonatomic, weak) id <PlayerDetailsViewControllerDelegate> delegate;
@property (nonatomic, strong) Player *playerToEdit;

@end