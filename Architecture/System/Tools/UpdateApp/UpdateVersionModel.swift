//
//  UpdateVersionModel.swift
//  Architecture
//
//  Created by 华令冬 on 2020/6/30.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit

@objcMembers
class UpdateVersionModel: BaseModel {
    
    //    时间
    var createTime: String = ""
    //    更新文案
    var content: String = ""
    //    本地版本号
    var versionNoLocal: String = ""
    //    最新版本号
    var versionNo: String = ""
    //    更新url
    var url: String = ""
    //    平台
    var platform: String = ""
    /**
     是否强制更新
     0：不提示升级：不弹窗提示，用户需要主动更新
     1：强制升级：用户不升级无法使用APP（没有取消按钮）
     2：强提示升级：每天提醒一次（有取消按钮）
     3：弱提示升级：先保存最新版本号，并弹提示框，下次进来判断最近版本号和保存的版本号是否一致，不一致弹窗提示（有取消按钮）
     */
    var isForce: String = ""
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["isForce": "updateState"]
    }
}
