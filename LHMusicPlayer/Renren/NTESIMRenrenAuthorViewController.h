//
//  NTESIMRenrenViewController.h
//  iMoney
//
//  Created by Gavin Zeng on 14-3-25.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYJMainBaseViewController.h"

@protocol RenRenOauthLoginDelegate <NSObject>

@optional
- (void)renRenOauthLoginSucceed;
- (void)renRenOauthLoginFailed;
@end

@interface NTESIMRenrenAuthorViewController : GYJMainBaseViewController
@property(nonatomic,weak) id<RenRenOauthLoginDelegate> delegate;
@end


