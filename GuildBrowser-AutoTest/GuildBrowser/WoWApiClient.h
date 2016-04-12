#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@class Character;
@class Guild;

@interface WoWApiClient : AFHTTPClient

typedef void (^GuildBlock)(Guild *guild);
typedef void (^CharacterBlock)(Character *character);
typedef void (^ErrorBlock)(NSError *error);

+ (WoWApiClient *)sharedClient;

-(void)guildWithName:(NSString *)guildName
             onRealm:(NSString *)realmName
             success:(GuildBlock)successBlock
               error:(ErrorBlock)errorBlock;

-(void)characterWithName:(NSString *)characterName
                 onRealm:(NSString *)realmName
                 success:(CharacterBlock)successBlock
                   error:(ErrorBlock)errorBlock;

@end
