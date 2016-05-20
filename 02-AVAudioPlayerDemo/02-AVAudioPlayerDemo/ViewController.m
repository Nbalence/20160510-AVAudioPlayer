//
//  ViewController.m
//  02-AVAudioPlayerDemo
//
//  Created by qingyun on 16/5/10.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVAudioPlayerDelegate>
//音量进度条
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
//播放进度
@property (weak, nonatomic) IBOutlet UISlider *playeSlider;
//分贝的值
@property (weak, nonatomic) IBOutlet UIProgressView *meterProgres;
//播放器对象
@property (strong,nonatomic) AVAudioPlayer *player;
//计时器
@property (strong,nonatomic)NSTimer *timer;

@end

@implementation ViewController
#pragma mark 更新分贝值
-(void)UpdateMeter{
  //1.更新最新分贝值
    [self.player updateMeters];
  //2.获取当前通道平均的分贝值 0-(-160)
   float meterValue=[self.player averagePowerForChannel:1];
    NSLog(@"========%f",meterValue);
  //3更新progresss;
   _meterProgres.progress=(160+meterValue)/160.0;
    
}


#pragma mark 更新播放进度条
-(void)UpdateProgress{
   //获取当前播放的时间
    NSTimeInterval time=self.player.currentTime;
    //更新进度条
    _playeSlider.value=time;
    
    [self UpdateMeter];
}
//播放器对象
-(AVAudioPlayer *)player{
    if (_player) {
        return _player;
    }
   //初始化播放器对象
    NSURL *fileUrl=[[NSBundle mainBundle] URLForResource:@"红颜劫" withExtension:@"mp3"];
    NSError *error;
    _player=[[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
    if (error) {
        NSLog(@"=====error====%@",error);
    }
   //设置参数
     //设置代理
    _player.delegate=self;
    //设置速率是否可用
    _player.enableRate=YES;
    //设置循环次数 默认是0次，1 播放两边，-1 无限循环
    _player.numberOfLoops=1;
    //设置分贝值可用
    [_player setMeteringEnabled:YES];
    
    //准备播放，硬件准备工作
    [_player prepareToPlay];
    
    return _player;
}
//初始化计时器
-(NSTimer *)timer{
    if (_timer) {
        return _timer;
    }
    _timer=[NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(UpdateProgress) userInfo:nil repeats:YES];
    return  _timer;
}

- (void)viewDidLoad {
    //1.初始化当前音量值
     _volumeSlider.value=self.player.volume;
    //2设置当前播放进度条最大值
    _playeSlider.maximumValue=self.player.duration;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark 设置音量
- (IBAction)volumeChange:(UISlider *)sender {
    //音量值范围 0-1；
    self.player.volume=sender.value;
}

#pragma mark 播放暂停
- (IBAction)playOrPause:(UIButton *)sender {
    if(self.player.isPlaying){
     //暂停
        [sender setTitle:@"播放" forState:UIControlStateNormal];
        [self.player pause];
        //暂停计时器
        self.timer.fireDate=[NSDate distantFuture];

    }else{
     //播放
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        [self.player play];
        //启动计时器 里面启动
        self.timer.fireDate=[NSDate date];
    }
}
#pragma mark 设置速率
- (IBAction)setRotae:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            //设置放慢速率0.5
            self.player.rate=.5;
            break;
        case 2:
            //设置播放速率正常
            self.player.rate=1;
            break;
        case 3:
            //设置快速速率2
            self.player.rate=2;
            break;
        default:
            break;
    }
    
}
#pragma mark 指定播放位置
- (IBAction)progressChange:(UISlider *)sender {
    self.player.currentTime=sender.value;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
