//
//  HomeViewModel.swift
//  Architecture
//
//  Created by HLD on 2022/1/14.
//

import UIKit

class HomeViewModel: BaseTableViewViewModel {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseTools.adapted(value: 60)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell()
        if indexPath.row == 0{
            cell.textLabel?.text = "隐藏tabBar"
        }else if indexPath.row == 1{
            cell.textLabel?.text = "显示tabBar"
        }else if indexPath.row == 2{
            cell.textLabel?.text = "修改主题为白色"
        }else if indexPath.row == 3{
            cell.textLabel?.text = "修改主题为黑色"
        }else{
            cell.textLabel?.text = String(indexPath.row)
        }
        return cell
    }

}
