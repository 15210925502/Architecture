//
//  ScrollView1.swift
//  Architecture
//
//  Created by HLD on 2022/1/12.
//

import UIKit

class ScrollView1: BaseVC {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(query: Dictionary<String, Any>?) {
        super.init(query: query)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationView.isHidden = true
        self.view.backgroundColor = UIColor.orange
    }
    
    deinit {
        print("ScrollView1 对象已被释放")
    }

}
