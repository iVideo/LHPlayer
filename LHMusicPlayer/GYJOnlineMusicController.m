//
//  GYJOnlineMusicController.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-10.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJOnlineMusicController.h"
#import "LHDownloadedMusicViewController.h"
#import "GYJMusicSearchViewController.h"
#import "GYJCustomNaviSegment.h"
@interface GYJOnlineMusicController ()

@property (nonatomic, strong) LHDownloadedMusicViewController *downloadMusicController;
@property (nonatomic, strong) GYJMusicSearchViewController *musicSearchViewController;
@property (nonatomic, strong) GYJCustomNaviSegment *naviSegmentControll;
@end

@implementation GYJOnlineMusicController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _naviSegmentControll = [[GYJCustomNaviSegment alloc] initWithItems:@[@"在线音乐", @"已下载音乐"]];
    _naviSegmentControll.backgroundColor = [UIColor clearColor];
    [self.customNaviBar addSubview:_naviSegmentControll];
    
    self.musicSearchViewController = [[GYJMusicSearchViewController alloc] initWithCustomNaviBar:NO];
    self.musicSearchViewController.view.frame = CGRectMake(0.0,
                                                           self.customNaviBar.bottom,
                                                           self.view.width,
                                                           self.view.height - self.customNaviBar.height);
    [self addChildViewController:_musicSearchViewController];
    [self.view addSubview:self.musicSearchViewController.view];

    [self.musicSearchViewController didMoveToParentViewController:self];
    
    [_naviSegmentControll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.customNaviBar.mas_centerX);
        make.centerY.equalTo(self.naviTitleLabel.mas_centerY);
        make.height.equalTo(@25);
        make.width.equalTo(@160);
    }];
    
    __weak typeof(self) weakSelf = self;
    _naviSegmentControll.segmentSelectedBlock = ^(NSInteger selectedIndex){
        if (selectedIndex == 0) {
            [weakSelf activateOnlineViewController];
        }else{
            [weakSelf activateLocalViewController];
        }
    };
}

- (void)activateOnlineViewController{
    if (!_musicSearchViewController) {
        self.musicSearchViewController = [[GYJMusicSearchViewController alloc] initWithCustomNaviBar:NO];
        self.musicSearchViewController.view.frame = CGRectMake(0.0,
                                                               self.customNaviBar.bottom,
                                                               self.view.width,
                                                               self.view.height - self.customNaviBar.height);
        [self addChildViewController:_musicSearchViewController];
        [_musicSearchViewController didMoveToParentViewController:self];
    }
    if (self.downloadMusicController && [self.downloadMusicController.view superview]) {
        [self.downloadMusicController.view removeFromSuperview];
    }
    [self.view addSubview:self.musicSearchViewController.view];
    
}
- (void)activateLocalViewController{
    if (!_downloadMusicController) {
        self.downloadMusicController = [[LHDownloadedMusicViewController alloc] initWithCustomNaviBar:NO];
        self.downloadMusicController.view.frame = CGRectMake(0.0,
                                                             self.customNaviBar.bottom,
                                                             self.view.width,
                                                             self.view.height - self.customNaviBar.height);
        [self addChildViewController:_downloadMusicController];
        [_downloadMusicController didMoveToParentViewController:self];
    }
    if (self.musicSearchViewController && [self.musicSearchViewController.view superview]) {
        [self.musicSearchViewController.view removeFromSuperview];
    }
    [self.view addSubview:self.downloadMusicController.view];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
