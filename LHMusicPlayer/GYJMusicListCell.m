//
//  GYJMusicListCell.m
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-2.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import "GYJMusicListCell.h"
@interface GYJMusicListCell ()

@property (nonatomic, strong) MPMediaItem *mediaItem;
@end
@implementation GYJMusicListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.artWorkImage = [UIImageView new];
        [self.contentView addSubview:_artWorkImage];
        [_artWorkImage setImage:[UIImage imageNamed:@"artwork_empty"]];
        
        self.songNameLabel = [UILabel makeLabelWithStr:@"" fontSize:15 textColor:nil superView:self.contentView];
        [_songNameLabel setTextAlignment:NSTextAlignmentLeft];
        
        
        self.artistLabel = [UILabel makeLabelWithStr:@"" fontSize:12 textColor:[UIColor colorWithHexString:@"A37A5E"] superView:self.contentView];
        [_artistLabel setTextAlignment:NSTextAlignmentLeft];
        
        UIImage *buttonNormalImage = [UIImage imageNamed:@"sing_button_normal"];
        self.singButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_singButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_singButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_singButton setBackgroundImage:buttonNormalImage forState:UIControlStateNormal];
        [_singButton setBackgroundImage:[UIImage imageNamed:@"sing_button_press"] forState:UIControlStateHighlighted];
        [_singButton setTitle:@"演唱" forState:UIControlStateNormal];
        [_singButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_singButton];
        
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_playButton setBackgroundImage:buttonNormalImage forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"sing_button_press"] forState:UIControlStateHighlighted];
        [_playButton setTitle:@"播放" forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playButtonClieked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_playButton];

        
        [_artWorkImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(2);
            make.top.equalTo(self.contentView.mas_top).offset(2);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-2);
            make.width.equalTo(_artWorkImage.mas_height);
        }];
        
        [_songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_artWorkImage.mas_right).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.height.equalTo(@20);
            make.right.equalTo(_playButton.mas_left);
        }];
        
        [_artistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_songNameLabel.mas_left);
            make.top.equalTo(self.contentView.mas_centerY);
            make.height.equalTo(@20);
            make.right.equalTo(_songNameLabel.mas_right);
        }];
        
        [_singButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(buttonNormalImage.size.width));
        }];
        
        [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_singButton.mas_left).offset(-5);
            make.centerY.equalTo(_singButton.mas_centerY);
            make.width.equalTo(@(buttonNormalImage.size.width));
        }];

    }
    return self;
}

- (void)bindMediaItem:(MPMediaItem *)mediaItem{
    self.mediaItem = mediaItem;
    
    NSString *songName = verifiedString([mediaItem valueForProperty:MPMediaItemPropertyTitle]) ? [mediaItem valueForProperty:MPMediaItemPropertyTitle] : @"---";
    NSString *songArtist = verifiedString([mediaItem valueForProperty:MPMediaItemPropertyArtist]) ? [mediaItem valueForProperty:MPMediaItemPropertyArtist] : @"未知表演者";

    _songNameLabel.text = songName;
    _artistLabel.text = songArtist;
    
    MPMediaItemArtwork *artWork = [mediaItem valueForProperty:MPMediaItemPropertyArtwork];
    if (artWork){
        UIImage *artworkImage = [artWork imageWithSize:self.artWorkImage.size];
        if (artworkImage) {
            self.artWorkImage.image = [artWork imageWithSize:self.artWorkImage.size];
        } else {
            self.artWorkImage.image = [UIImage imageNamed:@"artwork_empty"];
        }
    }

}

- (void)playButtonClieked:(id)sender{
    if ([self.delegate respondsToSelector:@selector(GYJMusicListCell:playItem:)]){
        [self.delegate GYJMusicListCell:self playItem:_mediaItem];
    }
}

- (void)buttonClicked:(id)sender{
    if ([self.delegate respondsToSelector:@selector(GYJMusicListCell:cliekedItem:)]){
        [self.delegate GYJMusicListCell:self cliekedItem:_mediaItem];
    }
}
@end
