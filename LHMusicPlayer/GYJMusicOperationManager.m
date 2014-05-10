//
//  GYJOperationManager+MusicSearch.m
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-6.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import "GYJMusicOperationManager.h"
#import "GYJMusicSearchObject.h"
#import "GYJMusicSearchDetailObject.h"
#import "AFJSONPResponseSerializer.h"
#import "GYJJSON.h"
#import <objc/runtime.h>

static NSString *musicDownloadPath = @"downloadMusic/";
@interface GYJMusicOperationManager (){
    NSMutableDictionary *_reqMap;
}

@end
@implementation GYJMusicOperationManager
+ (GYJMusicOperationManager *)sharedMusicOperationManager{
    static GYJMusicOperationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GYJMusicOperationManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _reqMap = [[NSMutableDictionary alloc] initWithCapacity:5];
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (NSString *)musicDownloadPath{
    NSString *path = [DOC_PATH_CACHE stringByAppendingPathComponent:musicDownloadPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return path;
}

#pragma mark -
#pragma mark API general operations
- (AFHTTPRequestOperation *)operationForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    
    AFHTTPRequestOperation *op = _reqMap[key];
    if (op && [op isExecuting]) {
        return op;
    }else{
        [_reqMap removeObjectForKey:key];
        return nil;
    }
}

- (void)addOperation:(AFHTTPRequestOperation *)op forKey:(NSString *)key {
    if (!key) {
        return;
    }
    //先取消正进行的request
    AFHTTPRequestOperation *oldOp = _reqMap[key];
    if (oldOp && [oldOp isExecuting]) {
        [oldOp cancel];
    }
    [_reqMap removeObjectForKey:key];
    _reqMap[key] = op;
    [self.operationQueue addOperation:op];
}

- (void)removeOperation:(AFHTTPRequestOperation *)op forKey:(NSString *)key{
    if (!key) {
        return;
    }
    
    AFHTTPRequestOperation *oldOp = _reqMap[key];
    if (oldOp && [oldOp isEqual:op]) {
        if ([oldOp isExecuting]) {
            [oldOp cancel];
        }
        [_reqMap removeObjectForKey:key];
    }
}

- (void)cancelAllRequests {
    for (AFHTTPRequestOperation *op in _reqMap.allValues) {
        [op cancel];
    }
    [_reqMap removeAllObjects];
}


- (BOOL)networkAvailable{
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    if (status == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    }
    return YES;
}

- (void)searchMusicDetailWithSongID:(NSString *)songID success:(GYJMusicDetailObjectBlock)songDetail failure:(APIFailureBlock)failure{
    if (!verifiedString(songID)) {
        songID = @"";
    }
    
    NSString *requestURL = [[NSString stringWithFormat:kMusicDetailAPI,songID]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:requestURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __weak typeof(self) weakSelf = self;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf parserSongDetail:[responseObject objectFromJSONData] withBlock:songDetail];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self addOperation:operation forKey:keyMusicDetail];
}
- (void)searchWithKeyword:(NSString *)keyword success:(GYJMusicSearchResaults)musicSearchObjects failure:(APIFailureBlock)failedBlock{
    if (!verifiedString(keyword)) {
        keyword = @"";
    }
    
    NSString *requestURL = [[NSString stringWithFormat:kMusicSearchAPI,keyword]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:requestURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __weak typeof(self) weakSelf = self;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf parserSearchList:[responseObject objectFromJSONData] withBlock:musicSearchObjects];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self addOperation:operation forKey:keyMusicSearching];
}

- (void)parserSongDetail:(id)songDetail withBlock:(GYJMusicDetailObjectBlock)songDetailBlock{
    if (![songDetail isKindOfClass:[NSDictionary class]]) {
        if (songDetailBlock) {
            songDetailBlock(nil);
        }
        return;
    }
    id dataDic = [songDetail objectForKey:@"data"];
    if (![dataDic isKindOfClass:[NSDictionary class]]) {
        if (songDetailBlock) {
            songDetailBlock(nil);
        }
        return;
    }
    
    id songList = [dataDic objectForKey:@"songList"];
    if (![songList isKindOfClass:[NSArray class]]) {
        if (songDetailBlock) {
            songDetailBlock(nil);
        }
        return;
    }
    
    NSDictionary *songListDictionary = [songList firstObject];
    GYJMusicSearchDetailObject *musicDetailObject = [GYJMusicSearchDetailObject new];
    Class musicClass = [GYJMusicSearchDetailObject class];
    NSArray *musicDetailPropertys = [[GYJCommon calssPropertyForClass:musicClass] allKeys];
    @autoreleasepool {
        for (NSString *propertyKey in musicDetailPropertys) {
            NSString *propertyValue = [[songListDictionary allKeys] containsObject:propertyKey] ? [NSString stringWithFormat:@"%@",[songListDictionary objectForKey:propertyKey]] : @"";
            Ivar ivar = class_getInstanceVariable(musicClass, [[NSString stringWithFormat:@"_%@",propertyKey] UTF8String]);
            object_setIvar(musicDetailObject, ivar, propertyValue);
        }
    }
    if (songDetailBlock) {
        songDetailBlock(musicDetailObject);
    }
}

- (void)parserSearchList:(id)responseObject withBlock:(GYJMusicSearchResaults)block{
    if (![responseObject isKindOfClass:[NSArray class]]) {
        if (block) {
            block(@[]);
        }
        return;
    }
    @autoreleasepool {
        Class objectClass = [GYJMusicSearchObject class];
        NSMutableArray *searchResultsArray = [[NSMutableArray alloc] initWithCapacity:100];
        for (id aObjectDic in responseObject) {
            if ([aObjectDic isKindOfClass:[NSDictionary class]]) {
                NSArray *searchMusicObjectPropertys = [[GYJCommon calssPropertyForClass:objectClass] allKeys];
                GYJMusicSearchObject *asearchMusicObject = [GYJMusicSearchObject new];
                for (NSString *propertyKey in searchMusicObjectPropertys) {
                    NSString *propertyValue = [[aObjectDic allKeys] containsObject:propertyKey] ? [NSString stringWithFormat:@"%@",[aObjectDic objectForKey:propertyKey]] : @"";
                    Ivar ivar = class_getInstanceVariable(objectClass, [[NSString stringWithFormat:@"_%@",propertyKey] UTF8String]);
                    object_setIvar(asearchMusicObject, ivar, propertyValue);
                    [searchResultsArray addObject:asearchMusicObject];
                }
            }
        }
        if (block) {
            block([searchResultsArray copy]);
        }
    }
}

- (void)downloadFileWithPath:(NSString *)path fileURL:(NSURL *)url downProgress:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))block{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFDownloadRequestOperation *downloadOperation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:path shouldResume:YES];
    downloadOperation.shouldOverwrite = YES;
    
    [downloadOperation setDownloadProgressBlock:block];
    [self addOperation:downloadOperation forKey:keyMusicDownload];
}
@end
