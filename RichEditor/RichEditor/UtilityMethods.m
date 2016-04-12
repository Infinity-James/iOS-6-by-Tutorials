//
//  UtilityMethods.m
//  MonkeyJump
//
//  Created by James Valaitis on 14/01/2013.
//
//

#import "UtilityMethods.h"

@implementation UtilityMethods

+ (NSString *)documentsDirectory
{
	NSArray *paths						= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory		= [paths objectAtIndex:0];
	
	return documentsDirectory;
}

+ (void)runOnMainThreadSync:(EmptyBlock)anEmptyBlock
{
	if ([NSThread isMainThread])
		anEmptyBlock();
	else
		dispatch_sync(dispatch_get_main_queue(), anEmptyBlock);
}

@end
