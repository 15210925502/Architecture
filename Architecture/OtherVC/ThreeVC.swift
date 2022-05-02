//
//  ThreeVC.swift
//  Architecture
//
//  Created by HLD on 2022/1/12.
//

import UIKit

class ThreeVC: BaseVC {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(query: Dictionary<String, Any>?) {
        super.init(query: query)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title(title: "允许侧边滑动")
        self.showNavRightButtonWithTitleStr("下一页")
    }
    
    override func responseRightButtonAction() {
        let vc = FourVC.init(query: nil)
        vc.hld_popMaxAllowedDistanceToLeftEdge = 200.0;
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        print("ThreeVC 对象已被释放")
    }

}
