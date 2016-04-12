//
//  ChallengesPickerViewController.h
//  MonkeyJump
//
//  Created by Kauserali on 22/08/12.
//
//

typedef void
    (^ChallengesCancelButtonPressed)();
typedef void
    (^ChallengeSelected)(GKScoreChallenge *challenge);

@interface ChallengesPickerViewController : UIViewController
@property (nonatomic, copy) ChallengesCancelButtonPressed cancelButtonPressedBlock;
@property (nonatomic, copy) ChallengeSelected challengeSelectedBlock;
@end
