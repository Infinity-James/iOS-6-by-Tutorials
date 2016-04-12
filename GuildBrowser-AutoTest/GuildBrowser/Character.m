#import "Character.h"
#import "Item.h"
#import "WoWUtils.h"

@implementation Character

- (id)initWithCharacterDetailData:(NSDictionary *)data
{
    self = [super init];
    if (self)
    {
        _name = data[@"name"];
        _level = data[@"level"];
        _race = [WoWUtils raceFromRaceType:[data[@"race"] intValue]];
        _classType = [WoWUtils classFromCharacterType:[data[@"class"] intValue]];
        _achievementPoints = data[@"achievementPoints"];
        _realm = data[@"realm"];
        _thumbnail = data[@"thumbnail"];
        _battleGroup = data[@"battlegroup"];
        _averageItemLevelEquipped = data[@"items"][@"averageItemLevelEquipped"];
        _averageItemLevel = data[@"items"][@"averageItemLevel"];
        
        BOOL genderVal = [data[@"gender"] boolValue];
        if (genderVal) {
            _gender = @"Female";
        } else {
            _gender = @"Male";
        }
        
        // find selected spec
        _selectedSpec = [self selectedSpecFromTalents:data[@"talents"]];
        
        _neckItem = [Item initWithData:data[@"items"][@"neck"]];
        _wristItem = [Item initWithData:data[@"items"][@"wrist"]];
        _waistItem = [Item initWithData:data[@"items"][@"waist"]];
        _handsItem = [Item initWithData:data[@"items"][@"hands"]];
        _shoulderItem = [Item initWithData:data[@"items"][@"shoulder"]];
        _chestItem = [Item initWithData:data[@"items"][@"chest"]];
        _fingerItem1 = [Item initWithData:data[@"items"][@"finger1"]];
        _fingerItem2 = [Item initWithData:data[@"items"][@"finger2"]];
        _shirtItem = [Item initWithData:data[@"items"][@"shirt"]];
        _tabardItem = [Item initWithData:data[@"items"][@"tabard"]];
        _headItem = [Item initWithData:data[@"items"][@"head"]];
        _backItem = [Item initWithData:data[@"items"][@"back"]];
        _legsItem = [Item initWithData:data[@"items"][@"legs"]];
        _feetItem = [Item initWithData:data[@"items"][@"feet"]];
        _mainHandItem = [Item initWithData:data[@"items"][@"mainHand"]];
        _offHandItem = [Item initWithData:data[@"items"][@"offHand"]];
        _trinketItem1 = [Item initWithData:data[@"items"][@"trinket1"]];
        _trinketItem2 = [Item initWithData:data[@"items"][@"trinket2"]];
        _rangedItem = [Item initWithData:data[@"items"][@"ranged"]];
        _title = [self selectedTitle:data[@"titles"]];
    }
    return self;
}

// Given an array of talents (which are NSDictionaries) return the one with a key
// selected value = true
-(NSString *)selectedSpecFromTalents:(NSArray *)talents
{
    __block NSString *selectedTalentName;
    [talents enumerateObjectsUsingBlock:^(NSDictionary *talentTree, NSUInteger idx, BOOL *stop) {
        if ([talentTree[@"selected"] boolValue]) {
            selectedTalentName = talentTree[@"name"];
            *stop = YES;
        }        
    }];
    return selectedTalentName;
}

-(NSString *)selectedTitle:(NSArray *)titles
{
    __block NSString *selectedTitle;
    [titles enumerateObjectsUsingBlock:^(NSDictionary *title, NSUInteger idx, BOOL *stop) {
        if ([title[@"selected"] boolValue]) {
            selectedTitle = title[@"name"];
            *stop = YES;
        }        
    }];    
    return selectedTitle;
}

-(NSString *)profileImageUrl
{
    // only supporting US for now..
    NSString *baseUrl = @"http://us.battle.net/static-render/us/";
    NSString *profileMain = [_thumbnail stringByReplacingOccurrencesOfString:@"-avatar.jpg" withString:@"-profilemain.jpg"];
    NSString *profileImageUrl = [NSString stringWithFormat:@"%@%@",baseUrl,profileMain];
    return [profileImageUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(NSString *)profileBackgroundImageUrl
{
    return @"http://us.battle.net/wow/static/images/character/summary/backgrounds/race/1.jpg";
    
}

- (NSString *)thumbnailUrl
{
    NSString *baseUrl = @"http://us.battle.net/static-render/us/";
    NSString *url = [baseUrl stringByAppendingString:_thumbnail];
    return [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

// sort by level, then acheivement points
- (NSComparisonResult)compare:(Character *)other
{
    NSComparisonResult order;

    // first compare level in descending
    order = [other.level compare:self.level];
    
    // if same level sort by achievement points
    if (order == NSOrderedSame) {
        order = [other.achievementPoints compare:self.achievementPoints];
    }    
    return order;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@ - %@ - %@", _name, _classType, _level, _achievementPoints];
}

@end
