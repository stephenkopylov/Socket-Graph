//
//  GraphViewController.m
//  Socket+Graph
//
//  Created by Admin on 15.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "GraphViewController.h"
#import "PlotsManager.h"
#import "PlotView.h"

@interface GraphViewController ()<PlotsManagerDelegate>

@end

@implementation GraphViewController {
    PlotView *_plotVIew;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [PlotsManager sharedManager].delegate = self;
    
    _plotVIew = [PlotView new];
    _plotVIew.translatesAutoresizingMaskIntoConstraints = NO;
    _plotVIew.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:_plotVIew];
    
    NSDictionary *views = @{ @"plot": _plotVIew };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[plot]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[plot]|" options:0 metrics:nil views:views]];
}


#pragma mark - PlotsManagerDelegate

- (void)plotsManager:(PlotsManager *)manager didRecievePlot:(NSArray *)points
{
    [_plotVIew drawPlot:points];
}


- (void)plotsManager:(PlotsManager *)manager didRecievePoint:(PlotPoint *)point
{
    [_plotVIew addPoint:point];
}


@end
