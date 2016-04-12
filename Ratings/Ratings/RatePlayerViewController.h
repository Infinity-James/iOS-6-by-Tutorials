extern NSString *const			kPlayerIDKey;

@class RatePlayerViewController;
@class Player;

@protocol RatePlayerViewControllerDelegate <NSObject>

@required

- (void)ratePlayerViewController:(RatePlayerViewController *)controller
		  didPickRatingForPlayer:(Player *)player;

@end

@interface RatePlayerViewController : UIViewController

@property (nonatomic, weak)		id <RatePlayerViewControllerDelegate>	delegate;
@property (nonatomic, strong)	Player									*player;

@end