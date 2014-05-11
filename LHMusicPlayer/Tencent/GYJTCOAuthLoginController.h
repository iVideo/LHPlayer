//
//  GYJTCOAuthLoginController.h
//  Magazine
//
//  Created by 郭亚娟 on 13-9-27.
//  Copyright (c) 2013年 郭亚娟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYJMainBaseViewController.h"

@protocol WebOauthDelegate;

@interface GYJTCOAuthLoginController : GYJMainBaseViewController{
  id <WebOauthDelegate> __weak oauthDelegate;
}

@property (nonatomic, weak) id <WebOauthDelegate> oauthDelegate;

- (id)initWithUrlStr:(NSString*)url;
@end

@protocol WebOauthDelegate<NSObject>;
@required
- (void) finishLoadWithAccessToken:(NSString*)accessToken;
- (void) finishedWebRequestWithStatus:(BOOL)success;
@end
