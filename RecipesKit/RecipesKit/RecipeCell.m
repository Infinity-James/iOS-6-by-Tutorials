//
//  RecipeCell.m
//  RecipesKit
//
//  Created by James Valaitis on 26/03/2013.
//  Copyright (c) 2013 Felipe Last Marsetti. All rights reserved.
//

NSString *const kRecipeCellIdentifier	= @"RecipeCell";

#import "RecipeCell.h"

@implementation RecipeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end