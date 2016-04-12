//
//  FriendsPickerController.h
//  MonkeyJump
//
//  Created by James Valaitis on 14/01/2013.
//
//

@class GameTrackingObject;

typedef void (^FriendsPickerCancelButtonPressed)();
typedef void (^FriendsPickerChallengeButtonPressed)();

@interface FriendsPickerController : UIViewController

@property (nonatomic, copy)	FriendsPickerCancelButtonPressed	cancelButtonBlock;
@property (nonatomic, copy)	FriendsPickerChallengeButtonPressed	challengeButtonBlock;

- (id)  initWithScore:(NSNumber *)score
andGameTrackingObject:(GameTrackingObject *)gameTrackingObject;

@end
