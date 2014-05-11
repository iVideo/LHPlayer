//
//  UIView+Shadow.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-4.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "UIView+Shadow.h"

@implementation UIView (Shadow)

- (void)drawRoundCornerAndShadow {
    CGRect bounds = self.bounds;
    bounds.size.height +=10;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    [self.layer addSublayer:maskLayer];
    self.layer.mask = maskLayer;
    self.layer.shadowOffset = CGSizeMake(3, 3);
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

@end
