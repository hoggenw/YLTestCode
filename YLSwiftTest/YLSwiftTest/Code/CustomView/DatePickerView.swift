//
//  DatePickerView.swift
//  YLSwiftTest
//
//  Created by 王留根 on 2019/9/27.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

import UIKit

class DatePickerView: UIView {

    var yearRange: NSInteger{
        didSet {
            
        }
    };
    var dayRange: NSInteger;
    var startYear: NSInteger;
    var selectedYear: NSInteger;
    var selectedMonth: NSInteger;
    var selectedDay: NSInteger;
    var selectedHour: NSInteger;
    var selectedMinute: NSInteger;
    var selectedSecond: NSInteger;
    var calendar:Calendar;
    //左边退出按钮
    lazy var cancelButton:UIButton = {
        return DatePickerView.creatButton(frame: CGRect.init(x: 12, y: 0, width: 40, height: 40), title: "取消", backColor: UIColor.clear, fontSize: 15, titleColor: UIColor.init(hex: 0x0d8bf5));
    }()
    //右边的确定按钮
    lazy var  chooseButton:UIButton = {
        return DatePickerView.creatButton(frame: CGRect.init(x: 12, y: 0, width: 40, height: 40), title: "取消", backColor: UIColor.clear, fontSize: 15, titleColor: UIColor.init(hex: 0x0d8bf5))
        
    }()
    
    lazy var pickerView:UIPickerView = {
        return UIPickerView.init(frame: CGRect.init(x: 0, y: 40, width: ScreenWidth, height: 220));
    }()
    var backString: String?;
    lazy var contentV:UIView = {
        return UIView.init(frame: CGRect.init(x: 0, y: ScreenHeight, width: ScreenWidth, height: 220));
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.init(R: 0 as UInt8, G: 0 as UInt8, B: 0 as UInt8, A: 0.5 as CGFloat);
        self.alpha = 0;
        self.contentV.backgroundColor = UIColor.white;
        self.addSubview(contentV);
        
        self.pickerView.backgroundColor = .white;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.contentV.addSubview(self.pickerView)
        
        self.cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside);
        self.chooseButton.addTarget(self, action: #selector(configButtonClick), for: .touchUpInside);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    static func creatButton(frame:CGRect?,title:String?,backColor:UIColor?,fontSize:CGFloat?,titleColor:UIColor?) -> UIButton {
        let button = UIButton.init(type: .custom);
        if let frame = frame {
            button.frame = frame;
        }
        if let title = title {
            button.setTitle(title, for: .normal);
        }
        if let backColor = backColor {
            button.backgroundColor = backColor;
        }
        if let fontSize = fontSize {
            button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize);
        }
        if let titleColor = titleColor {
            button.setTitleColor(titleColor, for: .normal);
        }
        
    }
    
    @objc func cancelButtonClick() {
        
    }
    
    @objc func  configButtonClick() {
        
    }
   

}
extension DatePickerView: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        <#code#>
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        <#code#>
    }
    
    
}
