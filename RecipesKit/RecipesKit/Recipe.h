//
//  Recipe.h
//  RecipesKit
//
//  Created by Felipe on 7/1/12.
//  Copyright (c) 2012 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Image;

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * servings;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *images;

- (NSString *)servingsString;

@end

@interface Recipe (CoreDataGeneratedAccessors)

- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
