//
//  NTESNBOAuthLoginController.h
//  NewsBoard
//
//  Created by 王聪 on 11-4-8.
//  Copyright 2011 NetEase.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESActivityToast.h"
#import "WBEngine.h"
#import "GYJMainBaseViewController.h"

@protocol OauthLoginDelegate;

@interface NTESNBOAuthLoginController : GYJMainBaseViewController<UIWebViewDelegate, NTESActivityToastDelegate> {
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
