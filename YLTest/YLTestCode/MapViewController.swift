//
//  MapViewController.swift
//  YLTestCode
//
//  Created by 王留根 on 2017/5/3.
//  Copyright © 2017年 ios-mac. All rights reserved.
//
// @class MapViewController
// @abstract <#类的描述#>
// @discussion <#类的功能#>
//

import UIKit

class MapViewController: UIViewController {
    
    //MARK:Public Property
    
    
    
    //MARK:Private Property
    //地图初始化
     let mapView =  MAMapView(frame: UIScreen.main.bounds);
    //搜索初始化
     let search = AMapSearchAPI()
    

    
    
    
    
    //MARK:Public Methods
    
    
    
    //MARK:Override Methods
    
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
        mapView.zoomLevel = 14;
        //配置（可选）
        let config = MAUserLocationRepresentation();
        config.showsHeadingIndicator = true;
//        config.locationDotBgColor = UIColor.green;
//        config.image = UIImage(named: "test");
        mapView.update(config);
        // mapView.logoCenter = CGPoint(x: view.bounds.width + 155, y: 450);
        //指南针及其位置
        mapView.showsCompass = true;
        mapView.compassOrigin = CGPoint(x: view.bounds.width - 45, y: 64);
        //旋转手势关闭
        mapView.isRotateEnabled = false;
        //相关代理
        mapView.delegate = self;
        //设置定位精度
        mapView.desiredAccuracy = kCLLocationAccuracyBest;
        //设置定位距离
        mapView.distanceFilter = 1.0;
        //普通样式
        mapView.mapType = .standard;
        //防止系统自动杀掉定位 -- 后台定位
        mapView.pausesLocationUpdatesAutomatically = false;
        //需要设置plist文件 Required background modes : App registers for location updates
        mapView.allowsBackgroundLocationUpdates = true;
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
        let userLocation = mapView.userLocation.coordinate;
        NSLog("first latitude : %f , longitude : %f",userLocation.latitude,userLocation.longitude);
        let regeo = AMapReGeocodeSearchRequest();
        regeo.location = AMapGeoPoint.location(withLatitude: CGFloat(userLocation.latitude), longitude: CGFloat(userLocation.longitude));
        regeo.requireExtension = true;
        //逆地址编码
        search?.delegate = self
        search?.aMapReGoecodeSearch(regeo);
        //正向地址解析
        let request = AMapGeocodeSearchRequest();
        request.address = "成都市天府广场";
        search?.aMapGeocodeSearch(request);
        
        
    }
    
    func takeSnapshot() {
        //截屏
        let image =  mapView.takeSnapshot(in: self.view.bounds);
        let imageView = UIImageView(frame: CGRect(x: 0, y: 200, width: self.view.bounds.width, height: self.view.bounds.height - 200));
        imageView.image = image;
        self.view.addSubview(imageView);
        
    }
    
}

//MARK:Extension Delegate or Protocol
extension MapViewController: MAMapViewDelegate {
    //实时监控用户位置
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        if (updatingLocation) {
            NSLog("latitude : %f , longitude : %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        }
    }
    //大头针代理
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier";
            //自定义
            var annotationView: CustomAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! CustomAnnotationView?
            if annotationView == nil {
                annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier);
            }
            annotationView?.image = UIImage(named: "test");
            // 设置为NO，用以调用自定义的calloutView
            annotationView?.canShowCallout = false
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button;
            annotationView?.setSelected(true, animated: true)
            // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView!.centerOffset = CGPoint(x: -10, y: 0)
            //系统
//            var annottationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
//            if  annottationView == nil {
//                annottationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier);
//            }
//            annottationView?.canShowCallout = true;
//            annottationView?.animatesDrop = true;
//            annottationView?.isDraggable = true;
//            annottationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
             return annotationView!
        }
        
        return nil
    }
}

//MAKE: 逆地址编码
extension MapViewController: AMapSearchDelegate{
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        guard response.regeocode != nil  else {
            return
        }
        let returnValue = response.regeocode.addressComponent.building;
        let city: String = response.regeocode.addressComponent.city;
        NSLog("%@",city );
        print("\(String(describing: returnValue))")
    }
    //MAKE: 地址正向解析
    func onGeocodeSearchDone(_ request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        guard response.geocodes.count != 0 else {
            return;
        }
        for geocode in response.geocodes {
            print("latitude: \(geocode.location.latitude) ,longitude: \(geocode.location.longitude)");
            //大头针
            let pointAnnotation = MAPointAnnotation();
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(geocode.location.latitude), longitude: CLLocationDegrees(geocode.location.longitude))
            pointAnnotation.title = "天府广场";
            pointAnnotation.subtitle = geocode.formattedAddress
            mapView.addAnnotation(pointAnnotation);
        }
        
    }
}




























