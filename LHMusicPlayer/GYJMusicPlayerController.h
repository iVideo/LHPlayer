//
//  GYJMusicPlayerController.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-2.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJMainBaseViewController.h"

@interface GYJMusicPlayerController : GYJMainBaseViewController<SCLTAudioPlayerDelegate>
- (instancetype)initWithMediaItem:(MPMediaItem *)mediaItem;

@end
