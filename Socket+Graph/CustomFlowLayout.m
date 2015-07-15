//
//  CustomFlowLayout
//  Socket+Graph
//
//  Created by Admin on 15.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "CustomFlowLayout.h"

#define LANDSCAPE_FIRST_VIEW_HEIGHT           50
#define LANDSCAPE_SECOND_VIEW_WITH_PERCENTAGE 70

#define PORTRAIT_FIRST_VIEW_HEIGHT            50
#define PORTRAIT_SECOND_VIEW_WITH_PERCENTAGE  70

@implementation CustomFlowLayout

- (CGSize)collectionViewContentSize
{
    return self.collectionView.bounds.size;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    for ( int i = 0; i < CollectionViewCellsCount; i++ ) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self layoutAttributesForItemAtIndexPath:indexPath];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    return layoutAttributes;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    
    CGRect frame;
    CollectionViewCells cellNumber = indexPath.row;
    
    if ( IS_LANDSCAPE ) {
        switch ( cellNumber ) {
            case CollectionViewCellsFirst: {
                frame = CGRectMake(0, 0, self.collectionView.bounds.size.width, LANDSCAPE_FIRST_VIEW_HEIGHT);
                break;
            }
                
            case CollectionViewCellsSecond: {
                frame = CGRectMake(0, LANDSCAPE_FIRST_VIEW_HEIGHT, self.collectionView.bounds.size.width / 100 * LANDSCAPE_SECOND_VIEW_WITH_PERCENTAGE, self.collectionView.bounds.size.height - LANDSCAPE_FIRST_VIEW_HEIGHT);
                break;
            }
                
            case CollectionViewCellsThird: {
                frame = CGRectMake(self.collectionView.bounds.size.width / 100 * LANDSCAPE_SECOND_VIEW_WITH_PERCENTAGE, LANDSCAPE_FIRST_VIEW_HEIGHT, self.collectionView.bounds.size.width / 100 * (100 - LANDSCAPE_SECOND_VIEW_WITH_PERCENTAGE), self.collectionView.bounds.size.height - LANDSCAPE_FIRST_VIEW_HEIGHT);
                break;
            }
                
            default: {
                break;
            }
        }
    }
    else {
        switch ( cellNumber ) {
            case CollectionViewCellsFirst: {
                frame = CGRectMake(0, 0, self.collectionView.bounds.size.width, PORTRAIT_FIRST_VIEW_HEIGHT);
                break;
            }
                
            case CollectionViewCellsSecond: {
                frame = CGRectMake(0, PORTRAIT_FIRST_VIEW_HEIGHT, self.collectionView.bounds.size.width, (self.collectionView.bounds.size.height - PORTRAIT_FIRST_VIEW_HEIGHT) / 100 * PORTRAIT_SECOND_VIEW_WITH_PERCENTAGE);
                break;
            }
                
            case CollectionViewCellsThird: {
                frame = CGRectMake(0, PORTRAIT_FIRST_VIEW_HEIGHT + (self.collectionView.bounds.size.height - PORTRAIT_FIRST_VIEW_HEIGHT) / 100 * PORTRAIT_SECOND_VIEW_WITH_PERCENTAGE, self.collectionView.bounds.size.width, (self.collectionView.bounds.size.height - PORTRAIT_FIRST_VIEW_HEIGHT) / 100 * (100 - PORTRAIT_SECOND_VIEW_WITH_PERCENTAGE));
                break;
            }
                
            default: {
                break;
            }
        }
    }
    
    attributes.frame = frame;
    return attributes;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    
    if ( CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    
    return NO;
}


@end
