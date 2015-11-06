//
//  ZHBTableMenu.m
//  ZHBTableMenu
//
//  Created by 庄彪 on 15/11/5.
//  Copyright © 2015年 zhuang. All rights reserved.
//

#import "ZHBTableMenu.h"

@interface ZHBTableMenu ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UITableView *subTableView;
@property (nonatomic, assign) BOOL sigleTable;
@property (nonatomic, assign, readwrite) NSInteger mainSelectRow;
@property (nonatomic, assign, readwrite) NSInteger subSelectRow;

@end

static NSString * const kMainCellReuseIdentifier = @"maincell";
static NSString * const kSubCellReuseIdentifier = @"subcell";

@implementation ZHBTableMenu

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.mainTableView];
        [self addSubview:self.subTableView];
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        [self resetSelectData];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat selfW = self.frame.size.width;
    CGFloat selfH = self.frame.size.height;
    
    NSInteger count = self.sigleTable ? 1 : 2;
    self.mainTableView.frame = CGRectMake(0, 0, selfW/count, selfH);
    self.subTableView.frame = CGRectMake(selfW/count, 0, selfW/count, selfH);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self reloadData];
}

#pragma mark - Public Methods

- (void)resetSelectData {
    self.mainSelectRow = -1;
    self.subSelectRow = -1;
}

- (void)reloadData {
    self.subTableView.hidden = YES;
    [self.mainTableView reloadData];
    [self.subTableView reloadData];
}

- (void)selectMainTableRow:(NSInteger)mainRow {
    if (mainRow < 0) return;
    [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mainRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    self.mainSelectRow = mainRow;
    self.subTableView.hidden = NO;
    [self.subTableView reloadData];
}

- (void)selectSubTableRow:(NSInteger)subRow {
    if (subRow < 0) return;
    self.subTableView.hidden = NO;
    self.subSelectRow = subRow;
    [self.subTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:subRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (NSInteger)currentSelectedMainRow {
    return [self.mainTableView indexPathForSelectedRow].row;
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        return self.items.count;
    } else {
        NSInteger mainRow = [self currentSelectedMainRow];
        id<ZHBTableMenuItemProtocal> item = self.items[mainRow];
        return [item subtitles].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMainCellReuseIdentifier];
        id<ZHBTableMenuItemProtocal> item = self.items[indexPath.row];
        cell.textLabel.text = [item title];
        if ([item subtitles].count > 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            if (indexPath.row == self.mainSelectRow) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSubCellReuseIdentifier];
        NSInteger mainRow = [self currentSelectedMainRow];
        id<ZHBTableMenuItemProtocal> item = self.items[mainRow];
        if (indexPath.row == self.subSelectRow) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = [item subtitles][indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        self.mainSelectRow = indexPath.row;
        id<ZHBTableMenuItemProtocal> item = self.items[indexPath.row];
        if ([item subtitles].count > 0) {
            self.subTableView.hidden = NO;
            [self.subTableView reloadData];
        } else {
            self.subTableView.hidden = YES;
            self.subSelectRow = -1;
            !self.needRemoveHandle ?: self.needRemoveHandle([item title]);
        }
        if ([self.delegate respondsToSelector:@selector(tableMenu:didSelectMainRow:)]) {
            [self.delegate tableMenu:self didSelectMainRow:indexPath.row];
        }
    } else {
        self.subSelectRow = indexPath.row;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        !self.needRemoveHandle ?: self.needRemoveHandle(cell.textLabel.text);
        if ([self.delegate respondsToSelector:@selector(tableMenu:didSelectSubRow:ofMainRow:)]) {
            NSInteger mainRow = [self currentSelectedMainRow];
            [self.delegate tableMenu:self didSelectSubRow:indexPath.row ofMainRow:mainRow];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - Private Methods

- (void)setTableViewAbsoulteLine:(UITableView *)tableview {
    if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableview setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Setters

- (void)setItems:(NSArray *)items {
    _items = items;
    
    self.sigleTable = YES;
    for (id<ZHBTableMenuItemProtocal> item in items) {
        if ([item subtitles] && [item subtitles].count > 0) {
            self.sigleTable = NO;
            break;
        }
    }
    self.subTableView.hidden = self.sigleTable;
    [self setNeedsLayout];
}

#pragma mark - Getters

- (UITableView *)mainTableView {
    if (nil == _mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.tableFooterView = [[UIView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kMainCellReuseIdentifier];
        [self setTableViewAbsoulteLine:_mainTableView];
    }
    return _mainTableView;
}

- (UITableView *)subTableView {
    if (nil == _subTableView) {
        _subTableView = [[UITableView alloc] init];
        _subTableView.tableFooterView = [[UIView alloc] init];
        _subTableView.delegate        = self;
        _subTableView.dataSource      = self;
        [_subTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSubCellReuseIdentifier];
        [self setTableViewAbsoulteLine:_subTableView];
    }
    return _subTableView;
}

@end
