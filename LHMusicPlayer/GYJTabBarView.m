//
//  LHTabBarView.m
//  LHAD
//
//  Created by 郭亚娟 on 14-4-29.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJTabBarView.h"
#define kTabButtonTagBase 1024

@interface GYJTabBarView (){
    NSMutableArray *_tabButtonsArray;
    CGFloat _tabTitleFontHeight;
    
    NSInteger _currentIndex;
}

@end

@implementation GYJTabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _tabButtonsArray = [[NSMutableArray alloc] initWithCapacity:4];
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bg.backgroundColor = IM_NAVI_BLUE;
        [self addSubview:bg];
        
        _currentIndex = 0;
        
        // set default selected index
        [self selectTabFromButtonPressedWithIndex:0];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.backgroundView == nil) {
        self.backgroundView.frame = self.bounds;
    }
    
    CGFloat tmpWidth = (self.bounds.size.width-(_tabButtonsArray.count-1)*5)/_tabButtonsArray.count;
    CGRect buttonRect = CGRectZero;
    NSInteger index = 0;
    for (UIButton *tabButton in _tabButtonsArray) {
        if (CGRectEqualToRect(buttonRect, CGRectZero)) {
            buttonRect = CGRectMake(0.0, (self.bounds.size.height-tabButton.bounds.size.height)/2, tmpWidth, tabButton.bounds.size.height);
        }else{
            buttonRect = CGRectMake(CGRectGetMaxX(buttonRect)+5.0, buttonRect.origin.y, tmpWidth, tabButton.bounds.size.height);
        }
        tabButton.frame = buttonRect;
        
        index ++;
    }
    
}

- (void)setTabTitleImagesArray:(NSArray *)imgsArray andHighLightImagesArray:(NSArray *)imgsHLArray andTitlesArray:(NSArray *)titlesArray{
    if (verifiedNSArray(imgsArray) && imgsArray.count > 0) {
        CGRect frame = CGRectMake(0, 0, self.bounds.size.width/imgsArray.count, self.bounds.size.height);
        for (int i = 0; i <  imgsArray.count; i++) {
            UIButton *tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tabButton.backgroundColor = [UIColor clearColor];
            tabButton.tag = kTabButtonTagBase + i;
            [tabButton addTarget:self action:@selector(buttonBePressed:) forControlEvents:UIControlEventTouchUpInside];
            tabButton.backgroundColor = [UIColor clearColor];
            [tabButton setImage:(UIImage*)[imgsArray objectAtIndex:i] forState:UIControlStateNormal];
            [tabButton setImage:(UIImage*)[imgsHLArray objectAtIndex:i] forState:UIControlStateHighlighted];
            [tabButton setImage:(UIImage*)[imgsHLArray objectAtIndex:i] forState:UIControlStateSelected];
            
            [tabButton setTitle:[titlesArray objectAtIndex:i] forState:UIControlStateNormal];
            [tabButton setTitleColor:[UIColor purpleColor] forState:UIControlStateHighlighted];
            [tabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            tabButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
            tabButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5.0, 0, 0);
            
            if (i == _currentIndex) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
                    tabButton.highlighted = YES;
                });
            }
            
            tabButton.frame = frame;
            [self addSubview:tabButton];
            [_tabButtonsArray addObject:tabButton];
            frame = CGRectMake(CGRectGetMaxX(tabButton.frame), tabButton.frame.origin.y, frame.size.width, frame.size.height);
        }
    }
}

- (void)setTabTitlesArray:(NSArray*)titlesArray{
    if (verifiedNSArray(titlesArray)) {
        
        //CGRect frame = CGRectMake(0, 0, self.bounds.size.width/titlesArray.count, self.bounds.size.height);
        for (int i = 0; i <  titlesArray.count; i++) {
            UIButton *tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tabButton.tag = kTabButtonTagBase + i;
            [tabButton addTarget:self action:@selector(buttonBePressed:) forControlEvents:UIControlEventTouchUpInside];
            tabButton.backgroundColor = RGBCOLOR(198, 212, 234);
            [tabButton setTitle:[titlesArray objectAtIndex:i] forState:UIControlStateNormal];
            [tabButton setTitle:[titlesArray objectAtIndex:i] forState:UIControlStateHighlighted];
            
            [tabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [tabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            tabButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
            
            if (i == _currentIndex) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
                    tabButton.highlighted = YES;
                });
            }
            
            tabButton.frame = CGRectMake(0, 0, 50, 50);
            [self addSubview:tabButton];
            [_tabButtonsArray addObject:tabButton];
        }
    }
}

- (void)buttonBePressed:(id)sender{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *pressedButton = (UIButton*)sender;
        NSInteger selectedIndex = pressedButton.tag - kTabButtonTagBase;
        [self selectTabFromButtonPressedWithIndex:selectedIndex];
    }
}

- (void)selectTabFromButtonPressedWithIndex:(NSInteger)selectedIndex{
    if (_tabButtonsArray == nil || selectedIndex >= _tabButtonsArray.count) {
        return;
    }
    
    UIButton *currentButton = [_tabButtonsArray objectAtIndex:_currentIndex];
    currentButton.highlighted = NO;
    UIButton *targetButton = [_tabButtonsArray objectAtIndex:selectedIndex];
    _currentIndex = selectedIndex;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
        targetButton.highlighted = YES;
    });
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabSelectedWithIndex:)]) {
        [self.delegate tabSelectedWithIndex:_currentIndex];
    }
}

#pragma mark -
#pragma mark public method
- (NSInteger)currentSelectedIndex{
    return _currentIndex;
}

- (void)setDefaultSelectedTab{
    [self selectTabFromButtonPressedWithIndex:0];
}@end
