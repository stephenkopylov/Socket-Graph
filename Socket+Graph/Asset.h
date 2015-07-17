//
//  Asset.h
//  Socket+Graph
//
//  Created by Admin on 16.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Realm/Realm.h>

@interface Asset : RLMObject

@property NSInteger assetId;
@property NSString *name;

+ (void)parseNewAssets:(NSDictionary *)assets;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Asset>
RLM_ARRAY_TYPE(Asset)
