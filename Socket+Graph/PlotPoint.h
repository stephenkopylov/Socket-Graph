//
//  PlotPoint.h
//  Socket+Graph
//
//  Created by Admin on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlotPoint : NSObject

@property (nonatomic) NSNumber *assetId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *value;

+ (void)parsePoint:(NSDictionary *)point;

@end