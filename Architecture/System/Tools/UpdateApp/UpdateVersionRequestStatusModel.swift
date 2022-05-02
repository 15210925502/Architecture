//
//  UpdateVersionRequestStatusModel.swift
//  Architecture
//
//  Created by 华令冬 on 2020/6/30.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit

@objcMembers
class UpdateVersionRequestStatusModel: RequestStatusModel {
    var contentModel: UpdateVersionModel?
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["contentModel": "content"]
    }
}
