//
//  UILabel+Custom.h
//  TestCode
//
//  Created by 郭亚娟 on 14-2-17.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
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
