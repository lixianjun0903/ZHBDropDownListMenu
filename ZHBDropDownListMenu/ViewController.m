//
//  ViewController.m
//  ZHBDropDownListMenu
//
//  Created by 庄彪 on 15/8/16.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import "ViewController.h"
#import "ZHBDropDownListMenu.h"


@interface ViewController ()<ZHBDropDownListMenuDataSource, ZHBDropDownListMenuDelegate>

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
        for (NSInteger number = 0; number < arc4random() % 50; number ++) {
            [arr addObject:[NSString stringWithFormat:@"菜单数据%@", @(arc4random() % 10)]];
        }
        [titles addObject:arr];
    }
    self.titles = titles;
    
    ZHBDropDownListMenu *listMenu = [[ZHBDropDownListMenu alloc] init];
    listMenu.backgroundColor = [UIColor yellowColor];
    listMenu.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 40);
    listMenu.delegate = self;
    listMenu.dataSource = self;
    [listMenu reloadData];
    [self.view addSubview:listMenu];
    self.listMenu = listMenu;
}

- (NSString *)dropDownListMenu:(ZHBDropDownListMenu *)listMenu titleForRowAtIndexPath:(ZHBIndexPath *)indexPath {
    NSArray *title = self.titles[indexPath.column];
    return title[indexPath.row];
}

- (NSUInteger)dropDownListMenu:(ZHBDropDownListMenu *)listMenu numberOfRowsInColumn:(NSUInteger)column {
    NSArray *title = self.titles[column];
    return title.count;
}

- (NSUInteger)numberOfColumnsInDropDownListMenu:(ZHBDropDownListMenu *)listMenu {
    return 3;
}

- (void)dropDownListMenu:(ZHBDropDownListMenu *)listMenu didSelectTitleAtIndexPath:(ZHBIndexPath *)indexPath {
    NSLog(@"%@---%@", @(indexPath.column), @(indexPath.row));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
