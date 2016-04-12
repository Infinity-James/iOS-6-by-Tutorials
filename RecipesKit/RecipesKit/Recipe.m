//
//  Recipe.m
//  RecipesKit
//
//  Created by Felipe on 7/1/12.
//  Copyright (c) 2012 Felipe. All rights reserved.
//

#import "Recipe.h"
#import "Image.h"

@implementation Recipe

@dynamic notes;
@dynamic servings;
@dynamic title;
@dynamic images;

- (NSString *)servingsString
{
    // Configure the Subtitle Text Label depending on the amount of servings
    NSString *servingsString = @"1 Serving";
    
    if (self.servings.intValue  == 0 || self.servings.intValue > 1)
    {
        return servingsString = [NSString stringWithFormat:@"%@ Servings", self.servings];
    }
    
    return servingsString;
}

@end
