//
//  CustomHistoryWebView.swift
//  Architecture
//
//  Created by 华令冬 on 2020/7/16.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit
import WebKit

class CustomHistoryWebView: WKWebView {
    
    var history: WebViewHistory

    override var backForwardList: WebViewHistory {
        return history
    }
    init(frame: CGRect, configuration: WKWebViewConfiguration, history: WebViewHistory) {
        self.history = history
        super.init(frame: frame, configuration: configuration)
    }

    /* Not sure about the best way to handle this part, it was just required for the code to compile... */
    required init?(coder: NSCoder) {
        if let history = coder.decodeObject(forKey: "history") as? WebViewHistory {
            self.history = history
        }else {
            history = WebViewHistory()
        }
        super.init(coder: coder)
    }
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(history, forKey: "history")
    }
}
