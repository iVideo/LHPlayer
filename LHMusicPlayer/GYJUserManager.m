//
//  GYJUserManager.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-1.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJUserManager.h"
#import "GYJUserOperation.h"
#import "GYJHTTPClient.h"
#import "GYJJSON.h"
#import "GYJMusicPlayerController.h"

static GYJUserManager *sharedManager = nil;

@interface GYJUserManager ()
@property (nonatomic, strong) GYJUser *loginUser;
@property (nonatomic, strong) GYJUser *localUser;
@property (nonatomic, strong) NSString *passpord;
@property (nonatomic, strong) NSString *password;
@end

@implementation GYJUserManager{
    AFHTTPRequestOperation *loginRequestOperation;
    AFHTTPRequestOperation *updateRequestOperation;
    AFHTTPRequestOperation *nickOperation;
    GYJHTTPClient *httpClient;
    
    NSString *tmpNickname;
}

+ (GYJUserManager *)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[GYJUserManager alloc] init];
        }
    });
    
    return sharedManager;
}

- (id)init{
    self = [super init];
    if (self) {
        httpClient = [GYJHTTPClient sharedClient];
        
        GYJUser *localUser = [[GYJUser alloc] initLocalUser];
        self.localUser = localUser;
        
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_USERNAME_KEY];
        if (userName) {
            GYJUser *loginUser = [[GYJUser alloc] initLoginUserWith:userName];
            self.loginUser = loginUser;
        }
        
        self.currentUser = self.loginUser ? self.loginUser : self.localUser;
        
    }
    return self;
}

- (GYJHTTPClient *)client{
    if (!httpClient) {
        httpClient = [GYJHTTPClient sharedClient];
    }
    
    return httpClient;
}

//用户登录，这里跟新闻的逻辑一样
- (void)loginNeteaseWithUsername:(NSString *)username password:(NSString *)password{
    if ([[self client] operationForKey:API_163_USER_LOGIN]) {
        [[self client] removeOperation:nil forKey:API_163_USER_LOGIN];
    }
    
    self.password = password;
    self.passpord = username;
    [self clearCookie];
    AFHTTPResponseSerializer * responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *paramters = @{@"username": username,@"password":password};
    loginRequestOperation = [[self client] POSTWithCookies:API_163_USER_LOGIN parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        //在本地cookies上找名字为NTES_SESS, P_INFO, S_INFO的cookie
        NSInteger count = 0;
        NSString *cookieValue = nil;
        NSString *userAccount = nil;
        for (NSHTTPCookie *cookie in cookies)
        {
            NSString *cookieName = [[cookie properties] objectForKey:@"Name"];
            if ([cookieName isEqualToString:@"NTES_SESS"]) {
                cookieValue = [[cookie properties] objectForKey:@"Value"];
                if (verifiedString(cookieValue)) {
                    [[NSUserDefaults standardUserDefaults] setObject:[cookie properties] forKey:KEY_LOGINED_COOKIE_PROPERTIES];
                    [[NSUserDefaults standardUserDefaults] setObject:cookieValue forKey:LOGIN_COOKIE_KEY];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    count++;
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NTESIMUserLoginFailedNotification object:nil];
                    //登录异常等情况
                    //登录失败处理
                    if ([_delegate respondsToSelector:@selector(userloginFailedWithErrorType:)]) {
                        [_delegate userloginFailedWithErrorType:428];
                    }
                    return;
                }
                continue;
            }
            
            if ([cookieName isEqualToString:@"P_INFO"])
            {
                count++;
                //这个cookie value里，第一部分是主帐号
                cookieValue = [[cookie properties] objectForKey:@"Value"];
                NSArray *values = [cookieValue componentsSeparatedByString:@"|"];
                if (verifiedNSArray(values)) {
                    NSString *account = values[0];
                    //主帐号应该是一个邮箱地址，以防万一看一下有没有@符号
                    if (verifiedString(account) && [account rangeOfString:@"@"].location != NSNotFound) {
                        userAccount = account;
                    }
                }
            }
            
            if ([cookieName isEqualToString:@"S_INFO"])
            {
                count++;
            }
        }
        if (count >= 3)
        {
            //登录成功处理
            if (userAccount && [userAccount rangeOfString:@"@"].location == NSNotFound) {
                userAccount = [userAccount stringByAppendingString:@"@163.com"];
            }
            //用户名全部转成小写的保存
            userAccount = [userAccount lowercaseString];
            
            [[NSUserDefaults standardUserDefaults] setValue:userAccount forKey:LOGIN_USERNAME_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [self keychainStoragePassword:_password forAccount:userAccount];
            
            
            //登录成功清空注册用户名
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:REGISTER_USERNAME_KEY];
            
            //登录成功后需要更新app当前用户
            GYJUser *loginUser = [[GYJUser alloc] initLoginUserWith:userAccount];
            self.currentUser = self.loginUser = loginUser;
            
            [self updateUserDataForKey:API_163_USER_INFO];
            [self updateUserDataForKey:API_USER_GET_BASE_INFO];
            [self userFirstLoginNotifyToServer];
            [[NSNotificationCenter defaultCenter] postNotificationName:NTESIMUserLoginSuccessNotification object:nil];
        }
        else {
            //登录失败处理
            if ([_delegate respondsToSelector:@selector(userloginFailedWithErrorType:)]) {
                [_delegate userloginFailedWithErrorType:0];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NTESIMUserLoginFailedNotification object:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([_delegate respondsToSelector:@selector(userloginFailedWithErrorType:)]) {
            [_delegate userloginFailedWithErrorType:1];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESIMUserLoginFailedNotification object:nil];
        [[self client] removeOperation:operation forKey:API_163_USER_LOGIN];
    }];
    
    
    [loginRequestOperation setResponseSerializer:responseSerializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    [[self client] addOperation:loginRequestOperation forKey:API_163_USER_LOGIN];
}

#pragma mark - 用户初次登录成功通知服务器
- (void)userFirstLoginNotifyToServer{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *deviceId = [NSString stringWithFormat:@"iOS v%@",appVersion];
    NSDictionary *pra = @{@"deviceId":deviceId};
    [self updateUserDataForKey:API_USER_LOGIN_NOTI parameters:pra success:^(GYJUserOperation *operation) {
        
    } failed:^(GYJUserOperation *operation) {
        
    }];
}

#pragma mark - Operation
- (void)updateUserDataForKey:(NSString *)key parameters:(NSDictionary *)parameters{
    [self updateUserDataForKey:key parameters:parameters success:nil failed:nil];
}
- (void)updateUserDataForKey:(NSString *)key{
    
    [self updateUserDataForKey:key parameters:nil];
}
- (void)updateUserDataForKey:(NSString *)key
                     success:(UserManagerOperationSuccessBlock)success
                      failed:(UserManagerOperationFailedBlock)failed{
    [self updateUserDataForKey:key parameters:nil success:success failed:failed];
}

- (void)updateUserDataForKey:(NSString *)key
                  parameters:(NSDictionary *)parameters
                     success:(UserManagerOperationSuccessBlock)success
                      failed:(UserManagerOperationFailedBlock)failed{
    GYJUserOperation *operation = [[GYJUserOperation alloc] init];
    operation.key = key;
    operation.user = _currentUser;
    operation.parameters = parameters;
    operation.successBlock = success;
    operation.failedBlock = failed;
    [self pushOperationToQueue:operation];
}

- (void)pushOperationToQueue:(GYJUserOperation *)operation{
    if (![[self client] networkAvailable]) {
        NSError *error = nil;
        operation.error = error;
        [self userOperationFailed:operation];
        return;
    }
    operation.delegate = self;
    [operation start];
}

#pragma mark -
#pragma mark - NTESIMUserOperationDelegate
- (void)userOperationCompleted:(GYJUserOperation *)operation{
    
    NSDictionary *dic = [operation.responseData objectFromJSONData];
    if ([operation.key isEqualToString:API_163_USER_INFO]) {
        [self.currentUser updateUserInfoWith:dic];
        if ([_delegate respondsToSelector:@selector(userLoginSucceeded)]) {
            [_delegate userLoginSucceeded];
        }
    } else if ([operation.key isEqualToString:API_USER_PUSH_SWITCH]){
        if (verifiedNSDictionary(dic) && [[dic objectForKey:@"status"] intValue] == 0){
            BOOL userPush = NO;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_LOGIN_INFO]) {
                NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_LOGIN_INFO];
                if ([userInfo objectForKey:@"infoPush"]) {
                    userPush = [[userInfo objectForKey:@"infoPush"] boolValue];
                }
            }
            [self.currentUser saveUserInfo];
        } else {
        }
    } else if ([operation.key isEqualToString:API_USER_GET_BASE_INFO]){
        if (verifiedNSDictionary(dic) && [[dic objectForKey:@"status"] intValue] == 0){
            if (dic[@"data"]) {
                [self.currentUser updateUserInfoWith:dic[@"data"]];
            }
        } else {
        }
    } else if ([operation.key isEqualToString:API_USER_SET_BASE_INFO]){
        if (verifiedNSDictionary(dic) && [[dic objectForKey:@"status"] intValue] == 0){
            //信息设置成功了再去重新拉取一下
            [self updateUserDataForKey:API_USER_GET_BASE_INFO];
        } else {
        }
    }
}
- (void)userOperationFailed:(GYJUserOperation *)operation{
    
    if ([operation.key isEqualToString:API_163_USER_INFO]) {
        if ([_delegate respondsToSelector:@selector(userloginFailedWithErrorType:)]) {
            [_delegate userloginFailedWithErrorType:0];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESIMUserLoginFailedNotification object:nil];
    }
}



#pragma mark -
#pragma mark keychain
- (void)keychainStoragePassword:(NSString*)password forAccount:(NSString*)account{
    [SSKeychain deletePasswordForService:KEY_KEYCHAIN_SERVICE_MAILBOX account:account];
    [SSKeychain setPassword:password forService:KEY_KEYCHAIN_SERVICE_MAILBOX account:account];
}


#pragma mark - Login
- (BOOL)isLoginUser{
    return self.currentUser == self.loginUser;
}

//用户登出在这里做一些收尾工作
- (void)logoutLoginUser{
    NSString *passport = [self currentUser].username;
    if (verifiedString(passport)) {
        [SSKeychain deletePasswordForService:KEY_KEYCHAIN_SERVICE_MAILBOX account:passport];
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:LOGIN_USERNAME_KEY];
    [userDefault removeObjectForKey:KEY_LOGINED_COOKIE_PROPERTIES];
    [userDefault removeObjectForKey:KEY_USER_LOGIN_INFO];
    [userDefault removeObjectForKey:LOGIN_COOKIE_KEY];
    [userDefault synchronize];
    [self clearCookie];
    self.currentUser = [[GYJUser alloc] initLocalUser];
    //..........
    [[NSNotificationCenter defaultCenter] postNotificationName:NTESIMUserLogoutNotification object:nil];
    
}


- (void)clearCookie{
    //这里要额外清除shared Cookie，否则可能会让下一次登录无效
	NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
	//NSLog(@"cookies:%@",cookies);
	for (NSHTTPCookie *cookie in cookies) {
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
	}
}


@end
