//
//  FourVC.swift
//  Architecture
//
//  Created by HLD on 2022/1/12.
//

import UIKit

class FourVC: BaseVC {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(query: Dictionary<String, Any>?) {
        super.init(query: query)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title(title: "设置左滑区域")
        self.showNavRightButtonWithTitleStr("下一页")
    }
    
    override func responseRightButtonAction() {
        let vc = FiveVC.init(query: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        print("FourVC 对象已被释放")
    }

}
