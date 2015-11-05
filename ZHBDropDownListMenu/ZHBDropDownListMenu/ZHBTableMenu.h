//
//  ZHBTableMenu.h
//  ZHBTableMenu
//
//  Created by 庄彪 on 15/11/5.
//  Copyright © 2015年 zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHBTableMenu;

@protocol ZHBTableMenuItemProtocal <NSObject>

@required

- (NSString *)title;

- (NSArray *)subtitles;

@optional

- (id)identifier;

@end


@protocol ZHBTableMenuDelegate <NSObject>

@optional
- (void)tableMenu:(ZHBTableMenu *)tableMenu didSelectMainRow:(NSInteger)mainRow;
- (void)tableMenu:(ZHBTableMenu *)tableMenu didSelectSubRow:(NSInteger)subRow ofMainRow:(NSInteger)mainRow;

@end

@interface ZHBTableMenu : UIView

/**
 *  显示的数据模型(里面的模型必须遵守HMDropdownMenuItem协议)
 */
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) id<ZHBTableMenuDelegate> delegate;
/*! @brief  当选中主列表没有下级数据或者选中最后一级数据时的操作 */
@property (nonatomic, copy) void (^needRemoveHandle)(NSString *title);
@property (nonatomic, assign, readonly) NSInteger mainSelectRow;
@property (nonatomic, assign, readonly) NSInteger subSelectRow;

- (void)reloadData;
- (void)selectMainTableRow:(NSInteger)mainRow;
- (void)selectSubTableRow:(NSInteger)subRow;
- (void)resetSelectData;

@end
