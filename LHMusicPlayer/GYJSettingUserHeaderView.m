//
//  GYJIMSettingUserHeaderView.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-3-4.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJSettingUserHeaderView.h"
#import "UILabel+Custom.h"
static const CGFloat avatorWidth = 58;
@implementation GYJSettingUserHeaderView{
    UIImageView *_sepLine;
    UIImageView *_detailIndicator;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        UIImageView *iconImageview = [UIImageView new];
        iconImageview.contentMode = UIViewContentModeScaleToFill;
        _avatorImageView = iconImageview;
        _avatorImageView.layer.cornerRadius = avatorWidth/2;
        _avatorImageView.layer.masksToBounds = YES;
        [self addSubview:_avatorImageView];
        
        _nickNameLabel = [UILabel new];
        _nickNameLabel.backgroundColor = [UIColor clearColor];
        _nickNameLabel.font = [UIFont systemFontOfSize:16.0f];
        [_nickNameLabel setTextVerticalAlignment:UITextVerticalAlignmentBottom];
        [self addSubview:_nickNameLabel];
        
        _passpordLabel = [UILabel new];
        _passpordLabel.backgroundColor = [UIColor clearColor];
        _passpordLabel.textColor = [UIColor colorWithHexString:@"a7a7a7"];
        _passpordLabel.font = [UIFont systemFontOfSize:12.0f];
        [_passpordLabel setTextVerticalAlignment:UITextVerticalAlignmentTop];
        [self addSubview:_passpordLabel];
        
        _sepLine = [UIImageView new];
        _sepLine.image = [UIImage imageNamed:@"SeparatorLine"];
        [self addSubview:_sepLine];
        
        _detailIndicator = [UIImageView new];
        _detailIndicator.image = [UIImage imageNamed:@"cell_detail_indicator"];
        [self addSubview:_detailIndicator];
        
        [_detailIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
        [_avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(20);
            make.height.equalTo(@(avatorWidth));
            make.width.equalTo(@(avatorWidth));
        }];
        
        [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_avatorImageView.mas_centerY).offset(-10);
            make.height.equalTo(@30);
            make.left.equalTo(self.mas_left).offset(avatorWidth + 35);
        }];

        [_passpordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nickNameLabel.mas_left);
            make.top.equalTo(_nickNameLabel.mas_bottom);
            make.height.equalTo(@20);
        }];
        
        [_sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.width.equalTo(self.mas_width);
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_bottom).offset(-1);
        }];
    }
    return self;
}
@end
