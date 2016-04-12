#import <UIKit/UIKit.h>
@class Character;
@interface CharacterCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *levelRace;
@property (nonatomic, weak) IBOutlet UILabel *className;
@property (nonatomic, weak) IBOutlet UILabel *realm;
@property (nonatomic, weak) IBOutlet UILabel *achievementPoints;
@property (nonatomic, weak) IBOutlet UILabel *guildRank;
@property (nonatomic, weak) IBOutlet UIImageView *thumbNail;

@property (nonatomic, strong) Character *character;

-(void)configureCellWithCharacter:(Character *)character;

@end
