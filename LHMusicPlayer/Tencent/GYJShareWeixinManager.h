//
//  GYJShareWeixinManager.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-11.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
@interface GYJShareWeixinManager : NSObject

+ (id)sharedManager;

- (void)AppRegister;

- (void)sendWXImage:(UIImage *)image;
- (void)sendWXImage:(UIImage *)image withSence:(enum WXScene)scene;
@end
