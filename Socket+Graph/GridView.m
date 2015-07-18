//
//  GridView.m
//  Socket+Graph
//
//  Created by Admin on 18.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "GridView.h"

#define HORIZONTAL_LINES_COUNT 5

@implementation GridView {
    NSMutableArray *_lines;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        _lines = [NSMutableArray new];
        
        for ( int i = 0; i < HORIZONTAL_LINES_COUNT; i++ ) {
            UIView *line = [UIView new];
            line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
            line.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:line];
            [_lines addObject:line];
        }
        
        [_lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *line = (UIView *)obj;
            
            [line addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:0.5]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[line]|" options:0 metrics:nil views:@{ @"line": line }]];
        }];
        
        
        [self addConstraints:[self constraintsForEvenDistributionOfItems:_lines relativeToCenterOfItem:self vertically:YES]];
    }
    
    return self;
}


- (NSArray *)constraintsForEvenDistributionOfItems:(NSArray *)views
                            relativeToCenterOfItem:(id)toView vertically:(BOOL)vertically
{
    NSMutableArray *constraints = [NSMutableArray new];
    NSLayoutAttribute attr = vertically ? NSLayoutAttributeCenterY : NSLayoutAttributeCenterX;
    
    for ( NSUInteger i = 0; i < [views count]; i++ ) {
        id view = views[i];
        CGFloat multiplier = (2 * i + 2) / (CGFloat)([views count] + 1);
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:attr relatedBy:NSLayoutRelationEqual toItem:toView attribute:attr multiplier:multiplier constant:0];
        [constraints addObject:constraint];
    }
    
    return constraints;
}


@end
