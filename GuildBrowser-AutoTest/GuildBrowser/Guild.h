#import <Foundation/Foundation.h>
#import "WoWUtils.h"

@interface Guild : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *battlegroup;
@property (nonatomic, copy) NSString *realm;
@property (nonatomic, copy) NSNumber *achievementPoints;
@property (nonatomic, copy) NSNumber *level;
@property (nonatomic, copy) NSArray *members;


- (id)initWithGuildData:(NSDictionary *)guildData;
- (NSArray*)membersByWowClassTypeName:(NSString*)name;

@end
