//
//  HomeVC.swift
//  Architecture
//
//  Created by HLD on 2020/5/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit

class HomeVC: BaseTableViewVC, HLDTabBarDelegate {
    
    var isAddPrivacy : Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(query: Dictionary<String, Any>?) {
        super.init(query: query)
        self.canHeaderRereshing = true
        self.canFooterRereshing = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        /**
         便利数组的方法
         for (index, object) in array.enumerated(){}
        */
        
        self.navigationView.titleLabel.theme_textColor = "FFFFFF"
        self.navigationView.lineView.alpha = 0
        self.title(title: "航旅分期")
        self.navigationView.setNavigationBackgroundImage(UIImage.sd_image(withName: "home_nav_back"))
        
        (self.tabBarController as! HLDTabBarController).tabbar.hldDelegate = self
        
        self.tableView.theme_backgroundColor = "EF4035"
        self.addPrivacy()
        
        self.view.addSubview(self.topHeadBgView)
        self.view.sendSubview(toBack: self.topHeadBgView)
        weak var weakSelf = self
        self.dataViewModel.scrollViewDidScrollCallBlock = {(scrollView) in
            weakSelf?.scrollViewDidScroll(scrollView!)
        }
        
        self.dataViewModel.didSelectCallBlock = {(model,indexPath) in
            if indexPath?.row == 0{
                (self.tabBarController as! HLDTabBarController).setHLDTabBarHidden(true, animated: true)
            }else if indexPath?.row == 1{
                (self.tabBarController as! HLDTabBarController).setHLDTabBarHidden(false, animated: true)
            }else if indexPath?.row == 2{
                SDThemeManager.sharedInstance().changeTheme("White")
            }else if indexPath?.row == 3{
                SDThemeManager.sharedInstance().changeTheme("Black")
            }
        }
    }
    
    func tabbar(_ tabbar: HLDTabBar!, clickForCenter centerButton: HLDCenterTabBarButton!) {
        PlusAnimate.standardPublishAnimate(with: BaseTools.getKeyWindow())
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.mas_makeConstraints { (make) in
            make?.top.equalTo()(BaseTools.navBarAndStatusBarHeight)
            make?.left.right().equalTo()(0)
            make?.bottom.equalTo()(-BaseTools.tabBarHeight)
        }
    }
    
    /**
     方式一：
     监听tabeview的偏移量，修改tableview的下拉背景颜色
     self.tableView.addObserver(self, forKeyPath: "contentOffset", options: [.new,.old], context: nil)
     override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
     if keyPath == "contentOffset"{
     let newvalue : NSValue = change?[NSKeyValueChangeKey.newKey] as! NSValue
     let offset : CGPoint = newvalue.cgPointValue
     let newOffset_Y : CGFloat = offset.y
     
     self.topHeadBgView.frame = CGRect(x: 0, y: 0, width: BaseTools.screenWidth, height: -newOffset_Y)
     
     var rate = newOffset_Y / BaseTools.adapted(value: 50)
     if rate > 1 {
     rate = 1
     self.navigationView.titleLabel.textColor = UIColor.sd_color(withID: "444D54")
     }
     if rate <= 0 {
     rate = 0
     self.navigationView.titleLabel.textColor = UIColor.sd_color(withID: "FFFFFF")
     }
     self.navigationView.backgroundImageView.alpha = 1 - rate
     }
     }
     self.tableView.removeObserver(self, forKeyPath: "contentOffset")
     */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newOffset_Y = scrollView.contentOffset.y;
        self.topHeadBgView.frame = CGRect(x: 0, y: 0, width: BaseTools.screenWidth, height: -newOffset_Y)
        var rate = newOffset_Y / BaseTools.adapted(value: 50)
        if rate > 1 {
            rate = 1
            self.navigationView.titleLabel.theme_textColor = "444D54"
        }
        if rate <= 0 {
            rate = 0
            self.navigationView.titleLabel.theme_textColor = "FFFFFF"
        }
        self.navigationView.backgroundImageView.alpha = 1 - rate
    }
    
    private lazy var dataViewModel : HomeViewModel = {
        var dataViewModl : HomeViewModel = HomeViewModel.createViewModel(with: self.tableView)
        return dataViewModl
    }()
    
    func addPrivacy(){
        //先判断有没有同意隐私政策
        let privacy : String = UserDefaults.getUserDefaultsforKey("agreePrivacy") as! String
        if privacy.count <= 0 {
            self.isAddPrivacy = true
            //说明没有同意隐私政策,就要弹框显示
            var messageArray : Array<String> = Array()
            var colorArray : Array<String> = Array()
            
            let temp1 = "感谢您使用航旅分期！我们非常重视您的个人信息和隐私保护。为了更好的保护您的个人权利，在您使用我们的产品前，请您认真阅读"
            let temp2 = "《航旅分期隐私协议》"
            let temp3 = "《航旅分期服务协议》"
            let temp4 = "的全部内容，同意并接受全部条款后开始使用我们的产品和服务。我们会严格按照政策内容使用和保护您的个人信息，感谢您的信任。"
            messageArray.append(temp1)
            messageArray.append(temp2)
            messageArray.append(temp3)
            messageArray.append(temp4)
            
            colorArray.append("000000")
            colorArray.append("E0514C")
            colorArray.append("E0514C")
            colorArray.append("000000")
            let alertView = AlertView.presentShowTitleTwoButtonAttributedAlert("亲爱的航旅分期用户", messageArray, colorArray, [14],BaseTools.adapted(value: 3), "不同意", "同意", nil, {
                abort()
            }) {
                UserDefaults.save("agreePrivacy", forKey: "agreePrivacy")
                self.isAddPrivacy = false
                //                临时解决，首次安装app时，弹出选择使用网络时，请求数据失败的bug
//                if self.homeModle == nil{
//                    weak var weakSelf = self
//                    NetworkHelper.networkStatus { (status) in
//                        if status == .NetworkStatusUnknown ||
//                            status == .NetworkStatusNotReachable {
//                            //无网络链接
//                        } else {
//                            //网络链接成功
//                            weakSelf?.headerRereshing()
//                        }
//                    }
//                }
            }
            alertView.contentLabel.addTapTexts([temp2,temp3]) { (text, range) in

            }
        }
    }
    
    override func headerRequestRereshing() {
        self.endHeaderRefreshing()
    }
    
    lazy var topHeadBgView : UIView = {
        var topHeadBgView = UIView.init()
        topHeadBgView.theme_backgroundColor = "EF4035"
        return topHeadBgView
    }()
    
    deinit {
        print("对象已被释放")
    }
}
