//
//  MusicInfo.m
//  Hangman
//
//  Created by James Valaitis on 31/01/2013.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//

#import "MusicInfo.h"

@implementation MusicInfo

- (id)initWithTrackID:(NSInteger)trackID
			trackName:(NSString *)trackName
		   artistName:(NSString *)artistName
				price:(CGFloat)price
		   artworkURL:(NSString *)artworkURL
{
	if (self = [super init])
	{
		self.trackID		= trackID;
		self.trackName		= trackName;
		self.artistName		= artistName;
		self.artworkURL		= artworkURL;
		self.price			= price;
	}
	
	return self;
}

@end
