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
#import "YLVoiceCircleView.h"
#import "YLMicphoneVoiceView.h"

@interface YLVoiceAnimationViewController ()

@property (nonatomic,strong)YLVoiceView * voiceView;
@property (nonatomic,strong)YLVoiceCircleView * voiceCircleView;
@property (nonatomic,strong)YLMicphoneVoiceView * micphoneVoiceView;

@property (nonatomic, assign)NSInteger  type;
@property (nonatomic, strong)UIView * backView;

@end

@implementation YLVoiceAnimationViewController


#pragma mark - Override Methods


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.type = 1;
    _voiceView = [[YLVoiceView alloc] initWithFrame:CGRectZero];
    
    //动画type
    UIButton * animationTypeButton = [self creatNormalBUttonWithName:@"语音I动画" frame: CGRectMake(80, 70, 100, 40)];
    [animationTypeButton addTarget: self action:@selector(changedAnimationType:) forControlEvents: UIControlEventTouchUpInside];
    
    
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


- (void)changedAnimationType:(UIButton *) sender {
    switch (self.type) {
        case 1:{
            self.type = 2;
            [sender setTitle:@"语音II动画" forState:UIControlStateNormal];
            [_voiceView removeFromSuperview];
            _voiceView = nil;
            _voiceCircleView =  [[YLVoiceCircleView alloc] initWithFrame:CGRectZero];;
            break;
        }
            
        case 2:{
            self.type = 3;
            [sender setTitle:@"语音III动画" forState:UIControlStateNormal];
            [_voiceCircleView removeFromSuperview];
            _voiceCircleView = nil;
            _micphoneVoiceView =  [[YLMicphoneVoiceView alloc] initWithFrame:CGRectZero];;
            break;
        }
        case 3:{
            self.type = 1;
            [sender setTitle:@"语音I动画" forState:UIControlStateNormal];
            [_micphoneVoiceView removeFromSuperview];
            _micphoneVoiceView = nil;
            _voiceView =  [[YLVoiceView alloc] initWithFrame:CGRectZero];;
            break;
        }
        default:
            break;
    }
}


- (void)voiceAnimation {
    switch (self.type) {
        case 1:
            [self.voiceView startAnimation];
            break;
        case 2:
            [self.voiceCircleView startAnimation];
            break;
        case 3:
            [self.micphoneVoiceView startAnimation];
            break;
        default:
            break;
    }
    
}

- (void)stopVoiceAnimation {
    
    switch (self.type) {
        case 1:{
            [self.voiceView stopArcAnimation];
            [self.voiceView removeFromSuperview];
            self.voiceView = nil;
            break;
        }
        case 2:
            [self.voiceCircleView startAnimation];
            [self.voiceCircleView removeFromSuperview];
            self.voiceCircleView = nil;
            break;
        case 3:
            [self.micphoneVoiceView startAnimation];
            [self.micphoneVoiceView removeFromSuperview];
            self.micphoneVoiceView = nil;
            break;
        default:
            break;
    }
    
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
