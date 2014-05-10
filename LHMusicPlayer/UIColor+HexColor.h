//
//  UIColor+HexColor.h
//  iMoney
//
//  Created by 郭亚娟 on 14-2-25.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;
@end
