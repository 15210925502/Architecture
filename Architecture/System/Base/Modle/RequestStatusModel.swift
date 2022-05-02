//
//  RequestStatusModel.swift
//  Architecture
//
//  Created by HLD on 2020/6/4.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit

@objcMembers
class RequestStatusModel: BaseModel {
    
    //状态码
    var responseCode: String = ""
    //请求信息
    var responseDesc: String = ""
    //签名
    var signature: String = ""
}
