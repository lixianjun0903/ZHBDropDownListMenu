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

@end

@implementation ZHBDropDownView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.dataSource = self;
        self.rowHeight = 35;
        self.arrowStyle = ZHBArrowViewStyleSolid;
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

#pragma mark - Public Methods
- (void)closeAllListMenu {
    for (UIView *view in self.superview.subviews) {
        if ([view isKindOfClass:[ZHBDropDownListMenu class]]) {
            [((ZHBDropDownListMenu *)view) closeListMenu];
        }
    }
}

#pragma mark - ZHBDropDownListMenu DataSource
- (NSUInteger)dropDownListMenu:(ZHBDropDownListMenu *)listMenu numberOfRowsInColumn:(NSUInteger)column {
    return self.stringDatas.count;
}

- (NSString *)dropDownListMenu:(ZHBDropDownListMenu *)listMenu titleForRowAtIndexPath:(ZHBIndexPath *)indexPath {
    return self.stringDatas[indexPath.row];
}


#pragma mark - Getters

- (NSString *)value {
    return [self currentTitleAtColumn:0];
}

#pragma mark - Setters
- (void)setStringDatas:(NSArray *)array {
    _stringDatas = array;
    [self reloadData];
}

@end
