//
//  GYJCameraDelegate.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-3-21.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>

@protocol GYJTakePhotoDelegate <NSObject>
- (void)takePhoto:(UIImage *)photoImage;
@end

@protocol GYJCameraContainerDelegate <NSObject>
- (void) backFromController:(UIViewController *)fromController;
- (void) switchFromController:(UIViewController *)fromController toController:(UIViewController *)controller;
@end
