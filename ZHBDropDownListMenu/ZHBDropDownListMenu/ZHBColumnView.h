//
//  ZHBColumnView.h
//  ZHBDropDownListMenu
//
//  Created by 庄彪 on 15/11/4.
//  Copyright © 2015年 zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHBArrowView.h"

/*!
 *  @brief  ZHBDropDownListMenu的列控件
 */
@interface ZHBColumnView : UIControl

/*! @brief  箭头 */
@property (nonatomic, strong) ZHBArrowView *arrowView;
/*! @brief  标题 */
@property (nonatomic, strong) UILabel *titleLbl;

- (void)setEnable:(BOOL)enable;

@end
