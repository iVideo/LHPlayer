//
//  GYJRecorderListController.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-4.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJRecorderListController.h"
#import "GYJRecordListCell.h"
#import "GYJRecorderPlayerController.h"

static NSString *recordCellID = @"recordCell_id";
@interface GYJRecorderListController ()<GYJRecordListCellPlayDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSMutableArray *fileArray;

@property (nonatomic, strong) UITableView *listTableView;
@end

@implementation GYJRecorderListController

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
    
    self.title = @"本地录音";
    
    self.fileArray = [NSMutableArray arrayWithCapacity:100];
    self.fileManager = [NSFileManager defaultManager];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _editButton.selected = NO;
    [_editButton addTarget:self action:@selector(toggleRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editButton];
    
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.naviTitleLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [self.view addSubview:_listTableView];
    [_listTableView registerClass:[GYJRecordListCell class] forCellReuseIdentifier:recordCellID];
    
    [_listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.customNaviBar.mas_bottom);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)toggleRecord:(UIButton *)sender{
    _editButton.selected = !_editButton.isSelected;
    NSString *promptString = !_editButton.isSelected ? @"编辑" : @"完成";
    [_editButton setTitle:promptString forState:UIControlStateNormal];
    [_listTableView setEditing:_editButton.isSelected  animated:YES];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_fileArray removeAllObjects];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths firstObject];
    NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:docPath];
	NSArray *allFiles = [self.fileManager contentsOfDirectoryAtURL:documentsDirectoryURL includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pathExtension == 'aac'"];
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
}

@end
