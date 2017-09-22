//
//  KeyboardVC.swift
//  YLTestCode
//
//  Created by 王留根 on 2017/9/22.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

class KeyboardVC: UIViewController {

    public var emojiCallBack: ((_ keyboardEmoji: KeyboardEmojiModel) -> Void)?
    public var emojiSend: (()->Void)?
    //
    private var collectionVeiw: UICollectionView = UICollectionView();
    
    
    public convenience init(callBack: ((_ keyboardEmoji: KeyboardEmojiModel) -> Void)) {
        self.init(nibName: nil, bundle: nil);
        
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
