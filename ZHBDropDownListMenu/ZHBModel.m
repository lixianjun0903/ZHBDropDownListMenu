//
//  ZHBModel.m
//  ZHBTableMenu
//
//  Created by 庄彪 on 15/11/5.
//  Copyright © 2015年 zhuang. All rights reserved.
//

#import "ZHBModel.h"

@implementation ZHBModel

- (NSString *)title {
    return self.name;
}

- (NSArray *)subtitles {
    return self.subChilds;
}

- (BOOL)selected {
    return self.check;
}

- (void)setSelected:(BOOL)selected {
    self.check = selected;
}

@end
