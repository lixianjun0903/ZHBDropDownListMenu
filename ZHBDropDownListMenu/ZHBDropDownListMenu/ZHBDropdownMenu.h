//
//  ZHBDropdownMenu.h
//  ZHBDropdownMenu
//
//  Created by 庄彪 on 15/8/17.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHBTableMenu.h"

@class ZHBDropdownMenu;

@protocol ZHBDropdownMenuDataSource <NSObject>

- (NSArray *)tableMenu:(ZHBTableMenu *)tableMenu itemsListMenuColumn:(NSInteger)index;

@end


/*!
 *  @brief  菜单列之间的分割符样式
 */
typedef NS_ENUM(NSUInteger, ZHBDropDownMenuSeparatorStyle){
    ZHBDropDownMenuSeparatorStyleNone,
    ZHBDropDownMenuSeparatorStyleSingleLine
};


/*!
 *  @brief  可以自由设置列数的列表菜单
 */
@interface ZHBDropdownMenu : UIView

@property (nonatomic, weak) id<ZHBDropdownMenuDataSource> dataSource;
@property (nonatomic, assign) ZHBDropDownMenuSeparatorStyle separatorStyle;
/*! @brief  显示的菜单 */
@property (nonatomic, strong) ZHBTableMenu *tableMenu;

- (NSString *)currentTitleAtColumn:(NSUInteger)column;

- (instancetype)initWithColumnNum:(NSInteger)columnNum frame:(CGRect)frame;

- (void)setDefaultTitle:(NSString *)title forColumn:(NSUInteger)column;

- (void)closeListMenu;

- (void)reloadData;

@end

