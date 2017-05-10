//
//  TestMapViewController.swift
//  YLTestCode
//
//  Created by 王留根 on 2017/5/10.
//  Copyright © 2017年 ios-mac. All rights reserved.
//
// @class TestMapViewController
// @abstract 自带地图开发没有地铁信息，不建议使用
// @discussion <#类的功能#>
//

import UIKit
import MapKit

class TestMapViewController: UIViewController {
    
    //MARK:Public Property
    
    
    
    //MARK:Private Property
    //地图初始化
    let mapView =  MKMapView(frame: UIScreen.main.bounds);
    //搜索初始化
    let search = CLGeocoder()
    //定位管理
   // let manager = CLLocationManager()
    //当前位置
    var userCurrentLocation:MKUserLocation?
    //行走坐标Array
    var pointArray: [MKPointAnnotation] = [MKPointAnnotation]()
    //行走曲线
    var routeLine: MKPolyline?
    
    
    //MARK:Public Methods
    
    
    
    //MARK:Override Methods
    deinit {
        self.mapView.showsUserLocation = false;
        mapView.delegate = nil;
        mapView.removeAnnotations(mapView.annotations)
        // mapView.remove(mapView.overlays as! MAOverlay);
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "地图";
        self.view.backgroundColor = UIColor.white
        initialUI();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    //MARK:Private Methods
    func initialUI() {
        view.addSubview(mapView)
        //显示地图范围（比例）
        var mkSpan = MKCoordinateSpan();
        mkSpan.latitudeDelta = 0.1;
        mkSpan.longitudeDelta = 0.1;
        
        var theRegion = MKCoordinateRegion();
        theRegion.span = mkSpan;
        mapView.region = theRegion;
//        //配置（可选）
//        let config = MAUserLocationRepresentation();
//        config.showsHeadingIndicator = true;
//        //        config.locationDotBgColor = UIColor.green;
//        //        config.image = UIImage(named: "test");
//        mapView.update(config);
        // mapView.logoCenter = CGPoint(x: view.bounds.width + 155, y: 450);
        //指南针及其位置
        mapView.showsCompass = true;
        //显示比例尺
        //self.mapView.showsScale = true;
        //显示交通状况
        self.mapView.showsTraffic = true;
        //显示建筑物
        self.mapView.showsBuildings = true;
        //显示用户所在的位置
        self.mapView.showsUserLocation = true;
        //显示感兴趣的东西
        //self.mapView.showsPointsOfInterest = true;
        //mapView.compassOrigin = CGPoint(x: view.bounds.width - 45, y: 64);
        //旋转手势关闭
        mapView.isRotateEnabled = false;
        //相关代理
        mapView.delegate = self;
//        manager.delegate = self;
//        //设置定位精度
//        manager.desiredAccuracy = kCLLocationAccuracyBest;
//        //设置定位距离
//        manager.distanceFilter = 1.0;
        //普通样式
        mapView.mapType = .standard;
//        //防止系统自动杀掉定位 -- 后台定位
//        manager.requestAlwaysAuthorization();
//        //需要设置plist文件 Required background modes : App registers for location updates
//        manager.allowsBackgroundLocationUpdates = true;
//        manager.startUpdatingLocation();
        //确保定位和跟随设置不被覆盖
        mapView.showsUserLocation = true;
        mapView.userTrackingMode = .follow
        
        //MAKE: screenshot test
        let button3 = UIButton()
        button3.backgroundColor = UIColor.brown
        button3.frame = CGRect(x: view.bounds.size.width/2 - 30, y: view.bounds.size.height/2 + 100 , width: 80, height: 50)
        button3.setTitle("当前位置", for: .normal)
        button3.titleLabel?.textColor = UIColor.white
        self.view.addSubview(button3)
        button3.addTarget(self, action: #selector(userLocation), for: .touchUpInside)
        
    }
    
    //MARK:User Events
    
    func userLocation() {
        
    }
    
}

//MARK:Extension Delegate or Protocol
extension TestMapViewController: MKMapViewDelegate {
    
    
    //一个位置更改默认只会调用一次，不断监测用户的当前位置
    //每次调用，都会把用户的最新位置（userLocation参数）传进来
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    //地图的显示区域即将发生改变的时候调用
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
    }
    //地图的显示区域已经发生改变的时候调用
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
}





















