//
//  DropDownMenuItem.h
//  Socket+Graph
//
//  Created by Admin on 16.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DropDownMenuItem : NSObject

@property (nonatomic) NSNumber *itemId;
@property (nonatomic) NSString *name;

- (instancetype)initWithId:(NSNumber *)itemId andName:(NSString *)name;

@end
