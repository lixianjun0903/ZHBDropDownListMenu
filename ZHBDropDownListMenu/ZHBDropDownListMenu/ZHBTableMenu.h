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
- (void)tableMenu:(ZHBTableMenu *)tableMenu didSelectTitle:(NSString *)title AtMainRow:(NSInteger)mainRow haveSubTable:(BOOL)haveSub;
- (void)tableMenu:(ZHBTableMenu *)tableMenu didSelectTitle:(NSString *)title SubRow:(NSInteger)subRow ofMainRow:(NSInteger)mainRow;

@end

@interface ZHBTableMenu : UIView

/**
 *  显示的数据模型(里面的模型必须遵守HMDropdownMenuItem协议)
 */
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) id<ZHBTableMenuDelegate> delegate;

- (void)reloadData;
- (void)selectMainTableRow:(NSInteger)mainRow;
- (void)selectSubTableRow:(NSInteger)subRow;

@end
