//
//  GYJRecordListCell.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-5.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJRecordListCell.h"

@interface GYJRecordListCell ()

@property (nonatomic, strong) NSURL *filePath;
@end
@implementation GYJRecordListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.fileNameLabel = [UILabel makeLabelWithStr:nil fontSize:14 textColor:[UIColor grayColor] superView:self.contentView];
        [_fileNameLabel setTextAlignment:NSTextAlignmentLeft];
        [_fileNameLabel setTextVerticalAlignment:UITextVerticalAlignmentMiddle];
        
        UIImage *buttonNormalImage = [UIImage imageNamed:@"sing_button_normal"];
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_playButton setBackgroundImage:buttonNormalImage forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"sing_button_press"] forState:UIControlStateHighlighted];
        [_playButton setTitle:@"播放" forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playButtonClieked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_playButton];
        
        [_fileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.width.equalTo(self.contentView.mas_width);
            make.height.equalTo(self.contentView.mas_height);
        }];
        
        [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-5);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(buttonNormalImage.size.width));
        }];
    }
    return self;
}

- (void)playButtonClieked:(id)sender{
    if ([self.delegate respondsToSelector:@selector(GYJRecordListCell:clickedFilePath:)]){
        [self.delegate GYJRecordListCell:self clickedFilePath:_filePath];
    }
}

- (void)bindFilePath:(NSURL *)filepath{
    self.filePath = filepath;
    
    self.fileNameLabel.text = [filepath lastPathComponent];
}

@end
