//
//  GYJIMImageCropController.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-3-20.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYJImageCropController;
@protocol NTESIMImageCropDelegate <NSObject>

- (void)imageCropper:(GYJImageCropController *)imageCropController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(GYJImageCropController *)imageCropController;

@end
@interface GYJImageCropController : UIViewController
@property (nonatomic, assign) id<NTESIMImageCropDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;
@end
