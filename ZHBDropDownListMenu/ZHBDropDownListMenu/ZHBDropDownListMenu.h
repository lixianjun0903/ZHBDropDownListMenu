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

/*!
 *  @brief  箭头的样式
 */
typedef NS_ENUM(NSUInteger, ZHBArrowViewStyle){
    /*!
     *  线条箭头
     */
    ZHBArrowViewStyleLine,
    /*!
     *  实心箭头
     */
    ZHBArrowViewStyleSolid,
    /*!
     *  没有箭头
     */
    ZHBArrowViewStyleNone
};

/*!
 *  @brief  菜单列之间的分割符样式
 */
typedef NS_ENUM(NSUInteger, ZHBDropDownListMenuSeparatorStyle){
    /*!
     *  没有分隔符
     */
    ZHBDropDownListMenuSeparatorStyleNone,
    /*!
     *  分隔符为线条
     */
    ZHBDropDownListMenuSeparatorStyleSingleLine
};


/*!
 *  @brief  ZHBDropDownListMenu代理
 */
@protocol ZHBDropDownListMenuDelegate <NSObject>

@optional
/*!
 *  @brief  选中标题的代理事件
 *
 *  @param listMenu  操作的菜单
 *  @param indexPath 选中列和行
 */
- (void)dropDownListMenu:(ZHBDropDownListMenu *)listMenu didSelectTitleAtIndexPath:(ZHBIndexPath *)indexPath;

@end


/*!
 *  @brief  ZHBDropDownListMenu数据源
 */
@protocol ZHBDropDownListMenuDataSource <NSObject>

@required
/*!
 *  @brief  设置ZHBDropDownListMenu的每一列的行数
 *
 *  @param listMenu 要设置的ZHBDropDownListMenu
 *  @param column   要设置的列数
 *
 *  @return 行数
 */
- (NSUInteger)dropDownListMenu:(ZHBDropDownListMenu *)listMenu numberOfRowsInColumn:(NSUInteger)column;
/*!
 *  @brief  设置ZHBDropDownListMenu每一列每一行的标题
 *
 *  @param listMenu  要设置的ZHBDropDownListMenu
 *  @param indexPath 要设置的列和行
 *
 *  @return 标题
 */
- (NSString *)dropDownListMenu:(ZHBDropDownListMenu *)listMenu titleForRowAtIndexPath:(ZHBIndexPath *)indexPath;

@optional
/*!
 *  @brief  设置ZHBDropDownListMenu要显示的列数(默认为1)
 *
 *  @param listMenu 要设置的ZHBDropDownListMenu
 *
 *  @return 列数
 */
- (NSUInteger)numberOfColumnsInDropDownListMenu:(ZHBDropDownListMenu *)listMenu;

@end


/*!
 *  @brief  可以自由设置列数的列表菜单
 */
@interface ZHBDropDownListMenu : UIView

/*! @brief  代理 */
@property (nonatomic, weak) id<ZHBDropDownListMenuDelegate> delegate;
/*! @brief  数据源 */
@property (nonatomic, weak) id<ZHBDropDownListMenuDataSource> dataSource;
/*! @brief  菜单背景图片 */
@property (nonatomic, strong) UIImage *backgroundImage;
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
@property (nonatomic, strong) UIColor *listOutBgColor;
/*! @brief  边框颜色 */
@property (nonatomic, strong) UIColor *boardColor;
/*! @brief  边框颜色 */
@property (nonatomic, assign) CGFloat boardWidth;
/*! @brief  列表行高 */
@property (nonatomic, assign) CGFloat rowHeight;
/*! @brief  箭头样式 */
@property (nonatomic, assign) ZHBArrowViewStyle arrowStyle;
/*! @brief  分隔符样式 */
@property (nonatomic, assign) ZHBDropDownListMenuSeparatorStyle separatorStyle;

/*!
 *  @brief  根据设置菜单的属性刷新
 */
- (void)reloadData;

/*!
 *  @brief  获取指定列的标题
 *
 *  @param column 列数
 *
 *  @return 置顶列的标题
 */
- (NSString *)currentTitleAtColumn:(NSUInteger)column;

@end


/*!
 *  @brief  方便ZHBDropDownListMenu用于定位某列某行
 */
@interface ZHBIndexPath : NSObject

/*! @brief  列 */
@property (nonatomic, assign, readonly) NSUInteger column;
/*! @brief  行 */
@property (nonatomic, assign, readonly) NSUInteger row;

+ (instancetype)indexPathForRow:(NSUInteger)row inColumn:(NSUInteger)column;

@end
