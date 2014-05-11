//
//  GYJMusicSearchObject.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-6.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//
//  音乐搜索列表object
//
#import <Foundation/Foundation.h>

@interface GYJMusicSearchObject : NSObject
@property (nonatomic, strong) NSString *song;
@property (nonatomic, strong) NSString *song_id;
@property (nonatomic, strong) NSString *singer;
@property (nonatomic, strong) NSString *album;
@property (nonatomic, strong) NSString *singerPicSmall;
@property (nonatomic, strong) NSString *singerPicLarge;
@property (nonatomic, strong) NSString *albumPicLarge;
@property (nonatomic, strong) NSString *albumPicSmall;
@end
