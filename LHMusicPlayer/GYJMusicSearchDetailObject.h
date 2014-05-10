//
//  GYJMusicSearchDetailObject.h
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-10.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYJMusicSearchDetailObject : NSObject

@property (nonatomic, strong) NSString *queryId;
@property (nonatomic, strong) NSString *songId;
@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) NSString *artistId;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *albumId;
@property (nonatomic, strong) NSString *albumName;
@property (nonatomic, strong) NSString *songPicSmall;
@property (nonatomic, strong) NSString *songPicBig;
@property (nonatomic, strong) NSString *songPicRadio;
@property (nonatomic, strong) NSString *lrcLink;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *linkCode;
@property (nonatomic, strong) NSString *songLink;
@property (nonatomic, strong) NSString *showLink;
@property (nonatomic, strong) NSString *format;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *relateStatus;
@property (nonatomic, strong) NSString *resourceType;
@end
