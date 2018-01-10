//
//  ViewController.m
//  YLARKitTest
//
//  Created by 王留根 on 2018/1/6.
//  Copyright © 2018年 王留根. All rights reserved.
//

#import "ViewController.h"
#import "ARScanViewController.h"
//3d游戏框架
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * button = [UIButton new];
    [button setTitle:@"开启AR" forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 90, 40);
    [self.view addSubview: button];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)buttonAction:(UIButton *)sender {
    ARScanViewController * vc = [ARScanViewController new];
    [self presentViewController: vc animated: true completion: nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
