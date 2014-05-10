//
//  GYJOperationManager.m
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-6.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import "GYJOperationManager.h"
#import "AFJSONPResponseSerializer.h"

@interface GYJOperationManager ()
{
    NSMutableDictionary *_reqMap;
}
@end

@implementation GYJOperationManager

+ (GYJOperationManager *)sharedOperationManager{
    static GYJOperationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GYJOperationManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _reqMap = [[NSMutableDictionary alloc] initWithCapacity:5];
        AFJSONPResponseSerializer *jsonP = [AFJSONPResponseSerializer serializer];
        [self setResponseSerializer:jsonP];
    }
    return self;
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

#pragma mark -
- (AFHTTPRequestOperation *)POSTWithURL:(NSString *)URLString
                             parameters:(NSDictionary *)parameters
                                success:(AFHTTPRequestOperationSuccessBlock)success
                                failure:(AFHTTPRequestOperationFailureBlock)failure{
    
    return [self requestWithURL:URLString pra:parameters method:@"POST" success:success failure:failure];
}

- (AFHTTPRequestOperation *)GETWithURL:(NSString *)URLString
                            parameters:(NSDictionary *)parameters
                               success:(AFHTTPRequestOperationSuccessBlock)success
                               failure:(AFHTTPRequestOperationFailureBlock)failure{
    
    return [self requestWithURL:URLString pra:parameters method:@"GET" success:success failure:failure];
}

- (AFHTTPRequestOperation *)requestWithURL:(NSString *)url pra:(NSDictionary *)pra method:(NSString *)method success:(AFHTTPRequestOperationSuccessBlock)success failure:(AFHTTPRequestOperationFailureBlock)failure{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    serializer.stringEncoding = NSUTF8StringEncoding;
    
    NSMutableURLRequest *request = [serializer requestWithMethod:method URLString:[[NSURL URLWithString:url relativeToURL:self.baseURL] absoluteString] parameters:pra error:nil];
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    [self.operationQueue addOperation:operation];
    
    return operation;
}

@end
