//
//  RecipeDetailViewController.h
//  RecipesKit
//
//  Created by Felipe on 8/6/12.
//  Copyright (c) 2012 Felipe Last Marsetti. All rights reserved.
//

#import "Recipe.h"
#import <UIKit/UIKit.h>

@interface RecipeDetailViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Recipe *recipe;

@end
