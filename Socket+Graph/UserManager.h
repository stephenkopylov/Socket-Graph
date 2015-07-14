//
//  UserManager.h
//  Socket+Graph
//
//  Created by Admin on 15.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserManager : NSObject

+ (instancetype)sharedManager;

+ (User *)currentUser;

@property (nonatomic) User *currentUser;

@end
