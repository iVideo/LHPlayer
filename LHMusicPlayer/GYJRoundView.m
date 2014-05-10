//
//  GYJRoundView.m
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-2.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import "GYJRoundView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#define kRotationDuration 8.0

@interface GYJRoundView ()
@property (strong, nonatomic) UIImageView *roundImageView;
@property (strong, nonatomic) UIImageView *playStateView;
@end
@implementation GYJRoundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

-(void)initialization
{
    CGPoint center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    
    //set JingRoundView
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    
    self.layer.cornerRadius = center.x;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    
    
    //set roundImageView
    UIImage *roundImage = self.roundImage;
    self.roundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.roundImageView setCenter:center];
    [self.roundImageView setImage:roundImage];
    [self addSubview:self.roundImageView];
    
    //set play state
    UIImage *stateImage;
    if (self.isPlay) {
        stateImage = [UIImage imageNamed:@"start"];
    }else{
        stateImage = [UIImage imageNamed:@"pause"];
    }
    
    self.playStateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, stateImage.size.width, stateImage.size.height)];
    [self.playStateView setCenter:center];
    [self.playStateView setImage:stateImage];
//    [self addSubview:self.playStateView];
    
    //border
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
#define kCGImageAlphaPremultipliedLast  (kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast)
#else
#define kCGImageAlphaPremultipliedLast  kCGImageAlphaPremultipliedLast
#endif
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil, self.frame.size.width, self.frame.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CFRelease(colorSpace);
    
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7] CGColor]);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, center.x , 0, 2 * M_PI, 0);
    CGContextClosePath(context);
    CGContextSetLineWidth(context, 15.0);
    CGContextStrokePath(context);
    
    
    // convert the context into a CGImageRef
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage* image2 = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    UIImageView *imgv =[[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width , self.frame.size.height)];
    imgv.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    imgv.image = image2;
    [self addSubview:imgv];
    
    //Rotation
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    
    //default RotationDuration value
    if (self.rotationDuration == 0) {
        self.rotationDuration = kRotationDuration;
    }
    
    rotationAnimation.duration = self.rotationDuration;
    rotationAnimation.RepeatCount = FLT_MAX;
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO; //No Remove
    [self.roundImageView.layer addAnimation:rotationAnimation forKey:@"rotation"];
    
    if (!self.isPlay) {
        self.layer.speed = 0.0;
    }
}

-(void)setIsPlay:(BOOL)aIsPlay
{
    _isPlay = aIsPlay;
    
    if (self.isPlay) {
        [self startRotation];
    }else{
        [self pauseRotation];
    }
}
-(void)setRoundImage:(UIImage *)aRoundImage
{
    _roundImage = aRoundImage;
    self.roundImageView.image = self.roundImage;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    self.isPlay = !self.isPlay;
//    if ([self.delegate respondsToSelector:@selector(playStateUpdate:)]) {
//        [self.delegate playStateUpdate:self.isPlay];
//
//    }
}

-(void) startRotation
{
    self.layer.speed = 1.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval pausedTime = [self.layer timeOffset];
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
    
    //set ImgView
    self.playStateView.image = [UIImage imageNamed:@"start"];
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.playStateView.alpha = 1;
                     }completion:^(BOOL finished){
                         if (finished){
                             [UIView animateWithDuration:1.0 animations:^{self.playStateView.alpha = 0;}];
                         }
                     }
     ];
}

-(void) pauseRotation
{
    //set ImgView
    self.playStateView.image = [UIImage imageNamed:@"pause"];
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.playStateView.alpha = 1;
                     }completion:^(BOOL finished){
                         if (finished){
                             self.userInteractionEnabled = YES;
                             [UIView animateWithDuration:1.0 animations:^{
                                 self.playStateView.alpha = 0;
                                 //pause
                                 CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
                                 self.layer.speed = 0.0;
                                 self.layer.timeOffset = pausedTime;
                             }];
                         }
                     }
     ];
}

-(void)play
{
    self.isPlay = YES;
}
-(void)pause
{
    self.isPlay = NO;
}

@end
