//
//  UIView+Shake.m
//  iMoney
//
//  Created by 郭亚娟 on 14-4-8.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import "UIView+Shake.h"

@implementation UIView (Shake)

- (void)shake
{
    CAKeyframeAnimation *animationKey = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animationKey setDuration:0.5f];
    
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      nil];
    [animationKey setValues:array];
    
    NSArray *times = @[@0.1,@0.2,@0.3,@0.4,@0.5,@0.6,@0.7,@0.8,@0.9,@1.0];
    [animationKey setKeyTimes:times];
    
    [self.layer addAnimation:animationKey forKey:@"TextFieldShake"];
}
@end
