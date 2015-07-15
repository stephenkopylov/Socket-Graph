//
//  MainViewController
//  Socket+Graph
//
//  Created by Admin on 14.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "MainViewController.h"
#import "CustomFlowLayout.h"
#import "RatesViewController.h"

NSString *const cellIdentified = @"cellIdentified";

@interface MainViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@end



@implementation MainViewController {
    UICollectionView *_collectionView;
    UIView *_firstView;
    UIView *_seconView;
    RatesViewController *_ratesViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CustomFlowLayout *flowLayout = [CustomFlowLayout new];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentified];
    
    [self.view addSubview:_collectionView];
    
    NSDictionary *views = @{ @"collectionView": _collectionView };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[collectionView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:views]];
    
    _firstView = [UIView new];
    _firstView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _seconView = [UIView new];
    _seconView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _ratesViewController = [RatesViewController new];
    _ratesViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:_ratesViewController];
    [_ratesViewController didMoveToParentViewController:self];
}


#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return CollectionViewCellsCount;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentified forIndexPath:indexPath];
    
    CollectionViewCells number = indexPath.row;
    
    UIView *view;
    
    switch ( number ) {
        case CollectionViewCellsFirst: {
            if ( !cell.contentView.subviews.count ) {
                view = _firstView;
            }
            
            break;
        }
            
        case CollectionViewCellsSecond: {
            if ( !cell.contentView.subviews.count ) {
                view = _seconView;
            }
            
            break;
        }
            
        case CollectionViewCellsThird: {
            if ( !cell.contentView.subviews.count ) {
                view = _ratesViewController.view;
            }
            
            break;
        }
            
        default: {
            break;
        }
    }
    
    if ( view ) {
        [cell.contentView addSubview:view];
        
        NSDictionary *views = @{ @"view": view };
        
        NSMutableArray *constraints = [NSMutableArray new];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];
        
        [cell addConstraints:constraints.copy];
    }
    
    return cell;
}


- (NSArray *)setConstraintsPrioriry:(NSArray *)constraints
{
    for ( NSLayoutConstraint *constraint in constraints ) {
        constraint.priority = UILayoutPriorityRequired - 1;
    }
    
    return constraints;
}


@end
