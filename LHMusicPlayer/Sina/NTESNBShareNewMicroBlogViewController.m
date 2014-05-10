//
//  NTESNBShareNewMicroBlogViewController.m
//  网易微博iPhone客户端
//
//  Created by 范岩峰 on 11-2-22.
//  Copyright 2011 NetEase.com, Inc. All rights reserved.
//

#import "NTESNBShareNewMicroBlogViewController.h"
#import "JSON.h"
#import "NTESNBOAuthLoginController.h"

#define TAG_SHARE_ACTION 1000
#define TAG_SHORTEN_ACTION 2000
#define PIC_BUTTON_TAG 9485

@interface NTESNBShareNewMicroBlogViewController(PrivateMethod)

- (void)rotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

@implementation NTESNBShareNewMicroBlogViewController

@synthesize sharedContent;
@synthesize shouldRotate;
@synthesize sharedImage;
@synthesize sharedFloor;
@synthesize sharedArticle;
@synthesize errMsg;
@synthesize sharedData;
@synthesize sharedOriginImage;
@synthesize hasPhoto;

#pragma mark -
#pragma mark View Related Methods

const NSUInteger limitNumber = 140;

- (void)dealloc {	
	[[NSNotificationCenter defaultCenter] removeObserver:self];	
    if (connection) {
        [connection cancel];
        connection = nil;
    }
    if (buf) {
        buf = nil;
    }
}


- (id)init{
    if (self = [super init]) {
        buf = [[NSMutableData alloc] init];
        if (!_engine){
            _engine = [self newEngine];
            [_engine authorize];
        }
    }
    return self;
}

-(void)viewForIPhone{
    self.title = @"新浪微博分享";
	self.view.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self addLeftButtonWithImage:[UIImage imageNamed:@"base_top_navigation_back.png"]
                          target:self action:@selector(doBack)];
    [self addRightButtonWithImage:[UIImage imageNamed:@"button_share_send_normal.png"] target:self action:@selector(shareButtonPressed)];
    int yOffset = 0;
    if (SYSTEM_VERSION >= 7.0)
    {
        yOffset = 20;
    }

	//对话框
	shareTextView = [[UITextView alloc] init];
	shareTextView.font = [UIFont systemFontOfSize:16];
    shareTextView.textColor = RGBCOLOR(76, 76, 76);
	shareTextView.backgroundColor = [UIColor whiteColor];
	shareTextView.text = sharedContent;
	[shareTextView.layer setCornerRadius:10];
    [shareTextView.layer setBorderWidth: 1];
    [shareTextView.layer setBorderColor:[[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0] CGColor]];
	shareTextView.frame = CGRectMake(10, 30+44 + yOffset, self.customNaviBar.frame.size.width-20, 165);
	[self.view addSubview:shareTextView];
    
	//username
	usernameLabel = [[UILabel alloc] init];
	usernameLabel.font = [UIFont systemFontOfSize:14];
    usernameLabel.textColor = RGBCOLOR(76, 76, 76);
	usernameLabel.backgroundColor = [UIColor clearColor];
    usernameLabel.frame = CGRectMake(10,5+44 + yOffset,250,20);
	[self.view addSubview:usernameLabel];
	
	//163字数
	numberLabel = [[UILabel alloc] init];
	numberLabel.font = [UIFont systemFontOfSize:14];
    numberLabel.textColor = RGBCOLOR(76, 76, 76);
	numberLabel.backgroundColor = [UIColor clearColor];
	numberLabel.textAlignment = NSTextAlignmentCenter;
	numberLabel.frame  = CGRectMake(self.customNaviBar.frame.size.width-125,5+44 + yOffset,115,20);
	[self.view addSubview:numberLabel];
    
	[self changeNumber:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNumber:) name:UITextViewTextDidChangeNotification object:shareTextView];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
    
    //出keyboard
    [shareTextView becomeFirstResponder];
	
    
    picButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [picButton setTag:PIC_BUTTON_TAG];
    picButton.frame = CGRectMake(180+15, 8+44 + yOffset, 10, 15);
    [picButton addTarget:self action:@selector(picButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:picButton];
    
    if (sharedOriginImage) {
        [picButton setImage:sharedOriginImage forState:UIControlStateNormal];
    } else {
        [picButton setImage:[UIImage imageWithData:sharedData] forState:UIControlStateNormal];
    }
        
    hasPhoto = NO;
    
  
}

- (void)viewDidLoad {
    [super viewDidLoad];	    
    [self viewForIPhone];
}

- (void)viewWillDisappear:(BOOL)animated {	
	[super viewWillDisappear:animated];

	[shareTextView resignFirstResponder];
    
    [self cancelCurrentRequest];
}
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	NSString *userId = [self loginName];
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	usernameLabel.text = userId?userId:[self notLoginName];
	shareTextView.selectedRange = NSMakeRange(0, 0);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_isImageAnimate) {
        _isImageAnimate = YES;
        if (sharedData) {
            if (nil != sharedData) {
                [self picButtonDidClicked:picButton];
                [self imageButtonZoomingAnimation:YES];
            }else {
                [picButton setHidden:YES];
            }
        }
        
        if (sharedOriginImage) {
            if (nil != sharedOriginImage) {
                [self picButtonDidClicked:picButton];
                [self imageButtonZoomingAnimation:YES];
            }else {
                [picButton setHidden:YES];
            }
        }

    }
}

- (void)keyboardDidShow:(NSNotification *)notification {
	float keyboardHeight;
	
	if (SYSTEM_VERSION>=3.2) {
		CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
		keyboardHeight = keyboardRect.size.height;
	}else {
		keyboardHeight = 216.0;
	}
    float textHeight = 480-44-20 - 5 -30-keyboardHeight;/*44 nav，20 statusbar, 5 padding, 30 origin*/
    CGRect f = shareTextView.frame;
    f.size.height = textHeight;
    shareTextView.frame = f;
}

#pragma mark -
#pragma mark newEngine Methods
- (WBEngine *) newEngine{
    //NSLog(@"please overide");
    WBEngine *_newEngine = [[WBEngine alloc] initWithAppKey:SINA_APPKEY appSecret:SINA_SECRET];
    [_newEngine setDelegate:self];
    [_newEngine setRedirectURI:@"http://"];
    [_newEngine setIsUserExclusive:NO];
    return _newEngine;
}


#pragma mark
#pragma makr WBEngineDelegate method

- (void)storeCachedOAuthData: (NSString *) data forUsername: (NSString *) username {
        //NSLog(@"authData:\n%@",data);
	NSUserDefaults *defaults = US;
    if ([data length]) {
        [defaults setObject: data forKey: LOGIN_DATA_SINA_KEY];
        [defaults setObject:username forKey:LOGIN_USERNAME_SINA_KEY];
        
        // 绑定成功，发个消息
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SINA_LOGIN object:nil];
    }else {
        [defaults removeObjectForKey:LOGIN_USERNAME_SINA_KEY];
        [defaults removeObjectForKey:LOGIN_DATA_SINA_KEY];
    }
	
	[defaults synchronize];
}

- (void)removeCachedOAuthData {
    [US removeObjectForKey:LOGIN_USERNAME_SINA_KEY];
    [US removeObjectForKey:LOGIN_DATA_SINA_KEY];
}

- (void)engineDidLogIn:(WBEngine *)engine withTokenString:(NSString*)tokenString{
    [self storeCachedOAuthData:tokenString forUsername:engine.userID];
    [[NTESActivityToast sharedActivityToast] startSpinWithInfo:[NSString stringWithFormat:@"认证成功"] withButtonTitle:nil careLandscope:NO];

    [_loginController dismissController];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error{
    [[NTESActivityToast sharedActivityToast] startSpinWithInfo:[NSString stringWithFormat:@"认证失败"] withButtonTitle:nil careLandscope:NO];
}

- (BOOL)isAuthorizeExpired{
    if (_engine == nil) {
        _engine = [[WBEngine alloc] initWithAppKey:SINA_APPKEY appSecret:SINA_SECRET];
        [_engine setDelegate:self];
        [_engine setRedirectURI:@"http://"];
        [_engine setIsUserExclusive:NO];
    }
    if (_engine) {
        return [_engine isAuthorizeExpired];
    }else {
        return YES;
    }
}

- (void)saveSinaOA2Token:(NSString *)sinaToken{
    if (_engine == nil) {
        _engine = [[WBEngine alloc] initWithAppKey:SINA_APPKEY appSecret:SINA_SECRET];
        [_engine setDelegate:self];
        [_engine setRedirectURI:@"http://"];
        [_engine setIsUserExclusive:NO];
    }
    
    if (_engine) {
        [_engine saveAuthorizedTokenString:sinaToken];
    }
    return;
}

#pragma mark -
#pragma mark animation Methods
- (void)imageButtonZoomingAnimation:(BOOL)show{
    if (NO == show) {
        return;
    }

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGAffineTransform newTransform =  CGAffineTransformScale(picButton.transform, 5.0, 5.0);
        [picButton setTransform:newTransform];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGAffineTransform newTransform =  CGAffineTransformScale(picButton.transform, 0.2, 0.2);
            [picButton setTransform:newTransform];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                CGAffineTransform newTransform =  CGAffineTransformScale(picButton.transform, 1.0, 1.0);
                [picButton setTransform:newTransform];
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return interfaceOrientation ==UIInterfaceOrientationPortrait;
}

#pragma mark -
#pragma mark button clicked actions

- (void)doBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareButtonPressed {	// TODO...
    NSString *username = [US objectForKey:LOGIN_USERNAME_SINA_KEY];
    NSString *userData = [US objectForKey:LOGIN_DATA_SINA_KEY];
    
	if(nil == username || nil == userData || !![self isAuthorizeExpired])
	{
		//推出登录界面
		UIViewController *viewController = [self newLoginController];
		[self presentViewController:viewController animated:YES completion:nil];
	} 
	else 
	{
        int length = [self getLimit]-[shareTextView.text length];
        if (length < 0)
        {
            GYJAlert *alert = [[GYJAlert alloc] initAlertWithTitle:@"" message:@"您输入的 内容字数超过限制，请重新输入" cancelTitle:@"确定" completeBlock:nil otherTitle:nil, nil];
            [alert show];
            return;
        }
        else if(length == limitNumber)
        {
            GYJAlert *alert = [[GYJAlert alloc] initAlertWithTitle:@"" message:@"请输入分享内容" cancelTitle:@"确定" completeBlock:nil otherTitle:nil, nil];
            [alert show];
            return;
        }
		[NTESActivityToast sharedActivityToast].activeDelegate = self;
		[NTESActivityToast sharedActivityToast].tag = TAG_SHARE_ACTION;
		[[NTESActivityToast sharedActivityToast] startSpinWithInfo:@"发送中" withButtonTitle:@"取消" careLandscope:NO];
        NSString *text = shareTextView.text;
        if ([text hasPrefix:@" //"]) {//如果用户什么都没有写，就不要提交这个分隔符了
            text = [text substringFromIndex:3];
        }
        self.sharedContent = text;
        [self shareMicroBlogWithStatus:sharedContent];       
	}
}

- (void)picButtonDidClicked:(id)object{
    UIButton *selectedBtn = (UIButton*)object;
    UIImage *selectedImage;
    if (YES == hasPhoto) {
        hasPhoto = NO;
        selectedImage = [UIImage imageNamed:@"microblog_non_image.jpg"];
    }else {
        if (sharedOriginImage) {
            selectedImage = sharedOriginImage;
        } 
        if (sharedData) {
            selectedImage = [UIImage imageWithData:sharedData];
        }
        hasPhoto = YES;
    }
   
    [selectedBtn setImage:selectedImage forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark ActiveViewDelegate delegate Methods

- (void)buttonSelected:(NSString *)btnTitle{
    [self cancelCurrentRequest];
}

#pragma mark -
#pragma mark Number Related Methods

- (void) changeNumber:(NSNotification *) notification
{
	int length = [self getLimit]-[shareTextView.text length];

	numberLabel.text=[NSString stringWithFormat:@"还可输入%d字", length];
    numberLabel.textColor = RGBCOLOR(76, 76, 76);
	if(length<0){
		numberLabel.textColor = [UIColor redColor];
		numberLabel.text=[NSString stringWithFormat:@"已超%d字", -1*length];
	}else if (length==[self getLimit]) {
        if (![self canBlank]) {
        }
		
	}else{ 
		numberLabel.textColor = RGBCOLOR(76, 76, 76);
	}
	
}

#pragma mark -
#pragma mark other weibo Methods
- (NSString *) getTitle{
	return [NSString stringWithFormat:@"分享"];
}
- (int) getLimit{
	return limitNumber;
}

- (BOOL) canBlank{
    return NO;
}

//返回nil表示还没有登陆哦
- (NSString *) loginName{
    NSString *username = [US objectForKey:LOGIN_USERNAME_SINA_KEY];
    NSString *userData = [US objectForKey:LOGIN_DATA_SINA_KEY];
    NSString *bindString = nil;
	if (![self isAuthorizeExpired] && userData != nil && username != nil) {
        bindString = @"已经认证";
    } else if ([self isAuthorizeExpired]) {
        bindString = @"尚未认证";
        [self removeCachedOAuthData];
    } else {
        bindString = nil;
        [self removeCachedOAuthData];
    }
    
	return bindString;
}

- (NSString *) notLoginName{
	return @"尚未认证";
}

- (UIViewController *) newLoginController{
	_loginController = [[NTESNBOAuthLoginController alloc] initWithOA2Engine: _engine];
	return _loginController;
}


#pragma mark -
#pragma mark prepare Methods

- (NSString*)encodeAsURIComponent:(NSString *)uri
{
	const char* p = [uri UTF8String];
	NSMutableString* result = [NSMutableString string];
	
	for (;*p ;p++) {
		unsigned char c = *p;
		if (('0' <= c && c <= '9') || ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') || (c == '-' || c == '_')) {
			[result appendFormat:@"%c", c];
		} else {
			[result appendFormat:@"%%%02X", c];
		}
	}
	return result;
}



#pragma mark -
#pragma mark share Methods

- (void)shareMicroBlogWithStatus:(NSString *)status {
    if (hasPhoto) {
        [_engine sendWeiBoWithText:status image:sharedOriginImage];
    } else {
        [_engine sendWeiBoWithText:status image:nil];
    }
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)delayShare{
    [self shareMicroBlogWithStatus:sharedContent];
}

#pragma mark - WBEngineDelegate Methods

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error {
	[NTESActivityToast sharedActivityToast].activeDelegate = nil;
	[[NTESActivityToast sharedActivityToast] stopSpinWithInfo:@"分享失败！" withButtonTitle:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result {
    [NTESActivityToast sharedActivityToast].activeDelegate = nil;
	[[NTESActivityToast sharedActivityToast] stopSpinWithInfo:@"分享成功！" withButtonTitle:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark cancel Methods
- (void)cancelCurrentRequest{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;    
//    if (imageRequest) {
//        [imageRequest clearDelegatesAndCancel];
//        imageRequest = nil;
//    }

    if (connection) {
        [connection cancel];
        connection = nil;
    }
    [buf setLength:0];

}

- (void)logout{
  if (_engine == nil) {
    _engine = [[WBEngine alloc] initWithAppKey:SINA_APPKEY appSecret:SINA_SECRET];
    [_engine setDelegate:self];
    [_engine setRedirectURI:@"http://"];
    [_engine setIsUserExclusive:NO];
  }
  [_engine logOut];
  [self removeCachedOAuthData];
}

+ (BOOL)isSinaWeiboBinded
{
    NSString *username  = [US objectForKey:LOGIN_USERNAME_SINA_KEY];
    NSString *userData = [US objectForKey:LOGIN_DATA_SINA_KEY];

    BOOL isAuthorizeExpired = NO;
    WBEngine *engine = [[WBEngine alloc] initWithAppKey:SINA_APPKEY appSecret:SINA_SECRET];
    [engine setRedirectURI:@"http://"];
    [engine setIsUserExclusive:NO];
    isAuthorizeExpired = [engine isAuthorizeExpired];
    
    if (!isAuthorizeExpired && userData && username)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
