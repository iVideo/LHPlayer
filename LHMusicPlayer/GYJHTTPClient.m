//
//  GYJHTTPClient.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-1.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJHTTPClient.h"

@interface GYJHTTPClient (){
    NSMutableDictionary *_reqMap;
}
@end

@implementation GYJHTTPClient
+ (id)sharedClient
{
    static dispatch_once_t pred;
    static GYJHTTPClient *_sharedNTESIMHTTPClient = nil;
    
    dispatch_once(&pred, ^{
        _sharedNTESIMHTTPClient = [[GYJHTTPClient manager] init];
    });
    
    return _sharedNTESIMHTTPClient;
}

- (id)init{
    self = [super init];
    if (self) {
        
        _reqMap = [[NSMutableDictionary alloc] initWithCapacity:5];
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_NETWORK_CHANGE object:nil];
        }];
    }
    return self;
}


- (BOOL)networkAvailable{
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    if (status == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    }
    return YES;
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


#pragma mark get cookies
- (NSMutableArray*)requestCookies{
    NSString *cookieName = @"NTES_SESS";
    NSString *ntes_ness = [[NSUserDefaults standardUserDefaults] stringForKey:LOGIN_COOKIE_KEY];
    if (nil == ntes_ness) {
        ntes_ness = [[NSUserDefaults standardUserDefaults] stringForKey:LOGIN_M_COOKIE_KEY];
        cookieName = @"M_NTES_SESS";
    }
    if (nil == ntes_ness) {
        return nil;
    }
    NSDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setValue:ntes_ness forKey:NSHTTPCookieValue];
    [properties setValue:cookieName forKey:NSHTTPCookieName];
    [properties setValue:@".163.com" forKey:NSHTTPCookieDomain];
    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60*24*365] forKey:NSHTTPCookieExpires];
    [properties setValue:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
    NSMutableArray *cookies = [NSMutableArray arrayWithObject:cookie];
    return cookies;
}

#pragma mark -
#pragma mark - return the post request with cookies
- (AFHTTPRequestOperation*)POSTWithCookies:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    AFHTTPRequestSerializer *serializer = [[AFHTTPRequestSerializer alloc] init];
    serializer.stringEncoding = NSUTF8StringEncoding;
    
    NSMutableURLRequest *request = [serializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    NSArray *cookies = [self requestCookies];
    NSDictionary *sheaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    [request setAllHTTPHeaderFields:sheaders];
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation*)GETWithCookies:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    AFHTTPRequestSerializer *serializer = [[AFHTTPRequestSerializer alloc] init];
    serializer.stringEncoding = NSUTF8StringEncoding;
    
    NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    NSArray *cookies = [self requestCookies];
    NSDictionary *sheaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    [request setAllHTTPHeaderFields:sheaders];
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
    return operation;
}

- (BOOL)isLogin{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_USERNAME_KEY];
    return verifiedString(userName);
}


@end
