//
//  YLVoirceInputViewController.swift
//  YLAnimationTest
//
//  Created by 王留根 on 2018/1/31.
//Copyright © 2018年 ios-mac. All rights reserved.
//
// @class YLVoirceInputViewController
// @abstract <#类的描述#>
// @discussion <#类的功能#>
//

import UIKit

class YLVoirceInputViewController: UIViewController {
    
    //MARK:Public Property
    
    
    
    //MARK:Private Property
    
    
    private var voiceView: VioceInputView!
    //MARK:Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true;
        self.view.backgroundColor = UIColor.white;
        voiceView = VioceInputView(frame: self.view.bounds);
        self.view.addSubview(voiceView);
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    //MARK:Public Methods
    
    //MARK: Events

    //MARK:Private Methods
    
    
    
    
}

//MARK:Extension Delegate or Protocol

