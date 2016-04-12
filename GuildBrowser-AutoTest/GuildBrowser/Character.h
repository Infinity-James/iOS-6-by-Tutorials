#import <Foundation/Foundation.h>

@class Item;

@interface Character : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *level;
@property (nonatomic, readonly) NSString *race;
@property (nonatomic, readonly) NSString *classType;
@property (nonatomic, copy) NSNumber *achievementPoints;
@property (nonatomic, copy) NSString *realm;
@property (nonatomic, copy) NSNumber *guildRank;
@property (nonatomic, copy) NSString *thumbnail;

@property (nonatomic, copy) NSString *battleGroup;
@property (nonatomic, copy) NSNumber *averageItemLevelEquipped;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSNumber *averageItemLevel;
@property (nonatomic, copy) NSString *selectedSpec;
@property (nonatomic, copy) NSString *talentPoints;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) Item *neckItem;
@property (nonatomic, strong) Item *wristItem;
@property (nonatomic, strong) Item *waistItem;
@property (nonatomic, strong) Item *handsItem;
@property (nonatomic, strong) Item *shoulderItem;
@property (nonatomic, strong) Item *chestItem;
@property (nonatomic, strong) Item *fingerItem1;
@property (nonatomic, strong) Item *fingerItem2;
@property (nonatomic, strong) Item *shirtItem;
@property (nonatomic, strong) Item *tabardItem;
@property (nonatomic, strong) Item *headItem;
@property (nonatomic, strong) Item *backItem;
@property (nonatomic, strong) Item *legsItem;
@property (nonatomic, strong) Item *feetItem;
@property (nonatomic, strong) Item *mainHandItem;
@property (nonatomic, strong) Item *offHandItem;
@property (nonatomic, strong) Item *trinketItem1;
@property (nonatomic, strong) Item *trinketItem2;
@property (nonatomic, strong) Item *rangedItem;

- (id)initWithCharacterDetailData:(NSDictionary *)data;

- (NSString *)profileImageUrl;
- (NSString *)profileBackgroundImageUrl;
- (NSString *)thumbnailUrl;


@end
