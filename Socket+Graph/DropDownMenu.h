//
//  DropDownMenu.h
//  Socket+Graph
//
//  Created by Admin on 16.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownMenuItem.h"

@class DropDownMenu;

@protocol DropDownMenuDelegate <NSObject>

- (void)dropDownMenu:(DropDownMenu *)dropDownMenu didSeletItem:(DropDownMenuItem *)item;

@end

@interface DropDownMenu : UIView

@property (nonatomic) NSArray *items;
@property (nonatomic) DropDownMenuItem *selectedItem;
@property (nonatomic, weak) id <DropDownMenuDelegate> delegate;

@end
