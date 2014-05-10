//
//  GYJMusicListCell.h
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-2.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import "GYJCell.h"

@class GYJMusicListCell;
@protocol GYJMusicListCellDelegate <NSObject>

- (void)GYJMusicListCell:(GYJMusicListCell *)cell cliekedItem:(MPMediaItem *)mediaItem;//点歌
- (void)GYJMusicListCell:(GYJMusicListCell *)cell playItem:(MPMediaItem *)mediaItem;//播放
@end
@interface GYJMusicListCell : GYJCell

@property (nonatomic, strong) UIImageView *artWorkImage;
@property (nonatomic, strong) UILabel *songNameLabel;
@property (nonatomic, strong) UILabel *artistLabel;

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *singButton;

@property (nonatomic, weak) id <GYJMusicListCellDelegate> delegate;

- (void)bindMediaItem:(MPMediaItem *)mediaItem;
@end
