//
//  GYJSystemMusicLibraryController.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-7.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//
//  系统音乐库
//
#import "GYJMainBaseViewController.h"

@class GYJMusicPlayerController;
@interface GYJSystemMusicLibraryController : GYJMainBaseViewController

@property (nonatomic, strong, readonly) MPMediaQuery *query;
@end
