//
//  YLHintView.swift
//  YLWholesale
//
//  Created by 王留根 on 2017/4/14.
//  Copyright © 2017年 ios-mac. All rights reserved.
//
import SnapKit
import UIKit


class YLHintView: UIView {

    var hintLabel:YLLabel?
    var timer:Timer?
    var isExistence : Bool = false
    public static let hintView: YLHintView = YLHintView()
    
    deinit {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    //MARK:提示信息
    class func showMessageOnThisPage(_ message : String) {
        
        YLHintView.hintView.tag = 3333
        if YLHintView.hintView.hintLabel == nil {
            hintView.showHintView(message)
        }else {
            hintView.hintViewRemoveFromSuperview()
            hintView.showHintView(message)
        }
        
    }
    
    func showHintView(_ message : String) {
        YLHintView.hintView.hintLabel = YLLabel()
        
        let window = UIApplication.shared.keyWindow
        window?.addSubview(YLHintView.hintView.hintLabel!)
        YLHintView.hintView.hintLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalTo((window?.snp.centerX)!)
            make.centerY.equalTo((window?.snp.centerY)!)
            make.width.greaterThanOrEqualTo(100)
            make.width.lessThanOrEqualTo(220)
            make.height.greaterThanOrEqualTo(43)
        })
        window?.addSubview(YLHintView.hintView)
        YLHintView.hintView.hintLabel?.layer.cornerRadius = 5
        YLHintView.hintView.hintLabel?.isUserInteractionEnabled = false
        YLHintView.hintView.hintLabel?.clipsToBounds = true
        YLHintView.hintView.hintLabel?.textAlignment = .center
        YLHintView.hintView.hintLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        YLHintView.hintView.hintLabel?.backgroundColor = UIColor(hex: 0x2a2a2a).withAlphaComponent(0.8)
        YLHintView.hintView.hintLabel?.textColor = UIColor.white
        YLHintView.hintView.hintLabel?.text = message
        YLHintView.hintView.hintLabel?.numberOfLines = 0
        YLHintView.hintView.timer = Timer(timeInterval: 2, target: self, selector: #selector(hintViewRemoveFromSuperview), userInfo: nil, repeats: false)
        RunLoop.current.add(YLHintView.hintView.timer!, forMode: .defaultRunLoopMode)
        
    }
    
    func hintViewRemoveFromSuperview() {
        YLHintView.hintView.hintLabel?.removeFromSuperview()
        YLHintView.hintView.hintLabel = nil;
        
        if (YLHintView.hintView.timer) != nil{
            YLHintView.hintView.timer?.invalidate()
            YLHintView.hintView.timer = nil;
        }
    }

}
