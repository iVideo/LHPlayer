//
//  GYJShareViewController.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-11.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//
//  音乐分享
//
#import "GYJMainBaseViewController.h"
@import MessageUI;
@interface UIViewController (shared)

- (void)presentPanelSheetController:(UIViewController *)viewController;
- (void)dismissPanelSheetController;

@end

@interface GYJShareViewController : GYJMainBaseViewController<MFMessageComposeViewControllerDelegate>

- (id)initWithShareContent:(NSString *)shareContent shareImage:(UIImage *)shareImage;
@end
