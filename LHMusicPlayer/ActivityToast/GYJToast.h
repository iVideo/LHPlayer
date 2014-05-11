//
//  GYJToast.h
//  GYJShareLibrary
//
//  Created by 郭亚娟 on 11-8-4.
//  Copyright 2011 郭亚娟.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GYJToast : UIView {
	UIActivityIndicatorView*  activityIndicator;
	UILabel *label;
	UIView *backView;
}
@property(nonatomic,unsafe_unretained) NSString* text;
+ (GYJToast *)sharedNTESToast;
- (void)startSpinWithInfo:(NSString *)info careLandscope:(BOOL)careLandscope;
- (void)stopSpinWithInfo:(NSString *)info;
- (void)startSpinWithInfo:(NSString *)info;
- (void)showUpWithInfo:(NSString *)info careLandscope:(BOOL)careLandscope;
@end


@interface GYJToast()
- (void)constructView:(NSString *)info careLandscope:(BOOL)careLandscope;
- (void)drawRoundedRect:(CGRect) rect inContext:(CGContextRef)context withSize:(CGSize) size;
- (void)showUp;
- (void)fadeOut:(id)sender;
- (BOOL) isShowing;
@end