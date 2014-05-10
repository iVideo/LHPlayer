//
//  NTESIMCameraCantainer.m
//  iMoney
//
//  Created by 郭亚娟 on 14-3-21.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import "GYJCameraCantainer.h"

@interface GYJCameraCantainer ()
@property (nonatomic, strong) UIImagePickerController *defaultPhotoPickerController;
@property (nonatomic, strong) UIImagePickerController *defaultCameraPickerController;
@end

@implementation GYJCameraCantainer

- (id)initWithPhotoPickerController:(GYJPhotoPickerController *)photoPickerController{
    self = [super init];
    if (self) {
        self.wantsFullScreenLayout = YES;
        _defaultPhotoPickerController = photoPickerController;
    }
    return self;
}
- (id)initWithCameraController:(GYJCameraViewController *)cameraController{
    self = [super init];
    if (self) {
        self.wantsFullScreenLayout = YES;
        _defaultCameraPickerController = cameraController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_defaultCameraPickerController) {
        [(GYJCameraViewController *)_defaultCameraPickerController setContainerDelegate:self];
        [self addChildViewController:self.defaultCameraPickerController];
        [self.view addSubview:self.defaultCameraPickerController.view];
    } else if (_defaultPhotoPickerController){
        [(GYJPhotoPickerController *)_defaultPhotoPickerController setContainerDelegate:self];
        [self addChildViewController:self.defaultPhotoPickerController];
        [self.view addSubview:self.defaultPhotoPickerController.view];
    }
    
}
#pragma mark - DBCameraContainerDelegate

- (void)backFromController:(UIViewController *)fromController
{
    [self switchFromController:fromController
                  toController:self.defaultCameraPickerController];
}

- (void)switchFromController:(UIViewController *)fromController toController:(UIViewController *)toController
{
    [[(UIViewController *)toController view] setAlpha:1];
    [[(UIViewController *)toController view] setTransform:CGAffineTransformMakeScale(1, 1)];
    [self addChildViewController:toController];
    [fromController willMoveToParentViewController:nil];
    
    __block UIViewController * blockFromController = fromController;
    __block UIViewController * blockToViewController = toController;
    __weak typeof(self) weakSelf = self;
    [self transitionFromViewController:blockFromController
                      toViewController:toController
                              duration:.2
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^(void){ }
                            completion:^(BOOL finished) {
                                [blockFromController removeFromParentViewController];
                                blockFromController = nil;
                                [blockToViewController didMoveToParentViewController:weakSelf];
                            }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

