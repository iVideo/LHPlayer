//
//  GYJShareMailManager.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-11.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

@import Foundation;
@import MessageUI;
@import MessageUI.MFMailComposeViewController;

@interface GYJShareMailManager : NSObject<MFMailComposeViewControllerDelegate>{
    NSString *mailBody;
    NSInteger shareType;
    UIViewController *__unsafe_unretained presentNavigation;
    NSData *attachmentData;
    
    NSString *subjectName;
    NSString *receiptName;
}

@property (nonatomic, assign) NSInteger shareType;
@property (nonatomic, strong) NSString *mailBody;
@property (nonatomic, unsafe_unretained) UIViewController *presentNavigation;
@property (nonatomic, strong) NSData *attachmentData;
@property (nonatomic, strong) NSString *subjectName;
@property (nonatomic, strong) NSString *receiptName;

+ (GYJShareMailManager *)sharedMailManager;
- (void)displayComposerSheet;
- (void)launchMailAppOnDevice;
-(void)pushMailComposer;
@end
