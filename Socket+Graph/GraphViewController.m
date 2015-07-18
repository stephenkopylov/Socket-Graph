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
    PlotView *_plotView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SMSubscriptionRequested object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [PlotsManager sharedManager].delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subscriptionRequested) name:SMSubscriptionRequested object:nil];
}


#pragma mark - PrivateMethods

- (void)subscriptionRequested
{
    [self addPlotView];
}


- (void)addPlotView
{
    if ( _plotView ) {
        [_plotView removeFromSuperview];
    }
    
    _plotView = [PlotView new];
    _plotView.translatesAutoresizingMaskIntoConstraints = NO;
    _plotView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:_plotView];
    
    NSDictionary *views = @{ @"plot": _plotView };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[plot]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[plot]|" options:0 metrics:nil views:views]];
}


#pragma mark - PlotsManagerDelegate

- (void)plotsManager:(PlotsManager *)manager didRecievePlot:(NSArray *)points
{
    [_plotView drawPlot:points];
}


@end
