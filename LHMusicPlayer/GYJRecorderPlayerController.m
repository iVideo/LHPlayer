//
//  GYJRecorderPlayerController.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-4.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJRecorderPlayerController.h"
#import "GYJShareViewController.h"

@interface GYJRecorderPlayerController ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSURL *fileURL;

@property (nonatomic, strong) UIImageView *recordBackgroundView;
@property (nonatomic, strong) UIImageView *infoView;

@property (nonatomic, strong) UIButton *shareButton;
@end

@implementation GYJRecorderPlayerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithFilePath:(NSURL *)filePath{
    self = [super initWithCustomNaviBar:YES];
    if (self) {
        self.fileURL = filePath;
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_fileURL error:nil];
        [_audioPlayer prepareToPlay];
    }
    return self;
}

- (void)doBack{
    [_audioPlayer stop];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addLeftButtonTitle:@"返回" target:self action:@selector(doBack)];
    
    self.title = [[_fileURL lastPathComponent] stringByDeletingPathExtension];
    
    
    self.recordBackgroundView = [UIImageView new];
    _recordBackgroundView.image = [UIImage imageNamed:@"record_song_bg@2x.jpg"];
    [self.view addSubview:_recordBackgroundView];
    [self.view sendSubviewToBack:_recordBackgroundView];
    
    
    self.infoView = [UIImageView new];
    _infoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"material"]];
    [self.view addSubview:_infoView];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareButton setBackgroundImage:[UIImage imageNamed:@"4words_button_normal"] forState:UIControlStateNormal];
    [_shareButton setBackgroundImage:[UIImage imageNamed:@"4words_button_press"] forState:UIControlStateHighlighted];
    [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [self.view addSubview:_shareButton];
    __weak typeof(self) weakSelf = self;
    [_shareButton addAction:^(UIButton *btn) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        GYJShareViewController *shareController = [[GYJShareViewController alloc] initWithShareContent:[NSString stringWithFormat:@"我刚点了一首歌曲：//%@,赶快来听听吧~",[[strongSelf->_fileURL lastPathComponent] stringByDeletingPathExtension]] shareImage:[UIImage imageNamed:@"record_song_bg@2x.jpg"]];
        [strongSelf presentPanelSheetController:shareController];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@80);
    }];
    
    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_infoView.mas_centerX);
        make.centerY.equalTo(_infoView.mas_centerY);
    }];
    
    [_recordBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_infoView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
    }];
    
    [_audioPlayer setDelegate:self];
    [_audioPlayer play];
    

}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    //添加阴影
    [self.view sendSubviewToBack:_infoView];
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_recordBackgroundView.bounds];
    _recordBackgroundView.layer.masksToBounds = NO;
    _recordBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    _recordBackgroundView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    _recordBackgroundView.layer.shadowOpacity = 0.5f;
    _recordBackgroundView.layer.shadowPath = shadowPath.CGPath;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag{
    //播放结束时执行的动作
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError *)error{
    //解码错误执行的动作
}
- (void)audioPlayerBeginInteruption:(AVAudioPlayer*)player{
    //处理中断的代码
}
- (void)audioPlayerEndInteruption:(AVAudioPlayer*)player{
    //处理中断结束的代码
}
@end
