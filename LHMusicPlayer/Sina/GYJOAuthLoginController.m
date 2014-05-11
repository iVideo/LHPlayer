//
//  GYJNBOAuthLoginController.m
//
//  Created by 郭亚娟 on 11-4-8.
//  Copyright 2011 郭亚娟.com, Inc. All rights reserved.
//

#import "GYJOAuthLoginController.h"


@implementation GYJOAuthLoginController
@synthesize engine = _engine, delegate = _delegate;

- (id)initWithOA2Engine:(WBEngine *)engine{
    if (self = [super init]) {
        self.engine = engine;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
    [self.engine loginWithWebview:_webView];
}

#pragma mark View Controller Stuff
- (void)viewDidLoad {
    [super viewDidLoad];
	[GYJActivityToast sharedActivityToast].activeDelegate = self;
    [self addLeftButtonWithImage:[UIImage imageNamed:@"base_top_navigation_back.png"] target:self action:@selector(dismissController)];
    self.title = @"认证新浪微博";
    
    [[GYJActivityToast sharedActivityToast] startSpinWithInfo:[NSString stringWithFormat:@"加载%@\n授权页面",@"新浪微博"] withButtonTitle:nil careLandscope:NO];

	_webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, self.customNaviBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
	_webView.delegate = self;
	if ([_webView respondsToSelector: @selector(setDetectsPhoneNumbers:)]) [(id) _webView setDetectsPhoneNumbers: NO];
	if ([_webView respondsToSelector: @selector(setDataDetectorTypes:)]) [(id) _webView setDataDetectorTypes: 0];
	
	[self.view addSubview: _webView];
	
//	//shadow
//	UIImageView *shadow =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_navigation_shadow.png"]];
//	[self.view addSubview:shadow];
//	
//        //返回按钮　退出模态
//    UIImage *backImage = [UIImage imageNamed:@"button_nav_back.png"];
////    UIImage *backImageSel = [UIImage imageNamed:@"button_nav_back_selected.png"];
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(-5, 0, backImage.size.width, backImage.size.height);
//    [backBtn setImage:backImage forState:UIControlStateNormal];
////    [backBtn setImage:backImageSel forState:UIControlStateHighlighted];
//    [backBtn addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:backBtn];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    
}

- (void)buttonSelected:(NSString *)btnTitle{
    
	if ([_webView isLoading]) {
		[_webView stopLoading];
	}
	[self dismissController];
}


- (void)dismissController{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	if ([error code]==102) {
            //是我们的自定义oauth://
		return;
	}
	[[GYJActivityToast sharedActivityToast] stopSpinWithInfo:@"授权页面加载失败" withButtonTitle:@"确定"];
    
}


- (void) webViewDidFinishLoad: (UIWebView *) webView {
    [webView stringByEvaluatingJavaScriptFromString:@"\
     document.getElementsByClassName('btn_gray')[0].href='close://';\
     document.getElementsByClassName('rt_link')[0].style.display='none';"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL) webView: (UIWebView *) webView shouldStartLoadWithRequest: (NSURLRequest *) request navigationType: (UIWebViewNavigationType) navigationType {
        // 新浪微博oauth2认证分支
    NSRange range = [request.URL.absoluteString rangeOfString:@"code="];
    
    if (range.location != NSNotFound)
        {
        NSString *code = [request.URL.absoluteString substringFromIndex:range.location + range.length];
        
        if (![code isEqualToString:@"21330"])
            {
            [self.engine.authorize beginToRequestAccessTokenWithAuthorizeCode:code];
            return NO;
            }else {
                [self dismissController];
                return NO;
            }
        }
    return YES;
    
	NSString* urlString = [[request URL] absoluteString];

    
    if ([urlString hasPrefix:@"close://"]){
		[self dismissController];
		return NO;
	}
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
	return YES;
}

- (void)dealloc {
	if ([_webView isLoading]) {
		[_webView stopLoading];
	}
	_webView.delegate = nil;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	self.engine = nil;
}

@end
