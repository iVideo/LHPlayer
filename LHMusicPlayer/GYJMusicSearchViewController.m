//
//  GYJMusicSearchViewController.m
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-10.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import "GYJMusicSearchViewController.h"
#import "GYJMusicOperationManager.h"
#import "GYJMusicSearchCell.h"
#import "GYJMusicSearchObject.h"
#import "GYJMusicSearchDetailObject.h"
#import "LHOnlineMusicPlayerController.h"

static NSString *musicCellID = @"musicSearchcell_id";
@interface GYJMusicSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, strong)NSArray *searchDataArray;
@end

@implementation GYJMusicSearchViewController{
    
}

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
    
    // create searchBar;
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.backgroundColor = IM_240_GRAY;
    self.searchBar.inputView.backgroundColor = [UIColor redColor];
    [self.searchBar setBackgroundImage:nil];
    [self.searchBar setSearchFieldBackgroundImage:nil forState:UIControlStateNormal];
    [self.searchBar setImage:[UIImage imageNamed:@"base_search_magnifier.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchBar setImage:[UIImage imageNamed:@"base_search_fork.png"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [_searchBar sizeToFit];
    _searchBar.placeholder = @"搜索歌曲，演唱者或者专辑名称";
    
    self.searchDataArray = @[];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.tableHeaderView = _searchBar;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[GYJMusicSearchCell class] forCellReuseIdentifier:musicCellID];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    
}
#pragma mark -
#pragma mark - search bar delegate method
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.view endEditing:YES];
    
    if (verifiedString(searchBar.text)) {
        [SVProgressHUD showWithStatus:@"正在搜索"];
        __weak typeof(self) weakSelf = self;
        [[GYJMusicOperationManager sharedMusicOperationManager] searchWithKeyword:searchBar.text success:^(NSArray *musicSearchObjects) {
            [SVProgressHUD dismiss];
            __strong typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.searchDataArray = musicSearchObjects;
            [strongSelf.tableView reloadData];
        } failure:^(id errInfo) {
            [SVProgressHUD dismiss];
        }];
    }
}

#pragma mark - UItableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.searchDataArray count];
}

- (GYJMusicSearchCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GYJMusicSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:musicCellID];
    [cell bindObject:[self.searchDataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    GYJMusicSearchObject *selectedSong = [self.searchDataArray objectAtIndex:indexPath.row];
    [[GYJMusicOperationManager sharedMusicOperationManager] searchMusicDetailWithSongID:selectedSong.song_id success:^(GYJMusicSearchDetailObject *musicDetailObject) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf playItem:musicDetailObject];
        
    } failure:^(id errInfo) {
        
    }];
}

- (void)playItem:(GYJMusicSearchDetailObject *)musicDetailObject{
    
    LHOnlineMusicPlayerController *onlineMusicPlayer = [[LHOnlineMusicPlayerController alloc] initWithGYJMusicSearchDetailObject:musicDetailObject];
    
    [self.navigationController pushViewController:onlineMusicPlayer animated:YES];
//    NSURL *downloadURL = [NSURL URLWithString:musicDetailObject.songLink];
//    [[GYJMusicOperationManager sharedMusicOperationManager] downloadFileWithPath:[[GYJMusicOperationManager sharedMusicOperationManager] musicDownloadPath] fileURL:downloadURL downProgress:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        NSLog(@"Progress:%lld  totleBytes:%lld",totalBytesRead,totalBytesExpectedToRead);
//    }];
}

@end
