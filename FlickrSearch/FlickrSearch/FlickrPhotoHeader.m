//
//  FlickrPhotoHeaderView.m
//  FlickrSearch
//
//  Created by James Valaitis on 06/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import "FlickrPhotoHeader.h"

@interface FlickrPhotoHeader ()

@property (nonatomic, weak) IBOutlet	UIImageView	*backgroundImageView;
@property (nonatomic, weak) IBOutlet	UILabel		*searchLabel;

@end

@implementation FlickrPhotoHeader

- (void)setSearchText:(NSString *)text
{
	self.searchLabel.text			= text;
	
	UIImage *headerImage			= [[UIImage imageNamed:@"header_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(68, 68, 68, 68)];
	
	self.backgroundImageView.image	= headerImage;
	self.backgroundImageView.center	= self.center;
}

@end
