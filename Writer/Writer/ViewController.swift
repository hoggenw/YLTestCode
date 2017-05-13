//
//  ViewController.swift
//  Writer
//
//  Created by 王留根 on 2017/5/11.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let recog: IFlySpeechRecognizer = IFlySpeechRecognizer.sharedInstance();
    let textView: UITextView = UITextView()
    var textString: String = "";
    var pathName: String  = ""
    var endRecord: Bool = false;
    let startButton = UIButton(type: .custom)
    let shareButton = UIButton(type: .custom)
    var _scene = Int32(WXSceneSession.rawValue)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "test";
        initUI();
        config();
       
        
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initUI() {
        let width = (UIScreen.main.bounds.width - 100)/4
        
        startButton.frame = CGRect(x: 20, y: 74, width: width, height: 40)
        startButton.setTitle("开始识别", for: .normal);
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 13);
        startButton.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
        startButton.setTitleColor(UIColor.black, for: .normal)
        startButton.setBackgroundImage(UIImage.imageWith(color: UIColor.red), for: .selected)
        startButton.setBackgroundImage(UIImage.imageWith(color: UIColor.green), for: .normal)
        startButton.layer.cornerRadius = 4;
        startButton.clipsToBounds = true;
        self.view.addSubview(startButton)
        
        let endButton = UIButton(type: .custom)
        endButton.frame = CGRect(x: 40 + width, y: 74, width: width, height: 40)
        endButton.setTitle("结束识别", for: .normal);
        endButton.titleLabel?.font = UIFont.systemFont(ofSize: 13);
        endButton.addTarget(self, action: #selector(endButtonAction), for: .touchUpInside)
        endButton.setBackgroundImage(UIImage.imageWith(color: UIColor.green), for: .normal)
        endButton.setTitleColor(UIColor.black, for: .normal)
        endButton.layer.cornerRadius = 4;
        endButton.clipsToBounds = true;
        self.view.addSubview(endButton)
        
        
        let finishButton = UIButton(type: .custom)
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 13);
        finishButton.frame = CGRect(x: 60 + width * 2, y: 74, width: width, height: 40)
        finishButton.setTitle("生成文档", for: .normal);
        finishButton.addTarget(self, action: #selector(finishButtonAction), for: .touchUpInside)
        finishButton.setBackgroundImage(UIImage.imageWith(color: UIColor.green), for: .normal)
        finishButton.setTitleColor(UIColor.black, for: .normal)
        finishButton.layer.cornerRadius = 4;
        finishButton.clipsToBounds = true;
        self.view.addSubview(finishButton)
        
        shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 13);
        shareButton.frame = CGRect(x: 80 + width * 3, y: 74, width: width, height: 40)
        shareButton.setTitle("分享文档", for: .normal);
        shareButton.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)
        shareButton.setBackgroundImage(UIImage.imageWith(color: UIColor.green), for: .normal)
        shareButton.setBackgroundImage(UIImage.imageWith(color: UIColor.lightGray), for: .disabled)
        shareButton.setTitleColor(UIColor.black, for: .normal)
        shareButton.layer.cornerRadius = 4;
        shareButton.clipsToBounds = true;
        shareButton.isEnabled = false;
        self.view.addSubview(shareButton)
        
        let deleteButton = UIButton(type: .custom)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 13);
        deleteButton.frame = CGRect(x: UIScreen.main.bounds.width/2 - width, y: UIScreen.main.bounds.height - 30, width: width * 2, height: 30)
        deleteButton.setTitle("删除全部生成文档", for: .normal);
        deleteButton.addTarget(self, action: #selector(clearDeviceCacheSpace), for: .touchUpInside)
        deleteButton.setBackgroundImage(UIImage.imageWith(color: UIColor.green), for: .normal)
        deleteButton.setBackgroundImage(UIImage.imageWith(color: UIColor.lightGray), for: .disabled)
        deleteButton.setTitleColor(UIColor.black, for: .normal)
        deleteButton.layer.cornerRadius = 4;
        deleteButton.clipsToBounds = true;
        self.view.addSubview(deleteButton)
        
        
        textView.frame = CGRect(x: 2, y: 120, width: UIScreen.main.bounds.width - 4, height: UIScreen.main.bounds.height - 152)
        view.addSubview(textView)
        textView.textColor = UIColor.black;
        textView.backgroundColor = UIColor.green
    }
    
    func config() {
        IFlySpeechUtility.createUtility("appid=5913c3eb");
        recog.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN());
        recog.setParameter("16000", forKey: IFlySpeechConstant.sample_RATE())
        recog.setParameter("plain", forKey: IFlySpeechConstant.result_TYPE())
        recog.delegate = self;
    }
    
    func startButtonAction() {
        startButton.isSelected = true
        textString = "";
        recog.startListening();
    }
    
    func endButtonAction() {
        startButton.isSelected = false
        endRecord = true;
        recog.stopListening();
    }

    //创建txt文档
    func finishButtonAction() {
        shareButton.isEnabled = true;
        let fileManager:FileManager = FileManager.default;
        let directoryPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let date = Date();
        pathName = date.dateToString();
        textString = textView.text;
        let filePath: String = directoryPaths.first! +  "/" + pathName + ".txt";
        if !fileManager.fileExists(atPath: filePath) {
            fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        do {
            try textString.write(to: URL(fileURLWithPath: filePath), atomically: true, encoding: String.Encoding.utf8)
        } catch  {
            
        }
//        do {
//            let stringBack: String = try String(contentsOf: URL(fileURLWithPath: filePath), encoding:  String.Encoding.utf8);
//            print("stringBack = \(stringBack)")
//        } catch  {
//            
//        }
        
    }
    
    func shareButtonAction() {
        let message =  WXMediaMessage()
        message.title = "汪达令" + pathName;
        message.description = "这是王留根发来的一个测试"
        message.setThumbImage(UIImage(named:"beautiful.png"))
        
        let ext =  WXFileObject()
        ext.fileExtension = "txt"
        let directoryPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let filePath: String = directoryPaths.first! +  "/" + pathName + ".txt";
        let url = URL(fileURLWithPath: filePath)
        ext.fileData = try! Data(contentsOf: url)
        message.mediaObject = ext
        
        let req =  SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = _scene
        WXApi.send(req)
        
    }
    func clearDeviceCacheSpace() {
        
        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let fm = FileManager.default
        let paths = fm.subpaths(atPath: cachesPath)
        for filename in paths! {
            let path = cachesPath + "/" + filename
            if fm.fileExists(atPath: path) {
                do{
                    try fm.removeItem(atPath: path)
                    print("删除 \(path) ")
                }catch _{
                    print("删除 \(path) 失败")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: IFlySpeechRecognizerDelegate {
    
    func onError(_ errorCode: IFlySpeechError!) {
        
    }
    
    func onResults(_ results: [Any]!, isLast: Bool) {
        var resultStr: String = textView.text
        if let results = results, results.count > 0 {
            let resultDictionary: [String:String] = results.first as! [String : String]
            for key in resultDictionary.keys {
                resultStr += key
            }
            textView.text = resultStr;
        }
       
    }
    func onCancel() {
        
    }
    
    func onBeginOfSpeech() {
        print("========开始录音===========")
    }
    
    func onEndOfSpeech() {
        print("============结束录音==============")

    }
    
}



public extension Date{
    
    
    
    
    // 格式化输出时间  使用UTC时区表示时间  如：yyyy-MM-dd HH:mm:ss
    public func dateToString(with format: String? = "yyyy-MM-dd HH:mm", in timeZone: TimeZone? = TimeZone.current) -> String {
        
        let dateFormatter = DateFormatter()
        // 设置 格式化样式
        dateFormatter.dateFormat = format
        // 设置时区
        dateFormatter.timeZone = timeZone
        
        let strDate = dateFormatter.string(from: self)
        return strDate
        
    }
    
}


























