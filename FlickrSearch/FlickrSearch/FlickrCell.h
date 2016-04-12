//
//  FlickrCell.h
//  FlickrSearch
//
//  Created by James Valaitis on 06/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

@class FlickrPhoto;

@interface FlickrCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet	UIImageView	*imageView;
@property (nonatomic, strong)			FlickrPhoto	*photo;


@end
