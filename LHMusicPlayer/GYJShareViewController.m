//
//  GYJShareViewController.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-11.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJShareViewController.h"
#import "GYJShareWeixinManager.h"
#import "GYJShareYixinManager.h"
#import "GYJShareMailManager.h"
#import "GYJShareNewMicroBlogViewController.h"
#import "GYJTencentWeiboViewController.h"
#import "GYJShareRenrenViewController.h"

@implementation UIViewController (shared)

- (void)presentPanelSheetController:(UIViewController *)viewController {
    [self.view addSubview:viewController.view];
    [self addChildViewController:viewController];
}

- (void)dismissPanelSheetController {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end

@interface GYJShareViewController ()
{
    UIView *_backView;
    UIView *_whiteBackView;
    BOOL _isSharePanelAnimateDone;
    NSMutableArray *_sharePlateformArray;
    NSUInteger _sharePanelHeight;
    NSUInteger _shareChangedCount;
    NSInteger _startYOffset;
}

@property(nonatomic, strong) NSString *shareContent;
@property(nonatomic, strong) UIImage *shareImage;
@end

@implementation GYJShareViewController

enum
{
    kShareMagzineToYXFriend = 1,
    kShareMagzineToYXTimeline,
    kShareMagzineToWXFriend,
    kShareMagzineToWXTimeline,
    kShareMagzineToSinaWeibo,
    kShareMagzineToTCWeibo,
    kShareMagzineToEmail,
    kShareMagzineToMessage,
    kShareMagezineToRenRen
};

#define kCancelHeight 20


- (id)initWithShareContent:(NSString *)shareContent shareImage:(UIImage *)shareImage
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.shareContent = shareContent;
        self.shareImage = shareImage;
        _sharePlateformArray = [[NSMutableArray alloc] init];
        if (0/*[YXApi isYXAppInstalled]*/)
        {
            [_sharePlateformArray addObject:[NSArray arrayWithObjects:@"share_platform_yixin.png",@"易信好友",[NSNumber numberWithInt:kShareMagzineToYXFriend], nil]];
            [_sharePlateformArray addObject:[NSArray arrayWithObjects:@"share_platform_yixintimeline.png",@"易信朋友圈",[NSNumber numberWithInt:kShareMagzineToYXTimeline], nil]];
        }
        if (0/*[WXApi isWXAppInstalled]*/)
        {
            [_sharePlateformArray addObject:[NSArray arrayWithObjects:@"share_platform_wechat.png",@"微信好友",[NSNumber numberWithInt:kShareMagzineToWXFriend], nil]];
            [_sharePlateformArray addObject:[NSArray arrayWithObjects:@"share_platform_wechattimeline.png",@"微信朋友圈",[NSNumber numberWithInt:kShareMagzineToWXTimeline], nil]];
        }
        
        [_sharePlateformArray addObject:[NSArray arrayWithObjects:@"share_platform_sina.png",@"新浪微博",[NSNumber numberWithInt:kShareMagzineToSinaWeibo], nil]];
        [_sharePlateformArray addObject:[NSArray arrayWithObjects:@"share_platform_tencent.png",@"腾讯微博",[NSNumber numberWithInt:kShareMagzineToTCWeibo], nil]];
        [_sharePlateformArray addObject:[NSArray arrayWithObjects:@"share_platform_renren.png",@"人人网",[NSNumber numberWithInt:kShareMagezineToRenRen], nil]];
        
        Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
        if (messageClass != nil) {
            // Check whether the current device is configured for sending SMS messages
            if ([messageClass canSendText]) {
                [_sharePlateformArray addObject:[NSArray arrayWithObjects:@"share_platform_imessage.png",@"信息",[NSNumber numberWithInt:kShareMagzineToMessage], nil]];
            }
        }
        
        [_sharePlateformArray addObject:[NSArray arrayWithObjects:@"share_platform_email.png",@"邮件",[NSNumber numberWithInt:kShareMagzineToEmail], nil]];
        _sharePanelHeight = 40 + 75 * ceilf(_sharePlateformArray.count/4.0) + kCancelHeight + 20;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    if (SYSTEM_VERSION >= 7) {
        _startYOffset = 0;
    }
    else
    {
        _startYOffset = -20;
    }
    CGRect frame = CGRectMake(0, _startYOffset, self.view.bounds.size.width, self.view.bounds.size.height - _startYOffset);
    self.view.frame = frame;
    _backView = [[UIView alloc] initWithFrame:self.view.bounds];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0;
    [self.view addSubview:_backView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doCancel)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [_backView addGestureRecognizer:tapGesture];
    
    //分享
    _whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - _sharePanelHeight, SCREEN_W, _sharePanelHeight)];
    _whiteBackView.backgroundColor = IM_NAVI_PINK;
    [self.view addSubview:_whiteBackView];
    
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_W, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = @"分享到";
    [_whiteBackView addSubview:titleLabel];
    
    NSUInteger arrayCount = _sharePlateformArray.count;
    for (NSUInteger i = 0; i < arrayCount; i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8 + 75 * (i % 4), 40 + 75 * (i/4), 75, 75)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSArray *tmpArray = [_sharePlateformArray objectAtIndex:i];
        UIImage *image = [UIImage imageNamed:[tmpArray objectAtIndex:0]];
        button.frame = CGRectMake(0.5 * (75 - image.size.width), 0, image.size.width, image.size.height);
        NSNumber *tempNumer = [tmpArray objectAtIndex:2];
        button.tag = [tempNumer integerValue];
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchDown];
        [view addSubview:button];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,image.size.height + 5, 75, 15)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = [tmpArray objectAtIndex:1];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:titleLabel];
        [_whiteBackView addSubview:view];
    }
    
    //分割线
    UIImageView *seperatorView = [[UIImageView alloc] initWithFrame:CGRectMake(15, _sharePanelHeight - kCancelHeight - 20, SCREEN_W - 30, 1)];
    seperatorView.backgroundColor = RGBCOLOR(77, 134, 198);
    [_whiteBackView addSubview:seperatorView];
    
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [cancelButton setTitleColor:RGBCOLOR(77, 134, 198) forState:UIControlStateNormal];
    [cancelButton setFrame:CGRectMake(15, CGRectGetMaxY(seperatorView.frame) + 10, SCREEN_W - 30, kCancelHeight)];
    [_whiteBackView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
    _whiteBackView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, _sharePanelHeight);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_isSharePanelAnimateDone)
    {
        _backView.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            _backView.alpha = 0.6;
        }];
        
        _whiteBackView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, _sharePanelHeight);
        [UIView animateWithDuration:0.5 animations:^{
            _whiteBackView.frame = CGRectMake(0, SCREEN_H - _sharePanelHeight + _startYOffset, SCREEN_W, _sharePanelHeight);
        }];
        _isSharePanelAnimateDone = YES;
    }
    
}

- (void)shareButtonAction:(UIButton *)button
{
    switch (button.tag)
    {
        case kShareMagzineToYXFriend:
            [[GYJShareYixinManager sharedManager] sendYXImage:_shareImage];
            break;
        case kShareMagzineToYXTimeline:
            [[GYJShareYixinManager sharedManager] sendYXImage:_shareImage withSence:kYXSceneTimeline];
            break;
        case kShareMagzineToWXFriend:
            [[GYJShareWeixinManager sharedManager] sendWXImage:_shareImage];
            break;
        case kShareMagzineToWXTimeline:
            [[GYJShareWeixinManager sharedManager] sendWXImage:_shareImage withSence:WXSceneTimeline];
            break;
        case kShareMagzineToSinaWeibo:
            [self shareToSinaWeibo];
            break;
        case kShareMagzineToTCWeibo:
            [self shareToTCWeibo];
            break;
        case kShareMagzineToEmail:
            [self shareViaEmail];
            break;
        case kShareMagzineToMessage:
            [self shareViaMessage];
            break;
        case kShareMagezineToRenRen:
            [self shareToRenren];
            break;
        default:
            break;
    }
}


- (void)doCancel
{
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha = 0.0;
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        _whiteBackView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, _sharePanelHeight);
    }
     
                     completion:^(BOOL isFinish){
                         [self dismissPanelSheetController];
                         
                     }];
    
    
}

#pragma mark - ShareAction
- (void)shareToSinaWeibo
{
    GYJShareNewMicroBlogViewController *shareController;
    shareController = [[GYJShareNewMicroBlogViewController alloc] init];
    shareController.sharedOriginImage = _shareImage;
    shareController.sharedContent = _shareContent;
    shareController.shouldRotate = NO;
    [self presentViewController:shareController animated:YES completion:nil];
}

- (void)shareToTCWeibo
{
    GYJTencentWeiboViewController *shareController;
    shareController = [[GYJTencentWeiboViewController alloc] init];
    shareController.sharedOriginImage = _shareImage;
    shareController.sharedContent = _shareContent;
    shareController.shouldRotate = NO;
    [self presentViewController:shareController animated:YES completion:nil];
}

- (void)shareToRenren
{
    GYJShareRenrenViewController *shareController = [[GYJShareRenrenViewController alloc] init];
    shareController.sharedOriginImage = _shareImage;
    shareController.sharedContent = _shareContent;
    //shareController.shouldRotate = NO;
    [self presentViewController:shareController animated:YES completion:nil];
}

-(void)shareViaEmail{
    NSData *imgData = UIImagePNGRepresentation(_shareImage);
    [GYJShareMailManager sharedMailManager].attachmentData = imgData;
    NSString *sharedMail = [NSString stringWithFormat:@"test"];
    [GYJShareMailManager sharedMailManager].mailBody = sharedMail;
    [GYJShareMailManager sharedMailManager].subjectName = nil;
    [GYJShareMailManager sharedMailManager].receiptName = nil;
    [GYJShareMailManager sharedMailManager].presentNavigation = self;
    [[GYJShareMailManager sharedMailManager] pushMailComposer];
}

-(void)shareViaMessage
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    //      if ([picker.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
    //        [picker.navigationBar setBarTintColor:[UIColor whiteColor]];
    //        [picker.navigationBar setTintColor:[UIColor whiteColor]];
    //      } else {
    //        [picker.navigationBar setTintColor:[UIColor blackColor]];
    //      }
    
    picker.messageComposeDelegate = self;
    if (SYSTEM_VERSION >= 7) {
        [picker addAttachmentData:UIImagePNGRepresentation(_shareImage) typeIdentifier:(NSString*)kUTTypePNG filename:@"share.png"];
    }
    picker.body = _shareContent;
    
    [self presentViewController:picker animated:YES completion:^{
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    if ([controller.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        [controller.navigationBar setBarTintColor:[UIColor whiteColor]];
        [controller.navigationBar setTintColor:[UIColor whiteColor]];
    } else {
        [controller.navigationBar setTintColor:[UIColor blackColor]];
    }
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            
            break;
        case MessageComposeResultSent:
            [[GYJToast sharedNTESToast]showUpWithInfo:@"发送成功" careLandscope:YES];//toastInView:self.view withText:@"发送成功"];
            break;
        case MessageComposeResultFailed:
            [[GYJToast sharedNTESToast]showUpWithInfo:@"发送失败" careLandscope:YES];//[GYJToast toastInView:self.view withText:@"发送失败"];
            break;
        default:
            
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
