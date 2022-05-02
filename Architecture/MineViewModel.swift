//
//  MineViewModel.swift
//  HnaIOUs
//
//  Created by HLD on 2020/5/25.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit

class MineViewModel: BaseTableViewViewModel {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseTools.adapted(value: 60)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell()
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
    
}
