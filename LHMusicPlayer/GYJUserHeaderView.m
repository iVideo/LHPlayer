//
//  GYJIMUserHeaderView.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-2-26.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJUserHeaderView.h"
#include <math.h>
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
static const CGFloat avatorMargin = 25;
@implementation GYJUserHeaderView{

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpContent];
        
        self.backgroundColor = [UIColor colorWithHexString:@"243855"];
    }
    return self;
}

- (void)setUpContent{
    self.coverView = [UIImageView new];
    self.userAvatar = [UIImageView new];
    self.userNameLabel = [UILabel new];
    self.userSexView = [UIImageView new];
    self.userMailLabel = [UILabel new];
    self.editUserInfoBtn = [UIButton new];
    self.editUserAvatorBtn = [UIButton new];
    
    _coverView.image = [UIImage imageNamed:@"user_profile_bg"];
    _userAvatar.image = [UIImage imageNamed:@"avator"];
    [_editUserInfoBtn setBackgroundImage:[UIImage imageNamed:@"user_profile_edit_nick"] forState:UIControlStateNormal];
    [_editUserAvatorBtn setBackgroundImage:[UIImage imageNamed:@"user_profile_edit_avator"] forState:UIControlStateNormal];
    //按钮太小，把点击区域扩大一些
    _editUserInfoBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    _userNameLabel.backgroundColor = [UIColor clearColor];
    _userMailLabel.backgroundColor = [UIColor clearColor];
    
    _userNameLabel.textColor = [UIColor whiteColor];
    _userMailLabel.textColor = [UIColor colorWithHexString:@"859BC0"];
    
    _userNameLabel.font = [UIFont systemFontOfSize:18.0f];
    _userMailLabel.font = [UIFont systemFontOfSize:11.0f];
    
    __weak GYJUserHeaderView *weakSelf = self;
    [_editUserInfoBtn addAction:^(UIButton *btn) {
        if (weakSelf.userEditBlock) {
            weakSelf.userEditBlock();
        }
    }];

    [_editUserAvatorBtn addAction:^(UIButton *btn) {
        if (weakSelf.userAvatorBlock) {
            weakSelf.userAvatorBlock();
        }
    }];
    [self addSubview:_coverView];
    [self addSubview:_userAvatar];
    [self addSubview:_userNameLabel];
    [self addSubview:_userSexView];
    [self addSubview:_userMailLabel];
    [self addSubview:_editUserInfoBtn];
    [self addSubview:_editUserAvatorBtn];
    
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
    }];
    
    [_userAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo([NSNumber numberWithFloat:avatorMargin-5]);
        make.top.equalTo([NSNumber numberWithFloat:avatorMargin]);
        make.width.equalTo(_userAvatar.mas_height);
    }];
    CGFloat avatorRadius = (self.height - 2*avatorMargin)/2;
    _userAvatar.layer.cornerRadius = avatorRadius;
    _userAvatar.contentMode = UIViewContentModeScaleAspectFit;
    _userAvatar.layer.borderWidth = 5;
    _userAvatar.layer.borderColor = [UIColor colorWithRed:0.192 green:0.286 blue:0.408 alpha:1].CGColor;
    _userAvatar.layer.masksToBounds = YES;

    
    [_editUserAvatorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_userAvatar.mas_centerX).offset(avatorRadius*cosf(DEGREES_TO_RADIANS(35)));
        make.centerY.equalTo(_userAvatar.mas_centerY).offset(avatorRadius*sinf(DEGREES_TO_RADIANS(35)));
        make.width.equalTo(@27);
        make.height.equalTo(@27);
    }];
    
    [_editUserInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userSexView.mas_right).offset(5);
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userAvatar.mas_centerY).offset(-20);
        make.left.equalTo(_userAvatar.mas_right).offset(15);
        make.height.equalTo(@20);
    }];
    [_userMailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userNameLabel.mas_left);
        make.top.equalTo(_userNameLabel.mas_bottom).offset(5);
        make.height.equalTo(_userNameLabel.mas_height);
    }];

    // Auto Layout
    _userAvatar.translatesAutoresizingMaskIntoConstraints = NO;
    _userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _editUserInfoBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _userSexView.translatesAutoresizingMaskIntoConstraints = NO;
    _userMailLabel.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *views = NSDictionaryOfVariableBindings(_userAvatar,_userNameLabel,_userSexView,_userMailLabel,_editUserInfoBtn);
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"[_userNameLabel]-5-[_userSexView(==15)]-5-[_editUserInfoBtn]-(>=10)-|"
                          options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(>=10)-[_userMailLabel]"
                                                                 options:NSLayoutFormatDirectionRightToLeft metrics:nil views:views]];
}

@end
