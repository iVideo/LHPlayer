//
//  NTESIMRenrenManager.h
//  iMoney
//
//  Created by Gavin Zeng on 14-3-26.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESIMRenrenCommon.h"


@interface NTESIMRenrenManager : NSObject

@property(nonatomic, copy) NSString *accessToken;

@property(nonatomic, copy) NSString *secret;

@property(nonatomic, copy) NSString *sessionKey;

@property(nonatomic, copy) NSDate *expirationDate;

+ (NTESIMRenrenManager *)shareInstance;
-(BOOL)isSessionValid;
-(void)saveUserSessionInfo:(NSDictionary *)dict;
-(void)delUserSessionInfo;
@end
