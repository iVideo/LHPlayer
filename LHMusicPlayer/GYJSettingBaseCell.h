//
//  NTESIMSettingBaseCell.h
//  iMoney
//
//  Created by 郭亚娟 on 14-2-25.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//
//  设置页默认cell，左边一个label
//

#import "GYJCell.h"

extern NSString * const kMarginLeft;
extern NSString * const kMarginTop;
extern NSString * const kMarginBottom;
extern NSString * const kMarginImageToLabel;
extern NSString * const kMarginDetailLabelToIndicator;
extern NSString * const kMarginContentToRightEdge;

@interface GYJSettingBaseCell : GYJCell{
    UILabel *_headerLabel;
}
@property (nonatomic, strong) UILabel *headerLabel;
- (void)bindHeaderText:(NSString *)headerText detailText:(NSString *)detailText NS_REQUIRES_SUPER;
@end
