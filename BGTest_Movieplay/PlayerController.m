//
//  PlayerController.m
//  BGTest_Movieplay
//
//  Created by BingoMacMini on 16/3/25.
//  Copyright © 2016年 BingoMacMini. All rights reserved.
//


#define AVPLAYERVC [PlayerController sharedInstance];

#import "PlayerController.h"
#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>


@interface PlayerController ()

@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)AVPlayer *player;

@property(nonatomic,assign)CGFloat currentPlayTime;
@property(nonatomic,assign)CGFloat nextPlayTime;
@property(nonatomic,assign)CGFloat AllTime;
@property(nonatomic,strong)NSMutableDictionary *timeDic;

//判断是否进行播放状态
@property(nonatomic,getter=playing)BOOL playStatus;


@end

@implementation PlayerController


- (AVPlayer *)player{
    if (!_player) {
        
        NSURL *Url = [NSURL URLWithString:@"http://flv2.bn.netease.com/videolib3/1511/26/Wuimb0091/SD/Wuimb0091-mobile.mp4"];
        AVPlayerItem *item  = [AVPlayerItem playerItemWithURL:Url];
        _player = [AVPlayer playerWithPlayerItem:item];
        
        
    }
    return _player;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setTitle:@"播放视频" forState:0];
        
        
        [self.button setTintColor:[UIColor redColor]];
        self.button.backgroundColor = [UIColor grayColor];
        [self.button addTarget:self action:@selector(gotoplay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
//建立一个单例的播放器

+ (AVPlayerViewController *)sharedInstance{
    
    static AVPlayerViewController *vc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        vc = [AVPlayerViewController new];
        
        
    });
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.button];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width, 200));
    }];
    
    
    [self addNotification];

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"查看时间" forState:0];
    
    [button setTintColor:[UIColor redColor]];
    button.backgroundColor = [UIColor grayColor];
    [button addTarget:self action:@selector(lookatcurrenttime) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(400);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];

    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"查看时间" forState:0];
    
    [button2 setTintColor:[UIColor redColor]];
    button2.backgroundColor = [UIColor grayColor];
    [button2 addTarget:self action:@selector(looklook) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:button2];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(500);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];

    
    
    

    

}

//查看当前的时间，及统计看视频的时间
- (void)looklook{

    
    
    self.AllTime = fabs(self.currentPlayTime - self.nextPlayTime);
    NSLog(@"我拖动的时间是%.2fs",_AllTime);
    
    NSLog(@"aaaa暂停的时间是%.2fs",_currentPlayTime);
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)gotoplay:(UIButton *)sender{
    

    
    
    [self.player play];
    
    [self addobserTOPlayItem:self.player.currentItem];
    
    
   
    
    //NSLog(@"打印开始播放时间%.2fs",current);
    
    
    
    
    
    
    [PlayerController sharedInstance].player =self.player;
    [sender addSubview:[PlayerController sharedInstance].view];
    
    [[PlayerController sharedInstance].view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.button);
    }];
    
    
    
    //实现一些功能：
    
    
    
    
    
}

- (void)addNotification{
    //给AVplayItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:[PlayerController sharedInstance].player.currentItem];
   
}

- (void)playbackFinished{
    NSLog(@"播放完成");
}


//删除监听对象
- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - 监控视频的播放
- (void)lookatcurrenttime{
    
    [[PlayerController sharedInstance].player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        

        
        if (self.player.rate == 0) {
        
            self.currentPlayTime = CMTimeGetSeconds(time);
            NSLog(@"正在暂停的时间是%.2fs",self.currentPlayTime);
            
            
            
        }else if(self.player.rate == 1){
           // NSLog(@"正在播放");
            self.nextPlayTime = CMTimeGetSeconds(self.player.currentTime);
           
            
          
            
        }
    
        
        
        
        
        
    }];
}











- (void)addobserTOPlayItem:(AVPlayerItem *)playerItem{
    //监听状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew || NSKeyValueChangeOldKey context:nil];
    
    [playerItem addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    

}

- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            //
           // NSLog(@"正在播放。。。视频长度%.2f",CMTimeGetSeconds(playerItem.duration));
            
            NSLog(@"播放的时间是%.2fs",CMTimeGetSeconds(playerItem.currentTime));
            
//            [self removeObserverFromPlayerItem:self.player.currentItem];
//            
//            [self addobserTOPlayItem:self.player.currentItem];
            
           // [self lookatcurrenttime];
         
        }
        if (status == AVPlayerStatusUnknown){
            NSLog(@"abababababab....");
            
        }
        
        
        
}
    
    
    if ([keyPath isEqualToString:@"rate"]) {
        
        if (self.player.rate == 0) {
            NSLog(@"stop");
        }else if(self.player.rate == 1){
            NSLog(@"start");
        }
    }

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
