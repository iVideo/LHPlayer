//
//  NTESIMCell.m
//  iMoney
//
//  Created by 郭亚娟 on 14-2-26.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import "GYJCell.h"

@implementation GYJCell{
    UIImageView *_separatorLine;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _separatorLine = [UIImageView new];
        _separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
        _separatorLine.backgroundColor = [UIColor clearColor];
        _separatorLine.image = [UIImage imageNamed:@"SeparatorLine"];
        [self.contentView addSubview:_separatorLine];
        
        UIImage *detailIndicatorImage = [UIImage imageNamed:@"cell_detail_indicator"];
        _detailIndicatorView = [[UIImageView alloc] initWithImage:detailIndicatorImage];
        [self.contentView addSubview:_detailIndicatorView];
        
        UIImage *selectedIndicator = [UIImage imageNamed:@"cell_selected_indicator"];
        _selectIndicatorView = [[UIImageView alloc] initWithImage:selectedIndicator];
        [self.contentView addSubview:_selectIndicatorView];
        
        [_separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView);
            make.left.equalTo(@0);
            make.bottom.equalTo(self.contentView).offset(0);
        }];
        
        [_detailIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.width.equalTo([NSNumber numberWithFloat:detailIndicatorImage.size.width]);
            make.height.equalTo([NSNumber numberWithFloat:detailIndicatorImage.size.height]);
        }];
        
        [_selectIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.width.equalTo([NSNumber numberWithFloat:selectedIndicator.size.width]);
            make.height.equalTo([NSNumber numberWithFloat:selectedIndicator.size.height]);
        }];
       
        self.cellAccessoryType = NTESIMCellAccessoryTypeNone;
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    
}

- (void)setCellAccessoryType:(NTESIMCellAccessoryType)cellAccessoryType{
    _cellAccessoryType = cellAccessoryType;
    
    switch (_cellAccessoryType) {
        case NTESIMCellAccessoryTypeNone:
            _detailIndicatorView.hidden = YES;
            _selectIndicatorView.hidden = YES;
            break;
        case NTESIMCellAccessoryTypeDetail:
            _detailIndicatorView.hidden = NO;
            _selectIndicatorView.hidden = YES;
            break;
        case NTESIMCellAccessoryTypeMark:
            _detailIndicatorView.hidden = YES;
            _selectIndicatorView.hidden = NO;
            break;
        default:
            _detailIndicatorView.hidden = YES;
            _selectIndicatorView.hidden = YES;
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
