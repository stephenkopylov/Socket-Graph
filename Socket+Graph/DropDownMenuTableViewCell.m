//
//  DropDownMenuTableViewCell.m
//  Socket+Graph
//
//  Created by rovaev on 16.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "DropDownMenuTableViewCell.h"

@implementation DropDownMenuTableViewCell {
    UILabel *_nameLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if ( self ) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont boldSystemFontOfSize:13];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor grayColor];
        [self addSubview:_nameLabel];
        
        NSDictionary *views = @{ @"name": _nameLabel };
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[name]-5-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[name]|" options:0 metrics:nil views:views]];
    }
    
    return self;
}


- (void)setName:(NSString *)name
{
    if ( ![name isEqualToString:_nameLabel.text] ) {
        _name = name;
        _nameLabel.text = name;
    }
}


@end
