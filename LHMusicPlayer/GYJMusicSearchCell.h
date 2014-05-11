//
//  GYJMusicSearchCell.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-10.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJCell.h"

@class GYJMusicSearchObject;
@interface GYJMusicSearchCell : GYJCell

@property (nonatomic, strong) UIImageView *singerView;
@property (nonatomic, strong) UILabel *singerLabel;
@property (nonatomic, strong) UILabel *songNameLabel;

- (void)bindObject:(GYJMusicSearchObject *)musicObject;
@end
