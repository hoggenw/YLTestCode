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
     let mapView =  MAMapView(frame: UIScreen.main.bounds);
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
        mapView.showsUserLocation = true;
        mapView.userTrackingMode = .follow
        let config = MAUserLocationRepresentation();
        config.showsHeadingIndicator = true;
        config.locationDotBgColor = UIColor.green;
        config.image = UIImage(named: "test");
        mapView.update(config);
        // mapView.logoCenter = CGPoint(x: view.bounds.width + 155, y: 450);
        mapView.showsCompass = true;
        mapView.compassOrigin = CGPoint(x: view.bounds.width - 45, y: 64);
        //旋转手势关闭
        mapView.isRotateEnabled = false;
        //相关代理
        mapView.delegate = self;

        
        //MAKE: screenshot test
        let button3 = UIButton()
        button3.backgroundColor = UIColor.brown
        button3.frame = CGRect(x: view.bounds.size.width/2 - 30, y: view.bounds.size.height/2 + 100 , width: 60, height: 50)
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
        
        
    }
    
    func takeSnapshot() {
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
}




























