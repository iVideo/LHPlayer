//
//  GYJAppDelegate.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-1.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXApi.h"
#import "WXApi.h"
@interface GYJAppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,YXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@end
