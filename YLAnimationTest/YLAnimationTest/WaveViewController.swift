//
//  WaveViewController.swift
//  YLAnimationTest
//
//  Created by 王留根 on 2017/11/8.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

class WaveViewController: UIViewController {
    
    let wave = WaveView.init(frame: CGRect(x: 100, y: 200, width: 100, height: 100));

    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor.white;
        self.wave.backgroundColor = UIColor.init(R:  200, G: 30, B:  20, A: 1);
        self.wave.layer.cornerRadius = 50;
        self.wave.clipsToBounds = true;
        self.view.addSubview(self.wave);
        self.wave.animationBegin();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
