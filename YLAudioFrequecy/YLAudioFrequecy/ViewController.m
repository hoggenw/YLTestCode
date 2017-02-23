//
//  ViewController.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 17/2/22.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL * url = [NSURL URLWithString:@"http://fdfs.xmcdn.com/group25/M0B/92/53/wKgJNlims-vgpIJLADSwZ4QElcA333.mp3"];
    AVPlayerItem * songItem = [[AVPlayerItem alloc] initWithURL:url];
    AVPlayer * player = [[AVPlayer alloc] initWithPlayerItem:songItem];
    [player play];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end





















