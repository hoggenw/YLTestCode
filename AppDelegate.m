//
//  AppDelegate.m
//  ftxmall
//
//  Created by wanthings mac on 15/12/17.
//  Copyright © 2015年 wanthings. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
//#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
#import "MiPushSDK.h"

#import <RongIMKit/RongIMKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "UPPaymentControl.h"



#import "TabBarController.h"
#import "MessageViewController.h"
#import "OnlineChatViewController.h"
#import "OrderInforViewController.h"
#import "MyBillViewController.h"
#import "OrderInforViewController.h"
#import "MallConsigneeViewController.h"
#import "MallOrderInformViewController.h"
#import "MallViewController.h"
#import "MallOrderInformViewController.h"
#import "MallMarketOrderViewController.h"
#import "MallServiceViewController.h"

#import "SalesDetailViewController.h"
#import "MallServiceManageViewController.h"
#import "LoginViewController.h"

//#import "IQKeyboardManager.h"

//融云
#define RONGCLOUD_IM_APPKEY @"mgb7ka1nbx1kg" //请换成您的appkey，，mgb7ka1nbx1kg

@interface AppDelegate ()<MiPushSDKDelegate,WXApiDelegate,RCIMUserInfoDataSource>
@property (copy, nonatomic)NSString *package_url;
@property (strong, nonatomic)NSMutableDictionary *dic_UserInf;
@property (strong, nonatomic) UINavigationController *navController;//导航条

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.8H64jeG73qOiFOyCpXOFmLR2
    
    
    //设置背景色
    [[UINavigationBar appearance] setBarTintColor:[WXFX HexStringToColor:@"ff3356"]];
    //设置导航栏标题颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置状态栏颜色 在Info.plist中设置UIViewControllerBasedStatusBarAppearance 为NO
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;//改变状态栏的颜色为白色
    
    //设置返回字体颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //修改返回图标
    //[[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back.png"]];
    //[[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back.png"]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName, nil]
                                             forState:UIControlStateNormal];

    self.Url = @"https://api.ftxmall.com/api";
#if false
    self.Url = @"http://testapi.ftxmall.com/api";
#endif
    
    self.isUpdate = NO;

    

    //初始化融云SDK
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
    
    NSDictionary *informationDic = [WXFX GetFile:@"infors.dat"];
    //DLog(@"-----本地的个人信息=%@------",informationDic);
    
    if ([informationDic count] > 0)
    {
        BOOL isConsignee = NO;//默认不是代销商
        NSArray *arry = [NSArray arrayWithArray:[informationDic objectForKey:@"type"]];
        for (NSString *type in arry)
        {
            if ([type intValue] == 6)
            {
                isConsignee = YES;
            }
        }
        if (isConsignee)//代销商
        {
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.navController = [[UINavigationController alloc]init];
            [self.window addSubview:self.navController.view];
            self.window.rootViewController = self.navController;
            [self.window makeKeyAndVisible];
            //跳转到代销商个人中心
            MallConsigneeViewController *vc = [[MallConsigneeViewController alloc]init];
            [self.navController pushViewController:vc animated:YES];
            
        }
        else
        {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            ViewController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"view"];
            [self.window setRootViewController:tb];
        }
        
        
        
        
        
        
       
        NSString *token = [NSString stringWithFormat:@"%@",[informationDic objectForKey:@"im_token"]];
        //登录融云服务器,开始阶段可以先从融云API调试网站获取，之后token需要通过服务器到融云服务器取。
        //token=@"1Cv7TsY7T7wW4kksjL6p8UmcbyeYIrXSDa0nFvL2mH/U5nPXuaB+12S6/5HoVCjf2GXR/ibrED8=";
        
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId)
         {
             //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
             [[RCIM sharedRCIM] setUserInfoDataSource:self];
             
             [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
             DLog(@"登陆融云成功。当前登录的用户ID：%@", userId);
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                
                            });
             
         } error:^(RCConnectErrorCode status)
         {
             DLog(@"登陆融云的错误码为:%d", (int)status);
         } tokenIncorrect:^
         {
             DLog(@"融云token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
         }];
    }
    else
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        ViewController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"view"];
        [self.window setRootViewController:tb];
    }
    
    

    

    

    if ([[WXFX GetFile:@"token.dat"] count] == 0)
    {
        NSDictionary *token = @{@"token":@""};
        [WXFX SaveFile:token Name:@"token.dat"];
    }
    

    //开启异步线程
    dispatch_queue_t  queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        //检查更新
        [self Updates];
    });
    
    
    
    //微信支付
    [WXApi registerApp:@"wx3a3022ee215e9b51" withDescription:@"ftxmall"];
    //wx1c097f2769e1183e,wx80a547ebeae32295
  
    
    //[NSThread sleepForTimeInterval:5.0];//欢迎页显示1秒
    
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"1444ab281bf09"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
//             case SSDKPlatformTypeSinaWeibo:
//                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                 break;
//             case SSDKPlatformTypeRenren:
//                 [ShareSDKConnector connectRenren:[RennClient class]];
//                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
//             case SSDKPlatformTypeSinaWeibo:
//                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
//                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                                         redirectUri:@"http://www.sharesdk.cn"
//                                            authType:SSDKAuthTypeBoth];
//                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx3a3022ee215e9b51"
                                       appSecret:@"7c57154bf040087296fbd0e796ab6787"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105457560"
                                      appKey:@"DDPKWAREc6hyk4oE"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
    
    
    
    //[MiPushSDK registerMiPush:self];
    [MiPushSDK registerMiPush:self type:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound connect:YES];

    
    

    
    //从远程通知启动,UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound
    if (launchOptions != nil)
    {
        //DLog(@"---------------------LUN:%@------------------", launchOptions);
        // UIApplicationLaunchOptionsRemoteNotificationKey 这个key值就是push的信息
        NSDictionary *dic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        //使用此方法后，所有消息会进行去重，然后通过miPushReceiveNotification:回调返回给App
        [MiPushSDK handleReceiveRemoteNotification:dic];
    }
    
    

    
    
    
    return YES;
}












- (void)applicationWillResignActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark 注册push服务.
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 注册APNS成功, 注册deviceToken
    [MiPushSDK bindDeviceToken:deviceToken];
    //DLog(@"wlg说注册成功");
}
// 注册APNS失败.
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    DLog(@"wlg说注册fail");
}

#pragma mark Local And Push Notification
//同一条消息会通过APNs跟长连接分别收到。所以需要使用下面代码把APNs消息导入到SDK内部进行去重复。
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    DLog(@"---------------------------推送消息 =%@-----------------------------",userInfo);
    //使用此方法后，所有消息会进行去重，然后通过miPushReceiveNotification:回调返回给App
    [MiPushSDK handleReceiveRemoteNotification:userInfo];
}

#pragma mark MiPushSDKDelegate
//请求成功
- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    DLog(@"---------------------=%@-----regID请求成功 =%@-----------------------------",selector,data);

    
    //客户端注册成功保存userid
    if ([selector hasPrefix:@"bindDeviceToken:"])
    {
        if ([data count] > 0)
        {
            [WXFX SaveFile:data Name:@"mipush.dat"];
        }
        
        
        
        
//        // 设置别名
//        [MiPushSDK setAlias:@"alias"];
//        
        // 订阅内容
        //[MiPushSDK subscribe:@"topic"];
        
        // 设置帐号
        //[MiPushSDK setAccount:@"account"];
        
        
        //[vMain setRunState:YES];
    }

}
//请求失败
- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
{}


//收到推送消息
//长连接收到的消息。消息格式跟APNs格式一样
- (void)miPushReceiveNotification:(NSDictionary*)data
{
    DLog(@"---------------------长连接消息=%@------------------===-----------",data);
    self.dic_UserInf = [NSMutableDictionary dictionaryWithDictionary:data];
    if ([[data objectForKey:@"msg_type"] intValue] == 70)
    {
        [self Out];
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"通知" message:[NSString stringWithFormat:@"%@",[[data objectForKey:@"aps"] objectForKey:@"alert"]] delegate:self cancelButtonTitle:@"登录" otherButtonTitles:nil, nil];
        aler.tag = 10000;
        [aler show];
    }
    else
    {
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"通知" message:[NSString stringWithFormat:@"%@",[[data objectForKey:@"aps"] objectForKey:@"alert"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去看看", nil];
        aler.tag = 1000;
        [aler show];
    }
}

//判断选中的是确定还是取消
#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
            
        case 0:
            //DLog(@"取消 ");
            
            break;
        case 1:
            // DLog(@"确定");
            if (alertView.tag == 1000)
            {
                [self GoOtherView:self.dic_UserInf];
            }
            
            
            break;
            
        default:
            break;
    }
    
    
    if (alertView.tag == 100)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.package_url]];//更新
    }
}


///跳转到其他页面
-(void)GoOtherView:(NSDictionary *)dic
{
    int i = [[dic objectForKey:@"msg_type"] intValue];
    //DLog(@"---------------------跳转到其他页面=%d-----------------------------",i);
    
    if (i == 0)//系统消息
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        MallViewController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabbar"];
        [self.window setRootViewController:tb];
        
        
        
        MessageViewController *messageView = [[MessageViewController alloc] init];
        [messageView setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
        
        UINavigationController *nc = tb.selectedViewController;
        [nc pushViewController:messageView animated:YES];
        
        
    }
    else if (i == 1)//在线交流
    {
        OnlineChatViewController *chatList = [[OnlineChatViewController alloc] init];
        [chatList setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏

        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        [self.window setRootViewController:tb];
        
        UINavigationController *nc = tb.selectedViewController;
        [nc pushViewController:chatList animated:YES];
    }
    else if (i > 1 && i < 8)//订单情况
    {
        OrderInforViewController *vc = [[OrderInforViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        [self.window setRootViewController:tb];
        
        UINavigationController *nc = tb.selectedViewController;
        vc.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"order_id"]];
        [nc pushViewController:vc animated:YES];
    }
    else if (i > 7 && i < 12)//资金情况
    {
        MyBillViewController *vc = [[MyBillViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        [self.window setRootViewController:tb];
        
        UINavigationController *nc = tb.selectedViewController;
        vc.type = i - 7;
        [nc pushViewController:vc animated:YES];

    }
    else if (i == 12)//资金情况
    {
        MyBillViewController *vc = [[MyBillViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        [self.window setRootViewController:tb];

        UINavigationController *nc = tb.selectedViewController;
        vc.type = 2;
        [nc pushViewController:vc animated:YES];
        
    }
    else if (i == 51 || i == 53 || i == 67)//二期,跳商家订单详情
    {
        MallOrderInformViewController *vc = [[MallOrderInformViewController alloc]init];
        [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
        vc.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"order_id"]];
        vc.isShop = YES;
        
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.navController = [[UINavigationController alloc]init];
        [self.window addSubview:self.navController.view];
        self.window.rootViewController = self.navController;
        [self.window makeKeyAndVisible];
        //跳转到代销商个人中心
        MallConsigneeViewController *center = [[MallConsigneeViewController alloc]init];
        [self.navController pushViewController:center animated:YES];
        [center.navigationController pushViewController:vc animated:YES];
        
        
        
    }
    else if (i == 52)//二期,跳用户订单详情
    {
        MallOrderInformViewController *vc = [[MallOrderInformViewController alloc]init];
        [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
        
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        MallViewController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabbar"];
        [self.window setRootViewController:tb];
        UINavigationController *nc = tb.selectedViewController;
        
        
        vc.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"order_id"]];
        [nc pushViewController:vc animated:YES];
        
    }
    else if (i == 54)//二期,跳代销商收益列表
    {
        MallMarketOrderViewController *vc = [[MallMarketOrderViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
        
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        MallViewController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabbar"];
        [self.window setRootViewController:tb];
        UINavigationController *nc = tb.selectedViewController;
        
        
        [nc pushViewController:vc animated:YES];
        
    }
    else if (i == 55)//二期,进厂家详情的商品评价管理,给商家
    {
        SalesDetailViewController *vc = [[SalesDetailViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
        vc.isNote = YES;
        
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.navController = [[UINavigationController alloc]init];
        [self.window addSubview:self.navController.view];
        self.window.rootViewController = self.navController;
        [self.window makeKeyAndVisible];
        //跳转到代销商个人中心
        MallConsigneeViewController *center = [[MallConsigneeViewController alloc]init];
        [self.navController pushViewController:center animated:YES];
        [center.navigationController pushViewController:vc animated:YES];
        
    }
    else if (i == 56)//二期,售后管理,给商家
    {
        MallServiceManageViewController *vc = [[MallServiceManageViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
       
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.navController = [[UINavigationController alloc]init];
        [self.window addSubview:self.navController.view];
        self.window.rootViewController = self.navController;
        [self.window makeKeyAndVisible];
        //跳转到代销商个人中心
        MallConsigneeViewController *center = [[MallConsigneeViewController alloc]init];
        [self.navController pushViewController:center animated:YES];
        [center.navigationController pushViewController:vc animated:YES];
        
    }
    else if (i == 57 || i == 58)//二期,跳售后服务中的售后列表
    {
        MallServiceViewController *vc = [[MallServiceViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
        
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        MallViewController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabbar"];
        [self.window setRootViewController:tb];
        UINavigationController *nc = tb.selectedViewController;
        
        vc.isNote = YES;
        [nc pushViewController:vc animated:YES];
        
    }
    else if (i >= 60 && i <= 66)//二期,跳财富详情
    {
        MyBillViewController *vc = [[MyBillViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
        if (i == 60 || i == 61)//福元
        {
            vc.type = 2;
        }
        else if (i == 62 || i == 63)//福豆
        {
            vc.type = 5;
        }
        else if (i == 64 || i == 65)//支付记录
        {
            vc.type = 1;
        }
        else//收益
        {
            vc.type = 3;
        }
        
        
        
        
        NSDictionary *informationDic = [WXFX GetFile:@"infors.dat"];
        BOOL isConsignee = NO;//默认不是代销商
        if ([informationDic count] > 0)
        {
            NSArray *arry = [NSArray arrayWithArray:[informationDic objectForKey:@"type"]];
            for (NSString *type in arry)
            {
                if ([type intValue] == 6)
                {
                    isConsignee = YES;
                }
            }
        }
        
        
        if (isConsignee)//代销商
        {
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.navController = [[UINavigationController alloc]init];
            [self.window addSubview:self.navController.view];
            self.window.rootViewController = self.navController;
            [self.window makeKeyAndVisible];
            //跳转到代销商个人中心
            MallConsigneeViewController *vc = [[MallConsigneeViewController alloc]init];
            [self.navController pushViewController:vc animated:YES];
        }
        else
        {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            MallViewController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabbar"];
            [self.window setRootViewController:tb];
            UINavigationController *nc = tb.selectedViewController;
            [nc pushViewController:vc animated:YES];
        }
        
        
    }
    else if (i == 70)//二期,登录过期
    {
        [self Out];
    }
    
}

//退出登录
-(void)Out
{
    //解绑小米推送
//    NSDictionary *dic = [WXFX GetFile:@"token.dat"];
//    [self UnbindMiPush:[NSString stringWithFormat:@"%@",[dic objectForKey:@"token"]]];
    
    NSDictionary *token = @{@"token":@""};
    [WXFX SaveFile:token Name:@"token.dat"];
    NSString *mobile = [[WXFX GetFile:@"psw.dat"] objectForKey:@"mobile"];
    NSDictionary *psw = @{@"mobile":mobile};
    [WXFX SaveFile:psw Name:@"psw.dat"];
    
    [WXFX RemoveFile:@"infors.dat"];
    
    
    
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    MallViewController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabbar"];
    [self.window setRootViewController:tb];
    UINavigationController *nc = tb.selectedViewController;
    
    LoginViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"login"];
    [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
    
    [nc pushViewController:vc animated:YES];
    

}

////解绑小米推送
//-(void)UnbindMiPush:(NSString *)token
//{
//    NSDictionary *dic = [WXFX GetFile:@"mipush.dat"];
//    DLog(@"小米推送USERID IS %@",dic);
//    NSString *userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"regid"]];
//    
//    NSDictionary *parameters = @{@"token":token ,@"push_user_id":userId,@"platform":@"ios"};
//    [RequestAPI UnBindMiPush:parameters SuccessedBlock:^(id responseObject)
//     {
//         DLog(@" --------------------------推送解绑成功  ");
//     } FailuredBlock:^(id error)
//     {
//         DLog(@" --------------------------推送解绑失败 ");
//     }];
//    
//    
//}










/**
 *此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    
    NSDictionary *informationDic = [WXFX GetFile:@"infors.dat"];
    NSDictionary *dic_Id = [WXFX GetFile:@"imid.dat"];
    NSMutableArray *arry = [NSMutableArray array];
    RCUserInfo *user = [[RCUserInfo alloc]init];
    if (dic_Id.count > 0)
    {
        arry = [NSMutableArray arrayWithArray:[dic_Id objectForKey:@"im_id"]];
    }
    
    
    for (NSDictionary *dic in arry)
    {
        if ([userId isEqualToString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"im_id"]]])
        {
            //DLog(@"-------------=%@-----+---------------",dic);
            user.userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"im_id"]];
            user.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
            user.portraitUri =[NSString stringWithFormat:@"%@",[dic objectForKey:@"cover"]];
            break;
        }
    }
    
    if ([informationDic count] > 0)
    {
        if ([userId isEqualToString:[NSString stringWithFormat:@"%@",[informationDic objectForKey:@"im_id"]]])
        {
            //DLog(@"-------------=%@-----+---------------",informationDic);
            user.userId = [NSString stringWithFormat:@"%@",[informationDic objectForKey:@"im_id"]];
            user.name = [NSString stringWithFormat:@"%@",[informationDic objectForKey:@"name"]];
            user.portraitUri =[NSString stringWithFormat:@"%@",[informationDic objectForKey:@"avatar"]];
            
        }
    }
    
    
    
    
    

    return completion(user);

}






//检查更新
-(void)Updates
{
    NSString *url = [self.Url stringByAppendingString:@"/version/check"];
    url = @"https://www.ftxmall.net/api/version/check";
#if false
    url = @"http://www.zhilebd.com/api/version/check";
#endif
    
    //获取版本号
    NSString *version =[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSDictionary *parameters = @{@"version":version,@"platform":@"ios"};
    
    //DLog(@" ....-----------------parameters------------------------ = %@ ",parameters);
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
//    //https请求方式
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
//    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
//    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    // 是否允许,NO-- 不允许无效的证书
//    [securityPolicy setAllowInvalidCertificates:YES];
//    // 设置证书
//    [securityPolicy setPinnedCertificates:certSet];
//    session.securityPolicy = securityPolicy;
//    session.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    
    [session GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSString *errnos = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errno"]];
         
         DLog(@" ....-----------------检查更新-------------------- = %@ ",responseObject);
         if([errnos isEqualToString:@"0"])//成功
         {
             NSMutableDictionary *result  = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"result"]];
             if ([result count] > 0)
             {
                 NSDictionary *package = [result objectForKey:@"package"];//包信息
                
                 if ([package count] > 0)//有更新版本
                 {
                     self.isUpdate = YES;//有更新版本
                     NSComparisonResult result = [version compare:[NSString stringWithFormat:@"%@",[package objectForKey:@"version"]]];
                     if (result == NSOrderedAscending)
                     {
                         //获取下载地址
                         self.package_url = [NSString stringWithFormat:@"%@",[package objectForKey:@"package_url"]];
                         
                         NSString *title = @"发现新版本";
                         NSString *changelog =[NSString stringWithFormat:@"%@",[package objectForKey:@"changelog"]];
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:changelog delegate:self cancelButtonTitle:nil otherButtonTitles:@"去更新",nil];
                         alert.tag = 100;
                         [alert show];
                     }
                 }
                 else
                 {
                     
                 }
                 
                 [WXFX SaveFile:result Name:@"updates.dat"];
             }
         }
         else
         {
             
         }
         
         
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         
         DLog(@" --------------------------检查更新失败 = %@ ",error);
         
     }];
}



//ios9以上用这个回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[WXFX GetFile:@"payment.dat"]];
    NSString *isconfirm = @"0";
    if (dic.count > 0)
    {
        isconfirm = [NSString stringWithFormat:@"%@",[dic objectForKey:@"confirm"]];
    }
    
    
    
    NSString *str = [url absoluteString];
    if ([str hasPrefix:@"wx"])//微信回调
    {
        [WXApi handleOpenURL:url delegate:self];
    }
    else if ([str hasPrefix:@"ftxmall"])
    {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic)
         {
             //DLog(@"----------------支付情况----------result = %@",resultDic);
             
             NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
             
             NSString *strMsg;
             if ([resultStatus isEqualToString:@"9000"])
             {
                 strMsg = @"支付成功";
                 if ([isconfirm intValue] == 1)
                 {
                     OrderInforViewController *vc = [[OrderInforViewController alloc]init];
                     [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                     
                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                     TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                     [self.window setRootViewController:tb];
                     
                     UINavigationController *nc = tb.selectedViewController;
                     vc.isConfirm = YES;
                     vc.status = 2;
                     [nc pushViewController:vc animated:YES];
                 }
                 else if ([isconfirm intValue] == 2)//跳转到直营商城订单详情页面
                 {
                     MallOrderInformViewController *vc = [[MallOrderInformViewController alloc]init];
                     [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                     
                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                     TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabbar"];
                     [self.window setRootViewController:tb];
                     
                     UINavigationController *nc = tb.selectedViewController;
                     vc.isConfirm = YES;
                     vc.status = 2;
                     vc.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
                     [nc pushViewController:vc animated:YES];
                 }
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果"
                                                                 message:strMsg
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
                 
                 return;
             }
             else if([resultStatus isEqualToString:@"6001"])
             {
                 strMsg = @"取消支付";
             }
             else if([resultStatus isEqualToString:@"6002"])
             {
                 strMsg = @"网络连接出错";
             }
             else if([resultStatus isEqualToString:@"8000"])
             {
                 strMsg = @"正在处理中";
             }
             else
             {
                 strMsg = @"支付失败";
             }
             
             if ([isconfirm intValue] == 1)
             {
                 OrderInforViewController *vc = [[OrderInforViewController alloc]init];
                 [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                 
                 UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                 TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                 [self.window setRootViewController:tb];
                 
                 UINavigationController *nc = tb.selectedViewController;
                 vc.isConfirm = YES;
                 vc.status = 1;
                 vc.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
                 [nc pushViewController:vc animated:YES];
             }
             else if ([isconfirm intValue] == 2)//跳转到直营商城订单详情页面
             {
                 MallOrderInformViewController *vc = [[MallOrderInformViewController alloc]init];
                 [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                 
                 UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                 TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabbar"];
                 [self.window setRootViewController:tb];
                 
                 UINavigationController *nc = tb.selectedViewController;
                 vc.isConfirm = YES;
                 vc.status = 1;
                 vc.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
                 [nc pushViewController:vc animated:YES];
             }
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果"
                                                             message:strMsg
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil];
             [alert show];
         }];
        
    }
    else if ([str hasPrefix:@"unionpay"])
    {

        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data)
         {
             
             NSString *strMsg = @"支付失败";
             //结果code为成功时，先校验签名，校验成功后做后续处理
             if([code isEqualToString:@"success"])
             {
                 //判断签名数据是否存在
                 if(data == nil)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果"
                                                                     message:@"支付情况未知"
                                                                    delegate:self
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil, nil];
                     [alert show];
                     //如果没有签名数据，建议商户app后台查询交易结果
                     return;
                 }
                 strMsg = @"支付成功";
                 
                 if ([isconfirm intValue] == 1)
                 {
                     OrderInforViewController *vc = [[OrderInforViewController alloc]init];
                     [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                     
                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                     TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                     [self.window setRootViewController:tb];
                     
                     UINavigationController *nc = tb.selectedViewController;
                     vc.isConfirm = YES;
                     vc.status = 2;
                     [nc pushViewController:vc animated:YES];
                 }
                 else if ([isconfirm intValue] == 2)//跳转到直营商城订单详情页面
                 {
                     MallOrderInformViewController *vc = [[MallOrderInformViewController alloc]init];
                     [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                     
                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                     TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabbar"];
                     [self.window setRootViewController:tb];
                     
                     UINavigationController *nc = tb.selectedViewController;
                     vc.isConfirm = YES;
                     vc.status = 2;
                     vc.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
                     [nc pushViewController:vc animated:YES];
                 }
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果"
                                                                 message:strMsg
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
                 
                 return;
                 
             }
             else if([code isEqualToString:@"fail"])
             {
                 //交易失败
                 strMsg = @"支付失败";
             }
             else if([code isEqualToString:@"cancel"])
             {
                 //交易取消
                 strMsg = @"取消支付";
             }
             
             
             if ([isconfirm intValue] == 1)
             {
                 OrderInforViewController *vc = [[OrderInforViewController alloc]init];
                 [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                 
                 UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                 TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                 [self.window setRootViewController:tb];
                 
                 UINavigationController *nc = tb.selectedViewController;
                 vc.isConfirm = YES;
                 vc.status = 1;
                 vc.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
                 [nc pushViewController:vc animated:YES];
             }
             else if ([isconfirm intValue] == 2)//跳转到直营商城订单详情页面
             {
                 MallOrderInformViewController *vc = [[MallOrderInformViewController alloc]init];
                 [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                 
                 UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                 TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabbar"];
                 [self.window setRootViewController:tb];
                 
                 UINavigationController *nc = tb.selectedViewController;
                 vc.isConfirm = YES;
                 vc.status = 1;
                 vc.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
                 [nc pushViewController:vc animated:YES];
             }
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果"
                                                             message:strMsg
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil];
             [alert show];
             
         }];
    }
    
    
    return YES;
}



//ios9以下用这个回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[WXFX GetFile:@"payment.dat"]];
    NSString *isconfirm = @"0";
    if (dic.count > 0)
    {
        isconfirm = [NSString stringWithFormat:@"%@",[dic objectForKey:@"confirm"]];
    }
    
    
    NSString *str = [url absoluteString];
    if ([str hasPrefix:@"wx"])//微信回调
    {
        [WXApi handleOpenURL:url delegate:self];
    }
    else if ([str hasPrefix:@"ftxmall"])
    {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic)
         {
              //DLog(@"----------------支付情况----------result = %@",resultDic);
             
             NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
             
             NSString *strMsg;
             if ([resultStatus isEqualToString:@"9000"])
             {
                 strMsg = @"支付成功";
                 if ([isconfirm intValue] == 1)
                 {
                     OrderInforViewController *vc = [[OrderInforViewController alloc]init];
                     [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                     
                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                     TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                     [self.window setRootViewController:tb];
                     
                     UINavigationController *nc = tb.selectedViewController;
                     vc.isConfirm = YES;
                     vc.status = 2;
                     [nc pushViewController:vc animated:YES];
                 }
                 else if ([isconfirm intValue] == 2)//跳转到直营商城订单详情页面
                 {
                     MallOrderInformViewController *vc = [[MallOrderInformViewController alloc]init];
                     [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                     
                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                     TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabbar"];
                     [self.window setRootViewController:tb];
                     
                     UINavigationController *nc = tb.selectedViewController;
                     vc.isConfirm = YES;
                     vc.status = 2;
                     vc.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
                     [nc pushViewController:vc animated:YES];
                 }
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果"
                                                                 message:strMsg
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
                 
                 return;
             }
             else if([resultStatus isEqualToString:@"6001"])
             {
                 strMsg = @"取消支付";
             }
             else if([resultStatus isEqualToString:@"6002"])
             {
                 strMsg = @"网络连接出错";
             }
             else if([resultStatus isEqualToString:@"8000"])
             {
                 strMsg = @"正在处理中";
             }
             else
             {
                 strMsg = @"支付失败";
             }
             
             if ([isconfirm intValue] == 1)
             {
                 OrderInforViewController *vc = [[OrderInforViewController alloc]init];
                 [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                 
                 UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                 TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                 [self.window setRootViewController:tb];
                 
                 UINavigationController *nc = tb.selectedViewController;
                 vc.isConfirm = YES;
                 vc.status = 1;
                 [nc pushViewController:vc animated:YES];
             }
             else if ([isconfirm intValue] == 2)//跳转到直营商城订单详情页面
             {
                 MallOrderInformViewController *vc = [[MallOrderInformViewController alloc]init];
                 [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                 
                 UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                 TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabbar"];
                 [self.window setRootViewController:tb];
                 
                 UINavigationController *nc = tb.selectedViewController;
                 vc.isConfirm = YES;
                 vc.status = 1;
                 vc.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
                 [nc pushViewController:vc animated:YES];
             }
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果"
                                                             message:strMsg
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil];
             [alert show];
         }];
        
    }
    else if ([str hasPrefix:@"unionpay"])
    {
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data)
         {
             
             NSString *strMsg = @"支付失败";
             //结果code为成功时，先校验签名，校验成功后做后续处理
             if([code isEqualToString:@"success"])
             {
                 //判断签名数据是否存在
                 if(data == nil)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果"
                                                                     message:@"支付情况未知"
                                                                    delegate:self
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil, nil];
                     [alert show];
                     //如果没有签名数据，建议商户app后台查询交易结果
                     return;
                 }
                 strMsg = @"支付成功";
                 
                 if ([isconfirm intValue] == 1)
                 {
                     OrderInforViewController *vc = [[OrderInforViewController alloc]init];
                     [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                     
                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                     TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                     [self.window setRootViewController:tb];
                     
                     UINavigationController *nc = tb.selectedViewController;
                     vc.isConfirm = YES;
                     vc.status = 2;
                     [nc pushViewController:vc animated:YES];
                 }
                 else if ([isconfirm intValue] == 2)//跳转到直营商城订单详情页面
                 {
                     MallOrderInformViewController *vc = [[MallOrderInformViewController alloc]init];
                     [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                     
                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                     TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabbar"];
                     [self.window setRootViewController:tb];
                     
                     UINavigationController *nc = tb.selectedViewController;
                     vc.isConfirm = YES;
                     vc.status = 2;
                     vc.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
                     [nc pushViewController:vc animated:YES];
                 }
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果"
                                                                 message:strMsg
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
                 
                 return;
                 
             }
             else if([code isEqualToString:@"fail"])
             {
                 //交易失败
                 strMsg = @"支付失败";
             }
             else if([code isEqualToString:@"cancel"])
             {
                 //交易取消
                 strMsg = @"取消支付";
             }
             
             
             if ([isconfirm intValue] == 1)
             {
                 OrderInforViewController *vc = [[OrderInforViewController alloc]init];
                 [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                 
                 UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                 TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                 [self.window setRootViewController:tb];
                 
                 UINavigationController *nc = tb.selectedViewController;
                 vc.isConfirm = YES;
                 vc.status = 1;
                 [nc pushViewController:vc animated:YES];
             }
             else if ([isconfirm intValue] == 2)//跳转到直营商城订单详情页面
             {
                 MallOrderInformViewController *vc = [[MallOrderInformViewController alloc]init];
                 [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                 
                 UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                 TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabbar"];
                 [self.window setRootViewController:tb];
                 
                 UINavigationController *nc = tb.selectedViewController;
                 vc.isConfirm = YES;
                 vc.status = 1;
                 vc.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
                 [nc pushViewController:vc animated:YES];
             }
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果"
                                                             message:strMsg
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil];
             [alert show];
             
         }];
    }
    
    
   
    
    
    return YES;
}



//微信支付成功返回信息
- (void)onResp:(BaseResp *)resp
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[WXFX GetFile:@"payment.dat"]];
    NSString *isconfirm = @"0";
    if (dic.count > 0)
    {
        isconfirm = [NSString stringWithFormat:@"%@",[dic objectForKey:@"confirm"]];
    }
    
    
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        
        NSString *strTitle = [NSString stringWithFormat:@"支付结果"];
        NSString *strMsg = @"支付失败";
        
        if (response.errCode  == 0)
        {

            strMsg = @"支付成功";
            
            if ([isconfirm intValue] == 1)
            {
                OrderInforViewController *vc = [[OrderInforViewController alloc]init];
                [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                [self.window setRootViewController:tb];
                
                UINavigationController *nc = tb.selectedViewController;
                vc.isConfirm = YES;
                vc.status = 2;
                [nc pushViewController:vc animated:YES];
            }
            else if ([isconfirm intValue] == 2)//跳转到直营商城订单详情页面
            {
                MallOrderInformViewController *vc = [[MallOrderInformViewController alloc]init];
                [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabbar"];
                [self.window setRootViewController:tb];
                
                UINavigationController *nc = tb.selectedViewController;
                vc.isConfirm = YES;
                vc.status = 2;
                vc.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
                [nc pushViewController:vc animated:YES];
            }
            
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                            message:strMsg
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
            return;

        }
        else if(response.errCode  == -2)
        {
            strMsg = @"取消支付";
        }
        else
        {
            strMsg = @"支付失败";
        }
        
        if ([isconfirm intValue] == 1)
        {
            OrderInforViewController *vc = [[OrderInforViewController alloc]init];
            [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarController"];
            [self.window setRootViewController:tb];
            
            UINavigationController *nc = tb.selectedViewController;
            vc.isConfirm = YES;
            vc.status = 1;
            [nc pushViewController:vc animated:YES];
        }
        else if ([isconfirm intValue] == 2)//跳转到直营商城订单详情页面
        {
            MallOrderInformViewController *vc = [[MallOrderInformViewController alloc]init];
            [vc setHidesBottomBarWhenPushed:YES];//隐藏TabBar栏
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            TabBarController *tb = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabbar"];
            [self.window setRootViewController:tb];
            
            UINavigationController *nc = tb.selectedViewController;
            vc.isConfirm = YES;
            vc.status = 1;
            vc.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
            [nc pushViewController:vc animated:YES];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                        message:strMsg
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    }
}










- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    return YES;
}



















// 进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}


// 回到前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"进入前台");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
