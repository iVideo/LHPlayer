//
//  GYJActivityToast.h
//  GYJShareLibrary
//
//  Created by 郭亚娟 on 11-8-4.
//  Copyright 2011 郭亚娟.com, Inc. All rights reserved.
//

#import "GYJToast.h"
@interface GYJActivityToast : GYJToast {
	UIButton *button;	
	id __unsafe_unretained activeDelegate;
}
@property(nonatomic,unsafe_unretained) id activeDelegate;
+ (GYJActivityToast *)sharedActivityToast;
- (void)startSpinWithInfo:(NSString *)info withButtonTitle:(NSString *)buttonTitle careLandscope:(BOOL)careLandscope;
- (void)startAnotherSpinWithInfo:(NSString *)info withButtonTitle:(NSString *)buttonTitle careLandscope:(BOOL)careLandscope;
- (void)changeSpinWithInfo:(NSString *)info withButtonTitle:(NSString *)buttonTitle;
- (void)stopSpinWithInfo:(NSString *)info withButtonTitle:(NSString *)button;
@end


@protocol NTESActivityToastDelegate
@optional
- (void)buttonSelected:(NSString *)btnTitle;
@end