//
//  GYJMusicSearchObject.m
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-6.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import "GYJMusicSearchObject.h"

@implementation GYJMusicSearchObject

- (instancetype)init{
    self = [super init];
    if (self) {
        self.song = @"";
        self.song_id = @"";
        self.singer = @"";
        self.album = @"";
        self.singerPicSmall = @"";
        self.singerPicLarge = @"";
        self.albumPicLarge = @"";
        self.albumPicSmall = @"";
    }
    return self;
}
@end
