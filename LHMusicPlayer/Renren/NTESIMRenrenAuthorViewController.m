//
//  NTESIMRenrenViewController.m
//  iMoney
//
//  Created by Gavin Zeng on 14-3-25.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import "NTESIMRenrenAuthorViewController.h"
#import "NTESActivityToast.h"
#import "NTESIMRenrenManager.h"

@interface NTESIMRenrenAuthorViewController () <UIWebViewDelegate>
{
    UIWebView *_webView;
    NSMutableDictionary *_params;
}
@property(nonatomic,strong) NSString *serverURL;
@end

@implementation NTESIMRenrenAuthorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addLeftButtonWithImage:[UIImage imageNamed:@"base_top_navigation_back.png"] target:self action:@selector(dismissController)];
    [NTESActivityToast sharedActivityToast].activeDelegate = self;
    self.title = @"绑定人人网";
    [[NTESActivityToast sharedActivityToast] startSpinWithInfo:[NSString stringWithFormat:@"加载%@\n授权页面",@"人人网"] withButtonTitle:nil careLandscope:NO];
    
    _webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, self.customNaviBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
	_webView.delegate = self;
	if ([_webView respondsToSelector: @selector(setDetectsPhoneNumbers:)]) [(id) _webView setDetectsPhoneNumbers: NO];
	if ([_webView respondsToSelector: @selector(setDataDetectorTypes:)]) [(id) _webView setDataDetectorTypes: 0];
	[self.view addSubview: _webView];
    
    //发送授权请求
    [self authorization];
}

/*
 * 用户oauth2登录请求认证授权
 */
- (void)authorization{
    
    NSArray *permissions = [NSArray arrayWithObjects:@"read_user_album",@"status_update",@"photo_upload",@"publish_feed",@"create_album",@"operate_like",nil];
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray* graphCookies = [cookies cookiesForURL:
                             [NSURL URLWithString:@"http://graph.renren.com"]];
	
	for (NSHTTPCookie* cookie in graphCookies) {
		[cookies deleteCookie:cookie];
	}
	NSArray* widgetCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://widget.renren.com"]];
	
	for (NSHTTPCookie* cookie in widgetCookies) {
		[cookies deleteCookie:cookie];
	}
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:kRenRenAPI_Key forKey:@"client_id"];
    [parameters setValue:kRenRenSuccessURL forKey:@"redirect_uri"];
    [parameters setValue:@"token" forKey:@"response_type"];
    [parameters setValue:@"touch" forKey:@"display"];
    if (nil != permissions) {
        NSString *permissionScope = [permissions componentsJoinedByString:@","];
        [parameters setValue:permissionScope forKey:@"scope"];
    }
    [parameters setObject:kWidgetDialogUA forKey:@"ua"];
    
    NSURL *url = [self generateURL:kRenRenAuthBaseURL params:parameters];
    NSLog(@"start load URL: %@", url);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [_webView loadRequest:request];
    

}


- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
    if (params) {
        NSMutableArray* pairs = [NSMutableArray array];
        for (NSString* key in params.keyEnumerator) {
            NSString* value = [params objectForKey:key];
            NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                          NULL, /* allocator */
                                                                                          (CFStringRef)value,
                                                                                          NULL, /* charactersToLeaveUnescaped */
                                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                          kCFStringEncodingUTF8));
            
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
        }
        
        NSString* query = [pairs componentsJoinedByString:@"&"];
        NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
        return [NSURL URLWithString:url];
    } else {
        return [NSURL URLWithString:baseURL];
    }
}

/**
 * 解析URL参数的工具方法。
 */
- (NSDictionary *)parseURLParams:(NSString *)query{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString *val =[[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [params setObject:val forKey:[kv objectAtIndex:0]];
        }
	}
    return params;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissController{
    //browseView.delegate = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate Method

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *query = [url fragment]; // url中＃字符后面的部分。
    if (!query) {
        query = [url query];
    }
    NSDictionary *params = [self parseURLParams:query];
    NSString *accessToken = [params objectForKey:@"access_token"];
    NSString *errorReason = [params objectForKey:@"error"];
    if(nil != errorReason) {
        [self dialogDidCancel:nil];
        return NO;
    }
    if (navigationType == UIWebViewNavigationTypeLinkClicked)/*点击链接*/{
        BOOL userDidCancel = ((errorReason && [errorReason isEqualToString:@"login_denied"])||[errorReason isEqualToString:@"access_denied"]);
        if(userDidCancel){
            [self dialogDidCancel:url];
        }else {
            
            [[UIApplication sharedApplication] openURL:request.URL];
            
        }
        return NO;
    }
    if (navigationType == UIWebViewNavigationTypeFormSubmitted) {//提交表单
        //NSString *state = [params objectForKey:@"flag"];
        if (accessToken) {
            [self dialogDidSucceed:url];
        }
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (!([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)) {
        [self dismissWithError:error animated:YES];
    }
}

- (void)dialogDidCancel:(NSURL *)url {
    if ([self.delegate respondsToSelector:@selector(renRenOauthLoginFailed)]){
        [self.delegate renRenOauthLoginFailed];
    }
    [self close];
}

/*
 * 根据指定的参数名，从URL中找出并返回对应的参数值。
 */
- (NSString *)getValueStringFromUrl:(NSString *)url forParam:(NSString *)param {
    NSString * str = nil;
    NSRange start = [url rangeOfString:[param stringByAppendingString:@"="]];
    if (start.location != NSNotFound) {
        NSRange end = [[url substringFromIndex:start.location + start.length] rangeOfString:@"&"];
        NSUInteger offset = start.location+start.length;
        str = end.location == NSNotFound
        ? [url substringFromIndex:offset]
        : [url substringWithRange:NSMakeRange(offset, end.location)];
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return str;
}


- (NSDate *)getDateFromString:(NSString *)dateTime
{
	NSDate *expirationDate =nil;
	if (dateTime != nil) {
		int expVal = [dateTime intValue];
		if (expVal == 0) {
			expirationDate = [NSDate distantFuture];
		} else {
			expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
		}
	}
	
	return expirationDate;
}

- (void)dialogDidSucceed:(NSURL *)url {
	NSString *q = [url absoluteString];
	
    NSString *token = [self getValueStringFromUrl:q forParam:@"access_token"];
    NSString *expTime = [self getValueStringFromUrl:q forParam:@"expires_in"];
    NSDate   *expirationDate = [self getDateFromString:expTime];
    NSDictionary *responseDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:token,expirationDate,nil]
                                                            forKeys:[NSArray arrayWithObjects:@"token",@"expirationDate",nil]];
    [[NTESIMRenrenManager shareInstance] saveUserSessionInfo:responseDic];
    if ([self.delegate respondsToSelector:@selector(renRenOauthLoginSucceed)]) {
        
        [self.delegate renRenOauthLoginSucceed];
    }
    [self close];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RENREN_LOGIN object:nil];
    
}

- (void)dismissWithError:(NSError*)error animated:(BOOL)animated {

    if ([self.delegate respondsToSelector:@selector(renRenOauthLoginFailed)]) {
        
        [self.delegate renRenOauthLoginFailed];
    }
    
    [self close];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
