//
//  HomeViewController.swift
//  YLingFM
//
//  Created by 王留根 on 17/2/27.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
     //MARK: - TEST 1
    var timer: Timer?
    var changeModel: TestModel = TestModel()
    //==============
    var count = Variable(0)
    
    var subscription: Disposable?
    var inputTextFeild: UITextField = UITextField(frame: CGRect(x: 60, y: 100, width: 200, height: 35))
    var secondTextFeild: UITextField = UITextField(frame: CGRect(x: 60, y: 200, width: 200, height: 35))
    var cancalButton: UIButton = UIButton(frame:  CGRect(x: 100, y: 300, width: 100, height: 35))

    private let disPoseBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        cancalButton.setTitle("退出", for: .normal)
        cancalButton.backgroundColor = UIColor.gray
        inputTextFeild.backgroundColor = UIColor.green
        secondTextFeild.backgroundColor = UIColor.green
        self.view.addSubview(inputTextFeild)
        self.view.addSubview(cancalButton)
        self.view.addSubview(secondTextFeild)
         cancalButton.addTarget(self, action: #selector(cancelButtonAction(sender:)), for: .touchUpInside)
        
        #if false
        //MARK: - TEST 1
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)

        changeModel.rx.observe(Int.self, "testNumber").subscribe(onNext: { (testNumber) in
            
             print("testNumber = \(testNumber)")
            
        }).addDisposableTo(disPoseBag)
           

        //====================
        #elseif false
            subscription = inputTextFeild.rx.text.subscribe({ (text) in
               print("\(text)")
            })
       #elseif false
            let firstObserverable = inputTextFeild.rx.text.map({String(format: "%@%@", "first" , $0!) })
            let secondObserrable = secondTextFeild.rx.text.filter({($0?.characters.count)! > 3})
            _ = Observable.combineLatest(firstObserverable, secondObserrable, resultSelector: { (text1, text2) -> (String, Int) in
                return (text1 + text2!, text1.characters.count + (text2?.characters.count)!)
            }).subscribe(onNext: { (element1) in
                print("\(element1.0) : \(element1.1)")
            })
            
            
       #elseif false
             timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateValue), userInfo: nil, repeats: true)
            _ = count.asObservable().subscribe(onNext: {[weak self] (num) in
                self?.inputTextFeild.text = "variableValue: \(num)"
            })
            
//            let searchResult = inputTextFeild.rx.text
//                .throttle(0.3, scheduler: MainScheduler.instance)
//                .distinctUntilChanged()
            
       #elseif false
            //共享监听Sharing subscription－shareReplay
            let nameObserable = inputTextFeild.rx.text.shareReplay(1).map({($0?.characters.count)! >= 6})
            let pwdObserable = secondTextFeild.rx.text.shareReplay(1).map({ (stringText) -> Bool in
                return (stringText?.characters.count)! >= 8
            })
            _ = nameObserable.subscribe(onNext: {[weak self] (valid) in
                self?.inputTextFeild.backgroundColor = valid ? UIColor.clear : UIColor.lightGray
            }).addDisposableTo(disPoseBag)
            
            _ = pwdObserable.subscribe(onNext: {[weak self] (valid) in
                self?.secondTextFeild.backgroundColor = valid ? UIColor.clear : UIColor.lightGray
            }).addDisposableTo(disPoseBag)
            
            _ = Observable.combineLatest(nameObserable, pwdObserable, resultSelector: { (nameValid, pwdValid) -> Bool in
                return nameValid && pwdValid
            }).subscribe(onNext: {[weak self] (valid) in
                guard valid else {
                    self?.cancalButton.backgroundColor = UIColor.gray
                    return
                }
                self?.cancalButton.backgroundColor = UIColor.green
                
            })
       #elseif true
            
            
            
       #endif

        
    }
    

    func updateValue() {
        count.value = count.value + 1
    }
    
    func cancelButtonAction(sender: UIButton)  {
        print("取消了")
        subscription?.dispose()
        timer?.invalidate()
    }
    
    func timerAction() {
        changeModel.testNumber += 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        inputTextFeild.resignFirstResponder()
        secondTextFeild.resignFirstResponder()
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
