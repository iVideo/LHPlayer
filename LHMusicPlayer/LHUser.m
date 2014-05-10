//
//  LHUser.m
//  LHMusicPlayer
//
//  Created by 郭亚娟 on 14-5-1.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "LHUser.h"

@implementation LHUser

- (id)initLocalUser{
    self = [super init];
    if (self) {
        self.isLoginUser = NO;
        self.autoDownload = NO;
        self.username = @"未登录";
        self.nickname = nil;
        self.avator = nil;
    }
    return self;
}

- (id)initLoginUserWith:(NSString *)userName{
    self = [super init];
    if (self) {
        self.isLoginUser = YES;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *userInfo = [defaults objectForKey:KEY_USER_LOGIN_INFO];
        self.username = userName;
        NSArray *allKeys = [userInfo allKeys];
        if ([allKeys containsObject:@"nickname"]) {
            self.nickname = [userInfo objectForKey:@"nickname"];

        }
        if ([allKeys containsObject:@"avator"]) {
            self.avator = [userInfo objectForKey:@"avator"];

        }
        if ([allKeys containsObject:@"autoDownload"]) {
            self.autoDownload = [[userInfo objectForKey:@"autoDownload"] boolValue];

        }
    }
    return self;
}

- (NSString *)userid{
    NSString *userid = nil;
    if (_username && [_username rangeOfString:@"@"].location == NSNotFound &&_isLoginUser) {
        userid = [_username stringByAppendingString:@"@163.com"];
    }else{
        userid = _username;
    }
    return userid;
}

- (void)updateUserInfoWith:(NSDictionary *)userInfo{
    
    if ([userInfo objectForKey:@"nick"]) {
        if (verifiedString([userInfo objectForKey:@"nick"])) {
            self.nickname = [userInfo objectForKey:@"nick"];
            
        } else {
            if (verifiedString(_username)) {
                if ([_username rangeOfString:@"@"].location != NSNotFound) {
                    self.nickname = [_username substringWithRange:NSMakeRange(0, [_username rangeOfString:@"@"].location)];
                } else {
                    self.nickname = _username;
                }
            } else {
                self.nickname = @"";
            }
        }
    }
    
    if ([userInfo objectForKey:@"head"]) {
        self.avator = [userInfo objectForKey:@"head"];
    }
    if ([userInfo objectForKey:@"autoDownload"]) {
        self.autoDownload = [[userInfo objectForKey:@"autoDownload"] boolValue];
    }
    [self saveUserInfo];
}


- (void)saveUserInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (_isLoginUser) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        if (_username) [userInfo setObject:_username forKey:@"username"];
        if (_nickname) [userInfo setObject:_nickname forKey:@"nickname"];
        if (_avator) [userInfo setObject:_avator forKey:@"avator"];
        [userInfo setObject:@(_autoDownload) forKey:@"autoDownload"];
        [defaults setObject:userInfo forKey:KEY_USER_LOGIN_INFO];
    }
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NTESIMUserInfoChangedNotification object:nil];
    
}

@end
