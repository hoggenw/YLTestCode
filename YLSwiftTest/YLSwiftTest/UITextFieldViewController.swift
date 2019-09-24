//
//  UITextFieldViewController.swift
//  YLSwiftTest
//
//  Created by 王留根 on 2019/9/16.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UITextFieldViewController: UIViewController {
    let disposeBag = DisposeBag();
    var userVM = MusicListViewModel();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        
        let textField = UITextField();
        textField.borderStyle = UITextField.BorderStyle.roundedRect;
        self.view.addSubview(textField);
        textField.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view.snp.left).offset(10);
            maker.right.equalTo(self.view.snp.right).offset(-10);
            maker.height.equalTo(50);
            maker.top.equalTo(self.view).offset(kNavigationHeight + 10)
        }
        
        let outputField = UITextField();
        outputField.borderStyle = UITextField.BorderStyle.roundedRect;
        self.view.addSubview(outputField);
        outputField.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view.snp.left).offset(10);
            maker.right.equalTo(self.view.snp.right).offset(-10);
            maker.height.equalTo(50);
            maker.top.equalTo(textField.snp.bottom).offset(10)
        }
        
        let label = UILabel();
        self.view.addSubview(label);
        label.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view.snp.left).offset(10);
            maker.right.equalTo(self.view.snp.right).offset(-10);
            maker.height.equalTo(50);
            maker.top.equalTo(outputField.snp.bottom).offset(10)
        }
        
        let button: UIButton = UIButton(type: .system);
        self.view.addSubview(button);
        button.setTitle("提交", for:.normal);
        button.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view.snp.left).offset(10);
            maker.right.equalTo(self.view.snp.right).offset(-10);
            maker.height.equalTo(50);
            maker.bottom.equalTo(self.view.snp.bottom).offset(-60)
        }
        button.rx.tap.subscribe(onNext: { [weak self] in
            self?.showMessage("按钮被点击")
        }).disposed(by: disposeBag);
        
        
        textField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { (value) in
                 print("您输入的是：\(value)")
            }).disposed(by: disposeBag);
        
        let input = textField.rx.text.orEmpty.asDriver()// 将普通序列转换为 Driver
            .throttle(0.3);//在主线程中操作，0.3秒内值若多次改变，取最后一次
        
        input.drive(outputField.rx.text).disposed(by: disposeBag);
//        input.map{"当前字数：\($0.count)"}.drive(label.rx.text)
//            .disposed(by: disposeBag);
        
        //根据内容字数决定按钮是否可用
        input.map{ $0.count > 5 }
            .drive(button.rx.isEnabled)
            .disposed(by: disposeBag)
    

        Observable.combineLatest(textField.rx.text, outputField.rx.text) { (textValue1, textValue2) -> String in
            return "你输入的内容是：\(textValue1  ?? "")-\(textValue2 ?? "")";
            }
            .map{$0}
            .bind(to: label.rx.text)
            .disposed(by: disposeBag);
        
        
        /*
         editingDidBegin：开始编辑（开始输入内容）
         editingChanged：输入内容发生改变
         editingDidEnd：结束编辑
         editingDidEndOnExit：按下 return 键结束编辑
         allEditingEvents：包含前面的所有编辑相关事件
         */
        
        textField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: {[weak self] (_) in
                outputField.becomeFirstResponder();
            }).disposed(by: disposeBag);
        
        outputField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: {[weak self] (_) in
                outputField.resignFirstResponder();
            }).disposed(by: disposeBag);
        userVM.userName.asObservable().bind(to: textField.rx.text).disposed(by: disposeBag);
        textField.rx.text.orEmpty.bind(to: userVM.userName).disposed(by: disposeBag);
        //将用户信息绑定到label上
        userVM.info.bind(to: label.rx.text).disposed(by: disposeBag)
        
        
        //添加一个上滑手势
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .up
        self.view.addGestureRecognizer(swipe)
        
        //手势响应
        swipe.rx.event
            .bind { [weak self] recognizer in
                //这个点是滑动的起点
                let point = recognizer.location(in: recognizer.view)
                self?.showAlert(title: "向上划动", message: "\(point.x) \(point.y)")
            }
            .disposed(by: disposeBag)
        
    }
    
    //显示消息提示框
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel))
        self.present(alert, animated: true)
    }

    //显示消息提示框
    func showMessage(_ text: String) {
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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


extension UITextFieldViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.view.endEditing(true)
    }
}
