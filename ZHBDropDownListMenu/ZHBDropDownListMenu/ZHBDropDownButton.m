//
//  ZHBDropDownButton.m
//  ZHBDropDownListMenu
//
//  Created by 庄彪 on 15/8/18.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import "ZHBDropDownButton.h"
#import "ZHBDropdownMenu.h"

@interface ZHBDropdownItem : NSObject<ZHBTableMenuItemProtocal>

@property (nonatomic, strong) NSString *content;

@end

@implementation ZHBDropdownItem

- (NSString *)title {
    return self.content;
}

- (NSArray *)subtitles {
    return nil;
}

@end


@interface ZHBDropDownButton ()<ZHBDropdownMenuDataSource>

@end

@implementation ZHBDropDownButton

+ (instancetype)dropDownViewWithFrame:(CGRect)frame defaultTitle:(NSString *)title {
    ZHBDropDownButton *view = [[self alloc] initWithColumnNum:1 frame:frame];
    view.dataSource = view;
    view.defaultTitle = title;
    return view;
}

+ (instancetype)dropDownViewWithFrame:(CGRect)frame defaultTitle:(NSString *)title stringDatas:(NSArray *)datas {
    ZHBDropDownButton *view = [[self alloc] initWithColumnNum:1 frame:frame];
    view.dataSource = view;
    view.defaultTitle = title;
    view.stringDatas = datas;
    return view;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self reloadData];
}

#pragma mark - Public Methods
- (void)closeAllListMenu {
    for (UIView *view in self.superview.subviews) {
        if ([view isKindOfClass:[ZHBDropdownMenu class]]) {
            [((ZHBDropdownMenu *)view) closeListMenu];
        }
    }
}

#pragma mark - ZHBDropdownMenu DataSource

- (NSArray *)tableMenu:(ZHBTableMenu *)tableMenu itemsListMenuColumn:(NSInteger)index {
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in self.stringDatas) {
        ZHBDropdownItem *item = [[ZHBDropdownItem alloc] init];
        item.content = str;
        [array addObject:item];
    }
    return array;
}

#pragma mark - Getters and Setters

- (void)setDefaultTitle:(NSString *)defaultTitle {
    _defaultTitle = [defaultTitle copy];
    [self setDefaultTitle:_defaultTitle forColumn:0];
}

- (NSString *)value {
    return [self currentTitleAtColumn:0];
}

@end