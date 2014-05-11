//
//  LHUserManager.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-1.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYJUserOperation.h"
@class GYJUser;

@class GYJUserManager;
@protocol LHUserManagerDelegate <NSObject>
@optional
- (void)userCommitNickName:(BOOL)success errorInfo:(NSString *)errorInfo;
- (void)userLoginSucceeded;
- (void)userloginFailedWithErrorType:(NSInteger)errorType;
@end

@interface GYJUserManager : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate,LHUserOperationDelegate>

@property (nonatomic, weak) NSObject <LHUserManagerDelegate> *delegate;
@property (nonatomic, strong) GYJUser *currentUser;

+ (GYJUserManager *)defaultManager __attribute__((const));
- (void)loginNeteaseWithUsername:(NSString *)username password:(NSString *)password;
- (BOOL)isLoginUser;
- (void)logoutLoginUser;

#pragma mark - 下面四个方法中的key均为NTESIMAPIURL.h文件中定义的API接口
#pragma mark - 数据处理由delegate方法完成
- (void)updateUserDataForKey:(NSString *)key;
- (void)updateUserDataForKey:(NSString *)key parameters:(NSDictionary *)parameters;

#pragma mark - 将数据处理逻辑移到block中，不再需要delegate
- (void)updateUserDataForKey:(NSString *)key
                     success:(UserManagerOperationSuccessBlock)success
                      failed:(UserManagerOperationFailedBlock)failed;

- (void)updateUserDataForKey:(NSString *)key
                  parameters:(NSDictionary *)parameters
                     success:(UserManagerOperationSuccessBlock)success
                      failed:(UserManagerOperationFailedBlock)failed;

@end
