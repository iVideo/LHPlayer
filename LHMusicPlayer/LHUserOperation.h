//
//  LHUserOperation.h
//  LHMusicPlayer
//
//  Created by 郭亚娟 on 14-5-1.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHUser.h"

@class LHUserOperation;
typedef void(^UserManagerOperationSuccessBlock) (LHUserOperation *operation);
typedef void(^UserManagerOperationFailedBlock) (LHUserOperation *operation);

@protocol LHUserOperationDelegate <NSObject>

- (void)userOperationCompleted:(LHUserOperation *)operation;
- (void)userOperationFailed:(LHUserOperation *)operation;

@end

typedef enum _NTESIMUserOperationStatus{
    NTESIMUserOperationStatusPending = 0,
    NTESIMUserOperationStatusRunning,
    NTESIMUserOperationStatusCompleted,
    NTESIMUserOperationStatusFailed
}NTESIMUserOperationStatus;

@interface LHUserOperation : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, readonly) NTESIMUserOperationStatus status;

@property (nonatomic, assign) id <LHUserOperationDelegate> delegate;
@property (nonatomic, strong) LHUser *user;
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) NSError *error;

@property (nonatomic, copy) UserManagerOperationSuccessBlock successBlock;
@property (nonatomic, copy) UserManagerOperationFailedBlock failedBlock;

- (void)start;
@end
