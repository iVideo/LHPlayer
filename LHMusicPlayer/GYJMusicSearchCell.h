//
//  GYJMusicSearchCell.h
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-10.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import "GYJCell.h"

@class GYJMusicSearchObject;
@interface GYJMusicSearchCell : GYJCell

@property (nonatomic, strong) UIImageView *singerView;
@property (nonatomic, strong) UILabel *singerLabel;
@property (nonatomic, strong) UILabel *songNameLabel;

- (void)bindObject:(GYJMusicSearchObject *)musicObject;
@end
