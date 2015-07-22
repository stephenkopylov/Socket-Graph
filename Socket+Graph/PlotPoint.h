//
//  PlotPoint.h
//  Socket+Graph
//
//  Created by Admin on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    PlotPointTypeCommon,
    PlotPointTypeKey
} PlotPointType;

@interface PlotPoint : NSObject

@property (nonatomic) NSNumber *assetId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *value;
@property (nonatomic) NSNumber *time;
@property (nonatomic) CGPoint point;
@property (nonatomic) PlotPointType type;

- (instancetype)initWithServerDictionary:(NSDictionary *)dictionary;

+ (void)parsePoint:(NSDictionary *)point;

+ (NSArray *)parsePoints:(NSArray *)pointsDicts;

@end
