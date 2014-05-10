//
//  NTESIMCameraCantainer.h
//  iMoney
//
//  Created by 郭亚娟 on 14-3-21.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYJCameraViewController.h"
#import "GYJPhotoPickerController.h"

@interface GYJCameraCantainer : UIViewController<GYJCameraContainerDelegate>

@property (nonatomic, strong) GYJPhotoPickerController *photoPickerController;
@property (nonatomic, strong) GYJCameraViewController *cameraController;
- (id)initWithCameraController:(GYJCameraViewController *)cameraController;
- (id)initWithPhotoPickerController:(GYJPhotoPickerController *)photoPickerController;
@end

