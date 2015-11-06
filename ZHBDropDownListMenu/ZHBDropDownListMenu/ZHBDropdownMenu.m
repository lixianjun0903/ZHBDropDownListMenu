//
//  ZHBDropdownMenu.m
//  ZHBDropdownMenu
//
//  Created by 庄彪 on 15/8/17.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import "ZHBDropdownMenu.h"
#import "ZHBColumnView.h"

@interface ColumnInfo : NSObject

@property (nonatomic, assign) NSInteger mainRow;

@property (nonatomic, assign) NSInteger subRow;

@end

@implementation ColumnInfo

@end


@interface ZHBDropdownMenu ()<ZHBTableMenuDelegate>

/*! @brief  列数 */
@property (nonatomic, assign) NSUInteger columns;
/*! @brief  当前列 */
@property (nonatomic, weak) ZHBColumnView *currentColumnView;
/*! @brief  每一列选中的信息 */
@property (nonatomic, strong) NSMutableDictionary *selectColumns;

@end

@implementation ZHBDropdownMenu

#pragma mark - Life Cycle

- (void)layoutSubviews {
    [super layoutSubviews];
    //根据列数设置frame和分割符的frame
    CGFloat listMenuW = CGRectGetWidth(self.frame);
    CGFloat listMenuH = CGRectGetHeight(self.frame);
    CGFloat subViewW  = listMenuW / self.columns;
    CGFloat subViewX  = 0;
    CGFloat lineViewX = 0;
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[ZHBColumnView class]]) {
            subView.frame  = CGRectMake(subViewX + subView.tag * subViewW, 0, subViewW, listMenuH);
        }
        if ([subView isKindOfClass:[UIView class]] && subView.tag >= 100) {
            subView.frame = CGRectMake(lineViewX + (subView.tag - 100 + 1) * subViewW, listMenuH / 7 * 2, 1.5, listMenuH / 7 * 3);
        }
    }
}

#pragma mark - Public Methods

- (instancetype)initWithColumnNum:(NSInteger)columnNum frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.columns = columnNum;
        self.separatorStyle = ZHBDropDownMenuSeparatorStyleSingleLine;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.f;
        for (NSUInteger index = 0; index < columnNum; index ++) {
            ZHBColumnView *columnView     = [[ZHBColumnView alloc] init];
            columnView.tag                = index;
            [columnView addTarget:self action:@selector(didClickColumnView:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:columnView];
            if (ZHBDropDownMenuSeparatorStyleSingleLine == self.separatorStyle && index != self.columns - 1) {
                UIView *lineView         = [[UIView alloc] init];
                lineView.tag             = index + 100;
                lineView.backgroundColor = [UIColor redColor];
                [self addSubview:lineView];
            }
        }
    }
    return self;
}

- (void)setDefaultTitle:(NSString *)title forColumn:(NSUInteger)column {
    [self columnViewWithTag:column].titleLbl.text = title;
}

- (NSString *)currentTitleAtColumn:(NSUInteger)column {
    return [self columnViewWithTag:column].titleLbl.text;
}

- (void)closeListMenu {
    self.currentColumnView.selected = NO;
    if (self.tableMenu.mainSelectRow >= 0) {
        ColumnInfo *info = [ColumnInfo new];
        info.mainRow     = self.tableMenu.mainSelectRow;
        info.subRow      = self.tableMenu.subSelectRow;
        [self.selectColumns setObject:info forKey:@(self.currentColumnView.tag)];
        [self.tableMenu resetSelectData];
    }
    [self.tableMenu removeFromSuperview];
}

- (void)reloadData {
    [self.tableMenu reloadData];
}

#pragma mark - Private Methods
- (ZHBColumnView *)columnViewWithTag:(NSInteger)tag {
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[ZHBColumnView class]] && subview.tag == tag) {
            return (ZHBColumnView *)subview;
        }
    }
    return nil;
}

- (void)showListMenu {
    CGRect superRect = [self.superview convertRect:self.bounds fromView:self];
    self.tableMenu.frame = CGRectMake(CGRectGetMinX(superRect), CGRectGetMaxY(superRect)-1, CGRectGetWidth(superRect), 220);
    self.tableMenu.items = [self.dataSource tableMenu:self.tableMenu itemsListMenuColumn:self.currentColumnView.tag];
    [self.superview addSubview:self.tableMenu];
    [self.superview bringSubviewToFront:self.tableMenu];
    [self.superview bringSubviewToFront:self];
    ColumnInfo *info = self.selectColumns[@(self.currentColumnView.tag)];
    if (info) {
        [self.tableMenu selectMainTableRow:info.mainRow];
        [self.tableMenu selectSubTableRow:info.subRow];
    }
}

#pragma mark - Event Response

- (void)didClickColumnView:(ZHBColumnView *)sender {
    [self.tableMenu removeFromSuperview];
    if (sender != self.currentColumnView) {
        self.currentColumnView.selected = NO;
        sender.selected                 = YES;
        self.currentColumnView          = sender;
    } else {
        sender.selected = !sender.selected;
    }
    
    if (sender.isSelected) {//打开菜单列表
        [self showListMenu];
    } else {//关闭菜单列表
        [self closeListMenu];
    }
}

#pragma mark - Getters

- (ZHBTableMenu *)tableMenu {
    if (nil == _tableMenu) {
        _tableMenu = [[ZHBTableMenu alloc] init];
        __weak typeof(self) weakSelf = self;
        _tableMenu.needRemoveHandle = ^ (NSString *title){
            weakSelf.currentColumnView.titleLbl.text = title;
            [weakSelf closeListMenu];
        };
    }
    return _tableMenu;
}

- (NSMutableDictionary *)selectColumns {
    if (nil == _selectColumns) {
        _selectColumns = [[NSMutableDictionary alloc] init];
    }
    return _selectColumns;
}

@end
