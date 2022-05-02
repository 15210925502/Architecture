//
//  BaseTools.swift
//  Architecture
//
//  Created by HLD on 2020/5/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit

@objcMembers
class BaseTools: NSObject {
    //获取屏幕宽度和高度
    public static let screenWidth = (UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown) ? UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.height
    public static let screenHeight = (UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown) ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width
    
//    字符串转float类型
//    let version : String = UIDevice.current.systemVersion
//    print(version.stringToFloat())
//    print(version._bridgeToObjectiveC().floatValue)
//    print(CFStringGetDoubleValue(version as CFString))
    
    //比率
    public static let screenRatio = Float(screenWidth / 375.0)
    //宽和高
    public static func adapted(value:CGFloat) -> CGFloat{
//        ceilf()：方法为四舍五入,例如：ceilf(6.7) = 7
        return CGFloat(Float(value) * BaseTools.screenRatio)
    }
    //判断是否为iphoneX以上机型，或者是否为刘海屏
    public static func isIPhoneXSeries() -> Bool{
        var iPhoneXSeries = false
//        判断是不是手机
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            if #available(iOS 11.0, *) {
                let keyWinwow = BaseTools.getKeyWindow()
                if let window = keyWinwow {
                    iPhoneXSeries = window.safeAreaInsets.bottom > 0 ? true : false
                }
            }
        }
        return iPhoneXSeries
    }
//    获取window
    public static func getKeyWindow() -> UIWindow? {
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        }
        if window == nil {
            window = UIApplication.shared.windows.first { $0.isKeyWindow }
            if window == nil {
                window = UIApplication.shared.keyWindow
            }
        }
        return window
    }
    /*状态栏高度*/
    public static let statusBarHeight = CGFloat(UIApplication.shared.statusBarFrame.size.height)
    /*导航栏高度*/
    public static let navBarHeight = CGFloat(44.0)
    /*状态栏和导航栏总高度*/
    public static let navBarAndStatusBarHeight = CGFloat(statusBarHeight + navBarHeight)
    //tabar高度
    public static let tabBarHeight = CGFloat(BaseTools.isIPhoneXSeries() ? 83.0 : 49.0)
    /*导航条和Tabbar总高度*/
    public static let navAndTabHeight = CGFloat(navBarAndStatusBarHeight + tabBarHeight)
    /*iPhoneX的状态栏高度差值，就是iphoneX之前和之后状态栏高度差*/
    public static let topBarDifHeight = CGFloat(BaseTools.isIPhoneXSeries() ? 24.0 : 0)
    /*顶部安全区域远离高度，就是iphoneX之前和之后顶部高度差*/
    public static let topBarSafeHeight = CGFloat(BaseTools.isIPhoneXSeries() ? 44.0 : 0)
    /*底部安全区域远离高度,就是iphoneX之前和之后Tabbar高度差*/
    public static let bottomSafeHeight = CGFloat(BaseTools.isIPhoneXSeries() ? 34.0 : 0)

    // MARK: 系统相关
    /// Info
    public static let appBundleInfoVersion = Bundle.main.infoDictionary ?? Dictionary()
    /// plist:  AppStore 使用VersionCode 1.0.1
    public static let appBundleVersion = (appBundleInfoVersion["CFBundleShortVersionString" as String] as? String ) ?? ""
    public static let appBundleBuild = (appBundleInfoVersion["CFBundleVersion"] as? String ) ?? ""
    //app 名字
    public static let appDisplayName = (appBundleInfoVersion["CFBundleDisplayName"] as? String ) ?? ""
    
    //判断字符串不为空 如果为空返回true，否则返回flase
    //value 是AnyObject类型是因为有可能所传的值不是String类型，有可能是其他任意的类型。
    public static func isNullOrEmptyOfNSString(value: AnyObject?) -> Bool {
        //首先判断是否为nil
        if (nil == value) {
            //对象是nil，直接认为是空串
            return true
        }else{
            //然后是否可以转化为String
            if let myValue  = value as? String{
                let set = NSCharacterSet.whitespacesAndNewlines
                let trimedString = myValue.trimmingCharacters(in: set)
                //然后对String做判断
                return trimedString.isEmpty || trimedString == "" || trimedString == "(null)"
            }else{
                //字符串都不是，直接认为是空串
                return true
            }
        }
    }
    
    //    生成随机数
    public static func randomCustom(min: Int, max: Int) -> Int {
        let random = arc4random() % UInt32(max) + UInt32(min)
        return Int(random)
    }
}
