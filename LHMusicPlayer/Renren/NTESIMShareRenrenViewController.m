//
//  NTESIMShareRenrenViewController.m
//  iMoney
//
//  Created by Gavin Zeng on 14-3-26.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import "NTESIMShareRenrenViewController.h"
#import "NTESIMRenrenManager.h"
#import "NTESIMRenrenAuthorViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "SBJsonParser.h"
#import "RORequestParam.h"
#import "RORequest.h"
#import "ROPublishPhotoRequestParam.h"

#define TAG_SHARE_ACTION 1000
#define TAG_SHORTEN_ACTION 2000
#define TAG_SHARE_ACTION 1000
#define TAG_SHORTEN_ACTION 2000
#define PIC_BUTTON_TAG 9485

@interface NTESIMShareRenrenViewController ()<UITextViewDelegate,RORequestDelegate>
{
    UITextView *shareTextView;
	UILabel *numberLabel;
	UILabel *usernameLabel;
	
	NSString *sharedContent;
	NSString *sharedImage;
	NSDictionary *sharedFloor;
	NSString *sharedArticle;
    NSData *sharedData;
    UIImage *sharedOriginImage;
	
    //分享失败具体原因
    NSString *errMsg;
    //分享图片开关
    UIButton *picButton;
	int code;
    BOOL shouldRotate;
    BOOL hasPhoto;
    BOOL _isImageAnimate;
    AFHTTPRequestOperation *_sendOperation;
}
@end

@implementation NTESIMShareRenrenViewController
@synthesize sharedContent;
@synthesize sharedImage;
@synthesize sharedOriginImage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewForIPhone{
    self.title = @"人人网分享";
	self.view.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self viewForIPhone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
	[shareTextView resignFirstResponder];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_sendOperation cancel];
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

- (void)doBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareButtonPressed {
	if(![[NTESIMRenrenManager shareInstance] isSessionValid]) {
        //推出登录界面
        UIViewController *viewController = [[NTESIMRenrenAuthorViewController alloc] init];
		[self presentViewController:viewController animated:YES completion:nil];
    } else {
        [NTESActivityToast sharedActivityToast].activeDelegate = self;
        [NTESActivityToast sharedActivityToast].tag = TAG_SHARE_ACTION;
        [[NTESActivityToast sharedActivityToast] startSpinWithInfo:@"发送中" withButtonTitle:@"取消" careLandscope:NO];
        NSString *text = shareTextView.text;
        if ([text hasPrefix:@" //"]) {//如果用户什么都没有写，就不要提交这个分隔符了
            text = [text substringFromIndex:3];
        }
        
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
        self.sharedContent = text;
        [self shareToRenren];
        
        //[self shareMicroBlogWithStatus:sharedContent];
    }
}

/**
 * 针对人人开放平台接口传参需求生成随机CallId的工具方法。
 */
- (NSString *)generateCallId{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

/**
 * 对输入的字符串进行MD5计算并输出验证码的工具方法。
 */
- (NSString *)md5HexDigest:(NSString *)input{
    const char* str = [input UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(str, strlen(str), result);
    NSMutableString *returnHashSum = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [returnHashSum appendFormat:@"%02x", result[i]];
    }
	
	return returnHashSum;
}

/**
 * 针对人人开放平台接口传参需求计算sig码的工具方法。
 */
- (NSString *)generateSig:(NSMutableDictionary *)paramsDict secretKey:(NSString *)secretKey{
    NSMutableString* joined = [NSMutableString string];
	NSArray* keys = [paramsDict.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	for (id obj in [keys objectEnumerator]) {
		id value = [paramsDict valueForKey:obj];
		if ([value isKindOfClass:[NSString class]]) {
			[joined appendString:obj];
			[joined appendString:@"="];
			[joined appendString:value];
		}
	}
	[joined appendString:secretKey];
	return [self md5HexDigest:joined];
}

-(void)setGeneralRequestArgs: (RORequestParam *)inRequestParam{
    // 这里假设此前已经调用[self isSessionValid],并且返回Ture。
    inRequestParam.sessionKey = [[NTESIMRenrenManager shareInstance] sessionKey];
    inRequestParam.apiKey = kRenRenAPI_Key;
    inRequestParam.callID = [self generateCallId];
    inRequestParam.xn_ss = @"1";
    inRequestParam.format = @"json";
    inRequestParam.apiVersion = kRenRenSDKversion;
	
    inRequestParam.sig = [self generateSig:[inRequestParam requestParamToDictionary] secretKey:[[NTESIMRenrenManager shareInstance] secret]];
}

// 新的接口。
- (void)sendRequestWithUrl:(NSString *)url param:(RORequestParam *)param httpMethod:(NSString *)httpMethod delegate:(id<RORequestDelegate>)delegate{
    
    //delegate = delegate?delegate:self;
    RORequest *request = [RORequest getRequestWithParam:param httpMethod:httpMethod delegate:delegate requestURL:url];
    [request connect];
}

- (void)shareToRenren
{
    ROPublishPhotoRequestParam *param = [[ROPublishPhotoRequestParam alloc] init];
    param.caption = self.sharedContent;
    param.imageFile = sharedOriginImage;
    [self setGeneralRequestArgs:param];
    [self sendRequestWithUrl:kRenRenRestserverBaseURL param:param httpMethod:@"POST" delegate:self];
    
//    return;
//    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
//    [paramDict setObject:@"json" forKey:@"format"];
//    [paramDict setObject:kRenRenSDKversion forKey:@"v"];
//    [paramDict setObject:@"photos.upload" forKey:@"method"];
//    [paramDict setObject:kRenRenAPI_Key forKey:@"api_key"];
//    [paramDict setObject:[[NTESIMRenrenManager shareInstance] sessionKey] forKey:@"session_key"];
//    [paramDict setObject:[self generateCallId] forKey:@"call_id"];
//    [paramDict setObject:@"1" forKey:@"xn_ss"];
//    [paramDict setObject:[self generateSig:paramDict secretKey:[[NTESIMRenrenManager shareInstance] secret]] forKey:@"sig"];
//    [paramDict setObject:self.sharedContent forKey:@"caption"];
//    UIImage *storedImage = sharedOriginImage;
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:kRenRenRestserverBaseURL relativeToURL:manager.baseURL] absoluteString] parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
//                                    {
//                                        if (storedImage && storedImage.size.width > 0 && storedImage.size.height > 0 )
//                                        {
//                                            [formData appendPartWithFileData:UIImageJPEGRepresentation(sharedOriginImage, 1.0) name:@"upload" fileName:@"no.png" mimeType:@"image/jpeg"];
//                                        }
//                                        
//                                    } error:nil];
//    UIDevice *device = [UIDevice currentDevice];
//    NSString *ua = [NSString stringWithFormat:@"%@ (%@; %@ %@)",kUserAgent,device.model,device.systemName,device.systemVersion];
//    [request setValue:ua forHTTPHeaderField:@"User-Agent"];
//    
//    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", responseObject);
//        [self finishSendTwitterWithSuccessStatus:YES info:nil];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        [self finishSendTwitterWithSuccessStatus:NO info:nil];
//    }];
//    NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
//    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:contentType];
//    
//    [manager.operationQueue addOperation:operation];
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
    [_sendOperation cancel];
}

//返回nil表示还没有登陆哦
- (NSString *)loginName{
    NSString *bindString = nil;
	if ([[NTESIMRenrenManager shareInstance] isSessionValid]) {
        bindString = @"已经认证";
    } else  {
        bindString = @"尚未认证";
        [[NTESIMRenrenManager shareInstance] delUserSessionInfo];
    }
    
	return bindString;
}

- (NSString *)notLoginName{
	return @"尚未认证";
}

- (UIViewController *)newLoginController {
    UIViewController *viewController = [[NTESIMRenrenAuthorViewController alloc] init];
    return viewController;
}

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

- (void)request:(RORequest *)request didFailWithError:(NSError *)error
{
    [self finishSendTwitterWithSuccessStatus:NO info:nil];
}

- (void)request:(RORequest *)request didLoad:(id)result
{
    [self finishSendTwitterWithSuccessStatus:YES info:nil];
}
@end
