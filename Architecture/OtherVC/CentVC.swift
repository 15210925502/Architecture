//
//  CentVC.swift
//  Architecture
//
//  Created by HLD on 2022/1/13.
//

import UIKit

class CentVC: BaseVC {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(query: Dictionary<String, Any>?) {
        super.init(query: query)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
    }
    
    
    deinit {
        print("CentVC 对象已被释放")
    }
}
