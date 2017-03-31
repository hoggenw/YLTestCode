//
//  YLMainTabbarViewController.swift
//  YLTestCode
//
//  Created by 王留根 on 17/3/30.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

public class YLMainTabbarViewController: UITabBarController {
    
    public var viewControllerModels: [(UIViewController,String, String)]? {
        didSet {
            if let models = viewControllerModels {
                initialVc(models: models)
            }
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialVc(models:[(UIViewController,String, String)]) {
        var childVC = [UINavigationController]()
        for (viewController, title, imageName) in models {
            let navi = YLNavigationController(rootViewController: viewController)
            addChilds(childVC: navi, title: title, iconName: imageName)
            childVC.append(navi)
        }
        self.viewControllers = childVC
    }
    func addChilds(childVC:UINavigationController,title:String,iconName:String) {
        childVC.tabBarItem = UITabBarItem.init(title: title, image: UIImage(named: iconName)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: iconName)?.withRenderingMode(.alwaysOriginal))
        childVC.navigationItem.title = title
        
        self.addChildViewController(childVC)
        
    }
    
    func initialDataSource() {
        
    }
    //MARK:版本更新提示判断
//    func judgeAppVersionUpdate() {
//        let strUrl = "http://itunes.apple.com/lookup?id=\(AppID_PoGe)"
//        let netManager = PSNetWorkManager.netManager
//        var currentVersion:String?
//        var trackViewurl:String?
//        
//        netManager.generalGetWithUrl(requestString: strUrl, paramDic: [:]) { (value) in
//            
//            
//            let dict = value as? [String : AnyObject]
//            
//            if  dict?["resultCount"]?.int8Value == 1 {
//                
//                let dictArray = dict? ["results"]
//                if let mydictArray = dictArray as? NSArray{
//                    let dictInfo = mydictArray.firstObject
//                    if let mydictInfo = dictInfo as? NSDictionary {
//                        trackViewurl = mydictInfo["trackViewUrl"] as? String
//                        let currentVersion1 = mydictInfo["version"] as! String
//                        currentVersion = self.dealVersionString(versionString: currentVersion1)
//                    }
//                    
//                }
//                
//                //获取本地版本当前版本号
//                let localInfo = Bundle.main.infoDictionary
//                
//                
//                var localVersion = localInfo!["CFBundleShortVersionString"] as! String
//                localVersion = self.dealVersionString(versionString: localVersion)
//                if currentVersion != localVersion {
//                    let alertVc = UIAlertController(title: "更新", message: "版本有重要功能更新，是否前往更新？", preferredStyle: .alert)
//                    alertVc.addAction(UIAlertAction(title: "去更新", style: .destructive, handler: { (UIAlertAction) in
//                        UIApplication.shared.openURL(NSURL.init(string: trackViewurl!)! as URL)
//                    }))
//                    alertVc.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
//                    self.present(alertVc, animated: true, completion: nil)
//                }
//                
//            }else{
//                print("获取成功，但信息不对")
//            }
//        }
//        
//        
//        
//    }
//    func dealVersionString(versionString:String) -> String {
//        let array = versionString.components(separatedBy:".")
//        guard array.count >= 2  else{
//            return versionString
//        }
//        return "\(array[0]).\(array[1])"
//        
//    }
    
}
