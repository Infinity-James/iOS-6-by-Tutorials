//
//  RecipeCodeCell.h
//  RecipesKit
//
//  Created by James Valaitis on 26/03/2013.
//  Copyright (c) 2013 Felipe Last Marsetti. All rights reserved.
//

extern NSString *const kRecipeCodeCellIdentfier;
extern NSString *const kRecipeCodeCellSegue;

@interface RecipeCodeCell : UITableViewCell

@property (nonatomic, strong)	UILabel		*nameLabel;
@property (nonatomic, strong)	UILabel		*servingsLabel;

@end