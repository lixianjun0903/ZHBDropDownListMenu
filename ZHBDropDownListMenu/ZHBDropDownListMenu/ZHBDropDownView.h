//
//  ZHBDropDownView.h
//  ZHBDropDownListMenu
//
//  Created by 庄彪 on 15/8/18.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import "ZHBDropdownMenu.h"

/*!
 *  @brief  一个提供列表数据选择功能的控件
 */
@interface ZHBDropDownView : ZHBDropdownMenu

/*! @brief  当前值 */
@property (nonatomic, copy, readonly) NSString *value;
/*! @brief  数据,数组应存储字符串格式的内容 */
@property (nonatomic, strong) NSArray *stringDatas;
/*! @brief  <#Description#> */
@property (nonatomic, copy) NSString *defaultTitle;


+ (instancetype)dropDownViewWithFrame:(CGRect)frame defaultTitle:(NSString *)title;

+ (instancetype)dropDownViewWithFrame:(CGRect)frame defaultTitle:(NSString *)title stringDatas:(NSArray *)datas;

- (void)close;

@end
