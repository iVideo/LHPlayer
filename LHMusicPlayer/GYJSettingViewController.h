//
//  LHSettingViewController.h
//  LHMusicPlayer
//
//  Created by 郭亚娟 on 14-5-1.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJMainBaseViewController.h"
typedef NS_ENUM(NSInteger, UserInfoSectionCellType) {
    UserInfoSectionCellTypeUserInfo = 0,
    UserInfoSectionCellTypeCount
};
typedef NS_ENUM(NSInteger, SettingSectionCellType) {
    SettingSectionCellTypeMyLike = 0,//我喜欢
    SettingSectionCellTypeMyCollection,//我的收藏
    SettingSectionCellTypeFriendShared,//收到的好友点歌
    SettingSectionCellTypeAutoDownload,//边听边下
    SettingSectionCellTypeBindOtherPlatform,
    SettingSectionCellTypeCount
};

@interface GYJSettingViewController : GYJMainBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong, readonly) UITableView *contentTableView;
@end
