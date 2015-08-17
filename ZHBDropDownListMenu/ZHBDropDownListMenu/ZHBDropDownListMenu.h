//
//  ZHBDropDownListMenu.h
//  ZHBDropDownListMenu
//
//  Created by 庄彪 on 15/8/17.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHBDropDownListMenu;
@class ZHBIndexPath;

typedef NS_ENUM(NSUInteger, ZHBDropDownListMenuSeparatorStyle) {
    ZHBDropDownListMenuSeparatorStyleNone,
    ZHBDropDownListMenuSeparatorStyleSingleLine,
    ZHBDropDownListMenuSeparatorStyleCustom
};

@protocol ZHBDropDownListMenuDelegate <NSObject>

@optional
- (void)dropDownListMenu:(ZHBDropDownListMenu *)listMenu didSelectTitleAtIndexPath:(ZHBIndexPath *)indexPath;

@end


@protocol ZHBDropDownListMenuDataSource <NSObject>

@required
- (NSUInteger)dropDownListMenu:(ZHBDropDownListMenu *)listMenu numberOfRowsInColumn:(NSUInteger)column;

- (NSString *)dropDownListMenu:(ZHBDropDownListMenu *)listMenu titleForRowAtIndexPath:(ZHBIndexPath *)indexPath;

@optional
- (NSUInteger)numberOfColumnsInDropDownListMenu:(ZHBDropDownListMenu *)listMenu;

@end


@interface ZHBDropDownListMenu : UIView

/*! @brief  代理 */
@property (nonatomic, weak) id<ZHBDropDownListMenuDelegate> delegate;
/*! @brief  数据源 */
@property (nonatomic, weak) id<ZHBDropDownListMenuDataSource> dataSource;
/*! @brief  标题字体  */
@property (nonatomic, strong) UIFont *titleFont;
/*! @brief  列表字体  */
@property (nonatomic, strong) UIFont *subTitleFont;
/*! @brief  列表字体颜色 */
@property (nonatomic, strong) UIColor *subTitleColor;
/*! @brief  列表字体选中颜色  */
@property (nonatomic, strong) UIColor *subTitleSelectColor;
/*! @brief  标题颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/*! @brief  箭头颜色  */
@property (nonatomic, strong) UIColor *arrowColor;
/*! @brief  分隔符颜色 */
@property (nonatomic, strong) UIColor *separatorColor;
/*! @brief  菜单外部背景颜色 */
@property (nonatomic, strong) UIColor *bgColor;
/*! @brief  分隔符样式 */
@property (nonatomic, assign) ZHBDropDownListMenuSeparatorStyle separatorStyle;

- (void)reloadData;

@end


@interface ZHBIndexPath : NSObject

/*! @brief  列 */
@property (nonatomic, assign, readonly) NSUInteger column;
/*! @brief  行 */
@property (nonatomic, assign, readonly) NSUInteger row;

+ (instancetype)indexPathForRow:(NSUInteger)row inColumn:(NSUInteger)column;

@end
