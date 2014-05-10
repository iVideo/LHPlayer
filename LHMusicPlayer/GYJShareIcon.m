//
//  GYJShareIcon.m
//  iMoney
//
//  Created by LiHang on 14-3-14.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import "GYJShareIcon.h"
#import "UILabel+Custom.h"
#import "UIButton+Category.h"

@interface GYJShareIcon ()
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, copy) GYJShareIconBlock actionBlock;
@property (nonatomic, assign) GYJShareIconType shareType;
@end
@implementation GYJShareIcon

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:CGRectZero type:GYJShareIconTypeSina binded:YES block:NULL];
}
- (id)initWithFrame:(CGRect)frame type:(GYJShareIconType)type binded:(BOOL)binded block:(GYJShareIconBlock)actionBlock{
    self = [super initWithFrame:frame];
    if (self) {
        _binded = binded;
        self.shareType = type;
        self.backgroundColor = [self backgroundColorWithType:_shareType binded:_binded];
        
        self.headerView = [UIImageView new];
        self.headerLabel = [UILabel new];
        
        _headerLabel.backgroundColor = [UIColor clearColor];
        _headerLabel.textColor = [UIColor whiteColor];
        _headerLabel.font = [UIFont systemFontOfSize:13];
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        [_headerLabel setTextVerticalAlignment:UITextVerticalAlignmentTop];
        
        [self addSubview:_headerView];
        [self addSubview:_headerLabel];
        
        _headerLabel.text = [self headerTextWithType:_shareType];
        _headerView.image = [self headerImageWithType:_shareType];
        self.actionBlock = actionBlock;
        __weak typeof(self) weakSelf = self;
        [self addAction:^(UIButton *btn) {
            if (weakSelf.actionBlock) {
                weakSelf.actionBlock();
            }
        }];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_centerY).offset(5);
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@40);
            make.height.equalTo(_headerView.mas_width);
        }];
        [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(self.mas_width);
            make.top.equalTo(_headerView.mas_bottom);
            make.height.equalTo(@30);
        }];
    }
    return self;
}
- (NSString *)headerTextWithType:(GYJShareIconType)type{
    NSString *headerText = nil;
    switch (type) {
        case GYJShareIconTypeSina:
            headerText = @"新浪微博";
            break;
        case GYJShareIconTypeTencentWeibo:
            headerText = @"腾讯微博";
            break;
        case GYJShareIconTypeYiXin:
            headerText = @"易信";
            break;
        case GYJShareIconTypeRenRen:
            headerText = @"人人网";
            break;
        case GYJShareIconTypeWeChat:
            headerText = @"微信";
            break;
        case GYJShareIconTypeWeChatMoments:
            headerText = @"微信朋友圈";
            break;
        default:
            break;
    }
    return headerText;
}
- (UIColor *)backgroundColorWithType:(GYJShareIconType)type binded:(BOOL)binded{
    if (!binded) {
        return [UIColor colorWithHexString:@"d4dcdf"];
    }
    UIColor *bindedColor = nil;
    switch (type) {
        case GYJShareIconTypeSina:
            bindedColor = [UIColor colorWithHexString:@"EDA32B"];
            break;
        case GYJShareIconTypeTencentWeibo:
            bindedColor = [UIColor colorWithHexString:@"2785D7"];
            break;
        case GYJShareIconTypeYiXin:
            bindedColor = [UIColor colorWithHexString:@"00B68A"];
            break;
        case GYJShareIconTypeRenRen:
            bindedColor = [UIColor colorWithHexString:@"09479D"];
            break;
        case GYJShareIconTypeWeChat:
            bindedColor = [UIColor colorWithHexString:@"5EC337"];
            break;
        case GYJShareIconTypeWeChatMoments:
            bindedColor = [UIColor colorWithHexString:@"ADF348"];
            break;
        default:
            break;
    }
    return bindedColor;
}
- (void)setBinded:(BOOL)binded{
    _binded = binded;
    self.backgroundColor = [self backgroundColorWithType:self.shareType binded:_binded];
}
- (UIImage *)headerImageWithType:(GYJShareIconType)type{
    NSString *headerImageName = nil;
    switch (type) {
        case GYJShareIconTypeSina:
            headerImageName = @"share_sina_weibo@2x";
            break;
        case GYJShareIconTypeTencentWeibo:
            headerImageName = @"share_tentcent_weibo@2x";
            break;
        case GYJShareIconTypeYiXin:
            headerImageName = @"share_yixin@2x";
            break;
        case GYJShareIconTypeRenRen:
            headerImageName = @"share_renren@2x";
            break;
        case GYJShareIconTypeWeChat:
            headerImageName = @"share_wechat@2x";
            break;
        case GYJShareIconTypeWeChatMoments:
            headerImageName = @"share_wechat_moments@2x";
            break;
        default:
            break;
    }
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"ShareIcon" ofType:@"bundle"];
    UIImage *headerImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleWithPath:bundlePath] pathForResource:headerImageName ofType:@"png"]];
    return headerImage;
}

@end
