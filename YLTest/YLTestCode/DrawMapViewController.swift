////
////  DrawMapViewController.swift
////  YLTestCode
////
////  Created by 王留根 on 2017/5/16.
////  Copyright © 2017年 ios-mac. All rights reserved.
////
//
//import UIKit
//
//class DrawMapViewController: UIViewController {
//    //MARK:Private Property
//    //地图初始化
//    let mapView =  MAMapView(frame: UIScreen.main.bounds);
//    //搜索初始化
//    let search = AMapSearchAPI()
//    //存放点击点
//    fileprivate var pointArray: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
//    
//    let commitButton = UIButton()
//    
//    let sureButton = UIButton()
//    
//    let cancelButton = UIButton()
//    //MARK:Public Methods
//    
//    
//    
//    //MARK:Override Methods
//    deinit {
//        self.mapView.showsUserLocation = false;
//        mapView.delegate = nil;
//        // mapView.remove(mapView.overlays as! MAOverlay);
//        
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initialUI();
//        
//    }
//    //MARK:Private Methods
//    
//    func initialUI() {
//        view.addSubview(mapView)
//        //显示地图范围（比例）
//        mapView.zoomLevel = 14;
//        //配置（可选）
//        let config = MAUserLocationRepresentation();
//        config.showsHeadingIndicator = true;
//        //        config.locationDotBgColor = UIColor.green;
//        //        config.image = UIImage(named: "test");
//        mapView.update(config);
//        // mapView.logoCenter = CGPoint(x: view.bounds.width + 155, y: 450);
//        //指南针及其位置
//        mapView.showsCompass = true;
//        mapView.compassOrigin = CGPoint(x: view.bounds.width - 45, y: 64);
//        //旋转手势关闭
//        mapView.isRotateEnabled = false;
//        //相关代理
//        mapView.delegate = self;
//        //设置定位精度
//        mapView.desiredAccuracy = kCLLocationAccuracyBest;
//        //设置定位距离
//        mapView.distanceFilter = 5.0;
//        //普通样式
//        mapView.mapType = .standard;
//        //防止系统自动杀掉定位 -- 后台定位
//        mapView.pausesLocationUpdatesAutomatically = false;
//        //需要设置plist文件 Required background modes : App registers for location updates
//        mapView.allowsBackgroundLocationUpdates = true;
//        //确保定位和跟随设置不被覆盖
//        mapView.showsUserLocation = true;
//        mapView.userTrackingMode = .follow
//        creatBottomView()
//        
//    }
//    
//    func creatBottomView() {
//        let bottomView = UIView()
//        bottomView.backgroundColor = UIColor.white;
//        self.view.addSubview(bottomView)
//        bottomView.snp.makeConstraints { (make) in
//            make.bottom.left.right.equalTo(self.view)
//            make.height.equalTo(40)
//        }
//        
//        let width = UIScreen.main.bounds.width;
//        
//        
//        cancelButton.setBackgroundImage(UIImage.imageWith(color: UIColor.brown), for: .normal)
//        cancelButton.setBackgroundImage(UIImage.imageWith(color: UIColor.gray), for: .disabled)
//        cancelButton.frame = CGRect(x: 0, y: 0 , width: width/3 - 1, height: 40)
//        cancelButton.setTitle("取  消", for: .normal)
//        cancelButton.titleLabel?.textColor = UIColor.white
//        cancelButton.isEnabled = false
//        bottomView.addSubview(cancelButton)
//        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
//        
//        sureButton.setBackgroundImage(UIImage.imageWith(color: UIColor.brown), for: .normal)
//        sureButton.setBackgroundImage(UIImage.imageWith(color: UIColor.gray), for: .disabled)
//        sureButton.frame = CGRect(x: width/3, y: 0 , width: width/3 - 1, height: 40)
//        sureButton.setTitle("确  认", for: .normal)
//        sureButton.titleLabel?.textColor = UIColor.white
//        sureButton.isEnabled = false
//        bottomView.addSubview(sureButton)
//        sureButton.addTarget(self, action: #selector(sureButtonAction), for: .touchUpInside)
//        
//
//        commitButton.backgroundColor = UIColor.brown
//        commitButton.setBackgroundImage(UIImage.imageWith(color: UIColor.brown), for: .normal)
//        commitButton.setBackgroundImage(UIImage.imageWith(color: UIColor.gray), for: .disabled)
//        commitButton.frame = CGRect(x: width/3 * 2, y: 0 , width: width/3, height: 40)
//        commitButton.setTitle("提  交", for: .normal)
//        commitButton.titleLabel?.textColor = UIColor.white
//        commitButton.isEnabled = false
//        bottomView.addSubview(commitButton)
//        commitButton.addTarget(self, action: #selector(commitButtonAction), for: .touchUpInside)
//    }
//
//    func cancelButtonAction() {
//        if pointArray.count > 0 {
//            pointArray.removeLast();
//            tapMap()
//            if pointArray.count == 0 {
//               cancelButton.isEnabled = false;
//            }
//        }
//        commitButton.isEnabled = false
//    }
//    
//    func sureButtonAction() {
//        commitButton.isEnabled = true
//    }
//    
//    func commitButtonAction() {
//        
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        
//    }
//    
//    fileprivate func tapMap() {
//        mapView.removeOverlays(mapView.overlays)
//        mapView.removeAnnotations(mapView.annotations)
//        guard pointArray.count > 0 else {
//            return
//        }
//        if pointArray.count == 1 {
//            cancelButton.isEnabled = true
//            sureButton.isEnabled = false
//            //大头针
//            let pointAnnotation = MAPointAnnotation();
//            pointAnnotation.coordinate = pointArray.first!;
//            pointAnnotation.title = "起始点";
//            mapView.addAnnotation(pointAnnotation);
//        }else if pointArray.count == 2 {
//            sureButton.isEnabled = false
//            let polyline: MAPolyline = MAPolyline(coordinates: &pointArray, count: UInt(pointArray.count))
//            mapView.add(polyline)
//        }else if pointArray.count >= 3 {
//            sureButton.isEnabled = true
//            let polygon: MAPolygon = MAPolygon(coordinates: &pointArray, count: UInt(pointArray.count))
//            mapView.add(polygon)
//        }
//    }
//
//
//}
//
//
////MARK:Extension Delegate or Protocol
//extension DrawMapViewController: MAMapViewDelegate {
//    
//    func mapView(_ mapView: MAMapView!, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
//        print(" ====latitude: \(coordinate.latitude) ,longitude: \(coordinate.longitude)")
//        pointArray.append(coordinate)
//        tapMap()
//    }
//    //实时监控用户位置
//    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
//        //location数据是否更新
//        guard updatingLocation else {
//            return
//        }
////        mapView.setCenter(userLocation.coordinate, animated: true)
// 
//    }
//    //绘制关键代理
//    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
//        if overlay is MAPolyline {
//            let polylineView: MAPolylineRenderer = MAPolylineRenderer(overlay: overlay);
//            polylineView.lineWidth = 4;
//            polylineView.strokeColor = UIColor.green;
//            return polylineView;
//        }else if overlay is MAPolygon {
//            let polylineView: MAPolygonRenderer = MAPolygonRenderer(overlay: overlay);
//            polylineView.lineWidth = 4;
//            polylineView.strokeColor = UIColor.green;
//            polylineView.fillColor = UIColor.blue.withAlphaComponent(0.4)
//            polylineView.lineDash = false
//            polylineView.lineJoinType = kMALineJoinMiter
//            return polylineView;
//        }
//        return nil
//    }
//    
//    
//    //定位失败
//    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
//        
//    }
//    
//    //大头针代理
//    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
//        if annotation.isKind(of: MAPointAnnotation.self) {
//            let pointReuseIndetifier = "pointReuseIndetifier";
//            var annottationView: DrawAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! DrawAnnotationView?
//            if  annottationView == nil {
//                annottationView = DrawAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier);
//            }
//            annottationView?.image = UIImage.imageWith(color: UIColor.green)
//            annottationView?.canShowCallout = false;
//            annottationView?.isDraggable = false;
//            annottationView?.layer.cornerRadius = 3;
//            annottationView?.clipsToBounds = true;
//            return annottationView!
//        }
//        
//        return nil
//    }
//}
//
////MAKE: 逆地址编码
//extension DrawMapViewController: AMapSearchDelegate{
//    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
//        guard response.regeocode != nil  else {
//            return
//        }
//        let returnValue = response.regeocode.addressComponent.building;
//        let city: String = response.regeocode.addressComponent.city;
//        NSLog("%@",city );
//        print("\(String(describing: returnValue))")
//    }
//    //MAKE: 地址正向解析
//    func onGeocodeSearchDone(_ request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
//        guard response.geocodes.count != 0 else {
//            return;
//        }
//        
//    }
//}
//
