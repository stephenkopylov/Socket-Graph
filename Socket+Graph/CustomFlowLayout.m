//
//  CustomFlowLayout
//  Socket+Graph
//
//  Created by Admin on 15.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "CustomFlowLayout.h"



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
                frame = CGRectMake(0, 0, self.collectionView.bounds.size.width, 40);
                break;
            }
                
            case CollectionViewCellsSecond: {
                frame = CGRectMake(0, 40, self.collectionView.bounds.size.width / 100 * 70, self.collectionView.bounds.size.height - 40);
                break;
            }
                
            case CollectionViewCellsThird: {
                frame = CGRectMake(self.collectionView.bounds.size.width / 100 * 70, 40, self.collectionView.bounds.size.width / 100 * 30, self.collectionView.bounds.size.height - 40);
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
                frame = CGRectMake(0, 0, self.collectionView.bounds.size.width, 40);
                break;
            }
                
            case CollectionViewCellsSecond: {
                frame = CGRectMake(0, 40, self.collectionView.bounds.size.width, (self.collectionView.bounds.size.height - 40) / 100 * 60);
                break;
            }
                
            case CollectionViewCellsThird: {
                frame = CGRectMake(0, 40 + (self.collectionView.bounds.size.height - 40) / 100 * 60, self.collectionView.bounds.size.width, (self.collectionView.bounds.size.height - 40) / 100 * 40);
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
