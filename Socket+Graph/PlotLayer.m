//
//  PlotLayer.m
//  Socket+Graph
//
//  Created by rovaev on 22.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "PlotLayer.h"

@implementation PlotLayer

@dynamic animProgress;

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ( [@"animProgress" isEqualToString:key] ) {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}


- (void)setAnimatedPath:(UIBezierPath *)animatedPath
{
    if ( _animatedPath ) {
        _oldAnimatedPath = _animatedPath;
    }
    
    _animatedPath = animatedPath;
    self.animProgress = 0;
    self.animProgress = 1;
}


- (void)display
{
    NSLog(@"oldPath: %f", [[self presentationLayer] animProgress]);
    
   // NSLog(@"animatedPath: %@", self.animatedPath);
    
    self.path = _animatedPath.CGPath;
}


- (id<CAAction>)actionForKey:(NSString *)key
{
    if ( [key isEqualToString:@"animProgress"] ) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
            animation.duration = 0.2;
            animation.beginTime = 0;
            animation.fromValue = @0;
            animation.toValue = @1;
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = YES;
            
            return animation;
    }
    
    return [super actionForKey:key];
}


@end
