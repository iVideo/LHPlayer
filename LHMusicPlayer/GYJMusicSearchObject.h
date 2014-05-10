//
//  GYJMusicSearchObject.h
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-6.
//  Copyright (c) 2014年 LiHang. All rights reserved.
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
