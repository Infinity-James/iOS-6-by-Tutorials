//
//  ConferenceCell.m
//  GeekPlanner
//
//  Created by James Valaitis on 21/03/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "ConferenceCell.h"

@implementation ConferenceCell

/*#pragma mark - Initialisation

**
 *	called to initialise a class instance
 *
- (id)init
{
	if (self = [super init])
	{

	}
	
	return self;
}

#pragma mark - UIViewController Methods

**
 *	called when the view controller’s view needs to update its constraints
 *
- (void)updateViewConstraints
{	
	//	remove all constraints
	[self removeConstraints:self.constraints];
	
	//	objects to be used in creating constraints
	//	NSLayoutConstraint *constraint;
	NSArray *constraints;
	NSDictionary *viewsDictionary;
	
	//	dictionary of views to apply constraints to
	viewsDictionary					= NSDictionaryOfVariableBindings(_conferenceImageView, _nameLabel);
	
	constraints						= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_conferenceImageView(==75)]-[_nameLabel]" options:kNilOptions metrics:nil views:viewsDictionary];
	
	[self addConstraints:constraints];
}

#pragma mark - View Lifecycle

**
 *	lays out subviews
 *
- (void)layoutSubviews
{	
	if (!self.conferenceImageView || !self.nameLabel)
	{
		self.conferenceImageView	= [[UIImageView alloc] init];
		self.nameLabel				= [[UILabel alloc] init];
		
		self.conferenceImageView.translatesAutoresizingMaskIntoConstraints	= NO;
		self.nameLabel.translatesAutoresizingMaskIntoConstraints			= NO;
		
		[self addSubview:self.conferenceImageView];
		[self addSubview:self.nameLabel];
	}
	
	[self updateViewConstraints];
	[super layoutSubviews];
}*/

@end