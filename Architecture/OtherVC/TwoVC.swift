//
//  TwoVC.swift
//  Architecture
//
//  Created by HLD on 2022/1/12.
//

import UIKit

class TwoVC: BaseVC,HLDVCRightSlidePushDelegate {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(query: Dictionary<String, Any>?) {
        super.init(query: query)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title(title: "开启滑动并调用右滑方法")
        self.showNavRightButtonWithTitleStr("下一页")
        self.hld_rightSlidePushDelegate = self
    }
    
    override func responseRightButtonAction() {
        let vc = ThreeVC.init(query: nil)
        vc.hld_fullScreenPopDisabled = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // 这个代理系统不会自动回收，所以要做下处理
        self.hld_rightSlidePushDelegate = nil;
    }
    
    func rightSlidePushToNextViewController() {
        print("调用右滑方法")
    }
    
    deinit {
        print("TwoVC 对象已被释放")
    }

}
