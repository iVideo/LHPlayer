//
//  GYJMusicSearchObject.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-6.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
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
