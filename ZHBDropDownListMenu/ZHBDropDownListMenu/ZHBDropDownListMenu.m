//
//  ZHBDropDownListMenu.m
//  ZHBDropDownListMenu
//
//  Created by 庄彪 on 15/8/17.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import "ZHBDropDownListMenu.h"

#pragma mark - ZHBArrowView

typedef NS_ENUM(NSUInteger, ZHBArrowViewDirection) {
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
/*! @brief  显示颜色 */
@property (nonatomic, strong) UIColor *color;

@end

static CGFloat const kDefaultArrowHeight = 10;
static CGFloat const kDefaultArrowWidth = 15;

@implementation ZHBArrowView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat buttonMidY = CGRectGetMidY(rect);
    CGFloat buttonMidX = CGRectGetMidX(rect);
    
    CGFloat arrowMinY = buttonMidY - kDefaultArrowHeight / 2;
    CGFloat arrowMinX = buttonMidX - kDefaultArrowWidth / 2;
    CGFloat arrowMaxY = buttonMidY + kDefaultArrowHeight / 2;
    CGFloat arrowMaxX = buttonMidX + kDefaultArrowWidth / 2;
    
    CGContextMoveToPoint(context, buttonMidX, arrowMinY);
    CGContextAddLineToPoint(context, arrowMinX, arrowMaxY);
    CGContextAddLineToPoint(context, arrowMaxX, arrowMaxY);
    if (self.color) {
        [self.color set];
    } else {
        [[UIColor blackColor] set];
    }
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)changeDirection {
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(self.direction * 90 * (M_PI / 180.0f));
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = endAngle;
    }];
}

- (void)setDirection:(ZHBArrowViewDirection)direction {
    _direction = direction;
    [self changeDirection];
}

@end


#pragma mark - ZHBColumnView
/*!
 *  @brief  列表头View
 */
@interface ZHBColumnView : UIControl

/*! @brief  箭头 */
@property (nonatomic, strong) ZHBArrowView *arrowView;
/*! @brief  标题 */
@property (nonatomic, strong) UILabel *titleLbl;

@end

static NSString * const kSelectedKeyPath = @"selected";

@implementation ZHBColumnView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLbl];
        [self addSubview:self.arrowView];
        [self addObserver:self forKeyPath:kSelectedKeyPath options:0 context:nil];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:kSelectedKeyPath];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat selfW = CGRectGetWidth(self.frame);
    CGFloat selfH = CGRectGetHeight(self.frame);
    CGFloat titleW = selfW / 3 * 2;
    self.titleLbl.frame = CGRectMake(0, 0, titleW, selfH);
    CGFloat arrowW = selfW / 3;
    self.arrowView.frame = CGRectMake(titleW, 0, arrowW, selfH);
}

#pragma mark - Event Response

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kSelectedKeyPath]) {
        if (self.selected) {
            self.arrowView.direction = ZHBArrowViewDirectionDown;
        } else {
            self.arrowView.direction = ZHBArrowViewDirectionUp;
        }
    }
}

#pragma mark - Getters

- (ZHBArrowView *)arrowView {
    if (nil == _arrowView) {
        _arrowView = [[ZHBArrowView alloc] init];
        _arrowView.backgroundColor = [UIColor clearColor];
        _arrowView.userInteractionEnabled = NO;
    }
    return _arrowView;
}

- (UILabel *)titleLbl {
    if (nil == _titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}

@end

#pragma mark - ZHBDropDownListMenu

#define DEFAULT_TITLE_FONT              [UIFont systemFontOfSize:14]
#define DEFAULT_SUBTITLE_FONT           [UIFont systemFontOfSize:14]
#define DEFAULT_SUBTITLE_NORMAL_COLOR   [UIColor blackColor]
#define DEFAULT_SUBTITLE_SELECT_COLOR   [UIColor redColor]
#define DEFAULT_TITLE_COLOR             [UIColor blackColor]
#define DEFAULT_ARROW_COLOR             [UIColor blackColor]
#define DEFAULT_SEPARATOR_COLOR         [UIColor grayColor]
#define DEFAULT_BG_COLOR                [UIColor clearColor]
#define DEFAULT_BOARD_COLOR             [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1]

@interface ZHBDropDownListMenu ()<UITableViewDataSource, UITableViewDelegate>

/*! @brief  列数 */
@property (nonatomic, assign) NSUInteger columns;
/*! @brief  当前列 */
@property (nonatomic, weak) ZHBColumnView *currentColumnView;
/*! @brief  当前选中的数据 */
@property (nonatomic, strong) NSMutableDictionary *currentIndexPathDict;
/*! @brief  展开的菜单 */
@property (nonatomic, weak) UIView *listView;
/*! @brief  背景 */
@property (nonatomic, weak) UIImageView *bgImageView;

@end

static NSUInteger const kDefaultColumnCount = 1;
static CGFloat const kDefaultBoardWidth = 2.f;

@implementation ZHBDropDownListMenu

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.boardWidth          = kDefaultBoardWidth;
        self.titleFont           = DEFAULT_TITLE_FONT;
        self.titleColor          = DEFAULT_TITLE_COLOR;
        self.arrowColor          = DEFAULT_ARROW_COLOR;
        self.separatorColor      = DEFAULT_SEPARATOR_COLOR;
        self.subTitleFont        = DEFAULT_SUBTITLE_FONT;
        self.subTitleColor       = DEFAULT_SUBTITLE_NORMAL_COLOR;
        self.subTitleSelectColor = DEFAULT_SUBTITLE_SELECT_COLOR;
        self.listOutBgColor      = DEFAULT_BG_COLOR;
        self.boardColor          = DEFAULT_BOARD_COLOR;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgImageView.frame = self.bounds;
    
    //根据列数设置frame
    CGFloat listMenuW = CGRectGetWidth(self.frame);
    CGFloat listMenuH = CGRectGetHeight(self.frame);
    CGFloat subViewW = listMenuW / self.columns;
    CGFloat subViewX = 0;
    CGFloat lineViewX = 0;
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[ZHBColumnView class]]) {
            NSUInteger tag = subView.tag;
            subView.frame = CGRectMake(subViewX + tag * subViewW, 0, subViewW, listMenuH);
        }
        if ([subView isKindOfClass:[UIView class]] && subView.tag >= 100) {
            subView.frame = CGRectMake(lineViewX + (subView.tag - 100 + 1) * subViewW - 3, listMenuH / 7 * 2, 1.5, listMenuH / 7 * 3);
        }
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!self.backgroundImage) {
        if (!self.backgroundColor) {
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        } else {
            CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
        }
    }
    
    CGContextFillRect(context, rect);
    CGContextSetStrokeColorWithColor(context, self.boardColor.CGColor);
    CGContextStrokeRectWithWidth(context, rect, 3);
}

#pragma mark - Public Methods

- (void)reloadData {
    while (self.subviews.count) {
        [[self.subviews firstObject] removeFromSuperview];
    }
    if (self.backgroundImage) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = self.backgroundImage;
        [self addSubview:imageView];
        self.bgImageView = imageView;
    }
    
    for (NSUInteger index = 0; index < self.columns; index ++) {
        ZHBColumnView *columnView     = [[ZHBColumnView alloc] init];
        columnView.tag                = index;
        columnView.titleLbl.font      = self.titleFont;
        columnView.titleLbl.textColor = self.titleColor;
        columnView.arrowView.color    = self.arrowColor;
        ZHBIndexPath *indexPath       = [ZHBIndexPath indexPathForRow:0 inColumn:index];
        columnView.titleLbl.text      = [self.dataSource dropDownListMenu:self titleForRowAtIndexPath:indexPath];
        [self.currentIndexPathDict setObject:indexPath forKey:@(index)];
        [columnView addTarget:self action:@selector(didClickColumnView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:columnView];
        if (ZHBDropDownListMenuSeparatorStyleSingleLine == self.separatorStyle && index != self.columns - 1) {
            UIView *lineView = [[UIView alloc] init];
            lineView.tag = index + 100;
            lineView.backgroundColor = self.separatorColor;
            [self addSubview:lineView];
        }
    }
    [self setNeedsDisplay];
}

- (NSString *)currentTitleAtColumn:(NSUInteger)column {
    ZHBIndexPath *currentIndex = [self.currentIndexPathDict objectForKey:@(column)];
    return [self.dataSource dropDownListMenu:self titleForRowAtIndexPath:currentIndex];
}

#pragma mark - Private Methods

/*!
 *  @brief  添加list菜单
 */
- (void)showListMenu {
    if (self.listView) {
        [self.listView removeFromSuperview];
    }
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    UIView *contentView = [[UIView alloc] initWithFrame:window.bounds];
    //设置listView
    CGFloat defaultListViewHeight = 200.f;
    NSUInteger rows = [self.dataSource dropDownListMenu:self numberOfRowsInColumn:self.currentColumnView.tag];
    CGFloat rowHeight = 40.f;
    
    UITableView *listView = [[UITableView alloc] init];
    listView.layer.borderWidth = 2;
    listView.layer.borderColor = self.boardColor.CGColor;
    listView.backgroundColor = [UIColor whiteColor];
    listView.delegate = self;
    listView.dataSource = self;
    listView.rowHeight = rowHeight;
    listView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    listView.showsHorizontalScrollIndicator = NO;
    listView.showsVerticalScrollIndicator = NO;
    
    CGPoint point = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame));
    point = [window convertPoint:point fromView:self.superview];
    CGFloat listViewH = rows * rowHeight < defaultListViewHeight ? rows * rowHeight : defaultListViewHeight;
    CGFloat listViewY = point.y + listViewH > CGRectGetHeight(window.frame) ? point.y - CGRectGetHeight(self.frame) - listViewH : point.y;
    
    listView.frame = CGRectMake(point.x, listViewY, CGRectGetWidth(self.frame), listViewH);
    
    if ([listView respondsToSelector:@selector(setSeparatorInset:)]) {
        [listView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([listView respondsToSelector:@selector(setLayoutMargins:)]) {
        [listView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    //设置外部view
    UIView *tapView = [[UIView alloc] initWithFrame:window.bounds];
    tapView.backgroundColor = self.listOutBgColor;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeListMenu)];
    [tapView addGestureRecognizer:tapGesture];
    
    [contentView addSubview:tapView];
    [contentView addSubview:listView];
    [window addSubview:contentView];
    self.listView = contentView;
}

/*!
 *  @brief  移除list菜单
 */
- (void)closeListMenu {
    self.currentColumnView.selected = NO;
    [self.listView removeFromSuperview];
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = self.subTitleSelectColor;
    self.currentColumnView.titleLbl.text = cell.textLabel.text;
    ZHBIndexPath *currentIndexPath = [ZHBIndexPath indexPathForRow:indexPath.row inColumn:self.currentColumnView.tag];
    [self.currentIndexPathDict setObject:currentIndexPath forKey:@(self.currentColumnView.tag)];
    [self closeListMenu];
    if ([self.delegate respondsToSelector:@selector(dropDownListMenu:didSelectTitleAtIndexPath:)]) {
        ZHBIndexPath *listIndexPath = [ZHBIndexPath indexPathForRow:indexPath.row inColumn:self.currentColumnView.tag];
        [self.delegate dropDownListMenu:self didSelectTitleAtIndexPath:listIndexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource dropDownListMenu:self numberOfRowsInColumn:self.currentColumnView.tag];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.textLabel.font = self.subTitleFont;
        cell.textLabel.textColor = self.subTitleColor;
    }
    ZHBIndexPath *lastIndexPath = (ZHBIndexPath *)[self.currentIndexPathDict objectForKey:@(self.currentColumnView.tag)];
    ZHBIndexPath *listIndexPath = [ZHBIndexPath indexPathForRow:indexPath.row inColumn:self.currentColumnView.tag];
    if ([lastIndexPath isEqual:listIndexPath]) {
        cell.textLabel.textColor = self.subTitleSelectColor;
    } else {
        cell.textLabel.textColor = self.subTitleColor;
    }
    cell.textLabel.text = [self.dataSource dropDownListMenu:self titleForRowAtIndexPath:listIndexPath];
    return cell;
}

#pragma mark - Event Response

- (void)didClickColumnView:(ZHBColumnView *)sender {
    if (sender != self.currentColumnView) {
        self.currentColumnView.selected = NO;
        sender.selected = YES;
        self.currentColumnView = sender;
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

- (NSUInteger)columns {
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInDropDownListMenu:)]) {
        return [self.dataSource numberOfColumnsInDropDownListMenu:self];
    }
    return kDefaultColumnCount;
}

- (NSMutableDictionary *)currentIndexPathDict {
    if (nil == _currentIndexPathDict) {
        _currentIndexPathDict = [[NSMutableDictionary alloc] init];
    }
    return _currentIndexPathDict;
}

#pragma mark Setters

- (void)setDataSource:(id<ZHBDropDownListMenuDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

@end

#pragma mark - ZHBIndexPath
@interface ZHBIndexPath ()

/*! @brief  列 */
@property (nonatomic, assign, readwrite) NSUInteger column;
/*! @brief  行 */
@property (nonatomic, assign, readwrite) NSUInteger row;

@end

@implementation ZHBIndexPath

- (BOOL)isEqual:(ZHBIndexPath *)object {
    return self.column == object.column && self.row == object.row;
}

- (instancetype)initWithRow:(NSUInteger)row inColumn:(NSUInteger)column {
    if (self = [super init]) {
        self.row = row;
        self.column = column;
    }
    return self;
}

+ (instancetype)indexPathForRow:(NSUInteger)row inColumn:(NSUInteger)column {
    return [[self alloc] initWithRow:row inColumn:column];
}

@end