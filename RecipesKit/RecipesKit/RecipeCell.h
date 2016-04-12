//
//  RecipeCell.h
//  RecipesKit
//
//  Created by James Valaitis on 26/03/2013.
//  Copyright (c) 2013 Felipe Last Marsetti. All rights reserved.
//

extern NSString *const kRecipeCellIdentifier;

@interface RecipeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet	UILabel		*subtitleLabel;
@property (nonatomic, weak) IBOutlet	UILabel		*titleLabel;

@end