//
//  GYJUserOperation.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-1.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYJUser.h"

@class GYJUserOperation;
typedef void(^UserManagerOperationSuccessBlock) (GYJUserOperation *operation);
typedef void(^UserManagerOperationFailedBlock) (GYJUserOperation *operation);

@protocol LHUserOperationDelegate <NSObject>

- (void)userOperationCompleted:(GYJUserOperation *)operation;
- (void)userOperationFailed:(GYJUserOperation *)operation;

@end

typedef enum _NTESIMUserOperationStatus{
    NTESIMUserOperationStatusPending = 0,
    NTESIMUserOperationStatusRunning,
    NTESIMUserOperationStatusCompleted,
    NTESIMUserOperationStatusFailed
}NTESIMUserOperationStatus;

@interface GYJUserOperation : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, readonly) NTESIMUserOperationStatus status;

@property (nonatomic, assign) id <LHUserOperationDelegate> delegate;
@property (nonatomic, strong) GYJUser *user;
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) NSError *error;

@property (nonatomic, copy) UserManagerOperationSuccessBlock successBlock;
@property (nonatomic, copy) UserManagerOperationFailedBlock failedBlock;

- (void)start;
@end
