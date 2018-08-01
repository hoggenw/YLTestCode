//
//  RecordVideoViewController.m
//  UnitTestDemo
//
//  Created by 王留根 on 2018/7/30.
//  Copyright © 2018年 王留根. All rights reserved.
//

#import "RecordVideoViewController.h"
#import "YLRecordVideoView.h"
#import "DemoPreDefine.h"


@interface RecordVideoViewController ()<YLRecordVideoChoiceDelegate>
@property (nonatomic, strong) YLRecordVideoView * recordVideoView;
@end

@implementation RecordVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.recordVideoView = [[YLRecordVideoView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    self.recordVideoView.delegate = self;
    [self.view addSubview:self.recordVideoView];
    if (self.videoUrl.length > 0) {
        [self.recordVideoView preparePreview];
        self.recordVideoView.customVideoPath = self.videoUrl;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)choiceVideoWith:(NSString *)path {
    NSLog(@"path: %@",path);
}

@end
