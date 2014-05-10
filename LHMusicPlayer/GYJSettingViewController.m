//
//  LHSettingViewController.m
//  LHMusicPlayer
//
//  Created by 郭亚娟 on 14-5-1.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJSettingViewController.h"
#import "GYJUserLoginViewController.h"
#import "GYJUserInfoViewController.h"
#import "GYJSettingUserHeaderView.h"
#import "GYJFriendSharedSongsViewController.h"
#import "GYJMyTagViewController.h"
#import "GYJOtherPlatformViewController.h"
#import "GYJMyLikeSongsViewController.h"
#import "GYJSettingDetailCell.h"
#import "GYJSettingSwitchCell.h"

#import "NTESMTencentManager.h"
#import "NTESIMRenrenManager.h"
#import "NTESNBShareNewMicroBlogViewController.h"

@interface GYJSettingViewController ()
@property (nonatomic, strong) UITableView *contentTableView;
@end

@implementation GYJSettingViewController{
    GYJSettingUserHeaderView *_userHeaderView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    CGRect visibleFrame = [self viewVisibleFrameWithTabbar:YES naviBar:YES];

    _userHeaderView = [[GYJSettingUserHeaderView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(visibleFrame), SCREEN_W, 90)];
    _userHeaderView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeaderTapped)];
    [_userHeaderView addGestureRecognizer:tapper];
    
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.tableHeaderView = _userHeaderView;
    [self.view addSubview:_contentTableView];
    
    [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNaviBar.mas_bottom);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
    }];
    
    
    [[GYJUserManager defaultManager] updateUserDataForKey:API_163_USER_INFO];
    [[GYJUserManager defaultManager] updateUserDataForKey:API_USER_GET_BASE_INFO];
    [self updateHeaderView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationMsg:) name:NTESIMUserLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationMsg:) name:NTESIMUserLogoutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationMsg:) name:NTESIMUserInfoChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(platformSettingChange) name:NTESIMPlatformSettingChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(platformSettingChange) name:NOTIFICATION_SINA_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(platformSettingChange) name:NOTIFICATION_TENCENT_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(platformSettingChange) name:NOTIFICATION_RENREN_LOGIN object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [self updateHeaderView];
}

- (void)getNotificationMsg:(NSNotification *)notification{
    if ([notification.name isEqualToString:NTESIMUserLoginSuccessNotification] || [notification.name isEqualToString:NTESIMUserInfoChangedNotification]) {
        [self updateHeaderView];
    } else if ([notification.name isEqualToString:NTESIMUserLogoutNotification]) {
        [self userLogout];
    }
}

- (void)updateHeaderView{
    if ([GYJUserManager defaultManager].isLoginUser) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSDictionary *userInfo = [userDefault objectForKey:KEY_USER_LOGIN_INFO];
        [_userHeaderView.avatorImageView setImageWithURL:[NSURL URLWithString:[userInfo objectForKey:@"avator"]] placeholderImage:[UIImage imageNamed:@"avator"]];
        [_userHeaderView.nickNameLabel setText:[userInfo objectForKey:@"nickname"]];
        [_userHeaderView.passpordLabel setText:[userInfo objectForKey:@"username"]];
    } else {
        _userHeaderView.avatorImageView.image = [UIImage imageNamed:@"avator"];
        _userHeaderView.nickNameLabel.text = @"\t  未登录";
        _userHeaderView.passpordLabel.text = nil;
    }
}


- (void)userHeaderTapped{
    if (![GYJUserManager defaultManager].isLoginUser) {
        GYJUserLoginViewController *loginController = [[GYJUserLoginViewController alloc] initWithCustomNaviBar:YES];

        [self.navigationController presentViewController:loginController animated:YES completion:^{
            
        }];
    } else {
        //登录控制器采用present样式  登录成功或失败则dismiss
        GYJUserInfoViewController *userInfoController = [[GYJUserInfoViewController alloc] initWithCustomNaviBar:YES];
        [self.navigationController pushViewController:userInfoController animated:YES];
    }
}

#pragma mark - Login & Logout
- (void)platformSettingChange{
    NSIndexPath *platformCellIndexPath = [NSIndexPath indexPathForRow:SettingSectionCellTypeBindOtherPlatform inSection:0];
    [_contentTableView beginUpdates];
    [_contentTableView reloadRowsAtIndexPaths:@[platformCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    [_contentTableView endUpdates];
}


- (void)userLogout{
    [_contentTableView reloadData];
    [self updateHeaderView];

}
- (void)userLoginSuccess{
    [self updateHeaderView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - UITableViewDelegate & UITableViewDataSource

- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath{
    Class cellClass = [GYJSettingBaseCell class];
    switch (indexPath.row) {
        case SettingSectionCellTypeMyCollection:
        case SettingSectionCellTypeBindOtherPlatform:
            cellClass = [GYJSettingDetailCell class];
            break;
        case SettingSectionCellTypeAutoDownload:
            cellClass = [GYJSettingSwitchCell class];
            break;
    }
    return cellClass;
}
- (GYJSettingBaseCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class cellClass = [self cellClassForIndexPath:indexPath];
    GYJSettingBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
    if (!cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:NSStringFromClass(cellClass)];
    }
    [self bindCellObjectWithIndexPath:indexPath cell:cell];
    return cell;
}

- (void)bindCellObjectWithIndexPath:(NSIndexPath *)indexPath cell:(GYJSettingBaseCell *)cell{
    switch (indexPath.row) {
        case SettingSectionCellTypeMyCollection:{
            [cell bindHeaderText:@"我的收藏" detailText:nil];
        }
            break;
        case SettingSectionCellTypeBindOtherPlatform:{
            NSString *renrenIcon = [[NTESIMRenrenManager shareInstance] isSessionValid] ? @"renren" : nil;
            NSString *sinaIcon = [NTESNBShareNewMicroBlogViewController isSinaWeiboBinded] ? @"sina" : nil;
            NSString *tentcentIcon = [[NTESMTencentManager shareInstance] isTencenWeiboBinded] ? @"tencent" : nil;
            NSMutableArray *icons = [NSMutableArray arrayWithCapacity:4];
            if (sinaIcon) {
                [icons addObject:sinaIcon];
            }
            if (tentcentIcon) {
                [icons addObject:tentcentIcon];
            }
            if (renrenIcon) {
                [icons addObject:renrenIcon];
            }
            [(GYJSettingDetailCell *)cell showOtherPlatformIcons:icons];
            [cell bindHeaderText:@"绑定第三方平台" detailText:nil];
        }
            break;
        case SettingSectionCellTypeAutoDownload:{
            [cell bindHeaderText:@"边听边下" detailText:nil];
            __weak GYJSettingSwitchCell *switchCell = (GYJSettingSwitchCell *)cell;
            [switchCell toggleSwitch:[[GYJUserManager defaultManager] currentUser].autoDownload];
            switchCell.switchCallBackBlock = ^(BOOL on){
                if (on) {
                    GYJAlert *alert = [[GYJAlert alloc] initAlertWithTitle:nil message:@"开启后在听音乐时会自动下载到本地，3G环境下不建议开启\n确认开启吗？" cancelTitle:@"否" completeBlock:^(GYJAlert *alert, NSInteger buttonIndex) {
                        if (buttonIndex == 0) {
                            [switchCell toggleSwitch:!switchCell.isSwitchOn];
                        } else {
                            NSNumber *autoDownload = [NSNumber numberWithBool:YES];
                            [[[GYJUserManager defaultManager] currentUser] updateUserInfoWith:@{@"autoDownload":autoDownload}];
                        }
                    } otherTitle:@"是", nil];
                    [alert show];
                }
            };
        }
            break;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return SettingSectionCellTypeCount;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
       case SettingSectionCellTypeMyCollection:
        {
            GYJMyLikeSongsViewController *myConnectionSongs = [[GYJMyLikeSongsViewController alloc] initWithCustomNaviBar:YES];
            [self.navigationController pushViewController:myConnectionSongs animated:YES];
        }
            break;
        case SettingSectionCellTypeAutoDownload:
        {}
            break;
        case SettingSectionCellTypeBindOtherPlatform:
        {
            GYJOtherPlatformViewController *otherPlatformController = [[GYJOtherPlatformViewController alloc] initWithCustomNaviBar:YES];
            [self.navigationController pushViewController:otherPlatformController animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
