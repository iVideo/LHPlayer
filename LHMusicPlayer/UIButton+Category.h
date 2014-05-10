//
//  UIButton+Category.h
//  iMoney
//
//  Created by 郭亚娟 on 14-2-27.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(UIButton* btn);
@interface UIButton (Category)

@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;//增加UIButton的点击区域

- (void)addAction:(ButtonBlock)block;
- (void)addAction:(ButtonBlock)block forControlEvents:(UIControlEvents)controlEvents;
@end
