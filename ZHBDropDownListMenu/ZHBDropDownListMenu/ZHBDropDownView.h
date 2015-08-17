//
//  ZHBDropDownView.h
//  ZHBDropDownListMenu
//
//  Created by 庄彪 on 15/8/18.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHBDropDownView : UIView

/*! @brief  当前值 */
@property (nonatomic, copy, readonly) NSString *value;

/*! @brief  数据 */
@property (nonatomic, strong) NSArray *stringDatas;

@end
