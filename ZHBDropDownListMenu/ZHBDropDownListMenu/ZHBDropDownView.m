//
//  ZHBDropDownView.m
//  ZHBDropDownListMenu
//
//  Created by 庄彪 on 15/8/18.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import "ZHBDropDownView.h"
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


@interface ZHBDropDownView ()<ZHBDropdownMenuDataSource>

@end

@implementation ZHBDropDownView

+ (instancetype)dropDownViewWithFrame:(CGRect)frame {
    ZHBDropDownView *view = [[self alloc] initWithColumnNum:1 frame:frame];
    view.dataSource = view;
    return view;
}

+ (instancetype)dropDownViewWithFrame:(CGRect)frame stringDatas:(NSArray *)datas {
    ZHBDropDownView *view = [[self alloc] initWithColumnNum:1 frame:frame];
    view.dataSource = view;
    view.stringDatas = datas;
    return view;
}

#pragma mark - Public Methods
- (void)close {
    [self closeListMenu];
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


#pragma mark - Getters

- (void)setStringDatas:(NSArray *)stringDatas {
    _stringDatas = stringDatas;
    [self reloadData];
}

- (NSString *)value {
    return [self currentTitleAtColumn:0];
}

@end
