//
//  GYJMusicOperationManager.h
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-6.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import "GYJOperationManager.h"
#import "AFDownloadRequestOperation.h"

#define kMusicSearchAPI @"http://mp3.baidu.com/dev/api/?tn=getinfo&ct=0&word=%@&format=json&ie=utf-8"
#define kMusicDetailAPI @"http://ting.baidu.com/data/music/links?songIds=%@"

#define keyMusicDetail @"musicDetail"
#define keyMusicSearching @"musicSearching"
#define keyMusicDownload @"musicDownload"
@class GYJMusicSearchDetailObject;
@class GYJMusicSearchObject;

typedef void(^GYJMusicSearchResaults)(NSArray* musicSearchObjects);
typedef void(^GYJMusicDetailObjectBlock)(GYJMusicSearchDetailObject *musicDetailObject);
typedef void(^GYJDownloadProgressBlock)(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile);
@interface GYJMusicOperationManager:AFHTTPRequestOperationManager

+ (GYJMusicOperationManager *)sharedMusicOperationManager;
- (NSString *)musicDownloadPath;
- (void)searchWithKeyword:(NSString *)keyword success:(GYJMusicSearchResaults)musicSearchObjects failure:(APIFailureBlock)failure;
- (void)searchMusicDetailWithSongID:(NSString *)songID success:(GYJMusicDetailObjectBlock)songDetail failure:(APIFailureBlock)failure;

- (void)downloadFileWithPath:(NSString *)path fileURL:(NSURL *)url downProgress:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))block;

- (AFHTTPRequestOperation *)operationForKey:(NSString *)key;
- (void)addOperation:(AFHTTPRequestOperation *)op forKey:(NSString *)key;
- (void)removeOperation:(AFHTTPRequestOperation *)op forKey:(NSString *)key;

- (void)cancelAllRequests;
- (BOOL)networkAvailable;
@end
