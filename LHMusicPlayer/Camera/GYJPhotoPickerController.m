//
//  NTESIMPhotoPickerController.m
//  iMoney
//
//  Created by 郭亚娟 on 14-3-22.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import "GYJPhotoPickerController.h"

@interface GYJPhotoPickerController ()

@end

@implementation GYJPhotoPickerController

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
        self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.delegate = self;
        self.allowsEditing = YES;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIImage *)resizeImage:(UIImage *)originImage{
    return [originImage resizedImage:CGSizeMake(144, 144) imageOrientation:originImage.imageOrientation];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *editedImage = [info valueForKey:UIImagePickerControllerEditedImage];
    if (!editedImage) {
        editedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    UIImage * resizedImage = [self resizeImage:editedImage];
    if ([self.photoDelegate respondsToSelector:@selector(takePhoto:)]) {
        [self.photoDelegate takePhoto:resizedImage];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
