//
//  GYJMusicPlayerController.h
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-2.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import "GYJMainBaseViewController.h"

@interface GYJMusicPlayerController : GYJMainBaseViewController<SCLTAudioPlayerDelegate>
- (instancetype)initWithMediaItem:(MPMediaItem *)mediaItem;

@end
