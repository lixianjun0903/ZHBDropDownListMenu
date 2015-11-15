//
//  ZHBDropDownView.m
//  ZHBDropDownListMenu
//
//  Created by 庄彪 on 15/8/18.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import "ZHBDropDownView.h"
#import "ZHBDropDownListMenu.h"

@interface ZHBDropDownView ()<ZHBDropDownListMenuDataSource>

/*! @brief  菜单 */
@property (nonatomic, strong) ZHBDropDownListMenu *listMenu;

@end

@implementation ZHBDropDownView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.listMenu];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor);
    CGContextStrokeRectWithWidth(context, rect, 2);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.listMenu.frame = self.bounds;
}

#pragma mark - Public Methods
- (void)close {
    [self.listMenu closeListMenu];
}

#pragma mark - ZHBDropDownListMenu DataSource
- (NSUInteger)dropDownListMenu:(ZHBDropDownListMenu *)listMenu numberOfRowsInColumn:(NSUInteger)column {
    return self.stringDatas.count;
}

- (NSString *)dropDownListMenu:(ZHBDropDownListMenu *)listMenu titleForRowAtIndexPath:(ZHBIndexPath *)indexPath {
    return self.stringDatas[indexPath.row];
}


#pragma mark - Getters

- (ZHBDropDownListMenu *)listMenu {
    if (nil == _listMenu) {
        _listMenu = [[ZHBDropDownListMenu alloc] init];
        _listMenu.dataSource = self;
        _listMenu.rowHeight = 35;
        _listMenu.arrowStyle = ZHBArrowViewStyleLine;
    }
    return _listMenu;
}

- (NSString *)value {
    return [self.listMenu currentTitleAtColumn:0];
}

#pragma mark - Setters
- (void)setStringDatas:(NSArray *)array {
    _stringDatas = array;
    [self.listMenu reloadData];
}

@end
