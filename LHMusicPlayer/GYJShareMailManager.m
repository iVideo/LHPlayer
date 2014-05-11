//
//  GYJShareMailManager.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-11.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJShareMailManager.h"
#import "GYJToast.h"
#import "GYJMailComposeViewController.h"

static GYJShareMailManager *mailManager = nil;


@interface GYJShareMailManager (){
    
}



@end
@implementation GYJShareMailManager

@synthesize shareType;
@synthesize mailBody;
@synthesize presentNavigation;
@synthesize attachmentData;
@synthesize subjectName;
@synthesize receiptName;


+ (GYJShareMailManager *)sharedMailManager
{
	@synchronized(self)
    {
		if (mailManager == nil)
		{
			mailManager = [[GYJShareMailManager alloc] init];
		}
	}
	return mailManager;
}

- (void)setMailBody:(NSString *)string{
	mailBody = string;
}

-(void)pushMailComposer {
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil) {
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail]){
			[self displayComposerSheet];
		}else{
			[self launchMailAppOnDevice];
		}
	}else{
		[self launchMailAppOnDevice];
	}
}

-(void)displayComposerSheet {
	MFMailComposeViewController *picker = [[GYJMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    
    if (subjectName) {
        [picker setSubject:subjectName];
    } else {
        [picker setSubject:@"邮件分享"];
    }
    
    if (receiptName) {
        NSArray *toRecipients = [NSArray arrayWithObject:receiptName];
        [picker setToRecipients:toRecipients];
    }
    
    if (attachmentData) {
        [picker addAttachmentData:attachmentData mimeType:@"image/jpg" fileName:@"pic.jpg"];
    }
	[picker setMessageBody:mailBody isHTML:YES];
	
    [presentNavigation presentViewController:picker animated:YES completion:^{
    }];
	picker.navigationBar.topItem.title = @"邮件分享";
}

-(void)launchMailAppOnDevice{
	NSString *recipients = @"test";
	NSString *body = [NSString stringWithFormat:@"&body=%@",mailBody];
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Method
- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	switch (result)
	{
		case MFMailComposeResultCancelled:
			[[GYJToast sharedNTESToast] showUpWithInfo:@"发送取消！" careLandscope:NO];
			break;
		case MFMailComposeResultSent:
			[[GYJToast sharedNTESToast] showUpWithInfo:@"发送成功"  careLandscope:NO];
			break;
		case MFMailComposeResultFailed:
			[[GYJToast sharedNTESToast] showUpWithInfo:@"发送失败"  careLandscope:NO];
			break;
		default:
			break;
	}
    [presentNavigation dismissViewControllerAnimated:YES completion:nil];
    
}


@end
