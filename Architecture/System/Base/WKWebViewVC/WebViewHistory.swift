//
//  WebViewHistory.swift
//  Architecture
//
//  Created by 华令冬 on 2020/7/16.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import Foundation
import WebKit

class WebViewHistory: WKBackForwardList {
    /* 解决方案1：返回nil，丢弃backList中的内容& forwardList */
    override var backItem: WKBackForwardListItem? {
        return nil
    }
    override var forwardItem: WKBackForwardListItem? {
        return nil
    }
    /* 解决方案2：覆盖backList和forwardList以添加setter */
    var myBackList = [WKBackForwardListItem]()
    override var backList: [WKBackForwardListItem] {
        get {
            return myBackList
        }
        set(list) {
            myBackList = list
        }
    }
    func clearBackList() {
        backList.removeAll()
    }
}
