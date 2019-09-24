//
//  ShowInfoTableViewCell.swift
//  YLSwiftTest
//
//  Created by 王留根 on 2019/9/16.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

import UIKit

class ShowInfoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public  static func cellInTableView(tableView :UITableView) ->ShowInfoTableViewCell {
        let identifier = "ShowInfoTableViewCell";
        var cell:ShowInfoTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? ShowInfoTableViewCell;
        
        guard let _ = cell  else {
            cell = ShowInfoTableViewCell();
            return cell!;
        }
        
        return cell!;
        
    }
}
