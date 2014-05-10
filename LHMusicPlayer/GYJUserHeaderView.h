//
//  NTESIMUserHeaderView.h
//  iMoney
//
//  Created by 郭亚娟 on 14-2-26.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^UserEditBlock)(void);
typedef void (^UserAvatorBlock)(void);
@interface GYJUserHeaderView : UIView
@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) UIImageView *userAvatar;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIImageView *userSexView;
@property (nonatomic, strong) UILabel *userMailLabel;
@property (nonatomic, strong) UIButton *editUserInfoBtn;
@property (nonatomic, strong) UIButton *editUserAvatorBtn;

@property (nonatomic, copy) UserEditBlock userEditBlock;
@property (nonatomic, copy) UserAvatorBlock userAvatorBlock;
@end
