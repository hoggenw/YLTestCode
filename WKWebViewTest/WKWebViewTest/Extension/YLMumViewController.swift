//
//  YLMumViewController.swift
//  ftxmall
//
//  Created by hoggen on 2017/6/29.
//  Copyright © 2017年 hoggen. All rights reserved.
//
// @class YLMumViewController
// @abstract <#类的描述#>
// @discussion <#类的功能#>
//

import UIKit

class YLMumViewController: UIViewController {
    
    //MARK:Public Property
    
    
    //MARK:Private Property
    
    
    
    //MARK:Public Methods
    
    
    
    //MARK:Override Methods
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
          self.view.backgroundColor = UIColor.white;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    //MARK:Private Methods
    
    
    //MARK:User Events
    
}

//MARK:Extension Delegate or Protocol

