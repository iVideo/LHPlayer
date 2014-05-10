//
//  LHOnlineMusicPlayerController.m
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-10.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import "LHOnlineMusicPlayerController.h"
#import "GYJMusicSearchDetailObject.h"
#import "GYJMusicOperationManager.h"
#import "LDProgressView.h"

@interface LHOnlineMusicPlayerController ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) LDProgressView *progressView;
@property (nonatomic, strong) GYJMusicSearchDetailObject *musicObject;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic ,strong) UIImageView *singerImageView;
@property (nonatomic, strong) UIImageView *recordBackgroundView;

@property (nonatomic, strong) UIButton *playButton;
@end


@implementation LHOnlineMusicPlayerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithGYJMusicSearchDetailObject:(GYJMusicSearchDetailObject *)musicObject{
    self = [super initWithCustomNaviBar:YES];
    if (self) {
        self.musicObject = musicObject;
    }
    
    return self;
}


- (void)doBack{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    if (_audioPlayer) {
        [_audioPlayer stop];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.musicObject.songName;
    [self addLeftButtonTitle:@"返回" target:self action:@selector(doBack)];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

    
    self.recordBackgroundView = [UIImageView new];
    _recordBackgroundView.image = [UIImage imageNamed:@"record_song_bg@2x.jpg"];
    [self.view addSubview:_recordBackgroundView];
    [self.view sendSubviewToBack:_recordBackgroundView];
    
    
    
    self.singerImageView = [[UIImageView alloc] init];
    [self.view addSubview:_singerImageView];

    
    [_recordBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
    }];
    
    [_singerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(@90);
        make.height.equalTo(@90);
    }];

    self.progressView = [LDProgressView new];
    _progressView.type = LDProgressStripes;
    _progressView.color = [UIColor greenColor];

    [self.view addSubview:_progressView];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).offset(-30);
        make.height.equalTo(@15);
        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setTitle:@"播放音乐" forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(startPlayMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
    _playButton.hidden = YES;
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@30);
        make.width.equalTo(@100);
        make.top.equalTo(_singerImageView.mas_bottom);
    }];
    
    NSURL *downloadURL = [NSURL URLWithString:self.musicObject.songLink];
    if (!downloadURL) {
        GYJAlert *alert = [[GYJAlert alloc] initAlertWithTitle:@"歌曲链接无效！" message:nil cancelTitle:@"OK" completeBlock:^(GYJAlert *alert, NSInteger buttonIndex) {
            [self doBack];
        } otherTitle:nil, nil];
        [alert show];
        return;
    }
    
    [[GYJMusicOperationManager sharedMusicOperationManager] downloadFileWithPath:[self filePath] fileURL:downloadURL downProgress:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"Progress:%lld  totleBytes:%lld",totalBytesRead,totalBytesExpectedToRead);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = (CGFloat)totalBytesRead/(CGFloat)totalBytesExpectedToRead;
            if (totalBytesRead == totalBytesExpectedToRead) {
                _playButton.hidden = NO;
                self.progressView.hidden = YES;
            }
        });

    }];
}
- (NSString *)filePath{
    return [[[GYJMusicOperationManager sharedMusicOperationManager] musicDownloadPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",self.musicObject.songName]];
}

- (void)startPlayMusic{
    if (!_audioPlayer) {
        NSString *filePath = [self filePath];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        [self.audioPlayer prepareToPlay];
    }
    [self.audioPlayer setDelegate:self];

    if (_audioPlayer.isPlaying) {
        [_audioPlayer stop];
    }
    [_audioPlayer play];
    
    [_singerImageView setImageWithURL:[NSURL URLWithString:self.musicObject.songPicBig] placeholderImage:nil];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    //添加阴影
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


@end
