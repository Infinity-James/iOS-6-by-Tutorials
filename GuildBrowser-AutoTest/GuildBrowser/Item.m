#import "Item.h"
#import "WoWUtils.h"

@implementation Item

+(id)initWithData:(NSDictionary *)itemData
{
    return [self initWithName:itemData[@"name"]
                       itemId:itemData[@"id"]
                         icon:itemData[@"icon"]
                      quality:[itemData[@"quality"] integerValue]];
}

+(id)initWithName:(NSString *)name
           itemId:(NSNumber *)itemId
             icon:(NSString *)icon
          quality:(ItemQuality)quality
{
    return [[self alloc] initWithName:name itemId:itemId icon:icon quality:quality];
}

-(id)initWithName:(NSString *)name
           itemId:(NSNumber *)itemId
             icon:(NSString *)icon
          quality:(ItemQuality)quality
{
    self = [super init];
    if (self) {        
        _name = name;
        _itemId = itemId;
        _icon = icon;
        _quality = [WoWUtils qualityFromQualityType:quality];
    }
    return self;
}

-(NSString *)iconUrl
{
    NSString *url = [NSString stringWithFormat:@"http://us.media.blizzard.com/wow/icons/56/%@.jpg",_icon];
    return [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
