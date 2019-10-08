//
//  DatePickerView.swift
//  YLSwiftTest
//
//  Created by 王留根 on 2019/9/27.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

import UIKit


protocol DatePickerViewDelegate : NSObjectProtocol  {
    func didClickFinishDateTimePickerView(date:String) ;
    func didClickCancelDateTimePickerView() ;
    func cancelDateTimePickerView() ;
}


class DatePickerView: UIView {

    private var yearRange: NSInteger
    private var dayRange: NSInteger;
    private var startYear: NSInteger;
    private var selectedYear: NSInteger;
    private var selectedMonth: NSInteger;
    private var selectedDay: NSInteger;
    private var selectedHour: NSInteger;
    private var selectedMinute: NSInteger;
    private var resultString = "";
   // private var selectedSecond: NSInteger;
//    private var calendar:Calendar;
    //左边退出按钮
    private lazy var cancelButton:UIButton = {
        return DatePickerView.creatButton(frame: CGRect.init(x: 12, y: 0, width: 40, height: 40), title: "取消", backColor: UIColor.clear, fontSize: 15, titleColor: UIColor.init(hex: 0x0d8bf5));
    }()
    //右边的确定按钮
    private lazy var  chooseButton:UIButton = {
        return DatePickerView.creatButton(frame: CGRect.init(x: 12, y: 0, width: 40, height: 40), title: "取消", backColor: UIColor.clear, fontSize: 15, titleColor: UIColor.init(hex: 0x0d8bf5))
        
    }()
    
    private lazy var pickerView:UIPickerView = {
        return UIPickerView.init(frame: CGRect.init(x: 0, y: 40, width: ScreenWidth, height: 220));
    }()
    var backString: String?;
    private lazy var contentV:UIView = {
        return UIView.init(frame: CGRect.init(x: 0, y: ScreenHeight, width: ScreenWidth, height: 220));
    }()
    
    private lazy var titleL:UILabel = {
        return UILabel.init(frame: CGRect.init(x: 52, y: 0, width: ScreenWidth-104, height: 40));
    }()
    
    
    public  weak var delegate: DatePickerViewDelegate?
    
    override init(frame: CGRect) {
        
        let calendar = Calendar.init(identifier: .gregorian);
        var comps = DateComponents();
        comps = calendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day,Calendar.Component.hour,Calendar.Component.minute], from: Date.init());
        let year = comps.year!;
        startYear = year  - 20;
        self.yearRange = 30;
        selectedYear = year;
        selectedMonth = comps.month!;
        selectedDay = comps.day!;
        selectedHour = comps.hour!;
        selectedMinute = comps.minute!;
        dayRange = 0;
        super.init(frame: frame);
        dayRange = isAllDay(year: selectedYear, month:  selectedMonth);
        self.backgroundColor = UIColor.init(R: 0 as UInt8, G: 0 as UInt8, B: 0 as UInt8, A: 0.5 as CGFloat);
        self.alpha = 0;
        self.contentV.backgroundColor = UIColor.white;
        self.addSubview(contentV);
        
        self.pickerView.backgroundColor = .white;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.contentV.addSubview(self.pickerView)
        
        let upVeiw = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 40));
        upVeiw.backgroundColor = .white;
        self.contentV.addSubview(upVeiw);
        
        self.cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside);
        upVeiw.addSubview(cancelButton);
        self.chooseButton.addTarget(self, action: #selector(configButtonClick), for: .touchUpInside);
        upVeiw.addSubview(chooseButton);
        
        self.titleL.textColor = UIColor.init(hex: 0x3f4548);
        titleL.font = UIFont.systemFont(ofSize: 13);
        titleL.textAlignment = .center;
        upVeiw.addSubview(self.titleL);
        
        upVeiw.addLineWithSide(.inBottom, color: UIColor.init(hex: 0xe6e6e6), thickness: 0.5, margin1: 0, margin2: 0);
        
      
      
        
        self.pickerView.selectRow(year-startYear, inComponent: 0, animated: false);
        self.pickerView.selectRow(selectedMonth - 1, inComponent: 1, animated: false);
        self.pickerView.selectRow(selectedDay - 1, inComponent: 2, animated: false);
        self.pickerView.selectRow(selectedHour, inComponent: 3, animated: false);
        self.pickerView.selectRow(selectedMinute, inComponent: 4, animated: false);
        self.pickerView.reloadAllComponents();
        resultString = String(format: "%ld-%.2ld-%.2ld %.2ld:%.2ld", selectedYear,selectedMonth,selectedDay,selectedHour,selectedMinute);
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCurrentDate(currentDate: Date) {
        let calendar = Calendar.init(identifier: .gregorian);
        var comps = DateComponents();
        comps = calendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day,Calendar.Component.hour,Calendar.Component.minute], from: Date.init());
        let year = comps.year!;
        startYear = year  - 20;
        self.yearRange = 30;
        selectedYear = year;
        selectedMonth = comps.month!;
        selectedDay = comps.day!;
        selectedHour = comps.hour!;
        selectedMinute = comps.minute!;
        
        dayRange = isAllDay(year: selectedYear, month:  selectedMonth);
        
        self.pickerView.selectRow(year-startYear, inComponent: 0, animated: false);
        self.pickerView.selectRow(selectedMonth - 1, inComponent: 1, animated: false);
        self.pickerView.selectRow(selectedDay - 1, inComponent: 2, animated: false);
        self.pickerView.selectRow(selectedHour, inComponent: 3, animated: false);
        self.pickerView.selectRow(selectedMinute, inComponent: 4, animated: false);
        
       
        
//        pickerView(self.pickerView, didSelectRow: year-startYear, inComponent: 0);
//        pickerView(self.pickerView, didSelectRow: selectedMonth - 1, inComponent: 1);
//        pickerView(self.pickerView, didSelectRow: selectedDay - 1, inComponent: 2);
//        pickerView(self.pickerView, didSelectRow: selectedHour, inComponent: 3);
//        pickerView(self.pickerView, didSelectRow: selectedMinute, inComponent: 4);
        self.pickerView.reloadAllComponents();
        resultString = String(format: "%ld-%.2ld-%.2ld %.2ld:%.2ld", selectedYear,selectedMonth,selectedDay,selectedHour,selectedMinute);

    }
    
    func isAllDay(year:Int,month:Int) -> Int {
        var day:Int = 0;
        switch month {
        case 1:
            fallthrough;
        case 3:
            fallthrough;
        case 5:
            fallthrough;
        case 7:
            fallthrough;
        case 8:
            fallthrough;
        case 10:
            fallthrough;
        case 12:
            day = 31;
        case 4:
            fallthrough;
        case 6:
            fallthrough;
        case 9:
            fallthrough;
        case 11:
            day = 31;
            
        case 2:
            if ( (year%4 == 0 && year%100 != 0) || (year%400) == 0){
                day = 29;
            }else {
                day = 28;
            }
        default:
            break;
        }
        return day;
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
        return button;
        
    }
    
    public func showDateTimePickerView() {
        setCurrentDate(currentDate: Date.init());
        self.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight);
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1;
            self.contentV.frame = CGRect.init(x: 0, y: ScreenWidth - 260, width: ScreenWidth, height: 260);
        }) { (success) in
            
        }
       
    }
    public func hideDateTimePickerView() {
        
        if let delegate = self.delegate, delegate.responds(to: Selector.init(("cancelDateTimePickerView"))) {
            self.delegate?.cancelDateTimePickerView();
        }
      
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0;
            self.contentV.frame = CGRect.init(x: 0, y: ScreenHeight, width: ScreenWidth, height: 260);
        }) { (success) in
              self.frame = CGRect.init(x: 0, y: ScreenHeight, width: ScreenWidth, height: ScreenHeight);
        }
    }
        
    
    @objc func cancelButtonClick() {
        if let delegate = self.delegate, delegate.responds(to: Selector.init(("didClickCancelDateTimePickerView"))) {
            self.delegate?.didClickCancelDateTimePickerView();
        }
        hideDateTimePickerView();
    }
    
    @objc func  configButtonClick() {
        if let delegate = self.delegate, delegate.responds(to: Selector.init(("didClickFinishDateTimePickerView:"))) {
            self.delegate?.didClickFinishDateTimePickerView(date: resultString);
        }
        hideDateTimePickerView();
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideDateTimePickerView();
    }
   

}
extension DatePickerView: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return yearRange;
        case 1:
            return 12;
        case 2:
            return dayRange;
        case 3:
            return 24;
        case 4:
            return 60;
        default:
            return 0;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel.init(frame: CGRect.init(x: ScreenWidth * CGFloat(component) / 6.0, y: 0, width: ScreenWidth/6.0, height: 30))
        label.font = UIFont.systemFont(ofSize: 15);
        label.tag = component*100 + row;
        label.textAlignment = .center;
        switch component {
        case 0:
            label.text = String(format: "%ld年", startYear + row);
        case 1:
            label.text = String(format: "%ld月",   row + 1);
        case 2:
            label.text = String(format: "%ld日",   row + 1);
        case 3:
            label.textAlignment = .right;
            label.text = String(format: "%ld时",   row);
        case 4:
            label.textAlignment = .right;
            label.text = String(format: "%ld分",   row);
        case 5:
            label.textAlignment = .right;
            label.text = String(format: "%ld秒",   row);
        default:
            label.text = "";
        }
        
        return label;
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return (ScreenWidth - 40 )/5.0;
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let calendar = Calendar.init(identifier: .gregorian);
        var comps = DateComponents();
        comps = calendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day,Calendar.Component.hour,Calendar.Component.minute], from: Date.init());
        
        let year = comps.year!;
        let month = comps.month!;
        let day = comps.day!;
        let hour = comps.hour!;
        let minute = comps.minute!;
        
        switch component {
        case 0:
            selectedYear = startYear + row;
            if (selectedYear >= year){
                selectedYear = year;
                self.pickerView.selectRow(year - startYear, inComponent: 0, animated: true);
                if selectedMonth > month {
                    selectedMonth = month;
                    self.pickerView.selectRow(month - 1 , inComponent: 1, animated: true);
                }
                if (selectedMonth == month && selectedDay > day) {
                    selectedDay = day;
                    self.pickerView.selectRow(day - 1 , inComponent: 2, animated: true);
                }
                if (selectedMonth == month && selectedDay == day && selectedHour > hour) {
                    selectedHour = hour;
                    self.pickerView.selectRow(hour , inComponent: 3, animated: true);
                }
                if (selectedMonth == month && selectedDay == day && selectedHour == hour && selectedMinute > minute) {
                    selectedMinute = minute;
                    self.pickerView.selectRow(minute , inComponent: 4, animated: true);
                }
                dayRange = isAllDay(year: selectedYear, month: selectedMonth);
                self.pickerView .reloadComponent(2);
            }
            
        case 1:
            selectedMonth = row + 1 ;
            if (selectedYear == year && selectedMonth >= month) {
                selectedMonth = month;
                   self.pickerView.selectRow(month - 1 , inComponent: 1, animated: true);
                if (selectedDay > day) {
                    selectedDay = day;
                      self.pickerView.selectRow(day - 1 , inComponent: 2, animated: true);
                }
                if (selectedDay == day && selectedHour > hour) {
                    selectedHour = hour;
                   self.pickerView.selectRow(hour , inComponent: 3, animated: true);
                }
                if (selectedDay == day && selectedHour == hour && selectedMinute > minute) {
                    selectedMinute = minute;
                    self.pickerView.selectRow(minute , inComponent: 4, animated: true);
                }
            }
            dayRange = isAllDay(year: selectedYear, month: selectedMonth);
            self.pickerView .reloadComponent(2);
           
        case 2:
            selectedDay = row + 1 ;
            if (selectedYear == year && selectedMonth == month && selectedDay >= day) {
                selectedDay = day;
                self.pickerView.selectRow(day - 1 , inComponent: 2, animated: true);
                if (selectedHour > hour) {
                    selectedHour = hour;
                    self.pickerView.selectRow(hour , inComponent: 3, animated: true);
                }
                if (selectedHour == hour && selectedMinute > minute) {
                    selectedMinute = minute;
                    self.pickerView.selectRow(minute , inComponent: 4, animated: true);
                }
            }
           
        case 3:
            selectedHour = row;
            if (selectedYear == year && selectedMonth == month && selectedDay == day && selectedHour >= hour) {
                selectedHour = hour;
                self.pickerView.selectRow(hour , inComponent: 3, animated: true);
                if (selectedMinute > minute) {
                    selectedMinute = minute;
                   self.pickerView.selectRow(minute , inComponent: 4, animated: true);
                }
            }
           
        case 4:
            selectedMinute=row;
            if (selectedYear == year && selectedMonth == month && selectedDay == day && selectedHour == hour && selectedMinute > minute) {
                selectedMinute = minute;
                 self.pickerView.selectRow(minute , inComponent: 4, animated: true);
            }
            
        default:
            break;
           
        }
        resultString = String(format: "%ld-%.2ld-%.2ld %.2ld:%.2ld", selectedYear,selectedMonth,selectedDay,selectedHour,selectedMinute);
    }
    
    
    
    
}
