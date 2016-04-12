//
//  ViewController.m
//  ArtistDetails
//
//  Created by James Valaitis on 04/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)nextButtonTapped
{
	static int index	= 0;
	
	static NSArray *artists;
	static NSArray *albums;
	
	if (!artists)
		artists			= @[@"Thelonious Monk", @"Miles Davis",
							@"Louis Jordan & His Tympany Five", @"Charlie 'Bird' Parker",
							@"Chet Baker", @"James 'The Freaking Super Legend' Valaitis"];
	if (!albums)
		albums			= @[@"The Complete Riverside Recordings", @"Live at the Blue Note"];
	
	[self.artistNameLabel setText:artists[index % artists.count]];
	[self.albumNameLabel setText:albums[index % albums.count]];
	 
	index++;
}

@end
