//
//  GYJIMRenrenManager.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-3-26.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYJRenrenCommon.h"


@interface GYJRenrenManager : NSObject

@property(nonatomic, copy) NSString *accessToken;

@property(nonatomic, copy) NSString *secret;

@property(nonatomic, copy) NSString *sessionKey;

@property(nonatomic, copy) NSDate *expirationDate;

+ (GYJRenrenManager *)shareInstance;
-(BOOL)isSessionValid;
-(void)saveUserSessionInfo:(NSDictionary *)dict;
-(void)delUserSessionInfo;
@end
