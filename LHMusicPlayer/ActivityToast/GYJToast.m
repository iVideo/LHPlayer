//
//  GYJToast.m
//  GYJShareLibrary
//
//  Created by 郭亚娟 on 11-8-4.
//  Copyright 2011 郭亚娟.com, Inc. All rights reserved.
//

#import "GYJToast.h"
#import "GYJAppDelegate.h"
#define MIN_WIDTH 80.0

#define WINDOW_TEXT_EFFECTS @"UITextEffectsWindow"
@implementation GYJToast
static GYJToast *myToast = nil;
@synthesize text;

+ (GYJToast *)sharedNTESToast{
	if (myToast == nil) {
		myToast = [[GYJToast alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
	}	
    return myToast;
}


- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		//
		activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		activityIndicator.hidesWhenStopped = YES;
		[self addSubview:activityIndicator];
		activityIndicator.center = CGPointMake(frame.size.width/2, 50);
		//
		label = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 160, 70)];
		label.numberOfLines = 0;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		label.shadowOffset = CGSizeMake(-1.0, 1.0);
		label.shadowColor = RGBACOLOR(0,0,0,0.4);
		label.font = [UIFont systemFontOfSize:16];
		label.adjustsFontSizeToFitWidth = YES;
		label.textColor = [UIColor whiteColor];
		[self addSubview:label];
		
		backView = [[UIView alloc] initWithFrame:frame];
		backView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
		backView.backgroundColor = RGBACOLOR(0,0,0,0.1);
		backView.hidden = YES;
		
		self.alpha = 0.0;
	}
	return self;
}



-(void) setText:(NSString*) txt
{
	label.text = txt;
}

-(NSString*) text
{
	return label.text;
}

- (void)startSpinWithInfo:(NSString *)info careLandscope:(BOOL)careLandscope
{	
	[self constructView:info careLandscope:careLandscope];	
	[self performSelector:@selector(fadeOut:) withObject:nil afterDelay:1.5];

	[self showUp];
}

- (void)startSpinWithInfo:(NSString *)info {
	[self constructView:info careLandscope:NO];	    
	[self showUp];
}

- (void)constructView:(NSString *)info careLandscope:(BOOL)careLandscope {
	//这个方法己经调整逻辑，buttonTitle为空时，不会出现activityindicator
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	//这里要重新取topwindow, 所以要先remove在add
	if ([backView superview]) {
		[backView removeFromSuperview];
	}
	
	NSArray *windows = [[UIApplication sharedApplication] windows];
    
	UIWindow *topWindow = nil;
	if (careLandscope) {
		for (int i=[windows count]-1; i>=0; i--) {
			topWindow = [windows objectAtIndex:i];
			if ([topWindow.subviews count] && topWindow.bounds.size.height > 100) {
				topWindow = [topWindow.subviews objectAtIndex:0];
				break;
			}
		}
	}else {
        NSString *classType = nil;
        for (NSInteger i=0; i<[windows count]; i++) {
            topWindow = [windows objectAtIndex:i];
            classType = [NSString stringWithFormat:@"%@",topWindow.class];
            if ([classType isEqualToString:WINDOW_TEXT_EFFECTS]) {
                break;
            }else{
                topWindow = nil;
            }
        }
	}
	
    if (nil == topWindow) {
        UIWindow *tmpWindow = [(GYJAppDelegate *)[UIApplication sharedApplication].delegate window];
        topWindow = tmpWindow;
    }
    
//	if (tmpWindow.bounds.size.height > topWindow.bounds.size.height) {
//		topWindow = tmpWindow;
//	}
	[topWindow addSubview:backView];
	if ([self superview]) {
		[self removeFromSuperview];
	}
	[topWindow addSubview:self];
	[self setNeedsDisplay];
	
	
	label.text = info;

}

- (void)stopSpinWithInfo:(NSString *)info {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[activityIndicator stopAnimating];
	label.text = info;
	
	[self performSelector:@selector(fadeOut:) withObject:nil afterDelay:0.5];
	[self setNeedsDisplay];
	[self showUp];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	activityIndicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2-40);
	label.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2+5);
}


- (void)drawRect:(CGRect)rect {
	CGFloat width = 160;
	CGFloat height = 160;
	
	CGRect centerRect = CGRectMake(
								   (rect.origin.x + rect.size.width - width) / 2,
								   (rect.origin.y + rect.size.height - height) / 2,
								   width, height);
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIColor* bgColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.618];
	[bgColor set];
	
	CGContextBeginPath(context);
    [self drawRoundedRect:centerRect inContext:context withSize:CGSizeMake(10,10)];
    CGContextFillPath(context);
}
#pragma mark private methods
- (void) drawRoundedRect:(CGRect) rect inContext:(CGContextRef)context withSize:(CGSize) size
{
	float ovalWidth = size.width;
	float ovalHeight = size.height;
	
    float fw, fh;
	
    if (ovalWidth == 0 || ovalHeight == 0) {// 1
        CGContextAddRect(context, rect);
        return;
    }
	
    CGContextSaveGState(context);// 2
	
    CGContextTranslateCTM (context, CGRectGetMinX(rect),// 3
						   CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);// 4
    fw = CGRectGetWidth (rect) / ovalWidth;// 5
    fh = CGRectGetHeight (rect) / ovalHeight;// 6
	
    CGContextMoveToPoint(context, fw, fh/2); // 7
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);// 8
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);// 9
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);// 10
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // 11
    CGContextClosePath(context);// 12
	
    CGContextRestoreGState(context);// 13
	
}

- (void)showUp{
	backView.hidden = NO;
	[UIView beginAnimations:@"showUp" context:nil];
	[UIView setAnimationDuration:0.25];
	self.alpha = 1.0;
	[UIView commitAnimations];
}
- (void)fadeOut:(id)sender{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	backView.hidden = YES;
	[UIView beginAnimations:@"fadeOut" context:nil];
	[UIView setAnimationDuration:0.5];
	//[UIView setAnimationDelegate:self];
	self.alpha = 0.0;
	[UIView commitAnimations];
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//	[UIView beginAnimations:@"fadeOut" context:nil];
//	[UIView setAnimationDuration:1.0];
//	self.alpha = 0.0;
//	[UIView commitAnimations];
    
}

- (BOOL) isShowing{
	return self.alpha >0.01;
}

#pragma mark -
#pragma mark private methods
- (void)showUpWithInfo:(NSString *)info careLandscope:(BOOL)careLandscope{
    
	float width = [info sizeWithFont:[UIFont boldSystemFontOfSize:16]].width + 20;
	if (width<MIN_WIDTH) {
		width = MIN_WIDTH;
	}
	CGRect rect = self.frame;
	rect.size.width = width;
	self.frame = rect;
    
	label.text = info;
	[self setNeedsDisplay];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	if ([self superview]) {
		[self removeFromSuperview];
	}
	self.hidden = NO;
	NSArray *windows = [[UIApplication sharedApplication] windows] ;
	UIWindow *topWindow = nil;
	if (careLandscope) {
		for (int i=[windows count]-1; i>=0; i--) {
			topWindow = [windows objectAtIndex:i];
			if ([topWindow.subviews count]) {
				topWindow = [topWindow.subviews objectAtIndex:0];
				break;
			}
		}
	}else {
		topWindow = [windows objectAtIndex:0];//[windows lastObject];
	}
    
    
    
	[topWindow addSubview: self];
    self.center = CGPointMake(160, 420);
    
	[UIView beginAnimations:@"showUp" context:nil];
	[UIView setAnimationDuration:0.75];
	self.alpha = 1.0;
	[UIView commitAnimations];
	
	[self performSelector:@selector(hideInfo) withObject:nil afterDelay:1.5];
}

- (void)hideInfo{
	//self.alpha = 1.0;
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[UIView beginAnimations:@"fadeOut" context:nil];
	[UIView setAnimationDuration:1.0];
	//[UIView setAnimationDidStopSelector:@selector(removeSelf)];
	self.alpha = 0.0;
	[UIView commitAnimations];
}

@end
