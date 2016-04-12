//
//  GameTrackingEngine.h
//  MonkeyJump
//
//  Created by James Valaitis on 18/01/2013.
//
//

#import "AFHTTPClient.h"

@class GameTrackingObject;

typedef void(^GameTrackingObjectResponse)(GameTrackingObject *gameTrackingObject);
typedef void(^GameTrackingObjectSentSuccessfully)();
typedef void(^GameTrackingObjectError)(NSError *error);

@interface GameTrackingEngine : AFHTTPClient

+ (GameTrackingEngine *)sharedClient;

- (void)retrieveGameTrackingDetailsForKey:(NSNumber *)key
								onSuccess:(GameTrackingObjectResponse)successBlock
							  orOnFailure:(GameTrackingObjectError)errorBlock;

- (void)sendGameTrackingInfo:(GameTrackingObject *)gameTrackingObject
			 withChallengeID:(NSNumber *)challengeID
				   onSuccess:(GameTrackingObjectSentSuccessfully)successBlock
				 orOnFailure:(GameTrackingObjectError)errorBlock;

@end
