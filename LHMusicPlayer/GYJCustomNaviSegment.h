//
//  GYJCustomNaviSegment.h
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-2.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYJCustomNaviSegment : UIView

@property (nonatomic, copy)void(^segmentSelectedBlock)(NSInteger selectedIndex);

@property (nonatomic, assign)NSInteger selectedIndex;

- (id)initWithItems:(NSArray*)itemsArray;

@end
