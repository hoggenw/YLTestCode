//
//  ViewController.m
//  YLWebViewForH5
//
//  Created by 王留根 on 2018/7/9.
//  Copyright © 2018年 OwnersVote. All rights reserved.
//

#import "ViewController.h"
#import "YLWKWebView.h"

@interface ViewController ()<WKNavigationDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //   let strUrl = "http://192.168.20.14:8080/protocal"/index.html
    NSString * strUrl = @"http://192.168.20.14:8080/index.html";
    YLWKWebView *webView = [[YLWKWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    webView.backgroundColor = [UIColor clearColor];
    webView.progressCorlor = [UIColor greenColor];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[strUrl stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]]]];
    [webView loadRequest:request];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
