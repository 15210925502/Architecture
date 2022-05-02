//
//  BaseVC.swift
//  Architecture
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    var navRightButton : UIButton?
    var navLeftButton : UIButton?
    var contentViewTopConstraint : MASConstraint?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //    重载父类的init()
    @objc init(query : Dictionary<String, Any>?){
        super.init(nibName: nil, bundle: nil)
    }
    
    //设置导航标题
    func title(title : String) {
        self.navigationView.setTitle(title)
    }
    //    显示导航左边按钮，按钮显示默认图片
    func showNavLeftButton(){
        if (self.navLeftButton != nil) {
            self.navLeftButton?.isHidden = false
        }else{
            self.navLeftButton = self.navigationView?.addLeftButton(with: UIImage.sd_image(withName: HLDNavigationConfig.sharedManage().navigationBackButtonImage), clickCallBack: { (view) in
                self.responseLeftButtonAction()
            })
            self.navLeftButton?.adjustsImageWhenHighlighted = false
        }
    }
    //    隐藏导航左边自定义按钮
    func hiddenNavLeftButton(){
        self.navLeftButton?.isHidden = true
    }
    //    移除导航左边自定义按钮
    func removeNavLeftButton() {
        self.navigationView.removeLeftView(self.navLeftButton)
    }
    //    移除导航左边所有按钮
    func removeNavLeftAllButton() {
        self.navigationView.removeAllLeftButton()
    }
    //    显示导航右边自定义按钮，按钮显示默认图片
    func showNavRightButton(){
        if (self.navRightButton != nil) {
            self.navRightButton?.isHidden = false
        }else{
            self.showNavRightButtonWithBackImageStr("close")
        }
    }
    //    隐藏导航右边自定义按钮
    func hiddenNavRightButton(){
        self.navRightButton?.isHidden = true
    }
    //    显示导航右边自定义按钮，按钮显示自定义图片
    func showNavRightButtonWithBackImageStr(_ backImageStr : String) {
        weak var weakSelf = self
        self.navRightButton = self.navigationView.addRightButton(with: UIImage.sd_image(withName: backImageStr)) { (view) in
            weakSelf?.responseRightButtonAction()
        }
        self.navRightButton?.adjustsImageWhenHighlighted = false
    }
    //    显示导航右边自定义按钮，按钮显示自定义文字
    func showNavRightButtonWithTitleStr(_ title : String) {
        weak var weakSelf = self
        self.navRightButton = self.navigationView.addRightButton(withTitle: title, clickCallBack: { (view) in
            weakSelf?.responseRightButtonAction()
        })
        self.navRightButton?.adjustsImageWhenHighlighted = false
    }
    //    移除导航右边自定义按钮
    func removeNavRightButton() {
        self.navigationView.removeRightView(self.navRightButton)
    }
    //    移除导航右边所有按钮
    func removeNavRightAllButton() {
        self.navigationView.removeAllRightButton()
    }
    //    点击导航右边自定义按钮触发事件
    func responseRightButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    //    点击导航左边自定义按钮触发事件
    func responseLeftButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    //    点击导航左边系统按钮触发事件
    @objc func responseSysLeftButtonAction() {
          self.navigationController?.popViewController(animated: true)
      }
    
//    隐藏底部Home Bar    返回true隐藏，返回false显示
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.theme_backgroundColor = "FFFFFF"
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
//        重写系统返回按钮的点击事件
        if self.navigationView.navigationBackButton != nil {
            weak var weakSelf = self
            self.navigationView.navigationBackButtonCallback = { (alert) in
                if ((weakSelf?.responds(to: #selector(BaseVC.responseSysLeftButtonAction))) != nil){
                    weakSelf?.responseSysLeftButtonAction()
                }
            }
        }
    }
    
    //判断是否登录，没有登录就跳转到登录页面
    func checkLogin() -> Bool {
        if (UserManager.shared()?.isLogin())!{
            return true
        }else{
//            let backVCName : String = NSStringFromClass(self.classForCoder)
//            let loginVC = LoginVC.init(query: ["BackVCName":backVCName])
//            self.navigationController?.pushViewController(loginVC, animated: true)
            return false
        }
    }
    
    //点击空白处, 回收键盘
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    deinit {
        print("BaseVC 对象已被释放")
    }
}
