//
//  GYJNBOAuthLoginController.h
//
//  Created by 郭亚娟 on 11-4-8.
//  Copyright 2011 郭亚娟.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYJActivityToast.h"
#import "WBEngine.h"
#import "GYJMainBaseViewController.h"

@protocol OauthLoginDelegate;

@interface GYJOAuthLoginController : GYJMainBaseViewController<UIWebViewDelegate, NTESActivityToastDelegate> {
	WBEngine *_engine;
	UIWebView *_webView;
}

@property (nonatomic, retain) WBEngine *engine;
@property (nonatomic, weak) id <OauthLoginDelegate> delegate;

- (id) initWithOA2Engine: (WBEngine*)engine;
- (void)dismissController;

@end

@protocol OauthLoginDelegate <NSObject>

@optional
- (void)oauthLoginSucceed;
- (void)oauthLoginFailed;
@end
