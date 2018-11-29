//
//  YLRecordControlView.m
//  UnitTestDemo
//
//  Created by 王留根 on 2018/7/30.
//  Copyright © 2018年 王留根. All rights reserved.
//

#import "YLRecordControlView.h"

@interface YLRecordControlView()

@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *stopOrChioceButton;
@property (nonatomic, strong) UIButton *cancalButton;

@end

@implementation YLRecordControlView

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        self.ifRestart = false;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.7];
        self.totalSeconds = 10;
        [self initialUI];
    }
    return  self;
}

-(void)initialUI {
    self.progressView = [[YLProgressRecordView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, 20)];
    [self addSubview: self.progressView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeOver) name:@"YLProgressTimeOver" object:nil];
    
    self.recordButton = [self buttonWithTitle:@"开始" frame: CGRectMake(self.frame.size.width/2 - 30, 20 + (self.frame.size.height - 20)/2 -35, 60, 60) action:@selector(recordButtonAction:) AddView: self];
    self.recordButton.layer.cornerRadius = 30;
    self.recordButton.backgroundColor = [UIColor orangeColor];
    
    self.stopOrChioceButton = [self buttonWithTitle:@"停止" frame: CGRectMake(self.frame.size.width - 60, 20 + (self.frame.size.height - 20)/2 -25, 50, 40) action:@selector(stopOrChioceButtonAction:) AddView: self];
     [self.stopOrChioceButton setTitle:@"选择" forState:UIControlStateSelected];
    self.stopOrChioceButton.backgroundColor = [UIColor clearColor];
    
    self.cancalButton = [self buttonWithTitle:@"取消" frame: CGRectMake(10, 20 + (self.frame.size.height - 20)/2 -25, 50, 40) action:@selector(cancalButtonAction) AddView: self];
     self.cancalButton.backgroundColor = [UIColor clearColor];

    
    
    
}

-(void)stopOrChioceButtonAction:(UIButton *)sender {
    [self.progressView stopProgress];
    self.recordButton.userInteractionEnabled = true;
    self.recordButton.selected = false;
    self.recordButton.backgroundColor = [UIColor orangeColor];
    [self.recordButton setTitle:@"重拍" forState: UIControlStateNormal];
    if (self.delegate != nil) {
        if (!sender.selected) {
            [self.delegate stopRecordWith: nil];
        }else{
            [self.delegate choiceVideoWith: nil];
        }
    }
    sender.selected = !sender.selected;
}

-(void)cancalButtonAction {
     [self.progressView stopProgress];
    if (self.delegate != nil) {
        [self.delegate cancelRecordWith: nil];
    }
}

-(void)timeOver {
    [self stopOrChioceButtonAction: self.stopOrChioceButton];
}


-(void)recordButtonAction:(UIButton *)sender {
    if (_totalSeconds > 0) {
        [self.progressView startProgress:1 totalTimer:_totalSeconds];
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = [UIColor grayColor];
        sender.userInteractionEnabled = false;
        self.stopOrChioceButton.selected = false;
    }
    if (self.delegate != nil) {
        if (!_ifRestart) {
            [self.delegate startRecordDelegate];
        }else{
            [self.delegate restartRecordDelegate];
        }
    }
    _ifRestart = true;
    
}

-(UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame action:(SEL)action AddView:(id)view
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds =true;
    [view addSubview:button];
    return button;
}

@end



























