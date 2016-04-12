//
//  MusicInfo.h
//  Hangman
//
//  Created by James Valaitis on 31/01/2013.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//

@interface MusicInfo : NSObject

@property (nonatomic, strong)	NSString		*artistName;
@property (nonatomic, strong)	NSString		*artworkURL;
@property (nonatomic, assign)	CGFloat			price;
@property (nonatomic, assign)	NSInteger		trackID;
@property (nonatomic, strong)	NSString		*trackName;

- (id)initWithTrackID:(NSInteger)trackID
			trackName:(NSString *)trackName
		   artistName:(NSString *)artistName
				price:(CGFloat)price
		   artworkURL:(NSString *)artworkURL;


@end
