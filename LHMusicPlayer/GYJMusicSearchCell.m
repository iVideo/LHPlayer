//
//  GYJMusicSearchCell.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-10.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJMusicSearchCell.h"
#import "UIImageView+AFNetworking.h"
#import "GYJMusicSearchObject.h"

@implementation GYJMusicSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.singerView = [UIImageView new];
        [self.contentView addSubview:_singerView];
        self.singerLabel = [UILabel makeLabelWithStr:nil fontSize:14 textColor:nil superView:self.contentView];
        self.songNameLabel = [UILabel makeLabelWithStr:nil fontSize:14 textColor:nil superView:self.contentView];
        
        [_songNameLabel setTextAlignment:NSTextAlignmentLeft];
        [_singerLabel setTextAlignment:NSTextAlignmentLeft];
        
        [_songNameLabel setTextVerticalAlignment:UITextVerticalAlignmentMiddle];
        [_singerLabel setTextVerticalAlignment:UITextVerticalAlignmentMiddle];
        
        [_singerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(2);
            make.top.equalTo(self.contentView.mas_top).offset(2);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-2);
            make.width.equalTo(_singerView.mas_height);
        }];
        
        [_songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_singerView.mas_right).offset(5);
            make.top.equalTo(_singerView.mas_top);
            make.width.equalTo(self.contentView.mas_width);
        }];
        
        [_singerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_songNameLabel.mas_left);
            make.top.equalTo(_songNameLabel.mas_bottom);
            make.width.equalTo(_songNameLabel.mas_width);
        }];
        
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    _singerView.image = nil;
    _songNameLabel.text = nil;
    _singerLabel.text = nil;
}


- (void)bindObject:(GYJMusicSearchObject *)musicObject{
    if (!musicObject) {
        return;
    }
    
    if (![musicObject isKindOfClass:[GYJMusicSearchObject class]]){
        return;
    }
    
    NSString *imageURLString = musicObject.singerPicSmall;
    if (!verifiedString(imageURLString)) {
        imageURLString = verifiedString(musicObject.albumPicSmall) ?  musicObject.singerPicSmall : @"";
    }
#warning 默认图片
    [_singerView setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:nil];
    
    _songNameLabel.text = verifiedString(musicObject.song) ?  musicObject.song : @"";
    _singerLabel.text = verifiedString(musicObject.singer) ?  musicObject.singer : @"";
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
}
@end
