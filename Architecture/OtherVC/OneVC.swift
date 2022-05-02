//
//  OneVC.swift
//  Architecture
//
//  Created by HLD on 2022/1/12.
//

import UIKit

class OneVC: BaseVC {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(query: Dictionary<String, Any>?) {
        super.init(query: query)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title(title: "禁止全屏滑动")
        self.showNavRightButtonWithTitleStr("下一页")
    }
    
    override func responseRightButtonAction() {
        let vc = TwoVC.init(query: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        print("OneVC 对象已被释放")
    }

}
