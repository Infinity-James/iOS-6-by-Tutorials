@class Player;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic)	UIWindow	*window;

- (Player *)playerWithID:		(NSString *)playerID;

@end