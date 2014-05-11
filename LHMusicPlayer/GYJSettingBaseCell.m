//
//  GYJIMSettingBaseCell.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-2-25.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJSettingBaseCell.h"
#import "UIImageView+AFNetworking.h"

NSString * const kMarginLeft = @"kMarginLeft";
NSString * const kMarginTop = @"kMarginTop";
NSString * const kMarginBottom = @"kMarginBottom";
NSString * const kMarginImageToLabel = @"kMarginImageToLabel";
NSString * const kMarginDetailLabelToIndicator = @"kMarginDetailLabelToIndicator";
NSString * const kMarginContentToRightEdge = @"kMarginContentToRightEdge";

@implementation GYJSettingBaseCell{
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpUI];
    
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    
    _headerLabel.text = nil;
}

- (void)setUpUI{

    _headerLabel = [UILabel new];
    _headerLabel.backgroundColor = [UIColor clearColor];
    _headerLabel.textColor = [UIColor blackColor];
    _headerLabel.font = [UIFont systemFontOfSize:14.0f];
    _headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_headerLabel];

    [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.width.equalTo(self.contentView.mas_width);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(self.contentView.mas_height);
    }];
}
- (void)bindHeaderText:(NSString *)headerText detailText:(NSString *)detailText{
   _headerLabel.text = headerText; 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
