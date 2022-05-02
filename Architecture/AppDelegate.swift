//
//  AppDelegate.swift
//  Architecture
//
//  Created by HLD on 2021/12/31.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,JPUSHRegisterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
              
//        一定要在其他SDK之前调用
        //        [LSSafeProtector openSafeProtectorWithIsDebug]
        //注意线上环境isDebug一定要设置为NO)
        LSSafeProtector.open(withIsDebug: ConfigurationFile.isDebug) { (exception, crashType) in
            print(exception ?? "")
        }
        //打开KVO添加，移除的日志信息
        LSSafeProtector.setLogEnable(ConfigurationFile.isDebug)
        
//        开启网络监听
        NetworkHelper.sharedManager()
        
//        极光推送
        self.addNPNs(launchOptions)

        let themeManager : SDThemeManager = SDThemeManager.sharedInstance()
        themeManager.setupThemeNameArray(["White", "Black"])
        if ((themeManager.currentTheme) != nil) {
            themeManager.changeTheme(themeManager.currentTheme)
        }else{
            themeManager.changeTheme("White")
        }
        
        let guideVC : GuideVC = GuideVC()
        self.window?.theme_backgroundColor = "FFFFFF"
        self.window?.rootViewController = guideVC;
        
        self.window?.makeKeyAndVisible();
        return true
    }
    
//    初始化极光推送
    func addNPNs(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        
    //        初始化 APNs
            let entity = JPUSHRegisterEntity()
            if #available(iOS 12.0, *) {
                entity.types = Int(JPAuthorizationOptions.alert.rawValue |
                                    JPAuthorizationOptions.badge.rawValue |
                                    JPAuthorizationOptions.sound.rawValue |
                                    JPAuthorizationOptions.providesAppNotificationSettings.rawValue)
            } else {
                entity.types = Int(JPAuthorizationOptions.alert.rawValue |
                                    JPAuthorizationOptions.badge.rawValue |
                                    JPAuthorizationOptions.sound.rawValue)
            }
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
            
    //        初始化 JPush
    //        isProduction : 是否生产环境. 如果为开发状态,设置为 false; 如果为生产状态,应改为 true.
            JPUSHService.setup(withOption: launchOptions, appKey: ConfigurationFile.appKey, channel: ConfigurationFile.channel, apsForProduction: ConfigurationFile.isProduction, advertisingIdentifier: nil)
        
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            if resCode == 0{
                print("你手机的registrationID = = = \(String(describing: registrationID))");
            }
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        /**
        说明：当程序从后台将要重新回到前台时候调用
        */
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        /**
        说明：当应用程序进入活动状态时执行
        */
//        解决还款模块在二级页面时进入后台，在进入活跃状态tabBar部分不显示的问题
        NotificationCenter.default.post(name: NSNotification.Name("applicationDidBecomeActive"), object: nil)
        UIApplication.shared.applicationIconBadgeNumber = 0
        JPUSHService.setBadge(0)
    }
    func applicationWillResignActive(_ application: UIApplication) {
        /** 在应用程序将要由活动状态切换到非活动状态时候，要执行的委托调用，如 按下 home 按钮，返回主屏幕，或全屏之间切换应用程序等。
        说明：当应用程序将要进入非活动状态时执行，在此期间，应用程序不接收消息或事件，比如来电话了。
        */
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        /**
        说明：当程序被推送到后台的时候调用。所以要设置后台继续运行，则在这个函数里面设置即可
        */
    }
    
//    实现注册 APNs 失败接口
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /// Required - 注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
//    推送代理方法
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfor = notification.request.content.userInfo
        print(userInfor)
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfor = response.notification.request.content.userInfo
        print(userInfor)
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        
    }
    
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
        
    }
}


