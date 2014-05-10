//
//  NTESTCOAuthLoginController.m
//  Magazine
//
//  Created by 范 岩峰 on 13-9-27.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NTESTCOAuthLoginController.h"
#import "NTESMTencentManager.h"
#import "NTESActivityToast.h"

@interface NTESTCOAuthLoginController() <UIWebViewDelegate>{
    UIWebView *browseView;
    NSString *_urlStr;
}
@property (nonatomic, retain) NSString *urlStr;
@end


@implementation NTESTCOAuthLoginController
@synthesize oauthDelegate;

@synthesize urlStr = _urlStr;

- (id)initWithUrlStr:(NSString*)url{
    if (self = [super init]) {
        self.urlStr = url;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftButtonWithImage:[UIImage imageNamed:@"base_top_navigation_back.png"] target:self action:@selector(dismissController)];
    [NTESActivityToast sharedActivityToast].activeDelegate = self;
    self.title = @"绑定腾讯微博";
    [[NTESActivityToast sharedActivityToast] startSpinWithInfo:[NSString stringWithFormat:@"加载%@\n授权页面",@"腾讯微博"] withButtonTitle:nil careLandscope:NO];
    
	browseView = [[UIWebView alloc] initWithFrame: CGRectMake(0, self.customNaviBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
	browseView.delegate = self;
	if ([browseView respondsToSelector: @selector(setDetectsPhoneNumbers:)]) [(id) browseView setDetectsPhoneNumbers: NO];
	if ([browseView respondsToSelector: @selector(setDataDetectorTypes:)]) [(id) browseView setDataDetectorTypes: 0];
	
	[self.view addSubview: browseView];
	
    if (_urlStr.length > 0) {
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
        [browseView loadRequest:requestObj];
    }    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - WebView

/*
 * 当前网页视图被指示载入内容时得到通知，返回yes开始进行加载
 */
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL* url = request.URL;
    NSString *urlStr = [url absoluteString];
    
    if ([urlStr hasPrefix:@"close://"]){
		[self dismissController];
		return NO;
	}
    
    NSRange tokenRange = [urlStr rangeOfString:@"#access_token="];
    if (tokenRange.length > 0) {
        NSArray *tokenList = [urlStr componentsSeparatedByString:@"#"];
        BOOL success = NO;
        NSString *info = nil;
        if (2 == [tokenList count]) {
            NSString *accessToken = [tokenList objectAtIndex:1];
            if (accessToken.length > 0) {
                [[NTESMTencentManager shareInstance] storageAccessToken:accessToken];
                    // 绑定成功，发个消息
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TENCENT_LOGIN object:nil];

                if (oauthDelegate && [oauthDelegate respondsToSelector:@selector(finishLoadWithAccessToken:)]) {
                    [oauthDelegate finishLoadWithAccessToken:accessToken];
                }
                success = YES;
                info = @"绑定成功";
            }else{
                success = NO;
                info = @"绑定失败";
            }
        }else{
            success = NO;
            info = @"绑定失败";
        }
        
        [[NTESActivityToast sharedActivityToast] stopSpinWithInfo:info withButtonTitle:nil];
        
        if (oauthDelegate && [oauthDelegate respondsToSelector:@selector(finishedWebRequestWithStatus:)]) {
            [oauthDelegate finishedWebRequestWithStatus:success];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return NO;
    }else{
        return YES;
    }
    
    return YES;
}

/*
 * 当网页视图结束加载一个请求后得到通知
 */
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    NSString *finishUrl = webView.request.URL.absoluteString;
        //NSLog(@"web view finish load URL %@", finishUrl);
    if ([finishUrl rangeOfString:@"authorize"].length > 0) {
            //    [[NTESNBActivityWindow sharedWindow] quicklyStopSpin];
    }
}

/*
 * 页面加载失败时得到通知，可根据不同的错误类型反馈给用户不同的信息
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
        //NSLog(@"no network:errcode is %d, domain is %@", error.code, error.domain);
    [[NTESActivityToast sharedActivityToast] stopSpinWithInfo:@"请求失败" withButtonTitle:nil];
}

- (void)activityWindowButtonClicked:(NSString *)btnTitle{
    browseView.delegate = nil;
    [[NTESActivityToast sharedActivityToast] stopSpinWithInfo:@"授权取消！" withButtonTitle:nil];
    if (oauthDelegate && [oauthDelegate respondsToSelector:@selector(finishedWebRequestWithStatus:)]) {
        [oauthDelegate finishedWebRequestWithStatus:NO];
    }
    
    browseView.delegate = self;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissController{
    browseView.delegate = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
