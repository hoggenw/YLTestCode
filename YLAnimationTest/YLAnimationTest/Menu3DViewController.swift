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
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action:
            #selector(gestureRecognizer(gesture:))));

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
    func gestureRecognizer(gesture: UIPanGestureRecognizer) {
        //获取手势在相对指定视图的移动距离，即在X,Y轴上移动的像素，应该是没有正负的，
        //于是考虑用velocityInView:这个方法，这个方法是获取手势在指定视图坐标系统的移动速度，结果发现这个速度是具有方向的，
        /**
         CGPoint velocity = [recognizer velocityInView:recognizer.view];
         if(velocity.x>0) {
         　　//向右滑动
         }else{
         //向左滑动
         }
         */
        if gesture.state == .changed {
            let point = gesture.translation(in: self.view);
            let fullHeight:CGFloat = 80;
            //print("point.x = \(point.x)");//往右为正，往左为负
            let rato: CGFloat = point.x/fullHeight;
            menuView.getRato(rato: rato);
            menuView._rota = rato;
        }
        if gesture.state == .ended || gesture.state == .cancelled {
            menuView.doAnimation();
        }
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
