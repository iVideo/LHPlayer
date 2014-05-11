//
//  GYJTabBarView.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-4-29.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultFontHeight 16.0f

@protocol LHTabBarViewDelegate <NSObject>

- (void)tabSelectedWithIndex:(NSInteger)index;

@end

@interface GYJTabBarView : UIView

@property(nonatomic, strong)UIImageView *backgroundView;
@property(nonatomic, weak)id<LHTabBarViewDelegate> delegate;

- (void)setTabTitleImagesArray:(NSArray*)imgsArray andHighLightImagesArray:(NSArray*)imgsHLArray andTitlesArray:(NSArray*)titlesArray;
- (void)setTabTitlesArray:(NSArray*)titlesArray;

- (NSInteger)currentSelectedIndex;
- (void)setDefaultSelectedTab;
@end
