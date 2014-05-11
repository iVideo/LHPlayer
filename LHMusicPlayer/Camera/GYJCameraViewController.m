//
//  GYJIMCameraViewController.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-3-21.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJCameraViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "GYJAssetManager.h"
#import "GYJImageCropController.h"
#import "GYJPhotoPickerController.h"

@interface GYJCameraViewController ()<NTESIMImageCropDelegate>
@property (nonatomic, strong) AVCaptureSession * AVSession;
@end

@implementation GYJCameraViewController{
    UIView *topBar;
    UIView *bottomBar;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (id)init{
    self = [super init];
    if (self) {
        self.wantsFullScreenLayout = YES;
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.showsCameraControls = NO;
        self.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        self.delegate = self;
        self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }
    return self;
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    topBar = [UIView new];
    topBar.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
    [self.view addSubview:topBar];
    
    UIButton *switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchCameraButton setBackgroundImage:[UIImage imageNamed:@"camera_selector"] forState:UIControlStateNormal];
    [topBar addSubview:switchCameraButton];
    
    UIButton *flashToggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashToggleButton setBackgroundImage:[UIImage imageNamed:@"camera_flashlight_off"] forState:UIControlStateNormal];
    [topBar addSubview:flashToggleButton];
    
    bottomBar = [UIView new];
    bottomBar.backgroundColor =  RGBACOLOR(0, 0, 0, 0.3);
    [self.view addSubview:bottomBar];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"camera_back"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:cancelButton];
    
    [topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@60);
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
    }];
    
    [switchCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topBar.mas_centerY);
        make.right.equalTo(topBar.mas_right).offset(-15);
    }];
    
    [flashToggleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topBar.mas_centerY);
        make.centerX.equalTo(topBar.mas_centerX);
    }];
    
    __weak typeof(self) weakSelf = self;
    __weak UIButton *weakFlashButton = flashToggleButton;

    
    [flashToggleButton addTarget:self action:@selector(flashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [switchCameraButton addAction:^(UIButton *btn) {
        if (weakSelf.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
            weakFlashButton.enabled = NO;
            weakSelf.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            [weakFlashButton setBackgroundImage:[UIImage imageNamed:@"camera_flashlight_off"] forState:UIControlStateNormal];
            weakSelf.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        } else {
            weakFlashButton.enabled = YES;
            weakSelf.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }
    }];
    
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@99);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topBar.mas_left).offset(10);
        make.centerY.equalTo(topBar.mas_centerY);
        make.height.equalTo(@35);
        make.width.equalTo(@35);
    }];
    
    UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recordBtn setBackgroundImage:[UIImage imageNamed:@"camera_take_button"] forState:UIControlStateNormal];
    [recordBtn addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:recordBtn];
    
    UIButton *photoLibraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoLibraryButton.layer setCornerRadius:3];
    [photoLibraryButton setBackgroundImage:[UIImage imageNamed:@"camera_photo_library"] forState:UIControlStateNormal];
    [bottomBar addSubview:photoLibraryButton];
    
    [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomBar.mas_centerY);
        make.width.equalTo(@78);
        make.height.equalTo(@78);
        make.centerX.equalTo(bottomBar.mas_centerX);
    }];
    
    [photoLibraryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomBar.mas_left).offset(15);
        make.centerY.equalTo(bottomBar.mas_centerY);
        make.height.equalTo(bottomBar.mas_height).multipliedBy(0.5);
        make.width.equalTo(photoLibraryButton.mas_height);
    }];
    
    [photoLibraryButton addAction:^(UIButton *btn) {
        [weakSelf showPhotoLibyary];
    }];
    
    if ([ALAssetsLibrary authorizationStatus] !=  ALAuthorizationStatusDenied) {
        [[GYJAssetManager sharedInstance] loadLastItemWithBlock:^(BOOL success, UIImage *image) {
            [photoLibraryButton setBackgroundImage:image forState:UIControlStateNormal];
        }];
    }
}

- (void)flashButtonTapped:(UIButton *)flashButton{
    flashButton.selected = !flashButton.isSelected;
    NSString *imageName = flashButton.isSelected ? @"camera_flashlight_on" : @"camera_flashlight_off";
    self.cameraFlashMode = flashButton.isSelected ? UIImagePickerControllerCameraFlashModeOn : UIImagePickerControllerCameraFlashModeOff;
    [flashButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)cancelButtonAction:(UIButton *)sender
{
    self.cameraOverlayView = nil;
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)showPhotoLibyary{
    if ( [ALAssetsLibrary authorizationStatus] !=  ALAuthorizationStatusDenied ) {
        [UIView animateWithDuration:.3 animations:^{
            [self.view setAlpha:0];
            [self.view setTransform:CGAffineTransformMakeScale(.8, .8)];
        } completion:^(BOOL finished) {
            GYJPhotoPickerController *pickerController = [[GYJPhotoPickerController alloc] init];
            pickerController.photoDelegate = self.photoDelegate;
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerController.allowsEditing = YES;
            [self.containerDelegate switchFromController:self toController:pickerController];
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            GYJAlert *alert = [[GYJAlert alloc] initAlertWithTitle:@"无法打开相册" message:@"请到系统设置-隐私中打开本应用相册访问权限" cancelTitle:@"确定" completeBlock:^(GYJAlert *alert, NSInteger buttonIndex) {
                
            } otherTitle:nil, nil];
            [alert show];
        });
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *editedImage = [info valueForKey:UIImagePickerControllerEditedImage];
    if (editedImage) {
        editedImage = [self resizeImage:editedImage];
        if ([self.photoDelegate respondsToSelector:@selector(takePhoto:)]) {
            [self.photoDelegate takePhoto:editedImage];
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    @autoreleasepool {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        CGRect cropRect = CGRectMake(0, 0, SCREEN_W, SCREEN_W);
        cropRect.origin.y = (SCREEN_H - SCREEN_W)/2;
        CGFloat ratio = image.size.width/SCREEN_W;
        //Downsizing the large image
        UIImage *scaleImage = [image scaleToResoltion:ratio];
        image = nil;
        
        GYJImageCropController *corpper = [[GYJImageCropController alloc] initWithImage:scaleImage cropFrame:cropRect limitScaleRatio:3.0];
        corpper.delegate = self;
        [self.containerDelegate switchFromController:picker toController:corpper];
    }
}
- (void)imageCropper:(GYJImageCropController *)imageCropController didFinished:(UIImage *)editedImage{
    editedImage = [self resizeImage:editedImage];
    if ([self.photoDelegate respondsToSelector:@selector(takePhoto:)]) {
        [self.photoDelegate takePhoto:editedImage];
    }
    [imageCropController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)imageCropperDidCancel:(GYJImageCropController *)imageCropController{
    [imageCropController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (UIImage *)resizeImage:(UIImage *)originImage{
    return [originImage resizedImage:CGSizeMake(144, 144) imageOrientation:originImage.imageOrientation];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
