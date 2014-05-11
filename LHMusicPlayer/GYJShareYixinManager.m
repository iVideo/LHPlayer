//
//  GYJShareYixinManager.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-11.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJShareYixinManager.h"
#import "UIImage+Extened.h"

@implementation GYJShareYixinManager

+ (id)sharedManager
{
    static dispatch_once_t onceQueue;
    static GYJShareYixinManager *engine = nil;
    
    dispatch_once(&onceQueue, ^{
        engine = [[self alloc] init];
    });
    return engine;
}

- (void)AppRegister {
    [YXApi registerApp:@"88b1c531a48342ca8146e4572fe94980"];
}


#define ShareThumbImageSize_Icon CGSizeMake(60, 60)

- (UIImage*)thumbImageFormImage:(UIImage*)storedImage scaleSize:(CGSize)size{
    UIImage *thumbImg = nil;
    CGFloat newWidth = size.width;
    CGFloat newHeight = size.height;
    if (storedImage && storedImage.size.width > 0 && storedImage.size.height > 0) {
        CGSize imageSize = storedImage.size;
        
        float ratio = imageSize.width / imageSize.height;
        float width,height;
        if (ratio > (newWidth / newHeight)) {
            width = newWidth;
            height = newWidth / ratio;
        } else {
            width =  newHeight * ratio;
            height = newHeight;
        }
        thumbImg = [storedImage imageScaledToSize:CGSizeMake(width, height)];
    }else{
        thumbImg = [[UIImage imageNamed:@"icon72"] imageScaledToSize:ShareThumbImageSize_Icon];
    }
    return thumbImg;
}

- (BOOL)sendYXImage:(UIImage *)image {
    YXImageObject *ext = [YXImageObject object];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    ext.imageData = imageData;
    
    YXMediaMessage *message = [YXMediaMessage message];
    message.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    message.mediaObject = ext;
    UIImage *thumbImage = [self thumbImageFormImage:image scaleSize:ShareThumbImageSize_Icon];
    NSData *thumbData = UIImageJPEGRepresentation(thumbImage, 1.0);
    [message setThumbData:thumbData];
    
    SendMessageToYXReq* req = [[SendMessageToYXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = kYXSceneSession;
    
    BOOL success = [YXApi sendReq:req];
    return success;
}

- (BOOL)sendYXImage:(UIImage *)image withSence:(enum YXScene)scene {
    YXImageObject *ext = [YXImageObject object];
    NSData *imageData = UIImagePNGRepresentation(image);
    ext.imageData = imageData;
    
    YXMediaMessage *message = [YXMediaMessage message];
    message.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    message.mediaObject = ext;
    UIImage *thumbImage = [self thumbImageFormImage:image scaleSize:ShareThumbImageSize_Icon];
    NSData *thumbData = UIImageJPEGRepresentation(thumbImage, 1.0);
    [message setThumbData:thumbData];
    
    SendMessageToYXReq* req = [[SendMessageToYXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    BOOL success = [YXApi sendReq:req];
    return success;
}

@end
