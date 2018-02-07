//
//  ViewController.m
//  YLOCAnimationTest
//
//  Created by 王留根 on 2018/2/7.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "ViewController.h"
#import "YLMicrophoneViewController.h"
#import "YLVoiceAnimationViewController.h"
#import "YLVoiceCircleViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    //测试语音输入动画
    UIButton * testVioceButton = [self creatNormalBUttonWithName:@"语音动画" frame: CGRectMake(80, 100, 100, 40)];
    [testVioceButton addTarget: self action:@selector(voiceAnimation) forControlEvents: UIControlEventTouchUpInside];
    //测试语音输入动画
    UIButton * micphoneButton = [self creatNormalBUttonWithName:@"micphone动画" frame: CGRectMake(80, 160, 100, 40)];
    [micphoneButton addTarget: self action:@selector(voiceMicphoneAnimation) forControlEvents: UIControlEventTouchUpInside];
    //测试语音输入动画
    UIButton * circleButton = [self creatNormalBUttonWithName:@"circle动画" frame: CGRectMake(80, 220, 100, 40)];
    [circleButton addTarget: self action:@selector(voiceCircleAnimation) forControlEvents: UIControlEventTouchUpInside];
}
-(UIButton *)creatNormalBUttonWithName:(NSString *)name frame:(CGRect)frame {
    
    UIButton * button = [UIButton new];
    button.frame = frame;
    [self.view addSubview: button];
    button.titleLabel.textColor = [UIColor blackColor];
    [button setTitle: name forState: UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
    
    return button;
    
}

#pragma mark - 语音动画
- (void)voiceAnimation {
    YLVoiceAnimationViewController * vc = [YLVoiceAnimationViewController new];
    [self.navigationController pushViewController: vc animated: true];

    
}

- (void)voiceMicphoneAnimation {
    YLMicrophoneViewController * vc = [YLMicrophoneViewController new];
    [self.navigationController pushViewController: vc animated: true];
    
}
- (void)voiceCircleAnimation {
    YLVoiceCircleViewController * vc = [YLVoiceCircleViewController new];
    [self.navigationController pushViewController: vc animated: true];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
