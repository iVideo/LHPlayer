//
//  GYJShareYixinManager.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-11.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXApi.h"

@interface GYJShareYixinManager : NSObject

+ (id)sharedManager;

- (void)AppRegister;

- (BOOL)sendYXImage:(UIImage *)image;
- (BOOL)sendYXImage:(UIImage *)image withSence:(enum YXScene)scene;

@end
