//
//  YLVoiceAnimationViewController.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/2/1.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLVoiceAnimationViewController.h"
#import "YLVoiceView.h"
#import "ExtensionHeader.h"


@interface YLVoiceAnimationViewController ()

@property (nonatomic,strong)YLVoiceView * voiceView;

@end

@implementation YLVoiceAnimationViewController


#pragma mark - Override Methods


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _voiceView = [[YLVoiceView alloc] initWithFrame:CGRectZero];
    
    
    //测试语音开始动画
    UIButton * testVioceButton = [self creatNormalBUttonWithName:@"语音动画" frame: CGRectMake(40, 380, 100, 40)];
    [testVioceButton addTarget: self action:@selector(voiceAnimation) forControlEvents: UIControlEventTouchUpInside];
    
    //测试语音结束动画
    UIButton * testVioceStopButton = [self creatNormalBUttonWithName:@"结束动画" frame: CGRectMake(180, 380, 100, 40)];
    [testVioceStopButton addTarget: self action:@selector(stopVoiceAnimation) forControlEvents: UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Public Methods


#pragma mark - Events

- (void)voiceAnimation {
    [self.voiceView startAnimation];
}

- (void)stopVoiceAnimation {
    [self.voiceView stopArcAnimation];
    [self.voiceView removeFromSuperview];
    self.voiceView = nil;
}

- (YLVoiceView *)voiceView {
    if (_voiceView == nil) {
        _voiceView = [[YLVoiceView alloc] initWithFrame:CGRectZero];
    }
    return _voiceView;
}

#pragma mark - Private Methods

-(UIButton *)creatNormalBUttonWithName:(NSString *)name frame:(CGRect)frame {
    
    UIButton * button = [UIButton new];
    button.frame = frame;
    [self.view addSubview: button];
    button.titleLabel.textColor = [UIColor blackColor];
    [button setTitle: name forState: UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
    
    return button;
    
}
#pragma mark - Extension Delegate or Protocol

@end
