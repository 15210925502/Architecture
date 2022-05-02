//
//  UserModel.swift
//  Architecture
//
//  Created by HLD on 2020/6/2.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit

@objcMembers
class UserModel: BaseModel {
    //    是否设置登录密码
    var isSetPassword: Bool = false
    //    昵称
    var nickname: String = ""
    //    连续签到天数
    var seriesDay: NSInteger = 0
    //    金鹏卡号
    var cardNumber: String = ""
    //    手机号
    var loginMobile: String = ""
    //    积分数
    var points: NSInteger = 0
    //    签到状态
    var status: Bool = false
    //签名
    var signature: String = ""
    //请求后H5时添加，拼接在地址后面
    var token: String = ""
    //请求后台数据时添加，添加在content里和body平级
    var appToken: String = ""
    //    现金贷是否授信（PASSED: 通过 FAILED: 不通过 PENDING: 复议 UNKNOWN: 未知）
    var isCashCredit: String = ""
    //    现金贷授信状态（ENABLED: 启用，DISABLED: 禁用，OVERDUE: 过期，NOCREDIT:未授信，CREDIT_ING:授信中，CREDIT_FAILED:授信失败）
//    禁用：冻结DISABLED
//    过期：过期OVERDUE
    var cashCreditStatus: String = ""
    //    嗨贷授信状态（ENABLED: 启用，DISABLED: 禁用，OVERDUE: 过期，NOCREDIT:未授信，CREDIT_ING:授信中，CREDIT_FAILED:授信失败）
    var hiCreditStatus: String = ""
    //    客户未现金贷授信：NO_CREDIT、已现金贷授信：HAVE_CREDIT、已现金贷授信，但额度已过期：CREDIT_EXPIRED
    var creditCash: String = ""
    //是否授信嗨贷(HAVE_CREDIT:已授信，NO_CREDIT:未授信，CREDIT_EXPIRED：授信过期，授信成功或授信过期，需要弹出窗口)
    var creditHra: String = ""
    var isHiCredit: String = ""
    var hiAvailableCashLimit: String = ""
    var availableLimit: String = ""
    var ticketCreditStatus: String = ""
    var totalLimit: String = ""
    var isTicketCredit: String = ""
    var dailyPayment: String = ""
    var validPeriod: String = ""
    var hiTotalLimit: String = ""
    var availableCashLimit: String = ""
    var dailyPaymentStr: String = ""
    //    当前是否有借款(true=有)
    var hasLoanDue: Bool = false
    //    最近还款日(2020-01-01)
    var lateRepayDateStr: String = ""
    //    是否显示嗨贷按钮
    var showHiLoan: Bool = false
    //    活动：利率打折(0=无活动, 1=新客户, 2=老客户)
    var customerType: NSInteger = 0
    // 是否特业人员, -1=不处理, 0=非特业人员, 1=特业人员
    var special: String = "";
}
