//
//  GYJOperationManager.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-6.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

typedef void(^AFHTTPRequestOperationSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void(^AFHTTPRequestOperationFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);
typedef void(^APIFailureBlock)(id errInfo);
@interface GYJOperationManager : AFHTTPRequestOperationManager

+ (GYJOperationManager *)sharedOperationManager;
- (AFHTTPRequestOperation *)operationForKey:(NSString *)key;
- (void)addOperation:(AFHTTPRequestOperation *)op forKey:(NSString *)key;
- (void)removeOperation:(AFHTTPRequestOperation *)op forKey:(NSString *)key;

- (BOOL)networkAvailable;
- (void)cancelAllRequests;

- (AFHTTPRequestOperation *)POSTWithURL:(NSString *)URLString
                                 parameters:(NSDictionary *)parameters
                                    success:(AFHTTPRequestOperationSuccessBlock)success
                                    failure:(AFHTTPRequestOperationFailureBlock)failure;

- (AFHTTPRequestOperation *)GETWithURL:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                                   success:(AFHTTPRequestOperationSuccessBlock)success
                                   failure:(AFHTTPRequestOperationFailureBlock)failure;
@end
