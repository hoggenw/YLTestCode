//
//  MusicListViewModel.swift
//  YLSwiftTest
//
//  Created by 王留根 on 2019/9/16.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//歌曲列表数据源
struct MusicListViewModel {
//    let data = [
//        Music(name: "我就是你", singer: "未来"),
//        Music(name: "无条件", singer: "陈奕迅"),
//        Music(name: "你曾是少年", singer: "S.H.E"),
//        Music(name: "从前的我", singer: "陈洁仪"),
//        Music(name: "在木星", singer: "朴树"),
//    ];
/**
     这里我们将 data 属性变成一个可观察序列对象（Observable Squence），而对象当中的内容和我们之前在数组当中所包含的内容是完全一样的。
     */
    var data = Observable.just([
        Music(name: "Label", singer: "未来"),
        Music(name: "UITextField", singer: "陈奕迅"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "从前的我", singer: "陈洁仪"),
        Music(name: "在木星", singer: "朴树"),
        ]) ;
    
    let userName =  BehaviorRelay.init(value: "gust");
    
    lazy var info = {return self.userName.asObservable()
        .map{($0 == "hoggen") ? "您是管理员" : "您是普通访客"}
        .share(replay:1)
    }()
    
}
