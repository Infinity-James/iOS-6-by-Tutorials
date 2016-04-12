//
//  Image.h
//  RecipesKit
//
//  Created by Felipe on 7/1/12.
//  Copyright (c) 2012 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe;

@interface ImageToDataTransformer : NSValueTransformer
@end

@interface Image : NSManagedObject

@property (nonatomic, retain) UIImage * image;
@property (nonatomic, retain) Recipe *recipe;

@end
