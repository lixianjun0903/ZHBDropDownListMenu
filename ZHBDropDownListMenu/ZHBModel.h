//
//  ZHBModel.h
//  ZHBTableMenu
//
//  Created by 庄彪 on 15/11/5.
//  Copyright © 2015年 zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHBTableMenu.h"

@interface ZHBModel : NSObject<ZHBTableMenuItemProtocal>

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray *subChilds;

@end
