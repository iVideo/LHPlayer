//
//  GYJSystemMusicLibraryController.h
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-7.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//
//  系统音乐库
//
#import "GYJMainBaseViewController.h"

@class GYJMusicPlayerController;
@interface GYJSystemMusicLibraryController : GYJMainBaseViewController

@property (nonatomic, strong, readonly) MPMediaQuery *query;
@end
