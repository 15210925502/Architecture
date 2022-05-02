//
//  NoticeModel.swift
//  Architecture
//
//  Created by 华令冬 on 2020/6/24.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit

@objcMembers
class NoticeModel: BaseModel {
    var author: String = ""
    var channel: String = ""
    var source: String = ""
    var updateTime: String = ""
    var isDelete: String = ""
    var content: String = ""
    var noticeTitle: String = ""
    var status: String = ""
    var createTime: String = ""
    var filePath: String = ""
    var IDCode: String = ""
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["IDCode": "id"]
    }
}
