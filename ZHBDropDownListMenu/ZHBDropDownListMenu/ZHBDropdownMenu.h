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

@protocol ZHBDropdownMenuDelegate <NSObject>

@required
- (NSArray *)dropdownMenu:(ZHBDropdownMenu *)dropdownMenu itemsListMenuForColumn:(NSInteger)index;

@optional
- (void)dropdownMenu:(ZHBDropdownMenu *)dropdownMenu didSelectItemAtColumn:(NSInteger)column mainRow:(NSInteger)mainRow subRow:(NSInteger)subRow;

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

@property (nonatomic, weak) id<ZHBDropdownMenuDelegate> delegate;
@property (nonatomic, assign) ZHBDropDownMenuSeparatorStyle separatorStyle;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, copy, readonly) NSString *currentTitle;

- (void)setSuperView:(UIView *)superView;

- (NSString *)currentTitleAtColumn:(NSUInteger)column;

- (instancetype)initWithColumnNum:(NSInteger)columnNum frame:(CGRect)frame;

- (void)setDefaultTitle:(NSString *)title forColumn:(NSUInteger)column;

- (void)selectTitleAtColumn:(NSInteger)column mainRow:(NSInteger)mainRow subRow:(NSInteger)subRow;

- (void)setEnableAtColumn:(NSInteger)column enable:(BOOL)enable;

- (void)setAllColumnsEnable:(BOOL)enable;

- (void)closeListMenu;

- (void)reloadData;

- (void)setCoverViewColor:(UIColor *)color;

@end

