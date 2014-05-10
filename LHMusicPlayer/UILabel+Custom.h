//
//  UILabel+Custom.h
//  TestCode
//
//  Created by Gavin Zeng on 14-2-17.
//  Copyright (c) 2014年 Gavin Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum UITextVerticalAlignment {
    UITextVerticalAlignmentTop,
    UITextVerticalAlignmentMiddle,
    UITextVerticalAlignmentBottom
} UITextVerticalAlignment;
@interface UILabel (Custom)

+(UILabel *)makeLabelWithStr:(NSString *)content
                    fontSize:(CGFloat)fontSize
                   textColor:(UIColor *)color
                   superView:(UIView *)superView;

+(UILabel *)makeNumberLabelWithStr:(NSString *)content
                          fontSize:(CGFloat)fontSize
                         textColor:(UIColor *)color
                         superView:(UIView *)superView;

-(UITextVerticalAlignment)textVerticalAlignment;

-(void)setTextVerticalAlignment:(UITextVerticalAlignment)textVerticalAlignment;

@end
