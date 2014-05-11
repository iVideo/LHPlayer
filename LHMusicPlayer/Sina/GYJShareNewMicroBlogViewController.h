//
//  GYJNBShareNewMicroBlogViewController.h
//  网易微博iPhone客户端
//
//  Created by 范岩峰 on 11-2-22.
//  Copyright 2011 郭亚娟.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WBEngine.h"
#import "GYJActivityToast.h"
#import "GYJOAuthLoginController.h"
#import "GYJMainBaseViewController.h"

#define TAG_SHARE_ACTION 1000
#define TAG_SHORTEN_ACTION 2000

@interface GYJShareNewMicroBlogViewController : GYJMainBaseViewController <UITextViewDelegate,WBEngineDelegate> {
	UITextView *shareTextView;
	UILabel *numberLabel;
	UILabel *usernameLabel;
	
	NSString *sharedContent;
	NSString *sharedImage;
	NSDictionary *sharedFloor;
	NSString *sharedArticle;
    NSData *sharedData;
    UIImage *sharedOriginImage;
	
    WBEngine *_engine;
    //下载图片
    //ASIHTTPRequest *imageRequest;
    
    NSURLConnection*    connection;
	NSMutableData*      buf;
    
    //分享失败具体原因
    NSString *errMsg;
    //分享图片开关
    UIButton *picButton;
	int code;
    BOOL shouldRotate;
    BOOL hasPhoto;
    GYJOAuthLoginController *_loginController;
    BOOL _isImageAnimate;
}
@property(nonatomic, copy) NSString *sharedContent;
@property(nonatomic, copy) NSString *sharedImage;
@property(nonatomic, retain) NSDictionary *sharedFloor;
@property(nonatomic, copy) NSString *sharedArticle;
@property (nonatomic, retain) NSData *sharedData;
@property(nonatomic, assign) BOOL shouldRotate;
@property (nonatomic, retain) NSString *errMsg;
@property(nonatomic, retain)UIImage *sharedOriginImage;
@property(nonatomic, unsafe_unretained)BOOL hasPhoto;
- (void) changeNumber:(NSNotification *) notification;

//其他微博继承覆写
- (NSString *) getTitle;
- (BOOL) canBlank;
- (int) getLimit;
//返回nil表示还没有登陆哦
- (NSString *) loginName;
- (NSString *) notLoginName;
- (UIViewController *) newLoginController;
- (WBEngine *) newEngine;

- (NSString *)encodeAsURIComponent:(NSString *)uri;

- (void)shareMicroBlogWithStatus:(NSString *)status;

//下载图片
- (void)cancelCurrentRequest;

- (BOOL)isAuthorizeExpired;
- (void)logout;

+ (BOOL)isSinaWeiboBinded;
@end





