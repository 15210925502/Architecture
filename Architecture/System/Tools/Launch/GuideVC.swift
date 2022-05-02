//
//  GuideVC.swift
//  Architecture
//
//  Created by 华令冬 on 2020/7/7.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit

class GuideVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let launView = LaunchView.launch(withImages: ["launch1","launch2","launch3"])
        launView.isHiddenPageControl = true
        launView.guideBtnCustom { () -> UIButton in
            let guideBtn = UIButton.init(type: .custom)
            guideBtn.titleLabel?.font = UIFont.setFontSizeWithValue(17)
            guideBtn.setTitle("开始使用", for: .normal)
            guideBtn.theme_setTitleColor("FFFFFF", for: .normal)
            guideBtn.theme_backgroundColor = "E0514C"
            let left = BaseTools.adapted(value: 30);
            let height = BaseTools.adapted(value: 45);
            let bottom = BaseTools.adapted(value: 30);
            guideBtn.frame = CGRect(x: left, y: launView.heightValue - bottom - height, width: launView.widthValue - left * 2, height: height)
            guideBtn.ba_viewCornerRadius = guideBtn.heightValue / 2
            guideBtn.ba_viewRectCornerType = .bottomRightAndTopLeft
            guideBtn.addActionBlock { (button) in
                launView.hideGuidView();
            }
            return guideBtn
        }
        self.view.addSubview(launView)
    }
    
    deinit {
        print("对象已被释放")
    }
}
