//
//  LHHomeController.m
//  LHAD
//
//  Created by 郭亚娟 on 14-4-29.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJHomeController.h"
#import "GYJSettingViewController.h"
#import "GYJSystemMusicLibraryController.h"
#import "GYJRecorderListController.h"
#import "GYJOnlineMusicController.h"

@interface GYJHomeController ()

@property (nonatomic, strong) GYJTabBarView *mainTabBar;

@property (nonatomic, strong) GYJSystemMusicLibraryController *systemLibraryController;
@property (nonatomic, strong) GYJRecorderListController *recordListController;

@property (nonatomic, strong) GYJOnlineMusicController *onlineMusicController;

@property (nonatomic, strong) GYJSettingViewController *settingController;

@end

@implementation GYJHomeController

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

    [self loadTabControllers];
    
    self.mainTabBar = [[GYJTabBarView alloc] initWithFrame:CGRectMake(0.0, self.view.bounds.size.height - MAIN_TABBAR_HEIGHT, self.view.bounds.size.width, MAIN_TABBAR_HEIGHT)];
    
    UIImage *tabImage1 = [[UIImage imageNamed:@"home_1"] imageTintedWithColor:[UIColor blackColor]];
    UIImage *tabImage2 = [[UIImage imageNamed:@"home_2"] imageTintedWithColor:[UIColor blackColor]];
    UIImage *tabImage3 = [[UIImage imageNamed:@"home_3"] imageTintedWithColor:[UIColor blackColor]];
    UIImage *tabImage4 = [[UIImage imageNamed:@"home_4"] imageTintedWithColor:[UIColor blackColor]];
    
    UIColor *highlightColor = [UIColor purpleColor];
    NSArray *tabNormalImageArray = @[tabImage1,tabImage2,tabImage3,tabImage4];
    
    NSArray *tabHighImageArray = @[[tabImage1 imageTintedWithColor:highlightColor],[tabImage2 imageTintedWithColor:highlightColor],[tabImage3 imageTintedWithColor:highlightColor],[tabImage4 imageTintedWithColor:highlightColor]];
    
    NSArray *titleArray = @[@"点歌",@"已点歌曲",@"在线音乐",@"设置"];
    
    [self.mainTabBar setTabTitleImagesArray:tabNormalImageArray andHighLightImagesArray:tabHighImageArray andTitlesArray:titleArray];
    self.mainTabBar.delegate = self;
    [self.view addSubview:_mainTabBar];
    [_mainTabBar setDefaultSelectedTab];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBarHidden) {
        self.navigationController.navigationBarHidden = YES;
    }
}

#pragma mark - 
- (void)loadTabControllers{
    
    self.systemLibraryController = [[GYJSystemMusicLibraryController alloc] initWithCustomNaviBar:YES];
    [self addChildViewController:_systemLibraryController];
    [self.systemLibraryController didMoveToParentViewController:self];
    
    self.recordListController = [[GYJRecorderListController alloc] initWithCustomNaviBar:YES];
    [self addChildViewController:self.recordListController];
    [self.recordListController didMoveToParentViewController:self];
    
    GYJSettingViewController *settingController = [[GYJSettingViewController alloc] initWithCustomNaviBar:YES];
    self.settingController = settingController;
    [self addChildViewController:self.settingController];
    [self.settingController didMoveToParentViewController:self];
    
    self.onlineMusicController = [[GYJOnlineMusicController alloc] initWithCustomNaviBar:YES];
    [self addChildViewController:self.onlineMusicController];
    [self.onlineMusicController didMoveToParentViewController:self];

}

- (void)removeAllTabViews{
    
    if (self.systemLibraryController && [self.systemLibraryController.view superview]) {
        [self.systemLibraryController.view removeFromSuperview];
    }
    
    if (self.recordListController && [self.recordListController.view superview]) {
        [self.recordListController.view removeFromSuperview];
    }
    
    if (self.settingController && [self.settingController.view superview]) {
        [self.settingController.view removeFromSuperview];
    }
    
    if (self.onlineMusicController && [self.onlineMusicController.view superview]) {
        [self.onlineMusicController.view removeFromSuperview];
    }
    
}

- (void)tabSelectedWithIndex:(NSInteger)index{
    if (index == 0) {
        [self bringInLocalMusicListController];
    }else if (index == 1) {
        [self bringInRecorderController];
    } else if (index == 2) {
        [self bringInMusicSearchController];
    } else if (index == 3) {
        [self bringInSettingController];
    }
}

- (void)bringInLocalMusicListController{
    
    if (self.systemLibraryController  && [self.systemLibraryController parentViewController]) {
        self.systemLibraryController.view.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height - self.mainTabBar.frame.size.height);
        [self removeAllTabViews];
        [self.view addSubview:self.systemLibraryController.view];
    }
}

- (void)bringInRecorderController{
    if (self.recordListController  && [self.recordListController parentViewController]) {
        self.recordListController.view.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height - self.mainTabBar.frame.size.height);
        [self removeAllTabViews];
        [self.view addSubview:self.recordListController.view];
    }

}

- (void)bringInSettingController{
    if (self.settingController  && [self.settingController parentViewController]) {
        self.settingController.view.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height - self.mainTabBar.frame.size.height);
        [self removeAllTabViews];
        [self.view addSubview:self.settingController.view];
    }

}

- (void)bringInMusicSearchController{
    if (self.onlineMusicController  && [self.onlineMusicController parentViewController]) {
        self.onlineMusicController.view.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height - self.mainTabBar.frame.size.height);
        [self removeAllTabViews];
        [self.view addSubview:self.onlineMusicController.view];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 @end
