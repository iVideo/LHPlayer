//
//  GYJRecordListCell.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-5.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
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
