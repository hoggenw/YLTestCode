//
//  YLHintView.swift
//  YLSwiftTest
//
//  Created by 王留根 on 2019/9/30.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

import UIKit

class YLHintView: UIView {

    static let sharedInstance = YLHintView();
    
    private var hintLabel:YLLabel?;
   
    private var timer: Timer!
    
    static func showMessageOnThisPage(message:String){
        let manager = YLHintView.sharedInstance;
        manager.tag = 3333;
        DispatchQueue.main.async {
            if let _ = manager.hintLabel {
                hintViewRemoveFromSuperview();
                showHintView(message: message);
            }else{
                showHintView(message: message)
            }
        }
    }
    static func showHintView(message: String){
        let manager = YLHintView.sharedInstance;
        manager.hintLabel = YLLabel();
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.addSubview(manager.hintLabel!);
        manager.hintLabel?.snp.makeConstraints({ (maker) in
            maker.centerX.equalTo((delegate.window?.snp.centerX)!);
            maker.centerY.equalTo((delegate.window?.snp.centerY)!).offset(-10);
            maker.width.greaterThanOrEqualTo(100);
            maker.width.lessThanOrEqualTo(220);
            maker.height.greaterThanOrEqualTo(43);
        })
         delegate.window?.addSubview(manager);
        manager.hintLabel?.layer.cornerRadius = 5;
        manager.hintLabel?.isUserInteractionEnabled = false;
        manager.hintLabel?.clipsToBounds = true;
        manager.hintLabel?.textAlignment = .center;
        manager.hintLabel?.font = UIFont.systemFont(ofSize: 15);
        manager.hintLabel?.backgroundColor = UIColor.colorWithHexString(hexString:  "#000000", alpha: 0.8)
        manager.hintLabel?.textColor = .white;
        manager.hintLabel?.text = message;
        manager.hintLabel?.numberOfLines = 0;
        manager.timer = Timer.init(timeInterval: 2.5, target: self, selector: #selector(hintViewRemoveFromSuperview), userInfo: nil, repeats: false);
        RunLoop.current.add(manager.timer, forMode: .common);
        
    }
    
    
    @objc static func hintViewRemoveFromSuperview(){
         let manager = YLHintView.sharedInstance;
        manager.hintLabel?.removeFromSuperview();
        manager.hintLabel = nil;
        
        if let _ = manager.timer {
            manager.timer.invalidate();
            manager.timer = nil;
        }
        
    }
    
    
    static func showAlertMessage(message: String, title:String) {
        let delegate  = UIApplication.shared.delegate as! AppDelegate;
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert);
        let okAction = UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            
        });
        alertController.addAction(okAction);
        delegate.window?.rootViewController?.present(alertController, animated: true, completion: {
            
        });
         
    }

}
