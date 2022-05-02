//
//  TestViewModel.swift
//  Architecture
//
//  Created by HLD on 2022/1/10.
//

import UIKit

class TestViewModel: BaseTableViewViewModel {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BaseTools.adapted(value: 60)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell()
        return cell
    }
}
