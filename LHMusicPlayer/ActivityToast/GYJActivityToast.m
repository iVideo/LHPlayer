//
//  GYJActivityToast.m
//  GYJShareLibrary
//
//  Created by 郭亚娟 on 11-8-4.
//  Copyright 2011 郭亚娟.com, Inc. All rights reserved.
//

#import "GYJActivityToast.h"


@implementation GYJActivityToast
static GYJActivityToast *myActivityToast = nil;
@synthesize activeDelegate;

+ (GYJActivityToast *)sharedActivityToast {
	if (myActivityToast == nil) {
		myActivityToast = [[GYJActivityToast alloc] initWithFrame:CGRectMake(0, 20, SCREEN_W, SCREEN_H-20)];
	}	
    return myActivityToast;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {		
		button = [UIButton buttonWithType:UIButtonTypeSystem];
		button.frame = CGRectMake(0, 0, 80, 24);
		button.titleLabel.font = [UIFont systemFontOfSize:14];
		button.titleLabel.textAlignment = NSTextAlignmentCenter;
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(fadeOut:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
		button.hidden = NO;
    }
    return self;
}

- (void)startSpinWithInfo:(NSString *)info withButtonTitle:(NSString *)buttonTitle careLandscope:(BOOL)careLandscope {	
	
	[self constructView:info careLandscope:careLandscope];	
    
	//对于无需按钮交互的信息
	if (buttonTitle == nil) {
		[self performSelector:@selector(fadeOut:) withObject:nil afterDelay:1.5];
		[button setHidden:YES];
	}else {
		[button setTitle:buttonTitle forState:UIControlStateNormal];
		button.hidden = NO;
		[activityIndicator startAnimating];
	}
	[self showUp];
}

- (void)startAnotherSpinWithInfo:(NSString *)info withButtonTitle:(NSString *)buttonTitle careLandscope:(BOOL)careLandscope {
    //当取消按钮无题目时一直刷，不消失
    [self constructView:info careLandscope:careLandscope];	
	if (nil != buttonTitle) {
        [activityIndicator startAnimating];
    }
    
	//对于无需按钮交互的信息
	if (buttonTitle == nil) {
		[self performSelector:@selector(fadeOut:) withObject:nil afterDelay:1.5];
		[button setHidden:YES];
	}else if(0 == buttonTitle.length){
        [button setHidden:YES];
    }else {
		[button setTitle:buttonTitle forState:UIControlStateNormal];
		button.hidden = NO;
	}
	[self showUp];
}


- (void)changeSpinWithInfo:(NSString *)info withButtonTitle:(NSString *)buttonTitle{
    //[button setTitle:buttonTitle forState:UIControlStateNormal];
    [activityIndicator startAnimating];
    if (nil == buttonTitle) {
        [activityIndicator stopAnimating];
        [button setHidden:YES];
    }else if(0 == buttonTitle.length){
        [button setHidden:YES];
    }else{
        [button setHidden:NO];
    }
    label.text = info;
}

- (void)stopSpinWithInfo:(NSString *)info withButtonTitle:(NSString *)buttonTitle
{
	[self constructView:info careLandscope:NO];	
	[activityIndicator stopAnimating];
	//label.text = info;	
	//对于无需按钮交互的信息
	if (buttonTitle == nil) {
		[self performSelector:@selector(fadeOut:) withObject:nil afterDelay:1.0];
		[button setHidden:YES];
	}else {
		float version = [[[UIDevice currentDevice] systemVersion] floatValue];
		if (version<4) {
			[self performSelector:@selector(fadeOut:) withObject:nil afterDelay:1.0];
			[button setHidden:YES];
		}else {
			//正常的情况
			[button setTitle:buttonTitle forState:UIControlStateNormal];
			button.hidden = NO;
		}
	}
	[self setNeedsDisplay];
	[self showUp];
}

- (void)layoutSubviews
{
	[super layoutSubviews];	
	button.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2+45);
}

- (void)fadeOut:(id)sender{
	UIButton *btn = (UIButton *)sender;	
	[super fadeOut:sender];	
	//如果view中有button
	if (btn && activeDelegate) {
		//NSString *df = btn.titleLabel.text;
        if ([activeDelegate respondsToSelector:@selector(buttonSelected:)]) {
            [activeDelegate buttonSelected:btn.titleLabel.text];
            self.activeDelegate = nil;
        }
		
	}
}
@end
