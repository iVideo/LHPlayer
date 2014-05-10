//
//  NTESMTencentWeiboViewController.m
//  Magazine
//
//  Created by 范 岩峰 on 13-9-26.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NTESMTencentWeiboViewController.h"
#import "JSON.h"

#define TAG_SHARE_ACTION 1000
#define TAG_SHORTEN_ACTION 2000
#define PIC_BUTTON_TAG 9485

@interface NTESMTencentWeiboViewController ()
{
    BOOL _isImageAnimate;
}
@end

@implementation NTESMTencentWeiboViewController

@synthesize sharedContent;
@synthesize shouldRotate;
@synthesize sharedImage;
@synthesize sharedFloor;
@synthesize sharedArticle;
@synthesize sharedData;
@synthesize sharedOriginImage;
@synthesize hasPhoto;

#pragma mark -
#pragma mark View Related Methods

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id)init{
    if (self = [super init]) {
        [[NTESMTencentManager shareInstance] setTencentDelegate:self];
    }
    return self;
}

-(void)viewForIPhone{
    self.title = @"腾讯微博分享";
	self.view.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [[NTESMTencentManager shareInstance] setTencentDelegate:self];
    int yOffset = 0;
    if (SYSTEM_VERSION >= 7.0)
    {
        yOffset = 20;
    }
    
    [self addLeftButtonWithImage:[UIImage imageNamed:@"base_top_navigation_back.png"]
                          target:self action:@selector(doBack)];
    [self addRightButtonWithImage:[UIImage imageNamed:@"button_share_send_normal.png"] target:self action:@selector(shareButtonPressed)];
    
    //对话框
	shareTextView = [[UITextView alloc] init];
	shareTextView.font = [UIFont systemFontOfSize:16];
    shareTextView.textColor = RGBCOLOR(76, 76, 76);
	shareTextView.backgroundColor = [UIColor whiteColor];
	shareTextView.text = sharedContent;
	[shareTextView.layer setCornerRadius:10];
    [shareTextView.layer setBorderWidth: 1];
    [shareTextView.layer setBorderColor:[[UIColor colorWithHexString:@"E0E0E0"] CGColor]];
	shareTextView.frame = CGRectMake(10, 30+44+yOffset, self.customNaviBar.frame.size.width-20, 165);
	[self.view addSubview:shareTextView];
    
    //username
	usernameLabel = [[UILabel alloc] init];
	usernameLabel.font = [UIFont systemFontOfSize:14];
    usernameLabel.textColor = RGBCOLOR(76, 76, 76);
	usernameLabel.backgroundColor = [UIColor clearColor];
    usernameLabel.frame = CGRectMake(10,5+44+yOffset,250,20);
	[self.view addSubview:usernameLabel];
	
    //163字数
	numberLabel = [[UILabel alloc] init];
	numberLabel.font = [UIFont systemFontOfSize:14];
    numberLabel.textColor = RGBCOLOR(76, 76, 76);
	numberLabel.backgroundColor = [UIColor clearColor];
	numberLabel.textAlignment = NSTextAlignmentCenter;
	numberLabel.frame  = CGRectMake(self.customNaviBar.frame.size.width-125,5+44+yOffset,115,20);
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
    picButton.frame = CGRectMake(180+15, 8+44+yOffset, 10, 15);
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
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[NTESMTencentManager shareInstance] cancelRequest];
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

- (void)shareButtonPressed {
    NSString *username = [US objectForKey:LOGIN_USERNAME_TENCENT_KEY];
    NSString *userData = [US objectForKey:LOGIN_DATA_TENCENT_KEY];
    
	if(nil == username || nil == userData || [[NTESMTencentManager shareInstance] oauthExpired]) {
            //推出登录界面
        NSString *requestTokenUrl = [[NTESMTencentManager shareInstance] requestTencentAuthorizeUrl];
        UIViewController *viewController = [[NTESTCOAuthLoginController alloc] initWithUrlStr:requestTokenUrl];
		[self presentViewController:viewController animated:YES completion:nil];
    } else {
        
        int length = [self getLimit]-[shareTextView.text length] + 22;
        if (length < 0)
        {
            GYJAlert *alert = [[GYJAlert alloc] initAlertWithTitle:@"" message:@"您输入的内容字数超过限制，请重新输入" cancelTitle:@"确定" completeBlock:nil otherTitle:nil, nil];
            [alert show];
            return;
        }else if (shareTextView.text.length == 0)
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

- (void)picButtonDidClicked:(id)object {
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

- (void)buttonSelected:(NSString *)btnTitle {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[NTESMTencentManager shareInstance] cancelRequest];
}

#pragma mark -
#pragma mark Number Related Methods

- (int)getLimit{
	return 163;
}

- (BOOL)canBlank{
    return NO;
}

- (void)changeNumber:(NSNotification *)notification {
	int length = [self getLimit]-[shareTextView.text length] + 22;
    
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

//返回nil表示还没有登陆哦
- (NSString *)loginName{
    NSString *username = [US objectForKey:LOGIN_USERNAME_TENCENT_KEY];
    NSString *userData = [US objectForKey:LOGIN_DATA_TENCENT_KEY];
    NSString *bindString = nil;
	if (![[NTESMTencentManager shareInstance] oauthExpired] && userData != nil && username != nil) {
        bindString = @"已经认证";
    } else if ([[NTESMTencentManager shareInstance] oauthExpired]) {
        bindString = @"尚未认证";
        [[NTESMTencentManager shareInstance] removeAccessToken];
    } else {
        bindString = nil;
        [[NTESMTencentManager shareInstance] removeAccessToken];
    }
    
	return bindString;
}

- (NSString *)notLoginName{
	return @"尚未认证";
}

- (UIViewController *)newLoginController {
    NSString *requestTokenUrl = [[NTESMTencentManager shareInstance] requestTencentAuthorizeUrl];
    UIViewController *viewController = [[NTESTCOAuthLoginController alloc] initWithUrlStr:requestTokenUrl];
    return viewController;
}

#pragma mark -
#pragma mark share Methods

- (void)shareMicroBlogWithStatus:(NSString *)status {
    if (hasPhoto) {
        [[NTESMTencentManager shareInstance] sendTwitter:status image:sharedOriginImage];
    } else {
        [[NTESMTencentManager shareInstance] sendTwitter:status image:nil];
    }
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

#pragma mark - cancel Methods

- (void)logout{
    [[NTESMTencentManager shareInstance] removeAccessToken];
}

#pragma mark - tencentweiboDelegate Methods

- (void)finishSendTwitterWithSuccessStatus:(BOOL)success info:(NSString*)aInfo {
    if (success) {
        [NTESActivityToast sharedActivityToast].activeDelegate = nil;
        [[NTESActivityToast sharedActivityToast] stopSpinWithInfo:@"分享成功！" withButtonTitle:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [NTESActivityToast sharedActivityToast].activeDelegate = nil;
        [[NTESActivityToast sharedActivityToast] stopSpinWithInfo:@"分享失败！" withButtonTitle:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
