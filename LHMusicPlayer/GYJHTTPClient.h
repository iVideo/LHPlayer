//
//  GYJHTTPClient.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-1.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"

#define NOTICE_NETWORK_CHANGE @"com.netease.GYJMusicPlayer.netStatus_changed"
// login info
#define LOGIN_COOKIE_KEY @"LOGIN_COOKIE_KEY"
//open id cookie
#define LOGIN_M_COOKIE_KEY @"LOGIN_M_COOKIE_KEY"

typedef void(^APIFailureBlock)(id errInfo);

@interface GYJHTTPClient : AFHTTPRequestOperationManager

@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;

+ (id)sharedClient;

#pragma mark -
#pragma mark - public methods

- (AFHTTPRequestOperation *)operationForKey:(NSString *)key;
- (void)addOperation:(AFHTTPRequestOperation *)op forKey:(NSString *)key;
- (void)removeOperation:(AFHTTPRequestOperation *)op forKey:(NSString *)key;

- (void)cancelAllRequests;

- (NSMutableArray*)requestCookies;

- (BOOL)networkAvailable;

// request with cookies
- (AFHTTPRequestOperation *)POSTWithCookies:(NSString *)URLString
                                 parameters:(NSDictionary *)parameters
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)GETWithCookies:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (BOOL)isLogin;

@end
