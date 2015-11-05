//
//  ZHBArrowView.m
//  ZHBDropDownListMenu
//
//  Created by 庄彪 on 15/11/4.
//  Copyright © 2015年 zhuang. All rights reserved.
//

#import "ZHBArrowView.h"

static CGFloat const kDefaultArrowHeight = 4;
static CGFloat const kDefaultArrowWidth = 10;

@implementation ZHBArrowView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.bounds = CGRectMake(0, 0, 15, 10);
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat viewMidY = CGRectGetMidY(rect);
    CGFloat viewMidX = CGRectGetMidX(rect);
    
    CGFloat arrowMinY = viewMidY - kDefaultArrowHeight / 2;
    CGFloat arrowMinX = viewMidX - kDefaultArrowWidth / 2;
    CGFloat arrowMaxY = viewMidY + kDefaultArrowHeight / 2;
    CGFloat arrowMaxX = viewMidX + kDefaultArrowWidth / 2;
    
    CGContextMoveToPoint(context, arrowMinX, arrowMaxY);
    CGContextAddLineToPoint(context, viewMidX, arrowMinY);
    CGContextAddLineToPoint(context, arrowMaxX, arrowMaxY);
    self.color ? [self.color set] : [[UIColor blackColor] set];
    
    switch (self.style) {
        case ZHBArrowViewStyleLine: {
            CGContextSetLineWidth(context, 1.5f);
            CGContextDrawPath(context, kCGPathStroke);
            break;
        }
        case ZHBArrowViewStyleSolid: {
            CGContextDrawPath(context, kCGPathFill);
            break;
        }
        default:
            break;
    }
}

#pragma mark - Public Methods
- (void)changeArrowDirection:(ZHBArrowViewDirection)direction animated:(BOOL)animated {
    self.direction = direction;
    NSTimeInterval duration = animated ? 0.25f : 0.f;
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(self.direction * M_PI_2);
    [UIView animateWithDuration:duration animations:^{
        self.transform = endAngle;
    }];
}

#pragma mark - Setters
- (void)setStyle:(ZHBArrowViewStyle)style {
    _style = style;
    [self setNeedsDisplay];
}

@end

