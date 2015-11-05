//
//  ZHBDropDownView.h
//  ZHBDropDownListMenu
//
//  Created by 庄彪 on 15/8/18.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import "ZHBDropDownListMenu.h"

/*!
 *  @brief  一个提供列表数据选择功能的控件
 */
@interface ZHBDropDownView : ZHBDropDownListMenu

/*! @brief  当前值 */
@property (nonatomic, copy, readonly) NSString *value;

/*! @brief  数据,数组应存储字符串格式的内容 */
@property (nonatomic, strong) NSArray *stringDatas;

- (void)closeAllListMenu;

@end
