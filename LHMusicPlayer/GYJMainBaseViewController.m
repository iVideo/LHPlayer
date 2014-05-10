//
//  LHMainBaseViewController.m
//  LHAD
//
//  Created by 郭亚娟 on 14-4-29.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJMainBaseViewController.h"

@interface GYJMainBaseViewController ()
{


}

@end

@implementation GYJMainBaseViewController

- (id)init {
    self = [super init];
    if (self) {
        _haveNaviBar = YES;
    }
    return self;
}

- (id)initWithCustomNaviBar:(BOOL)haveNaviBar{
    self = [super init];
    if (self) {
        _haveNaviBar = haveNaviBar;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.userInteractionEnabled = YES;
    
    if (_haveNaviBar) {
        _statusBarHeight = (SYSTEM_VERSION >= 7.0) ? STATUS_BAR_H : 0.0;
        
        self.view.backgroundColor = IM_LIGHT_BLUE;
        self.customNaviBar = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, NAVIGATION_BAR_H + _statusBarHeight)];
        self.customNaviBar.userInteractionEnabled = YES;
        self.customNaviBar.image = nil;
        [self.view addSubview:self.customNaviBar];
        self.customNaviBar.backgroundColor = IM_NAVI_BLUE;
        
        
        // title label
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, _statusBarHeight, self.view.bounds.size.width - 140.0, self.customNaviBar.bounds.size.height - _statusBarHeight)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.customNaviBar addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_customNaviBar.mas_left).offset(70);
            make.right.equalTo(_customNaviBar.mas_right).offset(-70);
            make.top.equalTo(@(_statusBarHeight));
            make.height.equalTo(_customNaviBar.mas_height).offset(-_statusBarHeight);
            
        }];
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
}

- (void)setTitle:(NSString *)title{
    if (title && _titleLabel) {
        _titleLabel.text =  title;
    }
}

- (UILabel*)naviTitleLabel{
    if (_titleLabel) {
        return _titleLabel;
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back:(UIGestureRecognizer*)gesture{
    
    [self backAction];
    //NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)backAction{
    // default empty
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark - public methods

- (void)resetNaviBar{
    if (self.customNaviBar) {
        [self.customNaviBar removeFromSuperview];
        self.customNaviBar = nil;
    }
    
    self.view.backgroundColor = IM_LIGHT_BLUE;
    self.customNaviBar = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, NAVIGATION_BAR_H + _statusBarHeight)];
    self.customNaviBar.userInteractionEnabled = YES;
    self.customNaviBar.image = nil;
    [self.view addSubview:self.customNaviBar];
    self.customNaviBar.backgroundColor = IM_NAVI_BLUE;
    
    
    // title label
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, _statusBarHeight, self.view.bounds.size.width - 140.0, self.customNaviBar.bounds.size.height - _statusBarHeight)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:16.0];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.customNaviBar addSubview:_titleLabel];
}

- (void)setLeftButtonBack{
    // left navi arrow
    UIImageView *backButton = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, _statusBarHeight, 45.0, 44.0)];
    backButton.userInteractionEnabled = YES;
    backButton.image = [UIImage imageNamed:@"base_top_navigation_back.png"];
    backButton.frame = CGRectMake(15.0,
                                  _statusBarHeight + (self.customNaviBar.bounds.size.height - _statusBarHeight - backButton.image.size.height)/2,
                                  backButton.image.size.width,
                                  backButton.image.size.height);
    backButton.backgroundColor = [UIColor clearColor];
    
    if (_leftButton && [_leftButton superview]) {
        [_leftButton removeFromSuperview];
    }
    
    _leftButton = backButton;
    _leftButton.hidden = NO;
    [self.customNaviBar addSubview:_leftButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    [_leftButton addGestureRecognizer:tap];
}

- (void)addRightButtonWithImage:(UIImage *)image target:(id)target action:(SEL)selector{
    UIImageView *naviItem = [[UIImageView alloc] initWithImage:image];
    naviItem.userInteractionEnabled = YES;
    naviItem.frame = CGRectMake(self.customNaviBar.frame.size.width - 15.0 - naviItem.image.size.width,
                                _statusBarHeight + (self.customNaviBar.bounds.size.height - _statusBarHeight - naviItem.image.size.height)/2,
                                naviItem.image.size.width,
                                naviItem.image.size.height);
    naviItem.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [naviItem addGestureRecognizer:tap];
    
    if (_rightButton && [_rightButton superview]) {
        [_rightButton removeFromSuperview];
    }
    
    _rightButton = naviItem;
    [self.view addSubview:_rightButton];
}

- (void)addRightButtonWithTitle:(NSString *)title target:(id)target action:(SEL)selector{
    if (title && title.length > 0) {
        UILabel *naviItem = [[UILabel alloc] init];
        naviItem.userInteractionEnabled = YES;
        naviItem.text = title;
        naviItem.textColor = [UIColor whiteColor];
        naviItem.font = [UIFont systemFontOfSize:14.0];
        naviItem.backgroundColor = [UIColor clearColor];
        naviItem.frame = CGRectMake(self.customNaviBar.frame.size.width - 15.0 - naviItem.intrinsicContentSize.width,
                                    (self.customNaviBar.frame.size.height - _statusBarHeight - naviItem.intrinsicContentSize.height)/2,
                                    naviItem.intrinsicContentSize.width,
                                    naviItem.intrinsicContentSize.height);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
        [naviItem addGestureRecognizer:tap];
        
        if (_rightButton && [_rightButton superview]) {
            [_rightButton removeFromSuperview];
        }
        
        _rightButton = naviItem;
        [_rightButton sizeToFit];
        _rightButton.centerY = _titleLabel.centerY;
        _rightButton.right = _customNaviBar.right - 10;
        [self.view addSubview:_rightButton];
    }
}

- (void)addLeftButtonWithTitle:(NSString *)title target:(id)target action:(SEL)selector{
    if (title && title.length > 0) {
        UILabel *naviItem = [[UILabel alloc] init];
        naviItem.userInteractionEnabled = YES;
        naviItem.text = title;
        naviItem.textColor = [UIColor whiteColor];
        naviItem.font = [UIFont systemFontOfSize:14.0];
        naviItem.backgroundColor = [UIColor clearColor];
        naviItem.frame = CGRectMake(15.0,
                                    (self.customNaviBar.frame.size.height - _statusBarHeight - naviItem.intrinsicContentSize.height)/2,
                                    naviItem.intrinsicContentSize.width,
                                    naviItem.intrinsicContentSize.height);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
        [naviItem addGestureRecognizer:tap];
        
        if (_rightButton && [_rightButton superview]) {
            [_rightButton removeFromSuperview];
        }
        
        _rightButton = naviItem;
        _rightButton.centerY = _titleLabel.centerY;
        [self.view addSubview:_rightButton];
    }
}

- (void)addPrimaryButtonForTwoButtonsStyleWithImage:(UIImage*)image target:(id)target action:(SEL)selector{
    [self addRightButtonWithImage:image target:target action:selector];
}

- (void)addSecondaryButtonForTwoButtonsStyleWithImage:(UIImage*)image target:(id)target action:(SEL)selector{
    UIImageView *naviItem = [[UIImageView alloc] initWithImage:image];
    naviItem.userInteractionEnabled = YES;
    naviItem.frame = CGRectMake(self.customNaviBar.frame.size.width - _rightButton.bounds.size.width - 15.0 - naviItem.image.size.width - 25.0,
                                _statusBarHeight + (self.customNaviBar.bounds.size.height - _statusBarHeight - naviItem.image.size.height)/2,
                                naviItem.image.size.width,
                                naviItem.image.size.height);
    naviItem.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [naviItem addGestureRecognizer:tap];
    
    if (_subRightButton && [_subRightButton superview]) {
        [_subRightButton removeFromSuperview];
    }
    
    _subRightButton = naviItem;
    [self.view addSubview:_subRightButton];
}

- (void)addLeftButtonTitle:(NSString *)title target:(id)target action:(SEL)selector{
    if (target == nil && selector == nil) {
        if (_leftButton) {
            [_leftButton removeFromSuperview];
            _leftButton = nil;
        }
        return;
    }
    
    if (_leftButton && [_leftButton superview]) {
        [_leftButton removeFromSuperview];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[[UIImage imageNamed:@"NavigationBack_ios7"] imageTintedWithColor:[UIColor blackColor]] stretchableImageWithLeftCapWidth:29 topCapHeight:29] forState:UIControlStateNormal];
    [button setBackgroundImage:[[[UIImage imageNamed:@"NavigationBack_ios7"] imageTintedWithColor:[UIColor purpleColor]] stretchableImageWithLeftCapWidth:29 topCapHeight:29] forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateHighlighted];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(5, 12, 5, 3)];
    [button sizeToFit];

    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        CGSize titleSize = [title sizeWithFont:button.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, button.height) lineBreakMode:NSLineBreakByClipping];
        button.size = CGSizeMake(18 + titleSize.width, button.height);
    }

    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.customNaviBar addSubview:button];
    button.centerY = _titleLabel.centerY;
    button.x = 5;
    
}

- (void)addLeftButtonWithImage:(UIImage*)image target:(id)target action:(SEL)selector{
    
    if (image == nil && target == nil && selector == nil) {
        if (_leftButton) {
            [_leftButton removeFromSuperview];
            _leftButton = nil;
        }
        return;
    }
    
    UIImageView *naviItem = [[UIImageView alloc] initWithImage:image];
    naviItem.userInteractionEnabled = YES;
    naviItem.frame = CGRectMake(15.0,
                                _statusBarHeight + (self.customNaviBar.bounds.size.height - _statusBarHeight - naviItem.image.size.height)/2,
                                naviItem.image.size.width,
                                naviItem.image.size.height);
    naviItem.backgroundColor = [UIColor clearColor];
    
    if (_leftButton && [_leftButton superview]) {
        [_leftButton removeFromSuperview];
    }
    
    _leftButton = naviItem;
    _leftButton.hidden = NO;
    [self.customNaviBar addSubview:_leftButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [_leftButton addGestureRecognizer:tap];
}

- (CGFloat)viewVisibleHeightWithTabbar:(BOOL)tabbar naviBar:(BOOL)naviBar{
    CGFloat naviBarHeight = naviBar ? self.customNaviBar.bottom : 0;
    CGFloat tabBarHeight = tabbar ? MAIN_TABBAR_HEIGHT : 0;
    return self.view.height - naviBarHeight - tabBarHeight;
}

- (CGRect)viewVisibleFrameWithTabbar:(BOOL)tabbar naviBar:(BOOL)naviBar{
    CGFloat naviBarHeight = naviBar ? self.customNaviBar.bottom : 0;
    CGFloat tabBarHeight = tabbar ? MAIN_TABBAR_HEIGHT : 0;
    CGFloat visibleHeight = self.view.height - naviBarHeight - tabBarHeight;
    return CGRectMake(0, naviBarHeight, self.view.width, visibleHeight);
}

- (void)setTwoLineNaviTitleWithMain:(NSString *)mainTitle andSubTitle:(NSString *)subTitle{
    if (mainTitle && mainTitle.length > 0) {
        _titleLabel.text = mainTitle;
    }
    
    if (subTitle && subTitle.length > 0) {
        if (_subTitleLabel == nil) {
            _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 0.0, self.view.bounds.size.width - 140.0, 14.0)];
            _subTitleLabel.backgroundColor = [UIColor clearColor];
            _subTitleLabel.font = [UIFont systemFontOfSize:12.0];
            _subTitleLabel.textColor = [UIColor whiteColor];
            _subTitleLabel.textAlignment = NSTextAlignmentCenter;
            [self.customNaviBar addSubview:_subTitleLabel];
        }
    }
    _subTitleLabel.text = subTitle;
    
    _titleLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, _titleLabel.frame.size.width, 20.0);
    _subTitleLabel.frame = CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_titleLabel.frame) + 6.0, _titleLabel.frame.size.width, 14.0);
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)setEmptyViewWithText:(NSString *)text superView:(UIView *)superView
{
    if (_tipLabel == nil)
    {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.backgroundColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = RGBCOLOR(210, 210, 210);
        if (nil == superView)
        {
            superView = self.view;
        }
        [superView addSubview:_tipLabel];
        [_tipLabel setUserInteractionEnabled:NO];
    }
    _tipLabel.hidden = NO;
    _tipLabel.text = text;
    _tipLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)setEmptyViewHidden:(BOOL)isHidden
{
    _tipLabel.hidden = isHidden;
}

@end
