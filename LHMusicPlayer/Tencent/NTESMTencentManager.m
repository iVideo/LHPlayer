//
//  NTESMTencentManager.m
//  Magazine
//
//  Created by 范 岩峰 on 13-9-27.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NTESMTencentManager.h"

@implementation NTESMTencentManager
@synthesize tencentDelegate;

+ (NTESMTencentManager *)shareInstance{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{instance = self.new;});
    return instance;
}

- (NSString*)userName{
    NSString *name = [US objectForKey:LOGIN_USERNAME_TENCENT_KEY];
    return name;
}

- (BOOL)authorize{
    NSString *storedToken = [US objectForKey:LOGIN_DATA_TENCENT_KEY];
        //过期判断
    if (nil != storedToken && storedToken.length > 0) {
        BOOL expiresin = [self oauthExpired];
        if (YES == expiresin) {
            return NO;
        }else{
            return YES;
        }
    }else{
        return NO;
    }
}


- (BOOL)oauthExpired{
    NSDate *expiresDate = [US objectForKey:LOGIN_EXPIRESIN_TENCENT_KEY];
    if (nil != expiresDate) {
        BOOL expired = [self tokenExpired:expiresDate];
        if (NO == expired) {
            return NO;
        }else{
            return YES;
        }
    }else{
        return NO;
    }
    
}

    //判断token是否过期
-(BOOL)tokenExpired:(NSDate *)expiresDate
{
    NSDate *today = [NSDate date]; //当前日期
    
    if ([today compare:expiresDate] == NSOrderedAscending) {
        return NO;
    }else{
        return YES;
    }
    
}

- (void)sendTwitter:(NSString*)content image:(UIImage*)img {
    if (twitterRequest) {
        [twitterRequest cancel];
        twitterRequest = nil;
    }
    
    NSString *urlStr = nil;
    if (nil == img) {
        urlStr = TencentOauthUpdate;
    }else{
        urlStr = TencentOauthUpload;
    }
    
    UIImage *storedImage = img;
    NSString *realPath = urlStr;    
    
    NSString *accessToken = [US objectForKey:LOGIN_DATA_TENCENT_KEY];
    NSString *openID = [US objectForKey:LOGIN_OPENID_TENCENT_KEY];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    
    [postDict setObject:QQ_APPKEY forKey:@"oauth_consumer_key"];
    [postDict setObject:accessToken forKey:@"access_token"];
    [postDict setObject:openID forKey:@"openid"];
    [postDict setObject:content forKey:@"content"];
    [postDict setObject:@"2.a" forKey:@"oauth_version"];
    [postDict setObject:@"json" forKey:@"format"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *sendRequest = [manager POST:urlStr parameters:postDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        if (storedImage && storedImage.size.width > 0 && storedImage.size.height > 0 && realPath && realPath.length > 0) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(img, 1.0) name:@"pic" fileName:@"pic" mimeType:@"image/jpeg"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Success: %@", responseObject);
        [self twitterRequestSucceed:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Error: %@", error);
        [self twitterRequestLost];
    }];
    
    sendRequest.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

}

#pragma mark -
#pragma mark ASIHTTPRequest Delegate and related Methods
- (void)twitterRequestSucceed:(NSDictionary *)dict{
    if (twitterRequest) {
		[twitterRequest cancel];
		twitterRequest = nil;
	}
    
    
    NSString *errorInfo = nil;
    
    if (verifiedNSDictionary(dict)) {
        
        NSNumber *ret = [dict objectForKey:@"ret"];
        
        
        
        if (nil != ret && 0 == [ret intValue]) {
            if (tencentDelegate && [tencentDelegate respondsToSelector:@selector(finishSendTwitterWithSuccessStatus:info:)]) {
                [tencentDelegate finishSendTwitterWithSuccessStatus:YES info:@"分享成功！"];
            }
            return;
        }else{
            NSNumber *err_Code = [dict objectForKey:@"errcode"];
            NSInteger errCode = [err_Code intValue];
            
            if (1 == [ret intValue]) {
                errorInfo = @"参数错误！";
            }else if(2 == [ret intValue]){
                errorInfo = @"频率受限！";
            }else if(3 == [ret intValue]){

            }else if(4 == [ret intValue]){
                if (4 == errCode) {
                    errorInfo = @"文字不和谐！";
                }else if(8 == errCode){
                    errorInfo = @"内容过长！";
                }else if(9 == errCode){
                    errorInfo = @"内容包含非法信息！";
                }else if(10 == errCode){
                    errorInfo = @"发表频率太快！";
                }else if(13 == errCode){
                    errorInfo = @"重复发表！";
                }else if(14 == errCode){
                    errorInfo = @"未实名认证！";
                }else{
                    errorInfo = @"微博服务错误！";
                }
                
            }else if(7 == [ret intValue]){
                errorInfo = @"未实名认证！";
            }else{
                errorInfo = @"分享失败！";
            }
        }
    }else{
        errorInfo = @"网络请求失败！";
    }
    
    
    if (tencentDelegate && [tencentDelegate respondsToSelector:@selector(finishSendTwitterWithSuccessStatus:info:)]) {
        [tencentDelegate finishSendTwitterWithSuccessStatus:NO info:errorInfo];
    }
}

- (void)twitterRequestLost{
    if (twitterRequest) {
		[twitterRequest cancel];
		twitterRequest = nil;
	}
    if (tencentDelegate && [tencentDelegate respondsToSelector:@selector(finishSendTwitterWithSuccessStatus:info:)]) {
        [tencentDelegate finishSendTwitterWithSuccessStatus:NO info:nil];
    }
}

//requesttoken url format
-(NSString *)generateURL:(NSString *)baseUrl
                  params:(NSDictionary *)params
              httpMethod:(NSString *)httpMethod
{
	
	NSURL *parsedUrl = [NSURL URLWithString:baseUrl];
	NSString *queryPrefix = parsedUrl.query ? @"&" : @"?";
	
	NSMutableArray* pairs = [NSMutableArray array];
	for (NSString* key in [params keyEnumerator])
        {
		if (([[params valueForKey:key] isKindOfClass:[UIImage class]])
            ||([[params valueForKey:key] isKindOfClass:[NSData class]]))
            {
			if ([httpMethod isEqualToString:@"GET"])
                {
				NSLog(@"can not use GET to upload a file");
                }
			continue;
            }
		
		NSString* escaped_value = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                               NULL,
                                                                                               (__bridge CFStringRef)[params objectForKey:key],
                                                                                               NULL,
                                                                                               (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                               kCFStringEncodingUTF8);
		
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
        }
	NSString* query = [pairs componentsJoinedByString:@"&"];
	
	return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}


//认证授权
-(NSString*)requestTencentAuthorizeUrl
{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   QQ_APPKEY, @"client_id",
                                   @"token", @"response_type",
                                   @"2",@"wap",
                                   TencentCallBackURL, @"redirect_uri",
                                   nil];
    
    NSString *loadingURL = [self generateURL:TencentOauthRequestTokenUrl params:params httpMethod:nil];
    
    return [NSString stringWithString:loadingURL];
}


- (void)storageAccessToken:(NSString*)token{
        //oauth2.0返回值 access_token=d9392fbb8ebc3eaca6801416340ebb9e&expires_in=1209600&openid=BF85C556579C12BAB711C96C5C924C3D&openkey=2913A48200C0AE9E35BB6645030FACBD&refresh_token=c01e91a0403a372e4ee05008f508e25b&name=toddfox&nick=toddfox
    if (token.length > 0) {
        NSArray *tokenList = [token componentsSeparatedByString:@"&"];
        NSString *object = nil;
        NSArray *objectList = nil;
        NSString *key = nil;
        
        NSString *accessToken = nil;
        NSString *expiresin = nil;
        NSString *screenName = nil;
        NSString *openID = nil;
        for (int i= 0; i<[tokenList count]; i++) {
            object = [tokenList objectAtIndex:i];
            objectList = [object componentsSeparatedByString:@"="];
            if ([objectList count] > 1) {
                key = [objectList objectAtIndex:0];
                if ([key isEqualToString:@"access_token"]) {
                    accessToken = [objectList objectAtIndex:1];
                }else if([key isEqualToString:@"expires_in"]){
                    expiresin = [objectList objectAtIndex:1];
                }else if([key isEqualToString:@"nick"]){
                    screenName = [[objectList objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }else if([key isEqualToString:@"openid"]){
                    openID = [objectList objectAtIndex:1];
                }
            }
        }
        if (nil == screenName) {
            screenName = @"已绑定";
        }

        NSDate *expiresDate = [NSDate dateWithTimeIntervalSinceNow:[expiresin doubleValue]];
        [US setObject: accessToken forKey: LOGIN_DATA_TENCENT_KEY];
        [US setObject:screenName forKey:LOGIN_USERNAME_TENCENT_KEY];
        [US setObject:expiresDate forKey:LOGIN_EXPIRESIN_TENCENT_KEY];
        [US setObject:openID forKey:LOGIN_OPENID_TENCENT_KEY];
        [US synchronize];
        
    }
    
}

- (void)removeAccessToken{
    [US removeObjectForKey:LOGIN_DATA_TENCENT_KEY];
    [US removeObjectForKey:LOGIN_USERNAME_TENCENT_KEY];
    [US removeObjectForKey:LOGIN_EXPIRESIN_TENCENT_KEY];
    [US removeObjectForKey:LOGIN_OPENID_TENCENT_KEY];
    [US synchronize];
}

- (void)getUesrInfoWithAccessToken:(NSString*)token{
    NSString *urlstr = [NSString stringWithFormat:@"https://open.t.qq.com/api/user/info?access_token=%@",token];
    
    if (infoRequest) {
        [infoRequest cancel];
        infoRequest = nil;
    }
    
    AFHTTPRequestOperationManager *httpmanager = [AFHTTPRequestOperationManager manager];
    [httpmanager GET:urlstr parameters:nil  success:^(AFHTTPRequestOperation *openration, id responseObject){
        [self infoRequestSucceed:responseObject];
    } failure:^(AFHTTPRequestOperation *openration, NSError *error){
        [self infoRequestLost];
    }];

}

#pragma mark -
#pragma mark ASIHTTPRequest Delegate and related Methods
- (void)infoRequestSucceed:(NSDictionary *)dict{
    if (infoRequest) {
		[infoRequest cancel];
		infoRequest = nil;
	}
    
    if (verifiedNSDictionary(dict)) {
        NSString *screenName = [dict objectForKey:@"screen_name"];
        if (screenName.length > 0) {
            [US setObject:screenName forKey:LOGIN_USERNAME_TENCENT_KEY];
            [US synchronize];
            if (tencentDelegate && [tencentDelegate respondsToSelector:@selector(finishInfoRequestWithScreenName:)]) {
                [tencentDelegate finishInfoRequestWithScreenName:screenName];
            }
        }
    }
}

- (void)infoRequestLost{
    if (infoRequest) {
		[infoRequest cancel];
		infoRequest = nil;
	}
}

- (void)cancelRequest{
    self.tencentDelegate = nil;
    
    if (twitterRequest) {
        [twitterRequest cancel];
        twitterRequest = nil;
    }
}

- (BOOL)isTencenWeiboBinded
{
    NSString *username = [US objectForKey:LOGIN_USERNAME_TENCENT_KEY];
    NSString *userData = [US objectForKey:LOGIN_DATA_TENCENT_KEY];
    
    BOOL isBind = [[NTESMTencentManager shareInstance] authorize];
    if (isBind && userData && username)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
