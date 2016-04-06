//
//  PlayerController2.m
//  BGTest_Movieplay
//
//  Created by Mac on 16/3/28.
//  Copyright © 2016年 BingoMacMini. All rights reserved.
//

#import "PlayerController2.h"
#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface PlayerController2 ()

@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)MPMoviePlayerController *playerController;
@property (nonatomic,assign)CGFloat playStartTime;
@property (nonatomic,assign)CGFloat playStopTime;
@property (nonatomic,assign)CGFloat playStopTime2;
@property (nonatomic,assign)CGFloat totalTime;
@property (nonatomic,assign)CGFloat totalTime2;
@property (nonatomic,assign)CGFloat totalTime1;
@property (nonatomic,assign)CGFloat totallTime3;
@property (nonatomic,assign)CGFloat totallTime4;
@property (nonatomic,assign)CGFloat forwardTime;
@property (nonatomic,assign)CGFloat backTime;


//
@property (nonatomic,assign) CGFloat loadingTime;
@property (nonatomic,assign)NSInteger index;

//一个路径记录播放结束后的时间点
@property (nonatomic,copy) NSString *endTimePath;

//是否要定位播放的开关
@property (nonatomic,assign) BOOL isPosition;



@property(nonatomic,getter=isStop1)BOOL fristStopTime;
@property(nonatomic,getter=isStop12)BOOL isStop;
//@property(assign) BOOL isHasData;


@property(nonatomic,strong)NSMutableDictionary*timeDic;

//数组保存播放过的点
@property(nonatomic,strong)NSMutableArray *playedArr;
@property(nonatomic,strong)NSMutableArray *playingArr;


@property(nonatomic,strong)NSMutableSet *tatolDuration;
@property(nonatomic,strong)NSMutableSet *tatolDuration2;




@end

@implementation PlayerController2

-(MPMoviePlayerController *)playerController{
    if (!_playerController) {
        NSURL *Url = [NSURL URLWithString:@"http://flv2.bn.netease.com/videolib3/1511/26/Wuimb0091/SD/Wuimb0091-mobile.mp4"];

        _playerController = [[MPMoviePlayerController alloc]initWithContentURL:Url];

            }
    return _playerController;
    
}



//点击视频播放的按钮

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




- (NSString *)endTimePath{
    
    if (!_endTimePath) {
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        _endTimePath = [docPath stringByAppendingPathComponent:@"playTime.plist"];

    }
    
    return _endTimePath;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tatolDuration2 = [NSMutableSet set];
    self.isStop = YES;
    self.isPosition = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.button];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width, 200));
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
    
    
    //崩溃时调用的方法
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveData) name:UIApplicationWillTerminateNotification object:nil];
    
}


//添加监听
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlaybackStateChange2:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.playerController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaplaybackFinnished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.playerController];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookVideoTime) name:MPMovieDurationAvailableNotification object:self.playerController];
    
    
}

//转换
- (NSNumber *)formFloat:(CGFloat)float1{
    
    NSNumber *num = [NSNumber numberWithFloat:float1];
    return num;
}

//只执行一次方法
- (void)oneExercise{
    __weak PlayerController2 *myself = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary *mytime = [NSMutableDictionary dictionaryWithContentsOfFile:myself.endTimePath];
        NSNumber *playtime = [mytime valueForKey:@"currentTime"];
        CGFloat  playtime2 = playtime.floatValue;
        [myself.playerController initialPlaybackTime];
        [myself.playerController setCurrentPlaybackTime:playtime2];
        NSLog(@"只执行一次");
        
    });
    
}
//调到指定的时间
- (void)gotoDataTime{
    NSMutableDictionary *mytime = [NSMutableDictionary dictionaryWithContentsOfFile:self.endTimePath];
    NSNumber *playtime = [mytime valueForKey:@"currentTime"];
    CGFloat  playtime2 = playtime.floatValue;
    [self.playerController setCurrentPlaybackTime:playtime2];

}


- (void)mediaPlaybackStateChange2:(NSNotification *)notifacation{
    
    if (self.playerController.playbackState == MPMoviePlaybackStatePlaying) {
        
        
        
        //记录时间
        NSTimeInterval current = self.playerController.currentPlaybackTime;
        NSLog(@"正在播放%.0fs",current);
        self.playStartTime = current;
        //一播放就开始记录起点
        // self.playedArr = [NSMutableArray arrayWithObject:[self formFloat:self.playStartTime]];
        if (self.fristStopTime == NO) {
            self.playStartTime = self.playerController.currentPlaybackTime;
            self.fristStopTime = YES;
            
        }
        
        self.isStop = YES;

    }

    
    
    
//停止时执行
    if (self.playerController.playbackState == MPMoviePlaybackStateStopped) {
        
    }

    
 //暂停时执行
    if (self.playerController.playbackState == MPMoviePlaybackStatePaused) {
        
       
        
        NSTimeInterval current2 = self.playerController.currentPlaybackTime;
        NSLog(@"暂停的时间是%.0fs",current2);
        self.playingArr = [NSMutableArray arrayWithObject:[self formFloat:current2]];
        if (self.isStop == YES) {
            self.totallTime3 = current2 - self.playStartTime;
            self.totallTime4 += self.totallTime3;
            NSLog(@"暂停的时候我看的播放的时间%.0fs",self.totallTime4);
            self.isStop = NO;
            
            //把播放过的点放进播放过的集合中去
            
            for (int i = (int)self.playStartTime; i <= (int)(current2); i++) {
               
                [self.tatolDuration2 addObject:[NSNumber numberWithInt:i]];
                // NSLog(@"i=%@",self.tatolDuration2);
                
            }
        }
        self.playStopTime = current2;
    }
    
    
    //定位时执行
    if (self.playerController.playbackState == MPMoviePlaybackStateSeekingForward) {
        
        
        if (_isStop == NO) {
            self.totalTime2 = 0.0;
        }else{
            
            NSTimeInterval current3 = self.playerController.currentPlaybackTime;
            NSLog(@"拖动前的时间是%.0fs",current3);
            self.forwardTime = current3;
            self.playingArr = [NSMutableArray arrayWithObject:[self formFloat:current3]];
            self.totalTime1 = self.forwardTime - self.playStartTime;
            self.totalTime2 += self.totalTime1;
            
            NSLog(@"我看的时间是%.0fs",self.totalTime2);
            self.fristStopTime = NO;
            
            for (int i = (int)(self.playStartTime); i <= (int)(self.forwardTime); i++) {
                
             
                [self.tatolDuration2 addObject:[NSNumber numberWithInt:i]];
                
            }
    }
    
}
}


- (void)mediaplaybackFinnished:(NSNotification *)notification{
    NSLog(@"完成播放");
    NSLog(@"我总看的时间是%.0fs",self.totallTime4 + self.totalTime2);
   // NSLog(@"集合的个数是%ld",self.tatolDuration2.count);
    
    if (self.tatolDuration2.count >= 57 ) {
        NSLog(@"视频已经看完了");
    }else{
        NSLog(@"视频没有看完");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)looklook{
    
    //[self saveData];
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [docPath stringByAppendingPathComponent:@"playTime.plist"];
    
    NSLog(@"我保存到的路径是%@",plistPath);
    
      //  [self oneExercise];
    
      NSLog(@"集合里面的数是%ld",self.tatolDuration2.count);
    
    
    
}

- (void)gotoplay:(UIButton *)sender{
    
    
    [self.button addSubview:self.playerController.view];
    [self.playerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.button);
    }];
    [self.playerController play];
   

    [self addNotification];
    

    
    
    //视频一播放就获取视频的总的长度并把视频分成一个个点来记录
    
    // self.playerController.playableDuration
    
    //  NSLog(@"abc%.0fs",self.playerController.duration);
    
    
    
    
    
    
}

- (void)lookVideoTime{

    NSLog(@"视频长度我可以看看吗%.0fs",self.playerController.duration);
    for (int i = 0; i <= (int)(self.playerController.duration); i++) {
        
        self.tatolDuration = [[NSMutableSet alloc]init];
        [self.tatolDuration addObject:[NSNumber numberWithInt:i]];
        NSLog(@"i=%@",self.tatolDuration);
    
        
    }
    
}







//保存数据
- (void)saveData{
    
    CGFloat currentTime = self.playerController.currentPlaybackTime;
    NSNumber *currentTime2 = [self formFloat:currentTime];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:currentTime2 forKey:@"currentTime"];
    [dic writeToFile:self.endTimePath atomically:YES];
    
    
    
    
    
    NSLog(@"数据已保存");
    
}

//加载退出前的数据

- (void)loadingData{

    NSMutableDictionary *mytime = [NSMutableDictionary dictionaryWithContentsOfFile:self.endTimePath];
    NSNumber *playtime = [mytime valueForKey:@"currentTime"];
    CGFloat  playtime2 = playtime.floatValue;
    [self.playerController setCurrentPlaybackTime:playtime2];

    
}







-(void)dealloc{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.playerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.playerController];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:self.playerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:self.playerController];
    
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
