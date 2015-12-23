//
//  ViewController.m
//  ZHBDropDownListMenu
//
//  Created by 庄彪 on 15/8/16.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import "ViewController.h"
#import "ZHBDropdownMenu.h"
#import "ZHBDropDownButton.h"
#import "ZHBTestDropDownCell.h"
#import "ZHBModel.h"
#import "ZHBDropDownListMenu/ZHBDropDownButton.h"

@interface ViewController ()<ZHBTableMenuDelegate>

/*! @brief  listMenu */
@property (nonatomic, weak) ZHBDropdownMenu *listMenu;
/*! @brief  listMenu */
@property (nonatomic, weak) ZHBDropdownMenu *listMenu1;
/*! @brief  存储下拉菜单的数据 */
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, weak) ZHBDropDownButton *dropView;

@end

@implementation ViewController

/*
- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZHBTableMenu *tableMenu = [[ZHBTableMenu alloc] initWithFrame:CGRectMake(0, 100, 375, 400)];
    tableMenu.delegate = self;
    tableMenu.multiSelect = YES;
    [self.view addSubview:tableMenu];
    ZHBModel *model0 = [[ZHBModel alloc] init];
    model0.name = @"所属专业";
    
    model0.subChilds = [self subArray];
    ZHBModel *model1 = [[ZHBModel alloc] init];
    model1.name = @"所属团队";
    model1.subChilds = [self subArray];
    ZHBModel *model2 = [[ZHBModel alloc] init];
    model2.name = @"@我的";
    model2.subChilds = [self subArray];
    ZHBModel *model3 = [[ZHBModel alloc] init];
    model3.name = @"我的待办";
    model3.subChilds = [self subArray];
    tableMenu.items =  @[model0, model1, model2, model3];
}

- (NSArray *)subArray {
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger index = 0; index < 10; index ++) {
        ZHBModel *model0 = [[ZHBModel alloc] init];
        model0.name = [NSString stringWithFormat:@"%@--%@", @"所属专业", @(index)];
        [array addObject:model0];
    }
    return array;
}

- (void)tableMenu:(ZHBTableMenu *)tableMenu didSelectTitle:(NSString *)title SubRow:(NSInteger)subRow ofMainRow:(NSInteger)mainRow {
    
}
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    ZHBDropdownMenu *menu = [[ZHBDropdownMenu alloc] initWithColumnNum:3 frame:CGRectMake(10, 100, 300, 44)];
    menu.delegate = self;

    [self.view addSubview:menu];
    self.listMenu = menu;
    [self.listMenu setDefaultTitle:@"列1" forColumn:0];
    [self.listMenu setDefaultTitle:@"列2" forColumn:1];
    [self.listMenu setDefaultTitle:@"列3" forColumn:2];
    
    ZHBDropdownMenu *menu1 = [[ZHBDropdownMenu alloc] initWithColumnNum:3 frame:CGRectMake(50, 160, 300, 44)];
    menu1.delegate = self;
    [self.view addSubview:menu1];
    self.listMenu1 = menu1;
    
    NSArray *array = @[@"标题1", @"标题2", @"标题3", @"标题4", @"标题5"];
    ZHBDropDownButton *view = [ZHBDropDownButton dropDownViewWithFrame:CGRectMake(60, 300, 100, 50) defaultTitle:@"123123"];
    view.stringDatas = array;
    [self.view addSubview:view];
    self.dropView = view;
    
    ZHBDropDownButton *view1 = [ZHBDropDownButton dropDownViewWithFrame:CGRectMake(120, 370, 100, 50) defaultTitle:nil stringDatas:array];
    [self.view addSubview:view1];
}

- (NSArray *)dropdownMenu:(ZHBDropdownMenu *)dropdownMenu itemsListMenuForColumn:(NSInteger)index {
    ZHBModel *model0 = [[ZHBModel alloc] init];
    model0.name = @"所属专业";
    model0.subChilds = @[@"所属专业0", @"所属专业1", @"所属专业2", @"所属专业3", @"所属专业4"];
    ZHBModel *model1 = [[ZHBModel alloc] init];
    model1.name = @"所属团队";
    model1.subChilds = @[@"所属团队0", @"所属团队1", @"所属团队2", @"所属团队3", @"所属团队4", @"所属团队5", @"所属团队6"];
    ZHBModel *model2 = [[ZHBModel alloc] init];
    model2.name = @"@我的";
    model2.subChilds = nil;
    ZHBModel *model3 = [[ZHBModel alloc] init];
    model3.name = @"我的待办";
    model3.subChilds = nil;
    if (0 == index) {
        return @[model0, model1, model2, model3];
    }
    if (1 == index) {
        return @[model0, model3, model2, model1];
    }
    if (2 == index) {
        return @[model2, model3];
    }
    return @[model0, model1, model2, model3];
}


//NSMutableArray *titles = [NSMutableArray array];
//for (NSInteger index = 0; index < 3; index ++) {
//    NSMutableArray *arr = [NSMutableArray array];
//    for (NSInteger number = 0; number < 3 + arc4random() % 50; number ++) {
//        [arr addObject:[NSString stringWithFormat:@"菜单数据%@", @(arc4random() % 10)]];
//    }
//    [titles addObject:arr];
//}
//self.titles = titles;

//NSArray *array = @[@"所属专业", @"所属团队", @"@我的", @"我的待办"];
//NSArray *array2 = @[@"所属专业0", @"所属专业1", @"所属专业2", @"所属专业3", @"所属专业4"];
//NSArray *array3 = @[@"所属团队0", @"所属团队1", @"所属团队2", @"所属团队3", @"所属团队4", @"所属团队5", @"所属团队6"];
//NSArray *ary4 = @[@"支撑工单", @"支撑工单1", @"支撑工单2", @"支撑工单3",];
//NSArray *ary5 = @[@"未解决", @"已解决", @" 全部解决", ];
//NSArray *ary6 = @[@"剩余1天", @"剩余3天", @"剩余6天", @"剩余7天以上"];


@end
