//
//  ZHBColumnView.m
//  ZHBDropDownListMenu
//
//  Created by 庄彪 on 15/11/4.
//  Copyright © 2015年 zhuang. All rights reserved.
//

#import "ZHBColumnView.h"

static NSString * const kSelectedKeyPath = @"selected";

@interface ZHBColumnView ()

/*! @brief  <#Description#> */
@property (nonatomic, strong) UIView *coverView;

@end

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
//    CGFloat selfW = CGRectGetWidth(self.frame);
//    CGFloat selfH = CGRectGetHeight(self.frame);
//    CGFloat arrowW = CGRectGetWidth(self.arrowView.frame);
//    CGFloat titleW = selfW - arrowW - 5;
//    self.titleLbl.frame = CGRectMake(0, 0, titleW, selfH);
//    self.arrowView.frame = CGRectMake(titleW, 0, arrowW, selfH);
    
    CGFloat selfW = CGRectGetWidth(self.frame);
    CGFloat selfH = CGRectGetHeight(self.frame);
    CGFloat arrowW = CGRectGetWidth(self.arrowView.frame);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = self.titleLbl.font;
    CGSize titleSize = [self.titleLbl.text boundingRectWithSize:CGSizeMake(selfW-arrowW, selfH) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    self.titleLbl.frame = CGRectMake(selfW/2-titleSize.width/2-arrowW/2, 0, titleSize.width, selfH);
    self.arrowView.frame = CGRectMake(CGRectGetMaxX(self.titleLbl.frame), 0, arrowW, selfH);
}


- (void)setEnable:(BOOL)enable {
    self.userInteractionEnabled = enable;
    if (enable) {
        [self.coverView removeFromSuperview];
    } else {
        [self addSubview:self.coverView];
        [self bringSubviewToFront:self.coverView];
    }
}

#pragma mark - Event Response

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kSelectedKeyPath]) {
        if (self.selected) {
            [self.arrowView changeArrowDirection:ZHBArrowViewDirectionUp animated:YES];
        } else {
            [self.arrowView changeArrowDirection:ZHBArrowViewDirectionDown animated:YES];
        }
    }
}

#pragma mark - Getters

- (ZHBArrowView *)arrowView {
    if (nil == _arrowView) {
        _arrowView = [[ZHBArrowView alloc] init];
        _arrowView.backgroundColor = [UIColor clearColor];
        _arrowView.userInteractionEnabled = NO;
        [_arrowView changeArrowDirection:ZHBArrowViewDirectionDown animated:NO];
    }
    return _arrowView;
}

- (UILabel *)titleLbl {
    if (nil == _titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
    }
    return _titleLbl;
}

- (UIView *)coverView {
    if (nil == _coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
//        _coverView.dynamic = NO;
        _coverView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
//        _coverView.blurRadius = 80;
    }
    return _coverView;
}

@end
