//
//  UIViewController+RegexCategory.swift
//
//  Created by HLD on 2020/5/27.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /**
     返回到指定的控制器
     
     @param vcName 要返回的控制器的名字
     @param animaed 是否有动画
     */
    @objc func customBackItemClicked(_ vcName: String,_ animated: Bool) {
        if self.navigationController?.viewControllers.count ?? 0 > 0 {
            for VC in (self.navigationController?.viewControllers)! {
                //  swift4中通过字符串名转化成类，需要在字符串名前加上项目的名称
                //这是获取项目的名称，
                let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String
                var className = clsName! + "."
                if vcName.contains(className) {
                    className = vcName
                }else{
                    className = className + vcName
                }
                
                //这里需要指定类的类型XX.Type
                let viewC = NSClassFromString(className)!as! UIViewController.Type
                if VC.isKind(of: viewC) {
                    self.navigationController?.popToViewController(VC, animated: animated)
                    return
                }
            }
        }
    }
    
    ///    返回根控制器后并添加新控制器
    func backRootAddNewVC(_ newVC : UIViewController){
        self.navigationController?.pushViewController(newVC, animated: true)
        
        var navigationArray : Array<UIViewController> = self.navigationController!.viewControllers
        
        //        反向便利数组
        for vc in navigationArray.reversed(){
            if vc != navigationArray.first && vc != navigationArray.last {
                navigationArray.remove(at: navigationArray.index(of: vc)!)
            }
        }
        
        // 移除指定下标数据
        //        [navigationArray removeObjectAtIndex: 2];
        // 移除所有
        //        navigationArray.removeAll()
        // 从末尾开始移除的个数
        //        navigationArray.removeLast(navigationArray.count - 1)
        
        self.navigationController?.setViewControllers(navigationArray, animated: true)
    }
}
