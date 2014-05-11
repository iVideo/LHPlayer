//
//  GYJRecordMusicController.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-2.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJRecordMusicController.h"

@interface GYJRecordMusicController ()<SCLTAudioPlayerDelegate>

@property (nonatomic, strong) UIImageView *recordBackgroundView;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, strong) MPMediaItem *mediaItem;

@property (nonatomic, strong) UIImageView *recordingDotView;
@property (nonatomic, strong) UILabel *recordingTimeLabel;

@property (nonatomic, strong) UIImageView *infoView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *finishRecordButton;


@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@end

@implementation GYJRecordMusicController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (instancetype)initWithMediaItem:(MPMediaItem *)mediaItem{
    self = [super initWithCustomNaviBar:YES];
    if (self) {
        self.mediaItem = mediaItem;
    }
    return self;
}

- (void)doBack{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [self.audioRecorder stop];
    [self.audioRecorder deleteRecording];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addLeftButtonTitle:@"返回" target:self action:@selector(doBack)];
    self.customNaviBar.backgroundColor = [UIColor clearColor];
    
    self.recordBackgroundView = [UIImageView new];
    _recordBackgroundView.image = [UIImage imageNamed:@"record_song_bg@2x.jpg"];
    [self.view addSubview:_recordBackgroundView];
    [self.view sendSubviewToBack:_recordBackgroundView];
    
     [SCLTAudioPlayer sharedPlayer].delegate = self;
    if (_mediaItem) {
        
        SCLTMediaItem *aMediaItem = [[SCLTMediaItem alloc] initWithMediaItem:_mediaItem];
        [[SCLTAudioPlayer sharedPlayer] setCurrentItem:aMediaItem];
        [[SCLTAudioPlayer sharedPlayer] setPlaylist:@[aMediaItem]];
        
        NSString *songName = verifiedString([self.mediaItem valueForProperty:MPMediaItemPropertyTitle]) ? [self.mediaItem valueForProperty:MPMediaItemPropertyTitle] : @"未知曲目";
        NSString *propertyArtist = verifiedString([_mediaItem valueForKey:MPMediaItemPropertyArtist]) ? [_mediaItem valueForKey:MPMediaItemPropertyArtist] : @"未知艺术家";
        self.title = [NSString stringWithFormat:@"%@-%@",songName,propertyArtist];
    } else {
        self.title = @"未知曲目-未知艺术家";
    }
    
    
    self.recordingDotView = [UIImageView new];
    UIImage *redDotImage = [UIImage drawImageWithColor:[[UIColor redColor] CGColor] rect:CGRectMake(0, 0, 10, 10)];
    UIImage *roundDot = [redDotImage cropRoundImageWithRect:CGRectMake(0, 0, 10, 10)];
    _recordingDotView.image = roundDot;
    [self.view addSubview:_recordingDotView];
    _recordingDotView.center = self.view.center;
    [_recordingDotView sizeToFit];
    
    self.recordingTimeLabel = [UILabel makeLabelWithStr:@"正在录制 00:00 / 00:00" fontSize:12 textColor:[UIColor darkGrayColor] superView:self.view];
    
    self.infoView = [UIImageView new];
    self.bottomView = [UIView new];
    
    _infoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"material"]];
    _bottomView.backgroundColor = IM_NAVI_PINK;

    [self.view addSubview:_bottomView];
    [self.view addSubview:_infoView];
    
    self.finishRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_finishRecordButton setBackgroundImage:[UIImage imageNamed:@"4words_button_normal"] forState:UIControlStateNormal];
    [_finishRecordButton setBackgroundImage:[UIImage imageNamed:@"4words_button_press"] forState:UIControlStateHighlighted];
    [_finishRecordButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_finishRecordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_finishRecordButton setTitle:@"完成录音" forState:UIControlStateNormal];
    [_finishRecordButton addTarget:self action:@selector(finishRecorder) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_finishRecordButton];
    
    [self layout];
    
    
    
    //设置录音
    NSError *sessionError;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
    
    NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                    [NSNumber numberWithFloat:16000.0], AVSampleRateKey,
                                    [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                    nil];
    NSError *error = nil;
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:[self createRecorderFile] settings:recordSettings error:&error];
    if (error) {
        NSLog(@"Error:%@",[error localizedDescription]);
    }
    [_audioRecorder prepareToRecord];
    [_audioRecorder record];

}

- (NSURL *)createRecorderFile{
	NSString *fileNameString = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@.aac",[self.mediaItem valueForProperty:MPMediaItemPropertyTitle]]];
    return [NSURL fileURLWithPath:fileNameString];
}


#pragma mark - 录音完成
- (void)finishRecorder{
    [self.audioRecorder stop];
    [[SCLTAudioPlayer sharedPlayer] togglePlayPause];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - Layout
- (void)layout{
    [_recordingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviTitleLabel.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@25);
    }];
    [_recordingDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_recordingTimeLabel.mas_centerY);
        make.right.equalTo(_recordingTimeLabel.mas_left);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@50);
    }];
    
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(_bottomView.mas_top);
        make.height.equalTo(@80);
    }];
    
    [_recordBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_infoView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
    }];
    
    [_finishRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bottomView.mas_centerX);
        make.centerY.equalTo(_bottomView.mas_centerY);
    }];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[SCLTAudioPlayer sharedPlayer] play];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[SCLTAudioPlayer sharedPlayer] pause];
}

-(void)player:(AVAudioPlayer *)player playingItem:(SCLTMediaItem *)item updateProgress:(NSTimeInterval)currentPlayingProgress duration:(NSTimeInterval)duration{
    NSUInteger currentSeconds = (NSUInteger)round(currentPlayingProgress);
    NSUInteger durationSeconds = (NSUInteger)round(duration);
    NSString *currentSecondsString = [NSString stringWithFormat:@"%02u:%02u",(currentSeconds / 60) % 60, currentSeconds % 60];
    NSString *durationSecondsString = [NSString stringWithFormat:@"%02u:%02u",(durationSeconds / 60) % 60, durationSeconds % 60];
    self.recordingTimeLabel.text = [NSString stringWithFormat:@"正在录制 %@ / %@",currentSecondsString,durationSecondsString];
}

-(void)playerDidPlay:(SCLTAudioPlayer *)player {
}

-(void)playerDidPause:(SCLTAudioPlayer *)player {
    
}

-(void)player:(SCLTAudioPlayer *)player willAdvancePlaylist:(SCLTMediaItem *)currentItem atPoint:(double)normalizedTime {
    [self finishRecorder];
}

-(void)player:(SCLTAudioPlayer *)player didAdvancePlaylist:(SCLTMediaItem *)newItem {
}

-(void)player:(SCLTAudioPlayer *)player didReversePlaylist:(SCLTMediaItem *)newItem {

}

-(void)player:(SCLTAudioPlayer *)player willReversePlaylist:(SCLTMediaItem *)currentItem atPoint:(double)normalizedTime {
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
