#import <UIKit/UIKit.h>
@class Character;
@class WowItemView;

@interface CharacterDetailViewController : UIViewController

@property (nonatomic, strong) Character *character;

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *averageItemLevel;
@property (nonatomic, weak) IBOutlet UILabel *avgItemLevelEquipped;
@property (nonatomic, weak) IBOutlet UILabel *selectedSpec;

@property (nonatomic, weak) IBOutlet WowItemView *headView;
@property (nonatomic, weak) IBOutlet WowItemView *neckView;
@property (nonatomic, weak) IBOutlet WowItemView *shoulderView;
@property (nonatomic, weak) IBOutlet WowItemView *backView;
@property (nonatomic, weak) IBOutlet WowItemView *chestView;
@property (nonatomic, weak) IBOutlet WowItemView *shirtView;
@property (nonatomic, weak) IBOutlet WowItemView *tabardView;
@property (nonatomic, weak) IBOutlet WowItemView *wristView;
@property (nonatomic, weak) IBOutlet WowItemView *handsView;
@property (nonatomic, weak) IBOutlet WowItemView *waistView;
@property (nonatomic, weak) IBOutlet WowItemView *legsView;
@property (nonatomic, weak) IBOutlet WowItemView *feetView;
@property (nonatomic, weak) IBOutlet WowItemView *finger1View;
@property (nonatomic, weak) IBOutlet WowItemView *finger2View;
@property (nonatomic, weak) IBOutlet WowItemView *trinket1View;
@property (nonatomic, weak) IBOutlet WowItemView *trinket2View;
@property (nonatomic, weak) IBOutlet WowItemView *mainHandView;
@property (nonatomic, weak) IBOutlet WowItemView *offHandView;
@property (nonatomic, weak) IBOutlet WowItemView *rangedView;

@property (nonatomic, weak) IBOutlet UIImageView *characterProfileImage;

@end
