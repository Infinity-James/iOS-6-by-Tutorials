#import <Foundation/Foundation.h>
#import "WoWUtils.h"

@interface Item : NSObject

// base properties
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *itemId;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *quality;

// extra from item detail
@property (nonatomic, strong) NSString *itemLevel;

+(id)initWithData:(NSDictionary *)itemData;

+(id)initWithName:(NSString *)name
           itemId:(NSNumber *)itemId
             icon:(NSString *)icon
          quality:(ItemQuality)quality;

-(id)initWithName:(NSString *)name
           itemId:(NSNumber *)itemId
             icon:(NSString *)icon
          quality:(ItemQuality)quality;


- (NSString*)iconUrl;

@end

/*
URL = Host + "/api/wow/item/" + ItemId
*/