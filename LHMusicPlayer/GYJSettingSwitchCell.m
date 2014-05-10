//
//  NTESIMSettingSwitchCell.m
//  iMoney
//
//  Created by 郭亚娟 on 14-2-25.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import "GYJSettingSwitchCell.h"
#import "SevenSwitch.h"

@implementation GYJSettingSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpContent];
    }
    
    return self;
}
- (BOOL)isSwitchOn{
    return _theSwitch.isOn;
}
- (void)prepareForReuse{
    [super prepareForReuse];
}
- (void)toggleSwitch:(BOOL)on{
    [_theSwitch setOn:on animated:YES];
}
- (void)switchCallBack:(id)sender{
    SevenSwitch *tmpSwitch = (SevenSwitch *)sender;
    if (self.switchCallBackBlock) {
        self.switchCallBackBlock(tmpSwitch.isOn);
    }
}

- (void)setUpContent{
    _theSwitch = [SevenSwitch new];
    _theSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_theSwitch];
    [_theSwitch addTarget:self action:@selector(switchCallBack:) forControlEvents:UIControlEventValueChanged];
    
    // Layout
    NSDictionary *bindingViews = NSDictionaryOfVariableBindings(_theSwitch);
    NSDictionary *metrics = @{kMarginContentToRightEdge:@10,kMarginTop:@5,kMarginBottom:@5};
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_theSwitch(==50)]-kMarginContentToRightEdge-|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:bindingViews]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_theSwitch(==30)]" options:0 metrics:metrics views:bindingViews]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_theSwitch attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

@end
