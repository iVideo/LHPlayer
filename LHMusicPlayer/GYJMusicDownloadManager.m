//
//  GYJMusicDownloadManager.m
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-6.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import "GYJMusicDownloadManager.h"

@interface GYJMusicDownloadManager ()

@property (nonatomic, strong) AFHTTPRequestOperation *operation;
@end
@implementation GYJMusicDownloadManager

+ (GYJMusicDownloadManager *)defauleDownloadManager{
    static GYJMusicDownloadManager *downloadManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadManager = [[GYJMusicDownloadManager alloc] init];
    });
    return downloadManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
