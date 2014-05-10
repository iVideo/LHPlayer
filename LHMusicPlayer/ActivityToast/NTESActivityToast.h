//
//  NTESActivityToast.h
//  NTESShareLibrary
//
//  Created by 张舒 on 11-8-4.
//  Copyright 2011 NetEase.com, Inc. All rights reserved.
//

#import "NTESToast.h"
@interface NTESActivityToast : NTESToast {
	UIButton *button;	
	id __unsafe_unretained activeDelegate;
}
@property(nonatomic,unsafe_unretained) id activeDelegate;
+ (NTESActivityToast *)sharedActivityToast;
- (void)startSpinWithInfo:(NSString *)info withButtonTitle:(NSString *)buttonTitle careLandscope:(BOOL)careLandscope;
- (void)startAnotherSpinWithInfo:(NSString *)info withButtonTitle:(NSString *)buttonTitle careLandscope:(BOOL)careLandscope;
- (void)changeSpinWithInfo:(NSString *)info withButtonTitle:(NSString *)buttonTitle;
- (void)stopSpinWithInfo:(NSString *)info withButtonTitle:(NSString *)button;
@end


@protocol NTESActivityToastDelegate
@optional
- (void)buttonSelected:(NSString *)btnTitle;
@end