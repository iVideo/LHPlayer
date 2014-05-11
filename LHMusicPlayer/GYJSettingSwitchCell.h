//
//  GYJIMSettingSwitchCell.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-2-25.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//
//  右边有switch的cell
//
#import "GYJSettingBaseCell.h"
#import "SevenSwitch.h"

typedef void (^NTESIMSettingSwitchBlock)(BOOL switched);

@interface GYJSettingSwitchCell : GYJSettingBaseCell{
    SevenSwitch *_theSwitch;
}
@property (nonatomic, strong) SevenSwitch *theSwitch;
@property (nonatomic, copy) NTESIMSettingSwitchBlock switchCallBackBlock;
@property (nonatomic, readonly,getter = isSwitchOn) BOOL switchOn;
- (void)toggleSwitch:(BOOL)on;
@end
