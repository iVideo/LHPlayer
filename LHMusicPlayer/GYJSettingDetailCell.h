//
//  GYJIMSettingDetailCell.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-2-25.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJSettingBaseCell.h"

@interface GYJSettingDetailCell : GYJSettingBaseCell{
    UIImageView *_detailIndicator;
    UILabel *_infoLabel;
    UIView *_shareIconsView;
}

@property (nonatomic, strong) UILabel *infoLabel;
- (void)showOtherPlatformIcons:(NSArray *)iconNames;//其他平台的icon图片名称
@end
