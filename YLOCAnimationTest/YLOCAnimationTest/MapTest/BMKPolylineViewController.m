//
//  BMKPolylineViewController.m
//  YLOCAnimationTest
//
//  Created by 王留根 on 2019/5/28.
//  Copyright © 2019 hoggen. All rights reserved.
//

#import "BMKPolylineViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "AppDelegate.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#import "BMKPolylineViewController.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

@interface BMKPolylineViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate> {
    BMKMapView * mapView;
    BMKPointAnnotation *pointAnnotation ;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geoCodeSearch;
}
@end

@implementation BMKPolylineViewController


#pragma mark - Override Methods


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
     mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    mapView.delegate = self;
    mapView.zoomLevel = 16; //地图等级，数字越大越清晰
    mapView.showsUserLocation = YES;//是否显示定位小蓝点，no不显示，我们下面要自定义的(这里显示前提要遵循代理方法，不可缺少)
    mapView.userTrackingMode = BMKUserTrackingModeNone;
    mapView.rotateEnabled = NO;
    mapView.overlookEnabled = NO;
    [self.view addSubview: mapView];
    
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    
    // 初始化编码服务
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    
    //启动LocationService
    [_locService startUserLocationService];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//遵循代理写在viewwillappear中
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [mapView viewWillAppear];
    mapView.delegate = self;
    _locService.delegate = self;
    _geoCodeSearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [mapView viewWillDisappear];
    mapView.delegate = nil;
    _locService.delegate = nil;
    _geoCodeSearch.delegate = nil;
}

#pragma mark - Public Methods


#pragma mark - Events


#pragma mark - Private Methods


#pragma mark - Extension Delegate or Protocol
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [UIColor redColor];
        polylineView.lineWidth = 2.0;
        
        return polylineView;
    }
    return nil;
}

#pragma mark - <BMKLocationServiceDelegate>
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser{
    NSLog(@"start locate");
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser{
    NSLog(@"stop locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    NSLog(@"heading is %@",userLocation.heading);

}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    NSLog(@"location update: %@",userLocation);

    
    
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"location error");
}

#pragma mark - <BMKGeoCodeSearchDelegate>
/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
}
@end
