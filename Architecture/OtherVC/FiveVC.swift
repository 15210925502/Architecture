//
//  FiveVC.swift
//  Architecture
//
//  Created by HLD on 2022/1/12.
//

import UIKit

class FiveVC: BaseVC,HLDVCRightSlidePushDelegate {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(query: Dictionary<String, Any>?) {
        super.init(query: query)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationView.isHidden = true
        self.hld_rightSlidePushDelegate = self
        
        self.scrollView.frame = self.view.bounds
        self.view.addSubview(self.scrollView)
        
        let childVC = [self.searchVC, self.playerVC,self.playerVC1]
        
        let w = self.view.frame.size.width
        let h = self.view.frame.size.height
        
//        数组遍历，遍历数组
        for (idx, vc) in childVC.enumerated() {
            self.addChildViewController(vc)
            self.scrollView.addSubview(vc.view)
            vc.view.frame = CGRect(x: CGFloat(idx) * w, y: 0, width: w, height: h)
        }
        self.scrollView.contentSize = CGSize(width: CGFloat(childVC.count) * w, height: 0)
        
        // 默认显示播放器页
        self.scrollView.contentOffset = CGPoint(x: w, y: 0)
    }

    override func viewDidDisappear(_ animated: Bool) {
        // 这个代理系统不会自动回收，所以要做下处理
        self.hld_rightSlidePushDelegate = nil;
    }

    func rightSlidePushToNextViewController() {
        print("调用右滑方法")
    }
    
    lazy var scrollView : UIScrollView = {
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.hld_leftGestureEnable = true
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return scrollView
    }()
    
    lazy var searchVC : ScrollView1 = {
        searchVC = ScrollView1.init(query: nil)
        return searchVC
    }()
    
    lazy var playerVC : ScrollView2 = {
        playerVC = ScrollView2.init(query: nil)
        return playerVC
    }()
    
    lazy var playerVC1 : ScrollView3 = {
        playerVC1 = ScrollView3.init(query: nil)
        return playerVC1
    }()
    
    deinit {
        print("FiveVC 对象已被释放")
    }

}
