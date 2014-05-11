//
//  GYJMyLikeSongsViewController.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-1.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJMyLikeSongsViewController.h"
#import "GYJMusicCollectionDataBase.h"
#import "GYJLikeMusicCell.h"

static NSString *cellID = @"liked_music_cell";
@interface GYJMyLikeSongsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *fetchedMusicArray;
@end

@implementation GYJMyLikeSongsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//返回
- (void)doBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"我喜欢的音乐";
    
    [self addLeftButtonTitle:@"返回" target:self action:@selector(doBack)];
    
    self.fetchedMusicArray = @[];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[GYJLikeMusicCell class] forCellReuseIdentifier:cellID];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNaviBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    __weak typeof(self) weakSelf = self;
    [[GYJMusicCollectionDataBase sharedInstance] fetchMediaItemDictionatys:^(NSArray *collectionMusics) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.fetchedMusicArray = [collectionMusics copy];
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - UItableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.fetchedMusicArray count];
}

- (GYJLikeMusicCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GYJLikeMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = [self.fetchedMusicArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *tempArray = [self.fetchedMusicArray mutableCopy];
    
    if (indexPath.row > [tempArray count]) {
        return;
    }
    [tableView beginUpdates];
    [tempArray removeObjectAtIndex:indexPath.row];
    self.fetchedMusicArray = [tempArray copy];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];

}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
