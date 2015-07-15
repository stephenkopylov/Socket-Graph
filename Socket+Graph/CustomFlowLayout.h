//
//  CustomFlowLayout
//  Socket+Graph
//
//  Created by Admin on 15.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//


#import <UIKit/UIKit.h>

#define IS_LANDSCAPE UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
#define IS_PORTRAIT UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)

typedef NS_ENUM (NSUInteger, CollectionViewCells) {
    CollectionViewCellsFirst,
    CollectionViewCellsSecond,
    CollectionViewCellsThird,
    CollectionViewCellsCount
};

@interface CustomFlowLayout : UICollectionViewFlowLayout

@end
