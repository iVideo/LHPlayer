//
//  GYJRecordListCell.h
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-5.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import "GYJCell.h"

@class GYJRecordListCell;
@protocol GYJRecordListCellPlayDelegate <NSObject>

- (void)GYJRecordListCell:(GYJRecordListCell *)cell clickedFilePath:(NSURL *)filePath;

@end
@interface GYJRecordListCell : GYJCell

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UILabel *fileNameLabel;

@property (nonatomic, weak) id <GYJRecordListCellPlayDelegate>delegate;
- (void)bindFilePath:(NSURL *)filepath;
@end
