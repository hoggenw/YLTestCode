//
//  ViewController.swift
//  YLSwiftTest
//
//  Created by 王留根 on 2019/9/11.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {
    
    var tableView = UITableView();
    
    let musicListViewModel = MusicListViewModel();
    
    let disposeBag  = DisposeBag();
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green;
        self.view.addSubview(tableView);
       // tableView.register(ShowInfoTableViewCell.self, forCellReuseIdentifier: "ShowInfoTableViewCell");
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.view);
            maker.top.equalTo(self.view).offset(kNavigationHeight)
        }
//        musicListViewModel.data
//            .bind(to: tableView.rx.items(cellIdentifier: "ShowInfoTableViewCell", cellType: ShowInfoTableViewCell.self)){_,music,cell in
//            cell.textLabel?.text = music.name
//            cell.detailTextLabel?.text = music.singer
//            }.disposed(by: disposeBag);
        musicListViewModel.data
            .bind(to: tableView.rx.items){(tableView, row, element)  in
                let cell = ShowInfoTableViewCell.cellInTableView(tableView: tableView);
                cell.textLabel?.text = element.name;
                cell.detailTextLabel?.text = element.singer;
                return cell;
            }.disposed(by: disposeBag)
        tableView.rx.modelSelected(Music.self).subscribe(onNext: {[weak self] (music) in
            switch music.name {
            case "Label":
                self?.navigationController?.pushViewController(UILabelViewController(), animated: true);
            case "UITextField":
                self?.navigationController?.pushViewController(UITextFieldViewController(), animated: true);
            default: break
                
            }
        
        }).disposed(by: disposeBag);
//        tableView.dataSource = self;
//        tableView.delegate = self
        // Do any additional setup after loading the view.
    }


}

//extension ViewController : UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return musicListViewModel.data.count;
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = ShowInfoTableViewCell.cellInTableView(tableView: tableView);
//        let music = musicListViewModel.data[indexPath.row];
//        cell.textLabel?.text = music.name;
//        cell.detailTextLabel?.text = music.singer;
//        return cell;
//
//    }
//
//
//}
//
//
//extension ViewController : UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("你选中的歌曲信息【\(musicListViewModel.data[indexPath.row])】");
//    }
//}


/*
 *DisposeBag：作用是 Rx 在视图控制器或者其持有者将要销毁的时候，自动释法掉绑定在它上面的资源。它是通过类似“订阅处置机制”方式实现（类似于 NotificationCenter 的 removeObserver）。
 rx.items(cellIdentifier:）:这是 Rx 基于 cellForRowAt 数据源方法的一个封装。传统方式中我们还要有个 numberOfRowsInSection 方法，使用 Rx 后就不再需要了（Rx 已经帮我们完成了相关工作）。
 rx.modelSelected： 这是 Rx 基于 UITableView委托回调方法 didSelectRowAt 的一个封装。
 */

