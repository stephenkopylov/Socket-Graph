//
//  PlotLine.m
//  Socket+Graph
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "PlotLine.h"

@implementation PlotLine
- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        self.strokeLayer.strokeColor = [UIColor redColor].CGColor;
    }
    
    return self;
}


@end
