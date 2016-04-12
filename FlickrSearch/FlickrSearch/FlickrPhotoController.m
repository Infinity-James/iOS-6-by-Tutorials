//
//  FlickrPhotoController.m
//  FlickrSearch
//
//  Created by James Valaitis on 06/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import "Flickr.h"
#import "FlickrPhoto.h"
#import "FlickrPhotoController.h"

@interface FlickrPhotoController ()

@property (nonatomic, weak) IBOutlet	UIImageView	*imageView;

@end

@implementation FlickrPhotoController

#pragma mark - Action & Selector Methods

- (IBAction)done
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - View Lifecycle

/**
 *	notifies the view controller that its view was added to a view hierarchy
 */
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if (self.flickrPhoto.largeImage)
		self.imageView.image			= self.flickrPhoto.largeImage;
	else
	{
		self.imageView.image			= self.flickrPhoto.thumbnail;
		
		[Flickr loadImageForPhoto:self.flickrPhoto thumbnail:NO completionBlock:^(UIImage *photoImage, NSError *error)
		{
			if (!error)
				dispatch_async(dispatch_get_main_queue(),
				^{
					self.imageView.image	= self.flickrPhoto.largeImage;
				});
		}];
	}
}

@end
