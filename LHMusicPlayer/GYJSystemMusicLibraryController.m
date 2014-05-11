//
//  GYJSystemMusicLibraryController.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-7.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJSystemMusicLibraryController.h"
#import "GYJMusicListCell.h"
#import "GYJMusicPlayerController.h"
#import "GYJRecordMusicController.h"

static NSString *cellID = @"musicCellID";

@interface GYJSystemMusicLibraryController ()<UITableViewDelegate,UITableViewDataSource,GYJMusicListCellDelegate>

@property (nonatomic, strong) NSArray *musicArray;
@property (nonatomic, strong) UITableView *musicListtableView;
@property (nonatomic, strong) MPMediaQuery *query;
@end

@implementation GYJSystemMusicLibraryController

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

    self.title = @"系统音乐";
    
    self.musicListtableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _musicListtableView.delegate = self;
    _musicListtableView.dataSource = self;
    _musicListtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_musicListtableView registerClass:[GYJMusicListCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:_musicListtableView];
    
    [_musicListtableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNaviBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.query = [MPMediaQuery songsQuery];
        self.musicArray = [_query items];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_musicListtableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UItableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.musicArray count];
}

- (GYJMusicListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GYJMusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.delegate = self;
    [cell bindMediaItem:[self.musicArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)GYJMusicListCell:(GYJMusicListCell *)cell playItem:(MPMediaItem *)mediaItem{
    GYJMusicPlayerController *musicPlayer = [[GYJMusicPlayerController alloc] initWithMediaItem:mediaItem];
    [self.navigationController pushViewController:musicPlayer animated:YES];
    
}

- (void)GYJMusicListCell:(GYJMusicListCell *)cell cliekedItem:(MPMediaItem *)mediaItem{
    GYJRecordMusicController *recordController = [[GYJRecordMusicController alloc] initWithMediaItem:mediaItem];
    [self.navigationController pushViewController:recordController animated:YES];
}

@end
