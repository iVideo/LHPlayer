//
//  UIImage+Extened.h
//  iMoney
//
//  Created by 郭亚娟 on 14-2-25.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extened)

#pragma mark - OverLay
- (UIImage*)overlayWith:(UIImage*)overlayImage;
- (UIImage*)overlayWithArtifact:(UIImage*)overlayImage;

#pragma mark - Resize
- (UIImage*)resize:(CGSize)newSize;
- (UIImage *)imageScaledToSize:(CGSize)size;
- (UIImage*)mask:(UIImage*)maskImage;
- (UIImage *)scaleToResoltion:(int)resolution;
- (UIImage *)cropRoundImageWithRect:(CGRect)rect;
- (UIImage *)createRoundedRectImageWithRadius:(CGFloat)radius;
- (CGRect)convertCropRect:(CGRect)cropRect;
- (UIImage *)croppedImage:(CGRect)cropRect;
- (UIImage *)resizedImage:(CGSize)size imageOrientation:(UIImageOrientation)imageOrientation;
- (UIImage *)fixOrientation;

#pragma mark - DrawNewImage
+ (UIImage *)drawImageWithColor:(CGColorRef)color rect:(CGRect)rect;

#pragma mark - 抗锯齿
- (UIImage*)antialiasedImage;//在image边缘加上一像素透明区域抗锯齿
- (UIImage*)antialiasedImageOfSize:(CGSize)size scale:(CGFloat)scale;

#pragma mark - TintColor
- (UIImage *)imageTintedWithColor:(UIColor *)color;
- (UIImage *)imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction;

#pragma mark - 翻转图片
- (UIImage*)rotateImageWithOrient:(UIImageOrientation)orient;
@end
