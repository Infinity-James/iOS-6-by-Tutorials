//
//  GameTrackingEngine.m
//  MonkeyJump
//
//  Created by James Valaitis on 18/01/2013.
//
//

#import "AFJSONRequestOperation.h"
#import "GameTrackingEngine.h"
#import "GameTrackingObject.h"

#define kSeedKey			@"Seed"
#define kJumpArrayKey		@"JumpArray"
#define kHitArrayKey		@"HitArray"

@implementation GameTrackingEngine

- (id)initWithBaseURL:(NSURL *)url
{
	if (self = [super initWithBaseURL:url])
	{
		self.parameterEncoding	= AFJSONParameterEncoding;
		[self registerHTTPOperationClass:[AFJSONRequestOperation class]];
		[self setDefaultHeader:@"Accept" value:@"application/json"];
	}
	
	return self;
}

+ (GameTrackingEngine *)sharedClient
{
	static GameTrackingEngine *sharedClient;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken,
	^{
		sharedClient			= [[GameTrackingEngine alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
	});
	
	return sharedClient;
}

- (void)retrieveGameTrackingDetailsForKey:(NSNumber *)key
								onSuccess:(GameTrackingObjectResponse)successBlock
							  orOnFailure:(GameTrackingObjectError)errorBlock
{
	NSDictionary *params		= @{@"challengeId" : key};
	
	[self getPath:@"ChallengesAPI.php"
	   parameters:params
		  success:^(AFHTTPRequestOperation *operation, id responseObject)
	{
		if (successBlock && responseObject && [responseObject isKindOfClass:[NSDictionary class]])
		{
			GameTrackingObject *gameTrackingObject	= [[GameTrackingObject alloc] init];
			
			gameTrackingObject.jumpTimingSinceStartOfGame	= responseObject[kJumpArrayKey];
			gameTrackingObject.hitTimingSinceStartOfGame	= responseObject[kHitArrayKey];
			gameTrackingObject.seed							= [responseObject[kSeedKey] intValue];
			
			successBlock(gameTrackingObject);
		}
	}
		  failure:^(AFHTTPRequestOperation *operation, NSError *error)
	{
		if (errorBlock)
			errorBlock(error);
	}];
}

- (void)sendGameTrackingInfo:(GameTrackingObject *)gameTrackingObject
			 withChallengeID:(NSNumber *)challengeID
				   onSuccess:(GameTrackingObjectSentSuccessfully)successBlock
				 orOnFailure:(GameTrackingObjectError)errorBlock
{
	NSDictionary *params			= @{kSeedKey : @(gameTrackingObject.seed),
										kJumpArrayKey : gameTrackingObject.jumpTimingSinceStartOfGame,
										kHitArrayKey : gameTrackingObject.hitTimingSinceStartOfGame};
	
	NSString *postPath				= [NSString stringWithFormat:@"ChallengesAPI.php?challengeId=%d", challengeID.intValue];
	
	[self postPath:postPath
		parameters:params
		   success:^(AFHTTPRequestOperation *operation, id responseObject)
	{
		if (successBlock)
			successBlock();
	}
		   failure:^(AFHTTPRequestOperation *operation, NSError *error)
	{
		if (errorBlock)
			errorBlock(error);
	}];
}

@end










































































