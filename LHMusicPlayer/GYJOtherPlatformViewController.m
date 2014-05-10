//
//  LHOtherPlatformViewController.m
//  LHMusicPlayer
//
//  Created by 郭亚娟 on 14-5-1.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJOtherPlatformViewController.h"
#import "GYJShareIcon.h"
#import "NTESNBShareNewMicroBlogViewController.h"
#import "NTESMTencentWeiboViewController.h"
#import "NTESIMRenrenManager.h"
#import "NTESIMRenrenAuthorViewController.h"
@interface GYJOtherPlatformViewController ()

@property (nonatomic, strong) NTESNBShareNewMicroBlogViewController *sinaVC;
@property (nonatomic, strong) GYJShareIcon *sinaWeiboView;
@property (nonatomic, strong) GYJShareIcon *tencentWeiboView;
@property (nonatomic, strong) GYJShareIcon *renrenView;
@end

@implementation GYJOtherPlatformViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getMsg:)
                                                     name:NOTIFICATION_SINA_LOGIN
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getMsg:)
                                                     name:NOTIFICATION_TENCENT_LOGIN
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getMsg:)
                                                     name:NOTIFICATION_RENREN_LOGIN
                                                   object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"绑定帐号";
    
    [self addLeftButtonTitle:@"返回" target:self action:@selector(doBack)];

    CGFloat shareIconWidth = CGRectGetWidth(self.view.bounds)/3;
    CGFloat shareIconHeight = shareIconWidth - 10;
    CGFloat contentTopY = self.customNaviBar.bottom + 20;
    __weak typeof(self) weakSelf = self;
    
    self.sinaWeiboView = [[GYJShareIcon alloc] initWithFrame:CGRectMake(0, contentTopY, shareIconWidth, shareIconHeight)
                                                       type:GYJShareIconTypeSina
                                                     binded:[self isSinaBinded]
                                                      block:^{
                                                          [weakSelf bindAction:GYJShareIconTypeSina];
                                                      }];
    [self.view addSubview:_sinaWeiboView];
    
    self.tencentWeiboView = [[GYJShareIcon alloc] initWithFrame:CGRectMake(shareIconWidth, contentTopY, shareIconWidth, shareIconHeight)
                                                          type:GYJShareIconTypeTencentWeibo
                                                        binded:[self isTencenWeiboBinded]
                                                         block:^{
                                                             [weakSelf bindAction:GYJShareIconTypeTencentWeibo];
                                                         }];
    [self.view addSubview:_tencentWeiboView];
    
    self.renrenView = [[GYJShareIcon alloc] initWithFrame:CGRectMake(shareIconWidth*2, contentTopY, shareIconWidth, shareIconHeight)
                                                    type:GYJShareIconTypeRenRen
                                                  binded:[self isRenRenBinded]
                                                   block:^{
                                                       [weakSelf bindAction:GYJShareIconTypeRenRen];
                                                   }];
    [self.view addSubview:_renrenView];

}

- (void)doBack{
    //防止卡顿
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESIMPlatformSettingChangeNotification object:nil];
    });
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bindAction:(GYJShareIconType)type
{
    __weak typeof(self) weakSelf = self;
    switch (type) {
        case GYJShareIconTypeSina:
        {
            if (!_sinaVC) {
                self.sinaVC = [[NTESNBShareNewMicroBlogViewController alloc] init];
                [_sinaVC view];
            }
            if ([self isSinaBinded]) {
                GYJAlert *sinaAlert = [[GYJAlert alloc] initAlertWithTitle:@"取消新浪微博绑定吗？" message:nil cancelTitle:@"取消" completeBlock:^(GYJAlert *alert, NSInteger buttonIndex) {
                    __strong typeof(weakSelf)strongSelf = weakSelf;
                    if (buttonIndex) {
                        [strongSelf.sinaVC logout];
                        strongSelf.sinaWeiboView.binded = NO;
                    }
                } otherTitle:@"确定", nil];
                [sinaAlert show];
                
            }else{
                UIViewController *viewController = [_sinaVC newLoginController];
                [self presentViewController:viewController animated:YES completion:nil];
            }
        }
            break;
        case GYJShareIconTypeTencentWeibo:
        {
            NTESMTencentWeiboViewController *vc = [[NTESMTencentWeiboViewController alloc] init];
            if ([self isTencenWeiboBinded]){
                GYJAlert *sinaAlert = [[GYJAlert alloc] initAlertWithTitle:@"取消腾讯微博绑定吗？" message:nil cancelTitle:@"取消" completeBlock:^(GYJAlert *alert, NSInteger buttonIndex) {
                    __strong typeof(weakSelf)strongSelf = weakSelf;
                    if (buttonIndex) {
                        [vc logout];
                        strongSelf.tencentWeiboView.binded = NO;
                    }
                } otherTitle:@"确定", nil];
                [sinaAlert show];
            }else{
                NTESTCOAuthLoginController *loginVC = (NTESTCOAuthLoginController *)[vc newLoginController];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
            
        }
            break;
        case GYJShareIconTypeRenRen:
        {
            BOOL isLogin = [[NTESIMRenrenManager shareInstance] isSessionValid];
            if (isLogin)
            {
                GYJAlert *sinaAlert = [[GYJAlert alloc] initAlertWithTitle:@"取消人人网绑定吗？" message:nil cancelTitle:@"取消" completeBlock:^(GYJAlert *alert, NSInteger buttonIndex) {
                    __strong typeof(weakSelf)strongSelf = weakSelf;
                    if (buttonIndex) {
                        [[NTESIMRenrenManager shareInstance] delUserSessionInfo];
                        strongSelf.renrenView.binded = NO;
                    }
                } otherTitle:@"确定", nil];
                [sinaAlert show];
            }
            else
            {
                //推出登录界面
                UIViewController *viewController = [[NTESIMRenrenAuthorViewController alloc] init];
                [self presentViewController:viewController animated:YES completion:nil];
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)getMsg:(NSNotification*)notification{
    if ([notification.name isEqualToString:NOTIFICATION_SINA_LOGIN]) {
        // 绑定成功，刷新一下
        _sinaWeiboView.binded = YES;
    }
    
    if ([notification.name isEqualToString:NOTIFICATION_TENCENT_LOGIN]) {
        // 绑定成功，刷新一下
        _tencentWeiboView.binded = YES;
    }
    
    if ([notification.name isEqualToString:NOTIFICATION_RENREN_LOGIN]) {
        // 绑定成功，刷新一下
        _renrenView.binded = YES;
    }
}

- (BOOL)isSinaBinded
{
    return [NTESNBShareNewMicroBlogViewController isSinaWeiboBinded];
}

- (BOOL)isTencenWeiboBinded
{
    NSString *username = [US objectForKey:LOGIN_USERNAME_TENCENT_KEY];
    NSString *userData = [US objectForKey:LOGIN_DATA_TENCENT_KEY];
    
    BOOL isBind = [[NTESMTencentManager shareInstance] authorize];
    if (isBind && userData && username)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isRenRenBinded
{
    return [[NTESIMRenrenManager shareInstance] isSessionValid];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SINA_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TENCENT_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_RENREN_LOGIN object:nil];
}

@end
