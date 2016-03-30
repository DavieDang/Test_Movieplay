//
//  ViewController.m
//  BGTest_Movieplay
//
//  Created by BingoMacMini on 16/3/25.
//  Copyright © 2016年 BingoMacMini. All rights reserved.
//

#import "ViewController.h"
#import "PlayerController.h"
#import "PlayerController2.h"


@interface ViewController ()
@property(nonatomic,strong)AVPlayer *player;
//在屏幕上只需要一个layer
@property(nonatomic,strong)AVPlayerLayer *layer;

//添加一个播放器






@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"播放视频" forState:0];
    
    [button setTintColor:[UIColor redColor]];
    button.backgroundColor = [UIColor grayColor];
    [button addTarget:self action:@selector(gotoplay) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"暂停" forState:0];
    
    [button2 setTintColor:[UIColor redColor]];
    button2.backgroundColor = [UIColor grayColor];
    [button2 addTarget:self action:@selector(gotoStop) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button2];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(button.mas_right).mas_offset(10);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    
    
    //添加下一个控制器
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"另一种播放" style:UIBarButtonItemStylePlain target:self action:@selector(nextVC)];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)gotoplay{
    
    //视频的网址
    NSString *str = @"http://flv2.bn.netease.com/videolib3/1511/26/Wuimb0091/SD/Wuimb0091-mobile.mp4";
    AVPlayerItem *tiem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:str]];
    self.player = [AVPlayer playerWithPlayerItem:tiem];
    self.layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    //设置当前的播放位置
    [self.view.layer addSublayer:self.layer];
    self.layer.frame  = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 200);
  
    [self.player play];
    
}

- (void)gotoStop{
    
    [self.player pause];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}

- (void)nextVC{
    
    [self.navigationController pushViewController:[PlayerController2 new] animated:YES];
    
}

@end
