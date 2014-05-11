//
//  GYJIMRenrenViewController.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-3-25.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYJMainBaseViewController.h"

@protocol RenRenOauthLoginDelegate <NSObject>

@optional
- (void)renRenOauthLoginSucceed;
- (void)renRenOauthLoginFailed;
@end

@interface GYJRenrenAuthorViewController : GYJMainBaseViewController
@property(nonatomic,weak) id<RenRenOauthLoginDelegate> delegate;
@end


