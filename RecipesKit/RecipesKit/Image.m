//
//  Image.m
//  RecipesKit
//
//  Created by Felipe on 7/1/12.
//  Copyright (c) 2012 Felipe. All rights reserved.
//

#import "Image.h"
#import "Recipe.h"

@implementation Image

@dynamic image;
@dynamic recipe;

@end

@implementation ImageToDataTransformer

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

+ (Class)transformedValueClass
{
    return [NSData class];
}

- (id)transformedValue:(id)value
{
    NSData *data = UIImagePNGRepresentation(value);
    
    return data;
}

- (id)reverseTransformedValue:(id)value
{
    UIImage *uiImage = [[UIImage alloc] initWithData:value];
    
    return uiImage;
}

@end