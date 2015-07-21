//
//  BaseLine.h
//  Socket+Graph
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseLine : UIView

@property (nonatomic) NSArray *points;

@property (nonatomic) UIBezierPath *strokePath;

@property (nonatomic)   CAShapeLayer *strokeLayer;

- (void)addPoints:(NSArray *)points withXOffset:(CGFloat *)offset;

- (void)generatePath;

@end
