//
//  BaiduMapViewController.m
//  YLOCAnimationTest
//
//  Created by 王留根 on 2018/3/12.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "BaiduMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import "MapCarAnnotationView.h"
#import "AppDelegate.h"
#import <BMKLocationkit/BMKLocationComponent.h>

//百度地图秘钥
//NS6lYC0TtQdaKmuWseunZ5pqobicYbyY

@interface BaiduMapViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate> {
    BMKMapView * mapView;
    BMKPointAnnotation *pointAnnotation ;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geoCodeSearch;
    CLLocationCoordinate2D * coors;
}
@property (nonatomic, strong) MapCarAnnotationView *busAnnotationView;
@end

@implementation BaiduMapViewController


#pragma mark - Override Methods


- (void)viewDidLoad {
    [super viewDidLoad];
    mapView = [[BMKMapView alloc]initWithFrame: self.view.bounds];
    mapView.zoomLevel = 16; //地图等级，数字越大越清晰
    mapView.showsUserLocation = YES;//是否显示定位小蓝点，no不显示，我们下面要自定义的(这里显示前提要遵循代理方法，不可缺少)
    mapView.userTrackingMode = BMKUserTrackingModeNone;
    mapView.rotateEnabled = NO;
    mapView.overlookEnabled = NO;
    
    pointAnnotation = [[BMKPointAnnotation alloc] init];
    [mapView addAnnotation: pointAnnotation];
    self.view = mapView;
    self.title = @"跟随变换";
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    
    // 初始化编码服务
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    
    //启动LocationService
    [_locService startUserLocationService];
    
    
    
 
    
    
}

//遵循代理写在viewwillappear中
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [mapView viewWillAppear];
    mapView.delegate = self;
    _locService.delegate = self;
    _geoCodeSearch.delegate = self;
    
    AppDelegate *AppDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSInteger count = 0;
    count = AppDele.locationArray.count;
    if (count <= 0) {
        count = 0;
    }
    coors = malloc(count * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i<AppDele.locationArray.count; i++) {
        BMKLocation * locationM = AppDele.locationArray[i];
        coors[i] = locationM.location.coordinate;
        NSLog(@"组合绘制线数组");
    }
    BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:coors count:AppDele.locationArray.count];
    [mapView addOverlay:polyline];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [mapView viewWillDisappear];
    mapView.delegate = nil;
    _locService.delegate = nil;
    _geoCodeSearch.delegate = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Public Methods


#pragma mark - Events


#pragma mark - Private Methods


#pragma mark - Extension Delegate or Protocol
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
    [UIView animateWithDuration:0.25 animations:^{
        self.busAnnotationView.busImageView.transform = CGAffineTransformMakeRotation(userLocation.heading.trueHeading*M_PI/180);
    }];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    NSLog(@"location update: %@",userLocation);
    [mapView removeAnnotation: pointAnnotation];
    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    if (![mapView.annotations containsObject: pointAnnotation]) {
        
    }
    if (![mapView.annotations containsObject:pointAnnotation]) {
        pointAnnotation.coordinate = userLocation.location.coordinate;
        [mapView  addAnnotation:pointAnnotation];
    }
    pointAnnotation.coordinate = userLocation.location.coordinate;


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


#pragma mark - <BMKMapViewDelegate>

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    NSString *AnnotationViewID = @"renameMark";
    MapCarAnnotationView *annotationView = (MapCarAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil)
    {
        annotationView = [[MapCarAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        annotationView.image = [UIImage imageNamed:@"bus_backView"];
        
        annotationView.busImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(annotationView.frame), CGRectGetHeight(annotationView.frame))];
        annotationView.busImageView.image = [UIImage imageNamed:@"bus_location"];
        [annotationView addSubview:annotationView.busImageView];
        annotationView.canShowCallout = NO;
        
        [annotationView.superview bringSubviewToFront:annotationView];
    }
    
    self.busAnnotationView = annotationView;
    return annotationView;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
   
    if ([overlay isKindOfClass:[BMKPolyline class]]){
         NSLog(@"绘制线");
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [UIColor redColor];
        polylineView.lineWidth = 2.0;
        
        return polylineView;
    }
    return nil;
}

@end
