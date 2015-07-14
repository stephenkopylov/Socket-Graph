//
//  User.h
//  Socket+Graph
//
//  Created by Admin on 15.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *balance;

- (instancetype)initWithName:(NSString *)name andBalance:(NSNumber *)balance;

@end
