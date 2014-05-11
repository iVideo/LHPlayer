//
//  GYJShareWeixinManager.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-11.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJShareWeixinManager.h"
#import "UIImage+Extened.h"

@implementation GYJShareWeixinManager

+ (id)sharedManager
{
    static dispatch_once_t onceQueue;
    static GYJShareWeixinManager *engine = nil;
    
    dispatch_once(&onceQueue, ^{
        engine = [[self alloc] init];
    });
    return engine;
}

- (void)AppRegister {
    [WXApi registerApp:@"wx6264463798124307"];
}

- (void)sendWXImage:(UIImage *)image {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    CGFloat thumbH = image.size.height * 120.0f / image.size.width;
    UIImage *thumbImage = [image resize:CGSizeMake(120.0f, thumbH)];
    [message setThumbImage:thumbImage];
    
    WXImageObject *ext = [WXImageObject object];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    ext.imageData = imageData;
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

- (void)sendWXImage:(UIImage *)image withSence:(enum WXScene)scene {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    CGFloat thumbH = image.size.height * 120.0f / image.size.width;
    UIImage *thumbImage = [image resize:CGSizeMake(120.0f, thumbH)];
    [message setThumbImage:thumbImage];
    
    WXImageObject *ext = [WXImageObject object];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    ext.imageData = imageData;
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}


@end
