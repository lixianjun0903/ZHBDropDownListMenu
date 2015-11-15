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
/*! @brief  <#Description#> */
@property (nonatomic, strong) ZHBTableMenu *tableMenu;
/*! @brief  <#Description#> */
@property (nonatomic, strong) UIButton *coverBtn;
/*! @brief  <#Description#> */
@property (nonatomic, assign) BOOL showed;
/*! @brief  <#Description#> */
@property (nonatomic, weak) UIView *showInView;
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
        self.separatorStyle = ZHBDropDownMenuSeparatorStyleNone;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 2.f;
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
    self.showed = NO;
    [self removeCurrentView];
}

- (void)reloadData {
    BOOL needShow = self.showed;
    [self closeListMenu];
    if (needShow) {
        [self showListMenu];
    }
}

- (void)setEnableAtColumn:(NSInteger)column enable:(BOOL)enable {
    ZHBColumnView *view = [self columnViewWithTag:column];
    if (view) {
        [view setEnable:enable];
    }
}

- (void)setAllColumnsEnable:(BOOL)enable {
    for (NSInteger column = 0; column < self.columns; column ++) {
        [self setEnableAtColumn:column enable:enable];
    }
}

- (void)selectTitleAtColumn:(NSInteger)column mainRow:(NSInteger)mainRow subRow:(NSInteger)subRow {
    self.currentColumnView = [self columnViewWithTag:column];
    [self saveSelectInfoWithMainRow:mainRow subRow:subRow];
    NSArray *array = [self.delegate dropdownMenu:self itemsListMenuForColumn:column];
    id<ZHBTableMenuItemProtocal> item = array[mainRow];
    NSString *title = [item title];
    if (subRow >= 0) {
        title = [item subtitles][subRow];
    }
    self.currentColumnView.titleLbl.text = title;
}

- (void)setSuperView:(UIView *)superView {
    self.showInView = superView;
}

- (void)setCoverViewColor:(UIColor *)color {
    [self.coverBtn setBackgroundColor:color];
}

#pragma mark - Delegate

- (void)tableMenu:(ZHBTableMenu *)tableMenu didSelectTitle:(NSString *)title AtMainRow:(NSInteger)mainRow haveSubTable:(BOOL)haveSub {
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:didSelectItemAtColumn:mainRow:subRow:)]) {
        [self.delegate dropdownMenu:self didSelectItemAtColumn:self.currentIndex mainRow:mainRow subRow:-1];
    }
    if (!haveSub) {
        self.currentColumnView.titleLbl.text = title;
        [self saveSelectInfoWithMainRow:mainRow subRow:-1];
        [self closeListMenu];
    } else {
        ColumnInfo *info = self.selectColumns[@(self.currentColumnView.tag)];
        if (info) {
            if (mainRow == info.mainRow) {
                [self.tableMenu selectSubTableRow:info.subRow];
            }
        }
    }
}

- (void)tableMenu:(ZHBTableMenu *)tableMenu didSelectTitle:(NSString *)title SubRow:(NSInteger)subRow ofMainRow:(NSInteger)mainRow {
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:didSelectItemAtColumn:mainRow:subRow:)]) {
        [self.delegate dropdownMenu:self didSelectItemAtColumn:self.currentIndex mainRow:mainRow subRow:subRow];
    }
    self.currentColumnView.titleLbl.text = title;
    [self saveSelectInfoWithMainRow:mainRow subRow:subRow];
    [self closeListMenu];
}

#pragma mark - Private Methods

- (void)removeCurrentView {
    [self.coverBtn removeFromSuperview];
    [self.tableMenu removeFromSuperview];
    self.tableMenu = nil;
}

- (void)saveSelectInfoWithMainRow:(NSInteger)mainRow subRow:(NSInteger)subRow {
    ColumnInfo *info = self.selectColumns[@(self.currentIndex)];
    if (!info) {
        info = [ColumnInfo new];
    }
    info.mainRow = mainRow;
    info.subRow  = subRow;
    [self.selectColumns setObject:info forKey:@(self.currentIndex)];
}

- (ZHBColumnView *)columnViewWithTag:(NSInteger)tag {
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[ZHBColumnView class]] && subview.tag == tag) {
            return (ZHBColumnView *)subview;
        }
    }
    return nil;
}

- (void)showListMenu {
    self.showed = YES;
    UIView *view = self.showInView ? self.showInView : self.superview;
    
    CGRect superRect = [view convertRect:self.bounds fromView:self];
    CGFloat tableMenuH = [self.delegate dropdownMenu:self itemsListMenuForColumn:self.currentIndex].count * 44;
    self.tableMenu.frame = CGRectMake(CGRectGetMinX(superRect), CGRectGetMaxY(superRect)-2, CGRectGetWidth(superRect), tableMenuH);
    self.tableMenu.items = [self.delegate dropdownMenu:self itemsListMenuForColumn:self.currentIndex];
    CGFloat coverY = CGRectGetMaxY(self.tableMenu.frame);
    self.coverBtn.frame = CGRectMake(CGRectGetMinX(superRect), coverY, CGRectGetWidth(superRect), CGRectGetHeight(view.frame) - coverY);
    
    [view addSubview:self.tableMenu];
    [view addSubview:self.coverBtn];
    [view bringSubviewToFront:self.coverBtn];
    [view bringSubviewToFront:self.tableMenu];
    [view bringSubviewToFront:self];
    ColumnInfo *info = self.selectColumns[@(self.currentColumnView.tag)];
    if (info) {
        [self.tableMenu selectMainTableRow:info.mainRow];
        [self.tableMenu selectSubTableRow:info.subRow];
    }
}

#pragma mark - Event Response

- (void)didClickCoverButton:(UIButton *)sender {
    [self closeListMenu];
}

- (void)didClickColumnView:(ZHBColumnView *)sender {
    [self removeCurrentView];
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
        _tableMenu.delegate = self;
    }
    return _tableMenu;
}

- (NSMutableDictionary *)selectColumns {
    if (nil == _selectColumns) {
        _selectColumns = [[NSMutableDictionary alloc] init];
    }
    return _selectColumns;
}

- (NSInteger)currentIndex {
    return self.currentColumnView.tag;
}

- (NSString *)currentTitle{
    return self.currentColumnView.titleLbl.text;
}

- (UIButton *)coverBtn {
    if (nil == _coverBtn) {
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coverBtn setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
        [_coverBtn addTarget:self action:@selector(didClickCoverButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverBtn;
}

@end
