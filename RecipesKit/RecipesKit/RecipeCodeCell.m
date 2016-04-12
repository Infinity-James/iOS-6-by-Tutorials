//
//  RecipeCodeCell.m
//  RecipesKit
//
//  Created by James Valaitis on 26/03/2013.
//  Copyright (c) 2013 Felipe Last Marsetti. All rights reserved.
//

NSString *const kRecipeCodeCellIdentfier	= @"RecipeCodeCell";
NSString *const kRecipeCodeCellSegue		= @"RecipeCodeCellSegue";

#import "RecipeCodeCell.h"

@implementation RecipeCodeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		self.accessoryType					= UITableViewCellAccessoryDisclosureIndicator;
		
		self.servingsLabel					= [[UILabel alloc] initWithFrame:CGRectMake(10, 21, 270, 21)];
		self.nameLabel						= [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 270, 21)];
		
		self.servingsLabel.font				= [UIFont fontWithName:@"AvenirNext-Medium" size:12];
		self.nameLabel.font					= [UIFont fontWithName:@"AvenirNext-Medium" size:14];
		
		[self.contentView addSubview:self.servingsLabel];
		[self.contentView addSubview:self.nameLabel];
    }
    
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter & Getter Methods

/**
 *	a string used to identify a cell that is reusable
 */
- (NSString *)reuseIdentifier
{
	return kRecipeCodeCellIdentfier;
}

@end
