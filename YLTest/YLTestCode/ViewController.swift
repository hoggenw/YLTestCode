//
//  ViewController.swift
//  YLTestCode
//
//  Created by 王留根 on 17/2/20.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit
import YLSwiftScan
import YLRecordingVideo
import YLAuxiliaryKit


class ViewController: UIViewController {

    let manager = YLScanViewManager.shareManager()
    //var baby: BabyBluetooth?
    override func viewDidLoad() {
        super.viewDidLoad()
        //dictionaryReduceTest()
        
//        baby = BabyBluetooth.shareBabyBluetooth()
         intialUI()
         reduceTest()
//        let minius = { () -> Int in
//            return 10
//        }
//        let test = minius
//        print("\(test)")
//        
//        let sampleArray: [Int] = [1,2,3,4,5]
//        let stringArray = sampleArray.map {
//            String($0)
//        }
//        for index in 0..<stringArray.count {
//            print("\(stringArray[index])")
//        }
    }
    
    func intialUI() {
        self.view.backgroundColor = UIColor.white
        let button = UIButton()
        button.backgroundColor = UIColor.brown
        button.frame = CGRect(x: self.view.bounds.width/2 - 30, y: self.view.bounds.height/2 - 200, width: 60, height: 50)
        button.setTitle("扫描", for: .normal)
        let leftmargin: CGFloat = 0
        let rightmargin: CGFloat = 0
        button.addTarget(self, action: #selector(scanQRcode), for: .touchUpInside)
        button.addLineWithSide(.inBottom, color: .red, thickness: 3, margin1: leftmargin, margin2: rightmargin)
        button.addLineWithSide(.inLeft, color: UIColor.randomColor(), thickness: 3, margin1: leftmargin, margin2: rightmargin)
        button.addLineWithSide(.outBottom, color: .red, thickness: 3, margin1: leftmargin, margin2: rightmargin)
        button.addLineWithSide(.outLeft, color: UIColor.randomColor(), thickness: 3, margin1: leftmargin, margin2: rightmargin)
        self.view.addSubview(button)
        
        let button1 = UIButton()
        button1.backgroundColor = UIColor.brown
        button1.frame = CGRect(x: self.view.bounds.width/2 - 30, y: self.view.bounds.height/2 - 100, width: 60, height: 50)
        button1.setTitle("生成", for: .normal)
        button1.addTarget(self, action: #selector(creatSelfQRcODE), for: .touchUpInside)
        self.view.addSubview(button1)
//        button1.addLineWithSide(.inRight, color: UIColor.randomColor(), thickness: 3, margin1: leftmargin, margin2: rightmargin)
//        button1.addLineWithSide(.inTop, color: UIColor.randomColor(), thickness: 3, margin1: leftmargin, margin2: rightmargin)
//        button1.addLineWithSide(.outRight, color: UIColor.randomColor(), thickness: 3, margin1: leftmargin, margin2: rightmargin)
//        button1.addLineWithSide(.outTop, color: UIColor.randomColor(), thickness: 3, margin1: leftmargin, margin2: rightmargin)
        
        let button2 = UIButton()
        button2.backgroundColor = UIColor.brown
        button2.frame = CGRect(x: view.bounds.size.width/2 - 30, y: view.bounds.size.height/2 , width: 60, height: 50)
        button2.setTitle("录制", for: .normal)
        button2.titleLabel?.textColor = UIColor.white
        self.view.addSubview(button2)
        button2.addTarget(self, action: #selector(turnToRecordController), for: .touchUpInside)
        
        let button3 = UIButton()
        button3.backgroundColor = UIColor.brown
        button3.frame = CGRect(x: view.bounds.size.width/2 - 30, y: view.bounds.size.height/2 + 100 , width: 60, height: 50)
        button3.setTitle("地图", for: .normal)
        button3.titleLabel?.textColor = UIColor.white
        self.view.addSubview(button3)
        button3.addTarget(self, action: #selector(button3Action), for: .touchUpInside)
        
        let button4 = UIButton()
        button4.backgroundColor = UIColor.brown
        button4.frame = CGRect(x: view.bounds.size.width/2 - 30, y: view.bounds.size.height/2 + 200 , width: 60, height: 50)
        button4.setTitle("跳转", for: .normal)
        button4.titleLabel?.textColor = UIColor.white
        self.view.addSubview(button4)
        button4.addTarget(self, action: #selector(callApp), for: .touchUpInside)
    }
    
    func callApp() {
        
//        //跳转其他app
//        let url = URL(string: "alipay://");
//        if UIApplication.shared.canOpenURL(url!) {
//            UIApplication.shared.openURL(url!);
//        }
        let vc = TestMapViewController();
        self.navigationController?.pushViewController(vc, animated: true);
    }

    
    func button3Action() {
        let vc = MapViewController();
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    //reduce测试
    func reduceTest() {
//        let dictionary: [String: Int] = ["1":11,"2":12,"3":13,"4":14,"5":15];
//        let result = dictionary.reduce([:]) { (result, element) -> [String: String] in
//            print("\(element.0 ) = \(element.1)")
//            guard
//                let key =  element.0 as? String,
//                let value = element.1 as? Int
//                else {
//                    
//                    return result
//            }
//            
//            var result = result
//            result[key] = value.description
//            return result
//        }
    }
    
    func scanQRcode() {
        
        manager.isNeedShowRetangle = true
        // manager.whRatio = 0.5
        //manager.centerUpOffset = 20
        // manager.scanViewWidth = 160
        //manager.colorRetangleLine = UIColor.red
        //manager.photoframeAngleStyle = YLScanViewPhotoframeAngleStyle.Outer
        //manager.colorAngle = UIColor.red
        //manager.photoframeLineW = 8
        manager.imageStyle = YLAnimationImageStyle.secondeNetGrid
        manager.delegate = self
        manager.showScanView(viewController: self)
    }
    
    func creatSelfQRcODE() {
        let codeView = manager.produceQRcodeView(frame: CGRect(x: (self.view.bounds.size.width - 200)/2, y: self.view.bounds.size.height/2, width: 200, height: 200), logoIconName: "device_scan",codeMessage: "wlg's test Message")
        self.view.addSubview(codeView)
        
        
    }
    
    func turnToRecordController() {
        let videoManager = YLRecordVideoManager.shareManager()
        videoManager.delegate = self
        videoManager.videoQuality = .normalQuality
        videoManager.recordTotalTime = 10
        videoManager.showRecordView(viewController: self)
    }
    
    
    //===============dictionary reduce test=============
    
    func dictionaryReduceTest() {
        let json: [String : Any] = ["1":"first","2":2]
        let result = json.reduce([:]) { (result, elment) -> [String: String] in
            let key:String = elment.key
            guard let value: AnyObject = elment.value as AnyObject? else {
                return ["wrong":"result"]
            }
            var result = result
            result[String(format: "this is key %@", key)] =   String(format: "this is value %@",value  as! CVarArg)
            return result
        }
        
        print("\(result)")
    }
    
    func classNameChioce() {
//        var outCount: UInt32 = 0
//        let propertys = class_copyPropertyList(classForCoder, &outCount)
//        let count: Int = Int(outCount)
//        var isExist = false
//        for i in 0..<count {
//            guard let aPro = propertys?[i],
//                let aName = property_getName(aPro),
//                let name = String(utf8String: aName) else {
//                    continue
//            }
//            if name == keyPath {
//                isExist = true
//                break
//            }
//        }
    }
}

extension ViewController: YLRecordVideoChoiceDelegate {
    func choiceVideoWith(path: String) {
        print("选择视频路径为：\(path)")
    }
}

extension ViewController: YLScanViewManagerDelegate {
    func scanSuccessWith(result: YLScanResult) {
        print("wlg====%@",result.strScanned!)
    }
}
