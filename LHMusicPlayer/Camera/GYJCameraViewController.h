//
//  GYJIMCameraViewController.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-3-21.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYJCameraDelegate.h"

@interface GYJCameraViewController : UIImagePickerController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) id <GYJCameraContainerDelegate> containerDelegate;
@property (nonatomic, weak) id <GYJTakePhotoDelegate> photoDelegate;
@end
