//
//  ViewController.m
//  ZHBDropDownListMenu
//
//  Created by 庄彪 on 15/8/16.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import "ViewController.h"
#import "ZHBDropDownListMenu.h"
#import "ZHBDropDownView.h"
#import "ZHBTestDropDownCell.h"

@interface ViewController ()<ZHBDropDownListMenuDataSource, ZHBDropDownListMenuDelegate, UITableViewDataSource, UITableViewDelegate>

/*! @brief  listMenu */
@property (nonatomic, weak) ZHBDropDownListMenu *listMenu;

/*! @brief  存储下拉菜单的数据 */
@property (nonatomic, strong) NSArray *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *titles = [NSMutableArray array];
    for (NSInteger index = 0; index < 3; index ++) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger number = 0; number < 3 + arc4random() % 50; number ++) {
            [arr addObject:[NSString stringWithFormat:@"菜单数据%@", @(arc4random() % 10)]];
        }
        [titles addObject:arr];
    }
    self.titles = titles;
    
    ZHBDropDownListMenu *listMenu = [[ZHBDropDownListMenu alloc] init];
    listMenu.backgroundColor = [UIColor yellowColor];
    listMenu.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 40);
    listMenu.listOutBgColor = [UIColor colorWithRed:1.f green:0 blue:0 alpha:0.3];
    listMenu.delegate = self;
    listMenu.dataSource = self;
    listMenu.titleColor = [UIColor blueColor];
    listMenu.arrowColor = [UIColor purpleColor];
    listMenu.separatorStyle = ZHBDropDownListMenuSeparatorStyleSingleLine;
    listMenu.separatorColor = [UIColor redColor];
    [listMenu reloadData];
    [self.view addSubview:listMenu];
    self.listMenu = listMenu;
    
    ZHBDropDownView *view1 = [[ZHBDropDownView alloc] initWithFrame:CGRectMake(100, 200, 100, 40)];
    ZHBDropDownView *view2 = [[ZHBDropDownView alloc] initWithFrame:CGRectMake(100, 260, 100, 40)];
    view1.stringDatas = self.titles[0];
    view2.stringDatas = self.titles[1];
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 320, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 320)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

#pragma mark - ZHBDropDownListMenu DataSource
- (NSString *)dropDownListMenu:(ZHBDropDownListMenu *)listMenu titleForRowAtIndexPath:(ZHBIndexPath *)indexPath {
    NSArray *title = self.titles[indexPath.column];
    return title[indexPath.row];
}

- (NSUInteger)dropDownListMenu:(ZHBDropDownListMenu *)listMenu numberOfRowsInColumn:(NSUInteger)column {
    NSArray *title = self.titles[column];
    return title.count;
}

- (NSUInteger)numberOfColumnsInDropDownListMenu:(ZHBDropDownListMenu *)listMenu {
    return self.titles.count;
}
#pragma mark - ZHBDropDownListMenu Delegate
- (void)dropDownListMenu:(ZHBDropDownListMenu *)listMenu didSelectTitleAtIndexPath:(ZHBIndexPath *)indexPath {
    NSLog(@"%@---%@", @(indexPath.column), @(indexPath.row));
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHBTestDropDownCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ZHBTestDropDownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.titles = self.titles[arc4random()%3];
    }
    return cell;
}

@end
