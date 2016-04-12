//
//  MyView.m
//  CustomView
//
//  Created by James Valaitis on 05/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import "MyView.h"

@implementation MyView
{
	CGSize	_mySize;
}

#pragma mark - Action & Selector Methods

- (void)viewTapped:(UIGestureRecognizer *)recogniser
{
	_mySize.width	+= 30.0f;
	_mySize.height	+= 30.0f;
	
	[self invalidateIntrinsicContentSize];
	[self setNeedsDisplay];
}

#pragma mark - Initialisation

/**
 *	allows the decoding of object when initialising
 *
 *	@param	aDecoder					the object used to decode our properties
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		_mySize		= CGSizeMake(30, 30);
		
		UITapGestureRecognizer *recogniser;
		recogniser	= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
		[self addGestureRecognizer:recogniser];
	}
	
	return self;
}

#pragma mark - UIView Methods

/**
 *	returns the insets from the view’s frame that define its alignment rectangle
 */
- (UIEdgeInsets)alignmentRectInsets
{
	return UIEdgeInsetsMake(10, 10, 10, 10);
}

/**
 *	draws the receiver’s image within the passed-in rectangle
 *
 *	@param	rect						portion of the view’s bounds that needs to be updated
 */
- (void)drawRect:(CGRect)rect
{
	[[UIColor redColor] setFill];
	
	CGRect alignmentRect	= [self alignmentRectForFrame:self.bounds];
	UIRectFill(alignmentRect);
	NSLog(@"Alignment Rect: %@", NSStringFromCGRect(alignmentRect));
}

/**
 *	returns the natural size for the receiving view, considering only properties of the view itself
 */
- (CGSize)intrinsicContentSize
{
	return _mySize;
}

@end
