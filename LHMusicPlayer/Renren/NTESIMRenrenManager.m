//
//  NTESIMRenrenManager.m
//  iMoney
//
//  Created by Gavin Zeng on 14-3-26.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import "NTESIMRenrenManager.h"
#import "NTESIMRenrenAuthorViewController.h"
#import "SBJsonParser.h"
#import "RORequestParam.h"
#import "RORequest.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NTESIMRenrenManager

+ (NTESIMRenrenManager *)shareInstance{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{instance = self.new;});
    return instance;
}

-(BOOL)isSessionValid{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (nil != defaults){
		self.accessToken = [defaults objectForKey:kRenRenAccessToken];
		self.expirationDate = [defaults objectForKey:kRenrenExpirationDate];
		self.sessionKey = [defaults objectForKey:kRenrenSessionKey];
		self.secret = [defaults objectForKey:kRenrenSecretKey];
	}
    return (self.accessToken != nil && self.expirationDate != nil && self.sessionKey != nil && NSOrderedDescending == [self.expirationDate compare:[NSDate date]]);
}

/**
 * 保存用户经oauth 2.0登录后的信息,到UserDefaults中。
 */
-(void)saveUserSessionInfo:(NSDictionary *)dict{
    
    NSString* token = [dict objectForKey:@"token"];
    NSDate* expirationDate = [dict objectForKey:@"expirationDate"];
    self.accessToken = token;
    self.expirationDate = expirationDate;
    self.secret=[self getSecretKeyByToken:token];
    self.sessionKey=[self getSessionKeyByToken:token];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (self.accessToken) {
        [defaults setObject:self.accessToken forKey:kRenRenAccessToken];
    }
	if (self.expirationDate) {
		[defaults setObject:self.expirationDate forKey:kRenrenExpirationDate];
	}
    if (self.sessionKey) {
        [defaults setObject:self.sessionKey forKey:kRenrenSessionKey];
        [defaults setObject:self.secret forKey:kRenrenSecretKey];
    }
	
    [defaults synchronize];
}

/**
 * 删除UserDefaults中保存的用户oauth 2.0信息
 */
-(void)delUserSessionInfo
{
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kRenRenAccessToken];
	[defaults removeObjectForKey:kRenrenSecretKey];
	[defaults removeObjectForKey:kRenrenSessionKey];
	[defaults removeObjectForKey:kRenrenExpirationDate];
	NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray* graphCookies = [cookies cookiesForURL:
                             [NSURL URLWithString:@"http://graph.renren.com"]];
	
	for (NSHTTPCookie* cookie in graphCookies) {
		[cookies deleteCookie:cookie];
	}
	NSArray* widgetCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://widget.renren.com"]];
	
	for (NSHTTPCookie* cookie in widgetCookies) {
		[cookies deleteCookie:cookie];
	}
	[defaults synchronize];
}

/**
 * 用accesstoken 获取调用api 时用到的参数session_secret
 */
-(NSString *)getSecretKeyByToken:(NSString *)token{
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   token, @"oauth_token",
								   nil];
	NSString *getKeyUrl = [self serializeURL:kRenRenSessionKeyURL params:params httpMethod:@"GET"];
    id result = [self getRequestSessionKeyWithParams:getKeyUrl];
	if ([result isKindOfClass:[NSDictionary class]]) {
		NSString* secretkey=[[result objectForKey:@"renren_token"] objectForKey:@"session_secret"];
		return secretkey;
	}
	return nil;
}

/**
 * 用accesstoken 获取调用api 时用到的参数session_key
 */
-(NSString *)getSessionKeyByToken:(NSString *)token{
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   token, @"oauth_token",
								   nil];
	NSString *getKeyUrl = [self serializeURL:kRenRenSessionKeyURL params:params httpMethod:@"GET"];
    id result = [self getRequestSessionKeyWithParams:getKeyUrl];
	if ([result isKindOfClass:[NSDictionary class]]) {
		NSString* sessionkey=[[result objectForKey:@"renren_token"] objectForKey:@"session_key"];
		return sessionkey;
	}
	return nil;
}

/**
 * Generate get URL
 */
- (NSString*)serializeURL:(NSString *)baseUrl params:(NSDictionary *)params httpMethod:(NSString *)httpMethod{
    NSURL* parsedURL = [NSURL URLWithString:baseUrl];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator]) {
        if (([[params valueForKey:key] isKindOfClass:[UIImage class]])
            ||([[params valueForKey:key] isKindOfClass:[NSData class]])) {
            if ([httpMethod isEqualToString:@"GET"]) {
                NSLog(@"can not use GET to upload a file");
            }
            continue;
        }
        
        NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,/* allocator */ (CFStringRef)[params objectForKey:key], NULL, /* charactersToLeaveUnescaped */ (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}

- (id)getRequestSessionKeyWithParams:(NSString *)url {
	NSURL* sessionKeyURL = [NSURL URLWithString:url];
	NSData *data=[NSData dataWithContentsOfURL:sessionKeyURL];
	NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
	SBJsonParser *jsonParser = [SBJsonParser new] ;
	id result = [jsonParser objectWithString:responseString];
	return result;
}
@end
