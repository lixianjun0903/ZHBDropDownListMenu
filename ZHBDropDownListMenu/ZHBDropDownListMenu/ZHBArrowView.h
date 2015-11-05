//
//  ZHBArrowView.h
//  ZHBDropDownListMenu
//
//  Created by 庄彪 on 15/11/4.
//  Copyright © 2015年 zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  @brief  箭头的样式
 */
typedef NS_ENUM(NSUInteger, ZHBArrowViewStyle){
    /// 线条箭头
    ZHBArrowViewStyleLine,
    /// 实心箭头
    ZHBArrowViewStyleSolid,
    /// 没有箭头
    ZHBArrowViewStyleNone
};

/*!
 *  @brief  箭头方向
 */
typedef NS_ENUM(NSUInteger, ZHBArrowViewDirection){
    ZHBArrowViewDirectionUp,
    ZHBArrowViewDirectionRight,
    ZHBArrowViewDirectionDown,
    ZHBArrowViewDirectionLeft
};



/*!
 *  @brief  箭头view
 */
@interface ZHBArrowView : UIView

/*! @brief  箭头方向 */
@property (nonatomic, assign) ZHBArrowViewDirection direction;
/*! @brief  箭头样式 */
@property (nonatomic, assign) ZHBArrowViewStyle style;
/*! @brief  显示颜色 */
@property (nonatomic, strong) UIColor *color;

- (void)changeArrowDirection:(ZHBArrowViewDirection)direction animated:(BOOL)animated;

@end
