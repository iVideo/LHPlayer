//
//  GYJMusicPlayerController.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-2.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJMusicPlayerController.h"
#import "GYJRoundView.h"
#import "GYJMusicCollectionDataBase.h"

const CGFloat bottonViewHeight = 80;
const CGFloat roundViewWidth = 200;
@interface GYJMusicPlayerController ()<AVAudioPlayerDelegate>
@property (nonatomic, strong) MPMediaItem *mediaItem;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) GYJRoundView *roundView;
@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UIView *lyricContainerView;//歌词
@property (nonatomic, strong) UITextView *lyricTextView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong)  UIButton *showInfoButton;

@property (nonatomic, strong) UISlider *volumeSlider;//音量滑条

@property (nonatomic, strong) YLProgressBar *playProgressBar;//播放进度滑条
@property (nonatomic, strong) UILabel *currentPlayTimeLabel;//当前播放时间
@property (nonatomic, strong) UILabel *remainTimeLabel;//剩余播放时间

@property (nonatomic, strong) UIButton *preButton;//前一首歌按钮
@property (nonatomic, strong) UIButton *nextButton;//后一首歌按钮
@property (nonatomic, strong) UIButton *playButton;//播放/暂停按钮

@property (nonatomic, strong) ILTranslucentView *translucentView;//显示专辑、演唱者的view
@property (nonatomic, strong) UILabel *artistLabel;//显示演唱者
@property (nonatomic, strong) UILabel *albumLabel;//显示专辑

@end

@implementation GYJMusicPlayerController{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_mediaItem) {
        NSString *songName = [self.mediaItem valueForProperty:MPMediaItemPropertyTitle];
        if (verifiedString(songName)) {
            self.title = songName;
        }
    }
    
    [SCLTAudioPlayer sharedPlayer].delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(systemVolumeChanged:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
    
    [self addLeftButtonTitle:@"返回" target:self action:@selector(doBack)];
    
    //右上角的i按钮，点击后能出现演唱者和专辑名称
    self.showInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showInfoButton setTitle:@"i" forState:UIControlStateNormal];
    [_showInfoButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNaviBar addSubview:_showInfoButton];
    [_showInfoButton sizeToFit];
    _showInfoButton.centerY = self.naviTitleLabel.centerY;
    _showInfoButton.right = self.customNaviBar.right - 10;
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundView.image = [UIImage imageNamed:@"audionews_play_bg_morning@2x.jpg"];
    [self.view addSubview:backgroundView];
    
    [self.view exchangeSubviewAtIndex:[self.view.subviews indexOfObject:self.customNaviBar] withSubviewAtIndex:[self.view.subviews indexOfObject:backgroundView]];
    
    //圆形专辑控件
    self.roundView = [[GYJRoundView alloc] initWithFrame:CGRectMake(0, 0, roundViewWidth, roundViewWidth)];
    self.roundView.rotationDuration = 8.0;
    self.roundView.roundImage = [UIImage imageNamed:@"music_disk"];
    self.roundView.isPlay = NO;
    [self.view addSubview:_roundView];
    self.roundView.center = self.view.center;
    _roundView.y -= 20;
    
    //收藏按钮
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_likeButton setBackgroundImage:[UIImage imageNamed:@"like_normal"] forState:UIControlStateNormal];
    [_likeButton setBackgroundImage:[UIImage imageNamed:@"like_selected"] forState:UIControlStateSelected];
    [_likeButton addTarget:self action:@selector(likeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _likeButton.selected = NO;
    [self.view addSubview:_likeButton];
    
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNaviBar.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    if (_mediaItem) {
        NSString *songName = [self.mediaItem valueForProperty:MPMediaItemPropertyTitle];
        if (verifiedString(songName)) {
            __weak typeof(self) weakSelf = self;
            [[GYJMusicCollectionDataBase sharedInstance] fetchMediaItemDictionatys:^(NSArray *collectionMusics) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                if ([collectionMusics containsObject:songName]) {
                    strongSelf.likeButton.selected = YES;
                } else {
                    strongSelf.likeButton.selected = NO;
                }
            }];
        }
    }
    
    //歌词面板
    self.lyricContainerView = [UIView new];
    [self.view addSubview:_lyricContainerView];
    _lyricContainerView.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
    
    
    self.lyricTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    _lyricTextView.backgroundColor = [UIColor clearColor];
    _lyricTextView.textColor = [UIColor whiteColor];
    [_lyricTextView setEditable:NO];
    _lyricTextView.textAlignment = NSTextAlignmentCenter;
    _lyricTextView.text = @"无法显示歌词";
    [_lyricContainerView addSubview:_lyricTextView];
    
    //最下面view
    self.bottomView = [UIView new];
    _bottomView.backgroundColor = IM_NAVI_PINK;
    [self.view addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@(bottonViewHeight));
        make.bottom.equalTo(self.view.mas_bottom);
    }];

    
    self.currentPlayTimeLabel = [UILabel makeLabelWithStr:nil fontSize:10 textColor:[UIColor whiteColor] superView:_bottomView];
    self.remainTimeLabel = [UILabel makeLabelWithStr:nil fontSize:10 textColor:[UIColor whiteColor] superView:_bottomView];
    [_currentPlayTimeLabel setTextAlignment:NSTextAlignmentLeft];
    [_remainTimeLabel setTextAlignment:NSTextAlignmentRight];
    [_currentPlayTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView.mas_left).offset(5);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
    [_remainTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomView.mas_right).offset(-5);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
    
    self.playProgressBar = [YLProgressBar new];
    _playProgressBar.type                     = YLProgressBarTypeFlat;
    _playProgressBar.hideStripes              = YES;
    _playProgressBar.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeProgress;
    _playProgressBar.progressTintColors       = @[[UIColor colorWithRed:33/255.0f green:180/255.0f blue:162/255.0f alpha:1.0f],
                                                  [UIColor colorWithRed:3/255.0f green:137/255.0f blue:166/255.0f alpha:1.0f],
                                                  [UIColor colorWithRed:91/255.0f green:63/255.0f blue:150/255.0f alpha:1.0f],
                                                  [UIColor colorWithRed:87/255.0f green:26/255.0f blue:70/255.0f alpha:1.0f],
                                                  [UIColor colorWithRed:126/255.0f green:26/255.0f blue:36/255.0f alpha:1.0f],
                                                  [UIColor colorWithRed:149/255.0f green:37/255.0f blue:36/255.0f alpha:1.0f],
                                                  [UIColor colorWithRed:228/255.0f green:69/255.0f blue:39/255.0f alpha:1.0f],
                                                  [UIColor colorWithRed:245/255.0f green:166/255.0f blue:35/255.0f alpha:1.0f],
                                                  [UIColor colorWithRed:165/255.0f green:202/255.0f blue:60/255.0f alpha:1.0f],
                                                  [UIColor colorWithRed:202/255.0f green:217/255.0f blue:54/255.0f alpha:1.0f],
                                                  [UIColor colorWithRed:111/255.0f green:188/255.0f blue:84/255.0f alpha:1.0f]];
    [_bottomView addSubview:_playProgressBar];
    [_playProgressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView.mas_left);
        make.height.equalTo(@2);
        make.width.equalTo(_bottomView.mas_width);
        make.top.equalTo(_bottomView.mas_top);
    }];
    
    self.preButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_preButton setBackgroundImage:[UIImage imageNamed:@"playing_btn_pre_h"] forState:UIControlStateNormal];
    [_nextButton setBackgroundImage:[UIImage imageNamed:@"playing_btn_next_h"] forState:UIControlStateNormal];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"playing_btn_pause_h"] forState:UIControlStateNormal];
    
    [_bottomView addSubview:_preButton];
    [_bottomView addSubview:_nextButton];
    [_bottomView addSubview:_playButton];
    
    [_preButton addTarget:self action:@selector(handleButtonBack:) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton addTarget:self action:@selector(handleButtonNext:) forControlEvents:UIControlEventTouchUpInside];
    [_playButton addTarget:self action:@selector(handleButtonPlay:) forControlEvents:UIControlEventTouchUpInside];
    
    [_preButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.left.equalTo(_bottomView.mas_left).offset(20);
    }];
    
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.right.equalTo(_bottomView.mas_right).offset(-20);
    }];
    
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.centerX.equalTo(_bottomView.mas_centerX);
    }];
    
    
    CGFloat height = [self viewVisibleHeightWithTabbar:NO naviBar:YES];
    [_lyricContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(_bottomView.mas_top).offset(-60);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@(height - bottonViewHeight));
    }];
    
    
    [_lyricTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lyricContainerView.mas_left);
        make.top.equalTo(_lyricContainerView.mas_top);
        make.width.equalTo(_lyricContainerView.mas_width);
        make.bottom.equalTo(_lyricContainerView.mas_bottom);
    }];
    
    //点击右上角的i出现的黑色半透明的view
    self.translucentView = [[ILTranslucentView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_translucentView];
    _translucentView.translucentAlpha = 1;
    _translucentView.translucentStyle = UIBarStyleBlack;
    _translucentView.translucentTintColor = [UIColor clearColor];
    _translucentView.backgroundColor = [UIColor clearColor];
    [_translucentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNaviBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(_bottomView.mas_top);
        make.width.equalTo(self.view.mas_width);
    }];
    _translucentView.hidden = YES;
    
    //音量滑条
    self.volumeSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    [_volumeSlider setThumbImage:[UIImage imageNamed:@"AudioPlayerVolumeKnob"] forState:UIControlStateNormal];
	[_volumeSlider setMinimumTrackImage:[[UIImage imageNamed:@"AudioPlayerScrubberLeft"] stretchableImageWithLeftCapWidth:5 topCapHeight:3]
                              forState:UIControlStateNormal];
	[_volumeSlider setMaximumTrackImage:[[UIImage imageNamed:@"AudioPlayerScrubberRight"] stretchableImageWithLeftCapWidth:5 topCapHeight:3]
							  forState:UIControlStateNormal];
    [_volumeSlider addTarget:self action:@selector(volumeSliderMoved:) forControlEvents:UIControlEventValueChanged];
    [_translucentView addSubview:_volumeSlider];
    _volumeSlider.value = [MPMusicPlayerController applicationMusicPlayer].volume;//滑条的初始值等于系统播放器的音量大小
    [_volumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_translucentView.mas_centerX);
        make.width.equalTo(_translucentView.mas_width).offset(-50);
        make.height.equalTo(@15);
        make.top.equalTo(_translucentView.mas_top).offset(60);
    }];
    
    self.artistLabel = [UILabel makeLabelWithStr:nil fontSize:16 textColor:[UIColor blackColor] superView:_translucentView];
    self.albumLabel = [UILabel makeLabelWithStr:nil fontSize:14 textColor:[UIColor blackColor] superView:_translucentView];
    _artistLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [_artistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_translucentView.mas_centerX);
        make.centerY.equalTo(_translucentView.mas_centerY);;
        make.width.equalTo(_translucentView.mas_width);
        make.height.equalTo(@20);
    }];
    
    [_albumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_translucentView.mas_centerX);
        make.top.equalTo(_artistLabel.mas_bottom);
        make.width.equalTo(_translucentView.mas_width);
        make.height.equalTo(@20);
    }];
    
    if (_mediaItem) {
        MPMediaItemArtwork *artWork = [self.mediaItem valueForProperty:MPMediaItemPropertyArtwork];
        if (artWork){
            UIImage *artWorkImage = [artWork imageWithSize:CGSizeMake(roundViewWidth, roundViewWidth)];
            if (artWorkImage) {
                self.roundView.roundImage = artWorkImage;
            }
        }
        NSString *PropertyAlbum = verifiedString([_mediaItem valueForKey:MPMediaItemPropertyTitle]) ? [_mediaItem valueForKey:MPMediaItemPropertyAlbumTitle] : @"未知专辑";
        NSString *PropertyArtist = verifiedString([_mediaItem valueForKey:MPMediaItemPropertyArtist]) ? [_mediaItem valueForKey:MPMediaItemPropertyArtist] : @"未知艺术家";
        _albumLabel.text = PropertyAlbum;
        _artistLabel.text = PropertyArtist;
        
        
        NSMutableArray *playList = [NSMutableArray arrayWithCapacity:100];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            MPMediaQuery *query = [MPMediaQuery songsQuery];
            NSArray *items = [query items];
            for (MPMediaItem *mediaItem in items) {
                SCLTMediaItem *smi = [[SCLTMediaItem alloc] initWithMediaItem:mediaItem];
                [playList addObject:smi];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                SCLTMediaItem *currentitem = [[SCLTMediaItem alloc] initWithMediaItem:_mediaItem];
                [[SCLTAudioPlayer sharedPlayer] setCurrentItem:currentitem];
                [[SCLTAudioPlayer sharedPlayer] setPlaylist:playList];
                if (verifiedString([self lyricForMediaItem:_mediaItem])) {
                    self.lyricTextView.text = [self lyricForMediaItem:_mediaItem];
                }
                
            });
        });
    }
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapper:)];
    [_lyricContainerView addGestureRecognizer:_tapGesture];
}

- (NSString *)lyricForMediaItem:(MPMediaItem *)medaiItem{
    NSURL* songURL = [medaiItem valueForProperty:MPMediaItemPropertyAssetURL];
    AVAsset* songAsset = [AVURLAsset URLAssetWithURL:songURL options:nil];
    if (songAsset) {
       return [songAsset lyrics];
    }
    return nil;
}

- (void)tapper:(UITapGestureRecognizer *)tapper{

    BOOL lyricShow = _lyricContainerView.top == self.customNaviBar.bottom ? YES : NO;
    if (!lyricShow) {
        _lyricContainerView.top = self.customNaviBar.bottom;
    } else {
        _lyricContainerView.top = _bottomView.top - 60;
    }
}

#pragma mark - ButtonAction
- (void)showInfo:(UIButton *)sender{
    _translucentView.hidden = !_translucentView.isHidden;
}

- (void)handleButtonPlay:(UIButton *)sender {
    [[SCLTAudioPlayer sharedPlayer] togglePlayPause];
}

- (void)handleButtonBack:(UIButton *)sender {
    [[SCLTAudioPlayer sharedPlayer] previous];
}

- (void)handleButtonNext:(UIButton *)sender {
    [[SCLTAudioPlayer sharedPlayer] next];
}

#pragma mark - 音乐收藏
- (void)likeButtonTapped:(UIButton *)sender{
    __weak typeof(self) weakSelf = self;
    if ([SCLTAudioPlayer sharedPlayer].currentItem) {
        NSString *songName = [[SCLTAudioPlayer sharedPlayer].currentItem.mediaItem valueForProperty:MPMediaItemPropertyTitle];
        if (verifiedString(songName)) {
            if (!sender.isSelected) {
                [[GYJMusicCollectionDataBase sharedInstance] insertMPMediaItem:[SCLTAudioPlayer sharedPlayer].currentItem.mediaItem];
                sender.selected = !sender.isSelected;
            } else {
                GYJAlert *alert = [[GYJAlert alloc] initAlertWithTitle:[NSString stringWithFormat:@"确认要将‘%@’从收藏的歌曲中删除吗？",songName] message:nil cancelTitle:@"否" completeBlock:^(GYJAlert *alert, NSInteger buttonIndex) {
                    __strong typeof(weakSelf)strongSelf = weakSelf;
                    if (buttonIndex) {
                        strongSelf.likeButton.selected = !strongSelf.likeButton.isSelected;
                        [[GYJMusicCollectionDataBase sharedInstance] deleteMediaItemFromDataBase:[SCLTAudioPlayer sharedPlayer].currentItem.mediaItem success:^(BOOL success, NSError *error) {
                            NSLog(@"从收藏列表中删除歌曲失败：%@",error);
                        }];
                    } else {
                        
                    }
                } otherTitle:@"是", nil];
                [alert show];
            }
        }
    }
}

- (void)volumeSliderMoved:(UISlider *)sender
{
	[SCLTAudioPlayer sharedPlayer].player.volume = [sender value];
    
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:[sender value]];
}

- (void)systemVolumeChanged:(NSNotification *)notification{
    self.volumeSlider.value = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    [SCLTAudioPlayer sharedPlayer].player.volume = self.volumeSlider.value;
}

#pragma mark - Audio Player delegate

-(void)player:(AVAudioPlayer *)player playingItem:(SCLTMediaItem *)item updateProgress:(NSTimeInterval)currentPlayingProgress duration:(NSTimeInterval)duration{
    CGFloat progress = currentPlayingProgress/duration;
    _playProgressBar.progress = progress;
    
    NSUInteger currentSeconds = (NSUInteger)round(currentPlayingProgress);
    NSUInteger remainSeconds = (NSUInteger)round(duration) - currentSeconds;

    _currentPlayTimeLabel.text = [NSString stringWithFormat:@"%02u:%02lu",(currentSeconds / 60) % 60, currentSeconds % 60];
    _remainTimeLabel.text = [NSString stringWithFormat:@"%02u:%02lu",(remainSeconds / 60) % 60, remainSeconds % 60];

    [_currentPlayTimeLabel sizeToFit];
    [_remainTimeLabel sizeToFit];
}

-(void)playerDidPlay:(SCLTAudioPlayer *)player {
    [self updateTrackInfo];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"playing_btn_pause_h"] forState:UIControlStateNormal];
}

-(void)playerDidPause:(SCLTAudioPlayer *)player {
    [_playButton setBackgroundImage:[UIImage imageNamed:@"playing_btn_play_n"] forState:UIControlStateNormal];
    
}

-(void)player:(SCLTAudioPlayer *)player willAdvancePlaylist:(SCLTMediaItem *)currentItem atPoint:(double)normalizedTime {
    NSLog(@"Skipping to next item, at %.2f percent", normalizedTime*100);
}

-(void)player:(SCLTAudioPlayer *)player didAdvancePlaylist:(SCLTMediaItem *)newItem {
    NSLog(@"Next item playing!");
    [self updateTrackInfo];
}

-(void)player:(SCLTAudioPlayer *)player didReversePlaylist:(SCLTMediaItem *)newItem {
    NSLog(@"Previous item playing!");
    [self updateTrackInfo];
}

-(void)player:(SCLTAudioPlayer *)player willReversePlaylist:(SCLTMediaItem *)currentItem atPoint:(double)normalizedTime {
    NSLog(@"Skipping to last item, at %.2f percent", normalizedTime*100);
}


-(void)updateTrackInfo {
    SCLTMediaItem *currentItem = [SCLTAudioPlayer sharedPlayer].currentItem;
    self.playProgressBar.progress = [SCLTAudioPlayer sharedPlayer].player.duration;
    if (currentItem) {
        if (currentItem.mediaItem) {
            self.title = [currentItem.mediaItem valueForKey:MPMediaItemPropertyTitle];
            MPMediaItemArtwork *artWork = [currentItem.mediaItem valueForProperty:MPMediaItemPropertyArtwork];
            if (artWork){
                UIImage *artWorkImage = [artWork imageWithSize:CGSizeMake(roundViewWidth, roundViewWidth)];
                if (artWorkImage) {
                    self.roundView.roundImage = artWorkImage;
                } else {
                    self.roundView.roundImage = [UIImage imageNamed:@"music_disk"];
                }
            }
            NSString *PropertyAlbum = verifiedString([currentItem.mediaItem valueForKey:MPMediaItemPropertyTitle]) ? [currentItem.mediaItem valueForKey:MPMediaItemPropertyAlbumTitle] : @"未知专辑";
            NSString *PropertyArtist = verifiedString([currentItem.mediaItem valueForKey:MPMediaItemPropertyArtist]) ? [currentItem.mediaItem valueForKey:MPMediaItemPropertyArtist] : @"未知艺术家";
            _albumLabel.text = PropertyAlbum;
            _artistLabel.text = PropertyArtist;
            if (verifiedString([self lyricForMediaItem:currentItem.mediaItem])) {
                self.lyricTextView.text = [self lyricForMediaItem:currentItem.mediaItem];
            } else {
                self.lyricTextView.text = @"无法显示歌词";
            }
        }
    }
}

#pragma mark - ViewLifecirle

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[SCLTAudioPlayer sharedPlayer] play];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.roundView.isPlay = NO;
    
    [[SCLTAudioPlayer sharedPlayer] pause];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.roundView.isPlay = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
