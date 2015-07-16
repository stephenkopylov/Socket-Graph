//
//  DropDownMenuItem.m
//  Socket+Graph
//
//  Created by Admin on 16.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "DropDownMenuItem.h"

@implementation DropDownMenuItem

- (instancetype)initWithId:(NSNumber *)itemId andName:(NSString *)name
{
    self = [super init];
    
    if ( self ) {
        _itemId = itemId;
        _name = name;
    }
    
    return self;
}

@end
