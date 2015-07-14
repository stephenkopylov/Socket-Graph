//
//  User.m
//  Socket+Graph
//
//  Created by Admin on 15.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithName:(NSString *)name andBalance:(NSNumber *)balance
{
    self = [super init];
    
    if ( self ) {
        _name = name;
        _balance = balance;
    }
    
    return self;
}


@end
