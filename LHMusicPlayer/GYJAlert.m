//
//  GYJMAlert.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-3-6.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJAlert.h"

@interface NTESMAlertQueue : NSObject
@property (nonatomic) NSMutableArray *alertViews;

+ (NTESMAlertQueue *)sharedQueue;

- (void)add:(GYJAlert *)alertView;
- (void)remove:(GYJAlert *)alertView;
@end

static const CGFloat AlertViewWidth = 270.0;
static const CGFloat AlertViewContentMargin = 9;
static const CGFloat AlertViewVerticalElementSpace = 10;
static const CGFloat AlertViewButtonHeight = 44;
static const CGFloat AlertViewLineLayerWidth = 0.5;

@interface GYJAlert ()
@property (nonatomic) UIWindow *mainWindow;
@property (nonatomic) UIWindow *alertWindow;
@property (nonatomic) UIView *alertView;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIView *contentView;
@property (nonatomic) UILabel *messageLabel;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *otherButton;
@property (nonatomic) NSArray *buttons;
@property (nonatomic) CGFloat buttonsY;
@property (nonatomic) CALayer *verticalLine;

@property (nonatomic, copy) NTESMAlertBlock completeBlock;
@end
@implementation GYJAlert
- (instancetype)initAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                     completeBlock:(NTESMAlertBlock)block
                        otherTitle:(NSString *)otherTitle, ...{
    self = [super init];
    if (self) {
        _mainWindow = [[UIApplication sharedApplication] keyWindow];
        
        CGRect frame = _mainWindow.bounds;
        self.frame = frame;
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
        _backgroundView.alpha = 0;
        [self addSubview:_backgroundView];
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 8.0;
        _alertView.clipsToBounds = YES;
        [self addSubview:_alertView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(AlertViewContentMargin,
                                                                AlertViewVerticalElementSpace,
                                                                AlertViewWidth - AlertViewContentMargin*2,
                                                                44)];
        _titleLabel.text = title;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.frame = [self adjustLabelFrameHeight:self.titleLabel];
        [_alertView addSubview:_titleLabel];
        
        CGFloat messageLabelY = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + AlertViewVerticalElementSpace;
        
        // Message
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(AlertViewContentMargin,
                                                                  messageLabelY,
                                                                  AlertViewWidth - AlertViewContentMargin*2,
                                                                  44)];
        _messageLabel.text = message;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageLabel.numberOfLines = 0;
        _messageLabel.frame = [self adjustLabelFrameHeight:self.messageLabel];
        [_alertView addSubview:_messageLabel];
        
        // Line
        CALayer *lineLayer = [self lineLayer];
        lineLayer.frame = CGRectMake(0, _messageLabel.frame.origin.y + _messageLabel.frame.size.height + AlertViewVerticalElementSpace, AlertViewWidth, AlertViewLineLayerWidth);
        [_alertView.layer addSublayer:lineLayer];
        
        _buttonsY = lineLayer.frame.origin.y + lineLayer.frame.size.height;
        
        // Buttons
        if (cancelTitle) {
            [self addButtonWithTitle:cancelTitle];
        } else {
            [self addButtonWithTitle:NSLocalizedString(@"Ok", nil)];
        }
        
        if (otherTitle){
            va_list args;
			va_start(args, otherTitle);
			NSString *buttonTitle;
			[self addButtonWithTitle:otherTitle];
			while ((buttonTitle = va_arg(args, NSString *))) {
				[self addButtonWithTitle:buttonTitle];
			}
			
			va_end(args);
        }
		_alertView.bounds = CGRectMake(0, 0, AlertViewWidth, 150);
        
        if (block) {
            _completeBlock = block;
        }
        
        [self resizeViews];
        
        _alertView.center = [self centerWithFrame:frame];
    }
    return self;
}

- (void)show{
    [[NTESMAlertQueue sharedQueue] add:self];
}
- (void)hide{
    [self removeFromSuperview];
}

- (void)showInternal
{
    [_mainWindow addSubview:self];
    [self.mainWindow makeKeyAndVisible];
    [self showBackgroundView];
    [self showAlertAnimation];
}

- (void)showBackgroundView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.mainWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        [self.mainWindow tintColorDidChange];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 1;
    }];
}

- (void)showAlertAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .3;
    
    [self.alertView.layer addAnimation:animation forKey:@"showAlert"];
}

- (UIWindow *)windowWithLevel:(UIWindowLevel)windowLevel
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows) {
        if (window.windowLevel == windowLevel) {
            return window;
        }
    }
    return nil;
}

- (CGPoint)centerWithFrame:(CGRect)frame
{
    return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - [self statusBarOffset]);
}

- (CGFloat)statusBarOffset
{
    CGFloat statusBarOffset = 0;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        statusBarOffset = 20;
    }
    return statusBarOffset;
}

- (void)dismiss:(id)sender
{
    [self dismiss:sender animated:YES];
}

- (void)dismiss:(id)sender animated:(BOOL)animated
{    
    if ([[[NTESMAlertQueue sharedQueue] alertViews] count] == 1) {
        if (animated) {
            [self dismissAlertAnimation];
        }
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            self.mainWindow.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            [self.mainWindow tintColorDidChange];
        }
        [UIView animateWithDuration:(animated ? 0.2 : 0) animations:^{
            self.backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.alertWindow removeFromSuperview];
            self.alertWindow = nil;
            [self.mainWindow makeKeyAndVisible];
        }];
    }
    
    [UIView animateWithDuration:(animated ? 0.2 : 0) animations:^{
        self.alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [[NTESMAlertQueue sharedQueue] remove:self];
        [self removeFromSuperview];
    }];
    
    if (self.completeBlock) {
        NSInteger buttonIndex = -1;
        if (self.buttons) {
            NSUInteger index = [self.buttons indexOfObject:sender];
            if (buttonIndex != NSNotFound) {
                buttonIndex = index;
            }
        }
        self.completeBlock(self, buttonIndex);
    }
}

- (void)dismissAlertAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeRemoved;
    animation.duration = .2;
    
    [self.alertView.layer addAnimation:animation forKey:@"dismissAlert"];
}

- (void)resizeViews
{
    CGFloat totalHeight = 0;
    for (UIView *view in [self.alertView subviews]) {
        if ([view class] != [UIButton class]) {
            totalHeight += view.frame.size.height + AlertViewVerticalElementSpace;
        }
    }
    if (self.buttons) {
        NSUInteger otherButtonsCount = [self.buttons count];
        totalHeight += AlertViewButtonHeight * (otherButtonsCount > 2 ? otherButtonsCount : 1);
    }
    totalHeight += AlertViewVerticalElementSpace;
    
    self.alertView.frame = CGRectMake(self.alertView.frame.origin.x,
                                      self.alertView.frame.origin.y,
                                      self.alertView.frame.size.width,
                                      totalHeight);
}

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    UIButton *button = [self genericButton];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    if (!self.cancelButton) {
        self.cancelButton = button;
        self.cancelButton.frame = CGRectMake(0, self.buttonsY, AlertViewWidth, AlertViewButtonHeight);
    } else if (self.buttons && [self.buttons count] > 1) {
        UIButton *lastButton = (UIButton *)[self.buttons lastObject];
        lastButton.titleLabel.font = [UIFont systemFontOfSize:17];
        if ([self.buttons count] == 2) {
            [self.verticalLine removeFromSuperlayer];
            CALayer *lineLayer = [self lineLayer];
            lineLayer.frame = CGRectMake(0, self.buttonsY + AlertViewButtonHeight, AlertViewWidth, AlertViewLineLayerWidth);
            [self.alertView.layer addSublayer:lineLayer];
            lastButton.frame = CGRectMake(0, self.buttonsY + AlertViewButtonHeight, AlertViewWidth, AlertViewButtonHeight);
            self.cancelButton.frame = CGRectMake(0, self.buttonsY, AlertViewWidth, AlertViewButtonHeight);
        }
        CGFloat lastButtonYOffset = lastButton.frame.origin.y + AlertViewButtonHeight;
        button.frame = CGRectMake(0, lastButtonYOffset, AlertViewWidth, AlertViewButtonHeight);
        CALayer *lineLayer = [self lineLayer];
        lineLayer.frame = CGRectMake(0, lastButtonYOffset, AlertViewWidth, AlertViewLineLayerWidth);
        [self.alertView.layer addSublayer:lineLayer];
    } else {
        self.verticalLine = [self lineLayer];
        self.verticalLine.frame = CGRectMake(AlertViewWidth/2, self.buttonsY, AlertViewLineLayerWidth, AlertViewButtonHeight);
        [self.alertView.layer addSublayer:self.verticalLine];
        button.frame = CGRectMake(AlertViewWidth/2, self.buttonsY, AlertViewWidth/2, AlertViewButtonHeight);
        self.otherButton = button;
        self.cancelButton.frame = CGRectMake(0, self.buttonsY, AlertViewWidth/2, AlertViewButtonHeight);
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    
    [self.alertView addSubview:button];
    self.buttons = (self.buttons) ? [self.buttons arrayByAddingObject:button] : @[ button ];
    return [self.buttons count] - 1;
}
- (UIButton *)genericButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor colorWithHexString:@"007AFF"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(clearBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    return button;
}

- (void)setBackgroundColorForButton:(id)sender
{
    [(UIButton *)sender setBackgroundColor:[UIColor colorWithHexString:@"D9D9D9"]];
}

- (void)clearBackgroundColorForButton:(id)sender
{
    [(UIButton *)sender setBackgroundColor:[UIColor clearColor]];
}

- (CALayer *)lineLayer
{
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = [[UIColor colorWithHexString:@"C3C3C3"] CGColor];
    return lineLayer;
}

- (CGRect)adjustLabelFrameHeight:(UILabel *)label
{
    CGFloat height;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize size = [label.text sizeWithFont:label.font
                             constrainedToSize:CGSizeMake(label.frame.size.width, FLT_MAX)
                                 lineBreakMode:NSLineBreakByWordWrapping];
        
        height = size.height;
#pragma clang diagnostic pop
    } else {
        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
        context.minimumScaleFactor = 1.0;
        CGRect bounds = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, FLT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:label.font}
                                                 context:context];
        height = bounds.size.height;
    }
    
    return CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, height);
}

@end
@implementation NTESMAlertQueue

+ (NTESMAlertQueue *)sharedQueue{
    static NTESMAlertQueue *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NTESMAlertQueue alloc] init];
        _sharedInstance.alertViews = [NSMutableArray array];
    });
    
    return _sharedInstance;
}

- (void)add:(GYJAlert *)alertView{
    [self.alertViews addObject:alertView];
    [alertView showInternal];
    for (GYJAlert *av in self.alertViews) {
        if (av != alertView) {
            [av hide];
        }
    }
    
}
- (void)remove:(GYJAlert *)alertView{
    [self.alertViews removeObject:alertView];
    GYJAlert *last = [self.alertViews lastObject];
    if (last) {
        [last showInternal];
    }

}

@end
