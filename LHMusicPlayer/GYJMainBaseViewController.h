//
//  LHMainBaseViewController.h
//  LHAD
//
//  Created by 郭亚娟 on 14-4-29.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYJMainBaseViewController : UIViewController{
    UIImageView *_customNaviBarShadow;
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
    UIView *_rightButton;
    UIView *_subRightButton; // secondary right navi button, the button which is not at the typical location
    UIView *_leftButton;
    
    CGFloat _statusBarHeight;
    UILabel *_tipLabel;
    BOOL _haveNaviBar;
}

@property (nonatomic, strong)UIImageView *customNaviBar;
@property (nonatomic, strong)UILabel *naviTitleLabel;

// 可以创建没有naviBar的实例
- (id)initWithCustomNaviBar:(BOOL)haveNaviBar;

- (void)addRightButtonWithImage:(UIImage*)image target:(id)target action:(SEL)selector;

- (void)addRightButtonWithTitle:(NSString*)title target:(id)target action:(SEL)selector;

- (void)addLeftButtonWithTitle:(NSString*)title target:(id)target action:(SEL)selector;

// 重置naviBar，回到刚刚创建时候的状态
- (void)resetNaviBar;

// 左按钮返回
- (void)setLeftButtonBack;

- (void)backAction;

// 在原有右导航按钮位置的是primary button
- (void)addPrimaryButtonForTwoButtonsStyleWithImage:(UIImage*)image target:(id)target action:(SEL)selector;

// 其它位置的是Secondary button
- (void)addSecondaryButtonForTwoButtonsStyleWithImage:(UIImage*)image target:(id)target action:(SEL)selector;

// default is back button, all parameters are nil = left button nil
- (void)addLeftButtonWithImage:(UIImage*)image target:(id)target action:(SEL)selector;


- (void)addLeftButtonTitle:(NSString *)title target:(id)target action:(SEL)selector;
// 两行title
- (void)setTwoLineNaviTitleWithMain:(NSString*)mainTitle andSubTitle:(NSString*)subTitle;

#pragma mark - 视图view可见区域高度/大小
- (CGFloat)viewVisibleHeightWithTabbar:(BOOL)tabbar naviBar:(BOOL)naviBar;

- (CGRect)viewVisibleFrameWithTabbar:(BOOL)tabbar naviBar:(BOOL)naviBar;

/* 没有数据时提示
 * text : 提示内容
 * superView : 加载的父视图.传nil时,默认为self.view
 */
- (void)setEmptyViewWithText:(NSString *)text superView:(UIView *)superView;
- (void)setEmptyViewHidden:(BOOL)isHidden;
@end
