//
//  FlickrCell.m
//  FlickrSearch
//
//  Created by James Valaitis on 06/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FlickrCell.h"
#import "FlickrPhoto.h"

@implementation FlickrCell

/**
 *	allows the decoding of object when initialising
 *
 *	@param	aDecoder					the object used to decode our properties
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		UIView *backgroundView	= [[UIView alloc] initWithFrame:self.backgroundView.frame];
		[backgroundView setBackgroundColor:[UIColor blueColor]];
		[backgroundView.layer setBorderColor:[UIColor whiteColor].CGColor];
		[backgroundView.layer setBorderWidth:4];
		[self setSelectedBackgroundView:backgroundView];
	}
	
	return self;
}

- (void)setPhoto:(FlickrPhoto *)photo
{
	if (_photo != photo)
		_photo					= photo;
	
	self.imageView.image		= _photo.thumbnail;
}

@end
