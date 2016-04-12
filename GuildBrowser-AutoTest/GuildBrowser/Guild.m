#import "Guild.h"
#import "Character.h"
#import "WoWUtils.h"

@implementation Guild
{
    NSMutableDictionary *membersByClassTypeData;
}


- (id)initWithGuildData:(NSDictionary *)guildData
{
    self = [super init];
    if (self) {
        
        _name = guildData[@"name"];
        _battlegroup = guildData[@"battlegroup"];
        _realm = guildData[@"realm"];
        _achievementPoints = guildData[@"achievementPoints"];
        _level = guildData[@"level"];

        // one entry per class type
        membersByClassTypeData = [[NSMutableDictionary alloc] initWithCapacity:12];
        
        // now create each character by getting the data of each character dictionary
        // and rank
        [self buildMembersFrom:guildData];
    }
    return self;
}


- (void)buildMembersFrom:(NSDictionary*)guildData
{
    // create characters from memeber data
    NSMutableArray *characters = [[NSMutableArray alloc] init];
    // get members, create character for each one
    for (NSDictionary *member in guildData [@"members"])
    {
        NSMutableDictionary *memberData = [[NSMutableDictionary alloc] init];
        [memberData addEntriesFromDictionary:member[@"character"]];
        
        [memberData setValue:member[@"rank"] forKey:@"rank"];
        
        Character *character = [[Character alloc] initWithCharacterDetailData:memberData];
        [characters addObject:character];
    }
    _members = [NSArray arrayWithArray:characters];
        
    NSArray *allClasses = @[
        WowClassTypeDeathKnight,
        WowClassTypeDruid,
        WowClassTypeHunter,
        WowClassTypeMage,
        WowClassTypePaladin,
        WowClassTypePriest,
        WowClassTypeRogue,
        WowClassTypeWarrior
    ];

    // initialize all the array data
    for (NSString *classType in allClasses)
    {
        [membersByClassTypeData setValue:[self lookupClassType:classType] forKey:classType];
    }
}

- (NSArray*)lookupClassType:(NSString*)name
{
    NSString *attributeName = @"classType";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES %@",
                              attributeName, name];
    return [[_members filteredArrayUsingPredicate:predicate] sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray*)membersByWowClassTypeName:(NSString*)name
{
    return membersByClassTypeData[name];
}


@end
