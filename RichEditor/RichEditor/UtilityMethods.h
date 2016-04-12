//
//  UtilityMethods.h
//  MonkeyJump
//
//  Created by James Valaitis on 14/01/2013.
//
//

typedef void(^EmptyBlock)(void);

@interface UtilityMethods : NSObject

+ (NSString *)documentsDirectory;
+ (void)runOnMainThreadSync:(EmptyBlock)anEmptyBlock;

@end
