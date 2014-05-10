//
//  LHDownloadedMusicViewController.m
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-10.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import "LHDownloadedMusicViewController.h"
#import "GYJRecordListCell.h"
#import "GYJRecorderPlayerController.h"
#import "GYJMusicOperationManager.h"

static NSString *recordCellID = @"recordCell_id";
@interface LHDownloadedMusicViewController ()<UITableViewDelegate,UITableViewDataSource,GYJRecordListCellPlayDelegate>

@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSMutableArray *fileArray;

@property (nonatomic, strong) UITableView *listTableView;
@end

@implementation LHDownloadedMusicViewController

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
    
    self.fileArray = [NSMutableArray arrayWithCapacity:100];
    self.fileManager = [NSFileManager defaultManager];
    
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [self.view addSubview:_listTableView];
    [_listTableView registerClass:[GYJRecordListCell class] forCellReuseIdentifier:recordCellID];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    _listTableView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSString *path = [[GYJMusicOperationManager sharedMusicOperationManager] musicDownloadPath];
    [_fileArray removeAllObjects];
    NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:path];
	NSArray *allFiles = [self.fileManager contentsOfDirectoryAtURL:documentsDirectoryURL includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pathExtension == 'mp3'"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSURL *fileURL in [allFiles filteredArrayUsingPredicate:predicate]) {
            [_fileArray addObject:fileURL];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_listTableView reloadData];
        });
    });
    
}

#pragma mark - UItableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_fileArray count];
}

- (GYJRecordListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GYJRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:recordCellID];
    cell.delegate = self;
    [cell bindFilePath:[_fileArray objectAtIndex:indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSURL *filePath = [_fileArray objectAtIndex:indexPath.row];
    NSString *fileName = [filePath lastPathComponent];
    
    GYJAlert *errorAlert = [[GYJAlert alloc] initAlertWithTitle:[NSString stringWithFormat:@"确认要删除文件'%@'吗？",fileName] message:nil cancelTitle:@"取消" completeBlock:^(GYJAlert *alert, NSInteger buttonIndex) {
        if (buttonIndex) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtURL:[_fileArray objectAtIndex:indexPath.row] error:&error];
            if (!error) {
                [tableView beginUpdates];
                [_fileArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
            } else {
                GYJAlert *errorAlert = [[GYJAlert alloc] initAlertWithTitle:[NSString stringWithFormat:@"文件'%@'删除失败",fileName] message:nil cancelTitle:@"我知道了" completeBlock:^(GYJAlert *alert, NSInteger buttonIndex) {
                    
                } otherTitle:nil, nil];
                [errorAlert show];
            }
            
        }
    } otherTitle:@"确定", nil];
    [errorAlert show];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath: (NSIndexPath *)indexPath{
    return @"删除";
}

- (void)GYJRecordListCell:(GYJRecordListCell *)cell clickedFilePath:(NSURL *)filePath{
    GYJRecorderPlayerController *recorderPlayer = [[GYJRecorderPlayerController alloc] initWithFilePath:filePath];
    [self.navigationController pushViewController:recorderPlayer animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
