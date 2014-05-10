//
//  NTESIMSettingDetailCell.m
//  iMoney
//
//  Created by 郭亚娟 on 14-2-25.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import "GYJSettingDetailCell.h"
#import "SevenSwitch.h"

@implementation GYJSettingDetailCell{
    NSArray *_icons;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _icons = nil;
        [self setContentUI];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    _infoLabel.hidden = verifiedNSArray(_icons) ? YES : NO;
    _shareIconsView.hidden = YES;
}
- (void)setContentUI{
    _detailIndicator = [UIImageView new];
    _detailIndicator.image = [UIImage imageNamed:@"cell_detail_indicator"];
    _detailIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_detailIndicator];
    
    _infoLabel = [UILabel new];
    _infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _infoLabel.backgroundColor = [UIColor clearColor];
    _infoLabel.textColor = [UIColor colorWithHexString:@"383838"];
    _infoLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_infoLabel];
    
    
    _shareIconsView = [UIView new];
    _shareIconsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_shareIconsView];
    
    // Layout
    NSDictionary *viewBindings = NSDictionaryOfVariableBindings(_headerLabel,_detailIndicator,_infoLabel,_shareIconsView);
    NSDictionary *metrics = @{kMarginContentToRightEdge:@10,kMarginDetailLabelToIndicator:@10};
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_infoLabel(<=80)]-kMarginDetailLabelToIndicator-[_detailIndicator]-kMarginContentToRightEdge-|"
                                                                             options:NSLayoutFormatAlignAllCenterY metrics:metrics views:viewBindings]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_detailIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_shareIconsView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_shareIconsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_shareIconsView(<=140)]-|" options:0 metrics:metrics views:viewBindings]];
    
}
- (void)bindHeaderText:(NSString *)headerText detailText:(NSString *)detailText{
    [super bindHeaderText:headerText detailText:detailText];
    _infoLabel.text = detailText;
}

- (void)showOtherPlatformIcons:(NSArray *)iconNames{

    _icons = iconNames;
    

    NSUInteger iconCount = iconNames.count;
     _infoLabel.hidden = (iconCount > 0) ? YES : NO;
    if (!verifiedNSArray(iconNames)) {
        return;
    }
    _shareIconsView.hidden = (iconCount > 0) ? NO : YES;
    if (iconCount > 0) {
        for (UIView *v in _shareIconsView.subviews) {
            [v removeFromSuperview];
        }
    }
    
    NSUInteger index = 0;
    for (NSString *platform in iconNames) {
        UIImage *icon = [UIImage imageNamed:[NSString stringWithFormat:@"share_platform_%@",platform]];
        UIImageView *iconView = [UIImageView new];
        iconView.image = icon;
        iconView.tag = index;
        [_shareIconsView addSubview:iconView];
        index ++;
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@36);
            make.height.equalTo(@36);
            make.centerY.equalTo(_shareIconsView.mas_centerY);
            make.centerX.equalTo(_shareIconsView.mas_right).offset(-20-34*iconView.tag);
        }];
        if (index >= 4) {
            break;
        }
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
@end
