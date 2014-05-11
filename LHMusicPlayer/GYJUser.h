//
//  GYJUser.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-1.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYJUser : NSObject
@property (nonatomic, strong) NSString *username;//通行证
@property (nonatomic, strong) NSString *nickname;//昵称
@property (nonatomic, strong) NSString *avator;
@property (nonatomic, assign) BOOL autoDownload;
@property (nonatomic, assign) BOOL isLoginUser;
@property (nonatomic, readonly) NSString *userid;

- (id)initLocalUser;
- (id)initLoginUserWith:(NSString *)userName;
- (void)updateUserInfoWith:(NSDictionary *)userInfo;
- (void)saveUserInfo;
@end
