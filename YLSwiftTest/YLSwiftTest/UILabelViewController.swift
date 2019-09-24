//
//  UILabelViewController.swift
//  YLSwiftTest
//
//  Created by 王留根 on 2019/9/16.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UILabelViewController: UIViewController {
    
    let disposeBag = DisposeBag();
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel();
         self.view.backgroundColor = UIColor.white;
        self.view.addSubview(label);
        label.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view);
            maker.height.equalTo(50);
            maker.top.equalTo(self.view).offset(kNavigationHeight)
        }
        let label2 = UILabel();
    
        self.view.addSubview(label2);
        label2.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view);
            maker.height.equalTo(50);
            maker.top.equalTo(label.snp.bottom).offset(2);
        }
        
        
        
        let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance);
        timer.map { String(format: "%0.2d:%0.2d.%0.1d",
                           arguments: [($0 / 600) % 600, ($0 % 600 ) / 10, $0 % 10])}
        .bind(to: label.rx.text)
            .disposed(by: disposeBag);
        
        
        let timer2 = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance);
        timer2.map(formatTimeInterval).bind(to: label2.rx.attributedText).disposed(by: disposeBag);
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    
    //将数字转成对应的富文本
    func formatTimeInterval(ms: NSInteger) -> NSMutableAttributedString {
        let string = String(format: "%0.2d:%0.2d.%0.1d",
                            arguments: [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10])
        //富文本设置
        let attributeString = NSMutableAttributedString(string: string)
        //从文本0开始6个字符字体HelveticaNeue-Bold,16号
        attributeString.addAttribute(NSAttributedString.Key.font,
                                     value: UIFont(name: "HelveticaNeue-Bold", size: 16)!,
                                     range: NSMakeRange(0, 5))
        //设置字体颜色
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                     value: UIColor.white, range: NSMakeRange(0, 5))
        //设置文字背景颜色
        attributeString.addAttribute(NSAttributedString.Key.backgroundColor,
                                     value: UIColor.orange, range: NSMakeRange(0, 5))
        return attributeString
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
