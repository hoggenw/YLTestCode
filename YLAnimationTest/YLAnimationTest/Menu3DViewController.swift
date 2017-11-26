//
//  Menu3DViewController.swift
//  YLAnimationTest
//
//  Created by 王留根 on 2017/11/16.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

class Menu3DViewController: UIViewController {

    var menuView: Menu3DView!
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView = Menu3DView(frame: self.view.bounds);
        self.view.addSubview(menuView);
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.navigationBar.isHidden = true;
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        self.navigationController?.navigationBar.isHidden = false;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
