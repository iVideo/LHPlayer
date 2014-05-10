//
//  GYJRoundView.h
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-2.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYJRoundViewDelegate <NSObject>

- (void)playStateUpdate:(BOOL)playState;
@end
@interface GYJRoundView : UIView

@property (assign, nonatomic) id<GYJRoundViewDelegate> delegate;

@property (strong, nonatomic) UIImage *roundImage;

@property (assign, nonatomic) BOOL isPlay;

@property (assign, nonatomic) float rotationDuration;

-(void) play;

-(void) pause;
@end
