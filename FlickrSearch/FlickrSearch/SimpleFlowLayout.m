//
//  SimpleFlowLayout.m
//  FlickrSearch
//
//  Created by James Valaitis on 06/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import "SimpleFlowLayout.h"

@interface SimpleFlowLayout ()
{
	NSMutableArray		*_deletedIndexPaths;
	NSMutableArray		*_insertedIndexPaths;
}

@end

@implementation SimpleFlowLayout

#pragma mark - UICollectionViewLayout Methods

/**
 *	performs any additional animations or clean up needed during a collection view update
 */
- (void)finalizeCollectionViewUpdates
{
	[_insertedIndexPaths removeAllObjects];
	[_deletedIndexPaths removeAllObjects];
	
	NSLog(@"Finalising collection view updates.");
}

/**
 *	returns the final layout information for an item that is about to be removed from the collection view
 *
 *	@param	itemIndexPath					index path of the item being deleted
 */
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
	NSLog(@"Layout Attributes For Disappearing Items");
	
	if ([_deletedIndexPaths containsObject:itemIndexPath])
	{
		UICollectionViewLayoutAttributes *attributes;
		attributes							= [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
		
		CGRect visibleRect					= (CGRect) {.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
		attributes.center					= CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
		attributes.alpha					= 0.0f;
		attributes.transform3D				= CATransform3DMakeScale(1.3f, 1.3f, 1.0f);
		
		return attributes;
	}
	
	else
		return [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
}

/**
 *	returns the starting layout information for an item being inserted into the collection view
 *
 *	@param	itemIndexPath				index path of the item being inserted
 */
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
	NSLog(@"Layout Attributes For Appearing Items");
	
	if ([_insertedIndexPaths containsObject:itemIndexPath])
	{
		UICollectionViewLayoutAttributes *attributes;
		attributes							= [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
		
		CGRect visibleRect					= (CGRect) {.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
		attributes.center					= CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
		attributes.alpha					= 0.0f;
		attributes.transform3D				= CATransform3DMakeScale(0.6f, 0.6f, 1.0f);
		
		return attributes;
	}
	
	else
		return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
}

/**
 *	prepares the layout object to receive changes to the contents of the collection view
 *
 *	@param	updateItems					array of uicollectionviewupdateitem objects that identify the changes being made
 */
- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
	[super prepareForCollectionViewUpdates:updateItems];
	
	for (UICollectionViewUpdateItem *updateItem in updateItems)
	{
		if (updateItem.updateAction == UICollectionUpdateActionInsert)
			[_insertedIndexPaths addObject:updateItem.indexPathAfterUpdate];
		else if (updateItem.updateAction == UICollectionUpdateActionDelete)
			[_deletedIndexPaths addObject:updateItem.indexPathBeforeUpdate];
	}
	
	NSLog(@"Simple Flow Layout is preparing for colection view updates.");
}

/**
 *	tells the layout object to update the current layout.
 */
- (void)prepareLayout
{
	_deletedIndexPaths	= @[].mutableCopy;
	_insertedIndexPaths	= @[].mutableCopy;
	
	NSLog(@"Simple Flow Layout is preparing the layout.");
}

@end
