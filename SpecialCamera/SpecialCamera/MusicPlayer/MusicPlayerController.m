//
//  MusicPlayerController.m
//  SpecialCamera
//
//  Created by njw on 2019/2/20.
//  Copyright © 2019 njw. All rights reserved.
//

#import "MusicPlayerController.h"

@interface MusicPlayerController () {
    AVAudioPlayer *audioPlayer;
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UITextView *text_view;
@property (weak, nonatomic) IBOutlet UIProgressView *audioProgress;
@property (weak, nonatomic) IBOutlet UISlider *audioTime;
@property (weak, nonatomic) IBOutlet UIStepper *cyc;

@property (weak, nonatomic) IBOutlet UISlider *audioVol;


- (IBAction)audioPlay:(id)sender;
- (IBAction)audioPause:(id)sender;
- (IBAction)audioStop:(id)sender;
- (IBAction)audioSwitch:(id)sender;
- (IBAction)audioVol:(id)sender;
- (IBAction)audioCyc:(id)sender;
- (IBAction)audioPlayAtTime:(id)sender;


@end

@implementation MusicPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

// 无法播放网络音乐 解决方法：1.把网络音乐缓存到本地 2.利用avplayer
- (IBAction)audioPlay:(id)sender {
    NSString *playmusicPath = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
    if (playmusicPath) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        NSURL *musicUrl = [NSURL fileURLWithPath:playmusicPath];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:nil];
        audioPlayer.delegate = self;
        audioPlayer.meteringEnabled = YES;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(monitor) userInfo:nil repeats:YES];
        [audioPlayer play];
    }
}

- (void)monitor {
    NSUInteger channels = audioPlayer.numberOfChannels;
    NSTimeInterval duration = audioPlayer.duration;
    [audioPlayer updateMeters];
    NSString *audioInfoValue = [[NSString alloc] initWithFormat:@"%f,%f\n channels=%lu duration=%lu\n currentTime = %f",[audioPlayer peakPowerForChannel:0], [audioPlayer peakPowerForChannel:1], channels, (unsigned long)duration, audioPlayer.currentTime];
    self.text_view.text = audioInfoValue;
    self.audioProgress.progress = audioPlayer.currentTime / audioPlayer.duration;
}

- (IBAction)audioPause:(id)sender {
    if ([audioPlayer isPlaying]) {
        [audioPlayer pause];
    }
    else {
        [audioPlayer play];
    }
}

- (IBAction)audioStop:(id)sender {
    self.audioTime.value = 0;
    self.audioProgress.progress = 0;
    [audioPlayer stop];
}

- (IBAction)audioSwitch:(id)sender {
    audioPlayer.volume = [sender isOn];
}

- (IBAction)audioVol:(id)sender {
    audioPlayer.volume = self.audioVol.value;
}

- (IBAction)audioCyc:(id)sender {
    audioPlayer.numberOfLoops = self.cyc.value;
}

- (IBAction)audioPlayAtTime:(id)sender {
    [audioPlayer pause];
    [audioPlayer setCurrentTime:(NSTimeInterval)self.audioTime.value*audioPlayer.duration];
    [audioPlayer play];
}

#pragma mark - 代理方法

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    
}

/* AVAudioPlayer INTERRUPTION NOTIFICATIONS ARE DEPRECATED - Use AVAudioSession instead. */

/* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    
}
@end
