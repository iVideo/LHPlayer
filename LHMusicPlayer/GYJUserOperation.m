//
//  GYJUserOperation.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-1.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJUserOperation.h"
#import "GYJHTTPClient.h"
#import "NSData+QBase64.h"
#import "NSData+ENBase64.h"
#import "GYJJSON.h"

@implementation GYJUserOperation
{
    GYJHTTPClient *httpClient;
    AFHTTPRequestOperation *getterOperation;
    AFHTTPRequestOperation *setterOperation;
    
    AFHTTPRequestOperation *nickOperation;
}

- (id)init{
    self = [super init];
    if (self) {
        _status = NTESIMUserOperationStatusPending;
    }
    return self;
}
- (GYJHTTPClient *)client{
    if (!httpClient) {
        httpClient = [GYJHTTPClient sharedClient];
    }
    return httpClient;
}

- (void)start{
    if ([[self client] operationForKey:_key]) {
        [[self client] removeOperation:nil forKey:_key];
    }
    _status = NTESIMUserOperationStatusRunning;
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    getterOperation = [[self client] POSTWithCookies:[self getterURLString] parameters:[self parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _status = NTESIMUserOperationStatusCompleted;
        self.error = nil;
        self.responseData = operation.responseData;
        if ([self.delegate respondsToSelector:@selector(userOperationCompleted:)]) {
            [self.delegate userOperationCompleted:self];
        }
        if (_successBlock) {
            _successBlock(self);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _status = NTESIMUserOperationStatusFailed;
        self.responseData = nil;
        self.error = error;
        if ([self.delegate respondsToSelector:@selector(userOperationFailed:)]) {
            [self.delegate userOperationFailed:self];
        }
        if (_failedBlock) {
            _failedBlock(self);
        }
    }];
    [getterOperation setResponseSerializer:responseSerializer];
}


//根据不同的key判断不同操作来拼接url
- (NSString *)getterURLString{
    //这里一部分走的是新闻的接口，其余的是股票的接口，这里的key本身就是URL
    NSString *url = nil;
    if ([_key isEqualToString:API_163_USER_INFO]) {
        NSData *iddata = [_user.userid dataUsingEncoding:NSUTF8StringEncoding];
        NSString *userid = [iddata base64EncodedString];
        url = [NSString stringWithFormat:_key,userid];
    } else{
        url = [NSString stringWithFormat:@"%@%@",API_HOST,_key];
    }
    return url;
}


@end
