//
//  HLDNavigationConfig.swift
//  Architecture
//
//  Created by HLD on 2020/5/21.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit

/**
 *  外观配置的单例对象
 */
//oc调用swift单利，在swift类的前面加上@objcMembers这个关键字，这样可以让该类的所有属性和方法加上@objc
@objcMembers
class HLDNavigationConfig: NSObject {
    /** 设置navgation标题颜色 */
    var navigationTitleColor : UIColor
    /** 按钮字体大小 */
    var navigationTitleFontSize : CGFloat
    /** 按钮未选中字体颜色 */
    var navigationButtonNormalTitleColor : UIColor;
    /** 按钮选中字体颜色 */
    var navigationButtonSelectedTitleColor : UIColor;
    /** 系统返回按钮图片更改 */
    var navigationBackButtonImage : String;
    /** 设置tabBar文字颜色 */
    var tabBarNormalTextColor : String
    /** 设置tabBar文字选中颜色 */
    var tabBarSelectedTextColor : String
    /** 设置tabBar字体大小 */
    var tabBarTitleFontSize : CGFloat
    /** tabBar背景颜色 */
    var tabBarBackgroundColor : String
    /** tabBar指定的初始化控制器 */
    var selectTabBarIndex : NSInteger = 0
    /** tabBar底部分割线的高度 */
    var tabBarBorderHeight : CGFloat
    /** tabBar的顶部分割线颜色 */
    var tabBarBordergColor : String
    
    //旋转按钮的下标，也是tag(设置哪个按钮可以旋转,第一个为0),默认-1没有旋转按钮
    var animationButtonIndex : NSInteger = 0
    //旋转动画图片名称
    var animationImageNameArray : NSArray
    
    private static let config = HLDNavigationConfig()
    class func sharedManage () -> HLDNavigationConfig {
        return config
    }
    
    private override init() {
        self.navigationTitleColor = UIColor.sd_color(withID: "444D54")
        self.navigationTitleFontSize = 14.0
        self.navigationButtonNormalTitleColor = UIColor.sd_color(withID: "585858")
        self.navigationButtonSelectedTitleColor = UIColor.sd_color(withID: "585858")
        self.navigationBackButtonImage = "Back"
            
        //指定的初始化控制器,默认选中第几个
        self.selectTabBarIndex = 0
                
        //bar底部分割线的高度
        self.tabBarBorderHeight = 2
        
        //tabBar背景颜色
        self.tabBarBackgroundColor = "FFFFFF"
        
        //设置tabBar文字颜色
        self.tabBarNormalTextColor = "848484"
        
        //设置tabBar文字选中颜色
        self.tabBarSelectedTextColor = "E0514C"
        
        //设置tabBar文字字体大小
        self.tabBarTitleFontSize = 12.0
                
        //bar的底部分割线颜色
        self.tabBarBordergColor = "DDDDDD"
        
        //图片格式大小要和tabbarItem的默认图片大小一致，不然动画后会有所改变
        self.animationImageNameArray = ["home_sel1","home_sel2","Home_Select"]
    }
}
