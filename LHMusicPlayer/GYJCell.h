//
//  GYJIMCell.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-2-26.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+Custom.h"

typedef NS_ENUM(NSInteger, NTESIMCellAccessoryType) {
    NTESIMCellAccessoryTypeNone,
    NTESIMCellAccessoryTypeDetail,
    NTESIMCellAccessoryTypeMark
};

@interface GYJCell : UITableViewCell{
    UIImageView *_detailIndicatorView;
    UIImageView *_selectIndicatorView;
}

@property (nonatomic, assign) NTESIMCellAccessoryType cellAccessoryType;
@end
