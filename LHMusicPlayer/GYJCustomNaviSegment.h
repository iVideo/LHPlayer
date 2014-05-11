//
//  GYJCustomNaviSegment.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-2.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYJCustomNaviSegment : UIView

@property (nonatomic, copy)void(^segmentSelectedBlock)(NSInteger selectedIndex);

@property (nonatomic, assign)NSInteger selectedIndex;

- (id)initWithItems:(NSArray*)itemsArray;

@end
