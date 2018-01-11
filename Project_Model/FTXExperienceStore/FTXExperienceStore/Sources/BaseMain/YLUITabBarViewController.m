//
//  YLUITabBarViewController.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "YLUITabBarViewController.h"
#import "AppDelegate.h"


@interface YLUITabBarViewController ()

@end

@implementation YLUITabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 版本更新提示 判断
- (void)judgeAppVersionUpdate
{
    
    NSString * strUrl = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", @"1238599161"];//福到家
    [[NetworkManager sharedInstance] generalGetWithURL:strUrl param:nil returnBlock:^(NSDictionary *returnDict) {
        
        // NSLog(@"request app itunes info failure, responseObj : %@", returnDict);
        if (1 == [returnDict[@"resultCount"] integerValue])    // 获取成功
        {
            // 获取appstore 里的版本号
            NSDictionary * dicInfo = [returnDict[@"results"] firstObject];
            NSString * currentVersion = dicInfo[@"version"];
            //NSLog(@"app.currentVersion=%@",currentVersion);
            currentVersion = [self dealVersionString:currentVersion];
            NSLog(@"app.currentVersion=%@",currentVersion);
            NSString *trackViewUrl = [dicInfo objectForKey:@"trackViewUrl"];
            
            // 获取本地当前版本号
            NSDictionary * localInfo = [[NSBundle mainBundle] infoDictionary];
            
            NSString * localVersion  = [localInfo objectForKey:@"CFBundleShortVersionString"];
            
            localVersion = [self dealVersionString:localVersion];
            NSLog(@"localVersion =%@",localVersion);
            // 这种方式要求填写一致  app上架申请里的版本必须和info配置里的版本一致
            //判断目前版本是否大于App Store的版本，小于则继续处理
            if ([self judgeVesion: dicInfo[@"version"] loaction: [localInfo objectForKey:@"CFBundleShortVersionString"]]) {
                UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"更新" message:@"版本有重要功能更新，是否前往更新？" preferredStyle:UIAlertControllerStyleAlert];
                [alertVC addAction:[UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
                    [self exitApplication];
                }]];
                // 判断版本号主要判断app store版本号1、3、5、7、9这几个特殊版本号
                if ([currentVersion isEqualToString:@"1"] || [currentVersion isEqualToString:@"3"] || [currentVersion isEqualToString:@"5"] || [currentVersion isEqualToString:@"7"] || [currentVersion isEqualToString:@"9"]) {
                    
                }else {
                    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                }
                
                [self presentViewController:alertVC animated:YES completion:nil];
                
            }else {
                return ;
            }
            
            
        }
        else    // 获取失败
        {
            NSLog(@"request app itunes info failure, responseObj : %@", returnDict);
        }
    }];
    
    
}
-(NSString *)dealVersionString:(NSString *)versionString {
    NSArray  *dealStringArray = [versionString componentsSeparatedByString:@"."];
    return  dealStringArray.lastObject;
}

-(BOOL )judgeVesion:(NSString *)appStoreVesion loaction:(NSString *)locationVesion {
    BOOL returnBool = false;
    NSArray  *appStoreStringArray = [appStoreVesion componentsSeparatedByString:@"."];
    NSArray  *locationStringArray = [locationVesion componentsSeparatedByString:@"."];
    // NSLog(@"localVersion =%@",@(locationStringArray.count));
    if (appStoreStringArray.count == 3 && appStoreStringArray.count == locationStringArray.count) {
        if ([locationStringArray[0] integerValue] < [appStoreStringArray[0] integerValue] ) {
            return  true;
        }
        if ([locationStringArray[1] integerValue] < [appStoreStringArray[1] integerValue]) {
            return  true;
        }
        if ([locationStringArray[2] integerValue] >= [appStoreStringArray[2] integerValue] ) {
            return  returnBool;
        }else {
            NSLog(@"localVersion,@(locationStringArray.count)");
            return  true;
        }
    }
    return  returnBool;
}
//-------------------------------- 退出程序 -----------------------------------------//

- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    AppDelegate *AppDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [UIView setAnimationTransition: 2 forView:AppDele.window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    //self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    AppDele.window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}



- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
        
    }
    
}
@end
