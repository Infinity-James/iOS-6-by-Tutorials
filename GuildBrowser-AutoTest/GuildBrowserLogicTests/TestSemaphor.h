//
//  TestSemaphor.h
//
//  Created by Marin Todorov on 17/01/2012.
//  Copyright (c) 2012 Marin Todorov. All rights reserved.
//

// Note this class was obtained via this awesome article by Marin Todorov (an iOS Tutorial and Book author)!
// blog post describing the use of this class: http://www.touch-code-magazine.com/unit-testing-for-blocks-based-apis/

#import <Foundation/Foundation.h>

@interface TestSemaphor : NSObject

@property (strong, atomic) NSMutableDictionary* flags;

+(TestSemaphor *)sharedInstance;

-(BOOL)isLifted:(NSString*)key;
-(void)lift:(NSString*)key;
-(void)waitForKey:(NSString*)key;

@end
