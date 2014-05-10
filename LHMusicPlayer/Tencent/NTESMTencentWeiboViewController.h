//
//  NTESMTencentWeiboViewController.h
//  Magazine
//
//  Created by 范 岩峰 on 13-9-26.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NTESActivityToast.h"
#import "NTESTCOAuthLoginController.h"
#import "NTESMTencentManager.h"
#import "GYJMainBaseViewController.h"

#define TAG_SHARE_ACTION 1000
#define TAG_SHORTEN_ACTION 2000

@interface NTESMTencentWeiboViewController : GYJMainBaseViewController<UITextViewDelegate,TencentManagerDelegate> {
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
}

@property(nonatomic, copy) NSString *sharedContent;
@property(nonatomic, copy) NSString *sharedImage;
@property(nonatomic, retain) NSDictionary *sharedFloor;
@property(nonatomic, copy) NSString *sharedArticle;
@property (nonatomic, retain) NSData *sharedData;
@property(nonatomic, assign) BOOL shouldRotate;
@property(nonatomic, retain)UIImage *sharedOriginImage;
@property(nonatomic, unsafe_unretained)BOOL hasPhoto;

- (UIViewController *)newLoginController;
- (NSString *)loginName;
- (NSString *)notLoginName;
- (void)logout;

- (void)shareMicroBlogWithStatus:(NSString *)status;

@end
    