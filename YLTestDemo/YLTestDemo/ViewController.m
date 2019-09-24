//
//  ViewController.m
//  YLTestDemo
//
//  Created by 王留根 on 2019/9/9.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

#import "ViewController.h"
#import <YLOCScan/YLScanViewManager.h>



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * button = [UIButton new];
    button.frame  = CGRectMake(0, 0, 60, 25);
    
    [button setTitle:@"二维码" forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget: self action:@selector(rightButtonAction) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}


-(void)rightButtonAction {
    YLScanViewManager * manager = [YLScanViewManager sharedInstance];
    manager.imageStyle = secondeNetGrid;
    //    manager.delegate = self;
    //    [manager showScanView: self];
    [manager showScanView:self withBlock:^(YLScanResult * result) {
        NSLog(@"wlg====%@", result.strScanned);
    }];
}

@end
