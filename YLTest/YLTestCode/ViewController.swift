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


class ViewController: UIViewController {

    let manager = YLScanViewManager.shareManager()
    //var baby: BabyBluetooth?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        baby = BabyBluetooth.shareBabyBluetooth()
        intialUI()
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
//        let leftmargin: CGFloat = 0
//        let rightmargin: CGFloat = 0
        button.addTarget(self, action: #selector(scanQRcode), for: .touchUpInside)
//        button.addLineWithSide(.inBottom, color: .red, thickness: 3, margin1: leftmargin, margin2: rightmargin)
//        button.addLineWithSide(.inLeft, color: UIColor.randomColor(), thickness: 3, margin1: leftmargin, margin2: rightmargin)
//        button.addLineWithSide(.outBottom, color: .red, thickness: 3, margin1: leftmargin, margin2: rightmargin)
//        button.addLineWithSide(.outLeft, color: UIColor.randomColor(), thickness: 3, margin1: leftmargin, margin2: rightmargin)
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
