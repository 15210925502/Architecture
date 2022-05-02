//
//  BaseTools.swift
//  Architecture
//
//  Created by HLD on 2020/5/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit

@objcMembers
class ConfigurationFile: NSObject {
    
    #if DEBUG
    
    //    测试环境
    public static let baseURLString = "https://hnhk.jbhloan.com"
    public static let h5baseURLString = "https://hnhk.jbhloan.com/cashLoan"
    
    //    uat环境
//        public static let baseURLString = "https://hnhk-uat.jbhloan.com"
//        public static let h5baseURLString = "https://hnhk-uat.jbhloan.com/cashLoan"
        
    //    生产环境
//        public static let baseURLString = "https://hkbt.jbhloan.com"
//        public static let h5baseURLString = "https://hkbt.jbhloan.com/cashLoan"
    
    //        public static let RSA_Pro_File =
    //            ConfigurationFile.getFileBundlePath("public_key_Test.der")
    
    public static let isDebug = false
    
//    推送key
    public static let appKey = "847ac6f1c83fd5595c7f75a0"
//    下载渠道
    public static let channel = "App Store"
//    isProduction : 0（默认值）表示采用的是开发证书，1 表示采用生产证书发布应用。
    public static let isProduction = false
    
    #else
    //    测试环境
    public static let baseURLString = "https://hnhk.jbhloan.com"
    public static let h5baseURLString = "https://hnhk.jbhloan.com/cashLoan"
    
    //    uat环境
//        public static let baseURLString = "https://hnhk-uat.jbhloan.com"
//        public static let h5baseURLString = "https://hnhk-uat.jbhloan.com/cashLoan"
    
    //    生产环境
//            public static let baseURLString = "https://hkbt.jbhloan.com"
//            public static let h5baseURLString = "https://hkbt.jbhloan.com/cashLoan"
    
    //    public static let RSA_Pro_File = ConfigurationFile.getFileBundlePath("public_key_Pro.der")
    
    public static let isDebug = false
        
    //    推送key
        public static let appKey = "5aa82d9f61cdcd57fa9d1bbd"
    //    下载渠道
        public static let channel = "App Store"
    //    isProduction : 0（默认值）表示采用的是开发证书，1 表示采用生产证书发布应用。
        public static let isProduction = true
    
    #endif
    
    
    
    
    
    
    
    
    
    
    
    
    
    //    h5地址
    //    个人信息维护    token，channel(渠道来源：cashLoanApp)，contactType(用户信息入口区分：COMMON)
    public static let personalInformation = "/personalSettings/personalInformation.html"
    //    还款    token，channel(渠道来源：cashLoanApp)
    public static let repayment = "/repayment/repayment.html"
    //    支用    token，channel(渠道来源：cashLoanApp)
    public static let payIndex = "/pay/index.html"
    //    提额    token，channel(渠道来源：cashLoanApp)
    public static let liftingAmountIndex = "/liftingAmount/index.html"
    //    公告列表    token，channel(渠道来源：cashLoanApp)
    public static let msgCenter = "/msgCenter/msgCenter.html"
    //    公告详情    token，channel(渠道来源：cashLoanApp)，id(公告id)，pageTitle（页面标题）
    public static let groups = "/msgCenter/groups.html"
    //    银行卡维护页    token，channel(渠道来源：cashLoanApp)
    public static let bankcardList = "/personalSettings/bankcardList.html"
    //    修改支付密码    token，channel(渠道来源：cashLoanApp)
    public static let verifyPassword = "/personalSettings/verifyPassword.html"
    //    忘记支付密码    token，channel(渠道来源：cashLoanApp)，type(重置密码:2)，codeType（验证码类型：2），state(区分是否为忘记密码：1)
    public static let reset_CreditMessage = "/personalSettings/reset-creditMessage.html"
    //    设置支付密码    token，channel(渠道来源：cashLoanApp),state(设置密码：1)，setType(区分设置密码入口：credit)
    public static let payment_password = "/personalSettings/payment-password.html"
    //    支付密码维护页    token，channel(渠道来源：cashLoanApp)
    public static let passwordSetting = "/personalSettings/passwordSetting.html"
    //    用户授信合同查看    token，channel(渠道来源：cashLoanApp)
    public static let creditContractsList = "/personalSettings/creditContractsList.html"
    //    平台服务协议查看    token，channel(渠道来源：cashLoanApp)
    public static let serviceAgreement = "/personalSettings/serviceAgreement.html"
    //    关于我们
    public static let aboutUs = "/aboutUs/index.html"
    //    帮助中心
    public static let helpCenterlist = "/helpCenter/helpCenterlist.html"
    //    缺省页地址
    public static let noDataPage = "/repayment/noDataPage.html"
    //进入授信流程
    public static let creaditIndex = "/creadit-granting/creadit-index.html"
    //绑卡页面
    public static let boundCard = "/creadit-granting/credit.html"
    //嗨贷授信成功页面
    public static let hdSuccess = "/creadit-granting/hd-success.html"
    //法院公告
    public static let notice = "/msgCenter/notice.html"
    //借款记录
    public static let myLoan = "/transactRecord/my-loan.html"
    //还款记录    token，channel(渠道来源：cashLoanApp)
    public static let payment_history = "/transactRecord/payment_history.html"
    
    
    //进入嗨贷详情页
    public static let hiDaiDetails = "/creadit-granting/hiDaiDetails.html"
    //航旅分期隐私协议
    public static let privacyAgreement = "/personalSettings/privacyAgreement.html"
    //用户授权委托书协议
    public static let userPowerOfAttorney = "/personalSettings/userPowerOfAttorney.html"
    //    平台变更协议
    public static let platformChangeAgreement = "/personalSettings/platformChangeAgreement.html"
    
    //买机票url
    public static let buyJiPiao = "hna2app://sdadf"
    //    跳转到评价页面
    //        public static let downloadApp = "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=465617429"
    //    下载航空App
    //    public static let downloadApp = "http://itunes.apple.com/us/app/id465617429"
    public static let downloadApp = "itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id465617429?mt=8"
    
    //    后台地址
    //我的首页
    public static let pointCheckStatus = "/api/forward/pointCheckStatus"
    //密码登录
    public static let pwdLogin = "/api/login/pwd"
    //积分规则
    public static let integralRule = "/personalSettings/integralRule.html"
    //刷新token
    public static let updateToken = "/api/forward/updateToken"
    //签到
    public static let checkIn = "/api/forward/checkIn"
    //退出登录
    public static let loginOut = "/api/forward/loginOut"
    //我的首页额度详情
    public static let homeLimitDetail = "/api/credit/homeLimitDetail"
    //获取验证码图像
    public static let loginCaptcha = "/api/loginCaptcha"
    //发送验证码
    public static let loginSendSmsCode = "/api/forward/loginSendSmsCode"
    //验证码登录
    public static let smsCodeLogin = "/api/login/sms"
    //忘记密码中获取验证码
    public static let sendSms = "/api/resetPwd/sendSms"
    //忘记密码中发送验证码
    public static let resetPwdVaildSmsCode = "/api/forward/resetPwdVaildSmsCode"
    //忘记密码中发送身份证号
    public static let resetPwdVerifyIdentity = "/api/forward/resetPwdVerifyIdentity"
    //忘记密码中设置密码
    public static let resetPwdSet = "/api/forward/resetPwdSet"
    //修改登录密码
    public static let minePwdModify = "/api/forward/minePwdModify"
    //设置登录密码
    public static let setLoginPwd = "/api/forward/setLoginPwd"
    //积分流水
    public static let pointsLog = "/api/forward/pointsLog"
    //更多积分流水
    public static let pointsLogWeek = "/api/forward/pointsLogWeek"
    //首页额度展示
    public static let homeLimitDisplay = "/api/credit/homeLimitDisplay"
    //上传身份证照片
    public static let creditOcrIdCard = "/api/credit/creditOcrIdCard"
    //人脸识别
    public static let creditAuthFace = "/api/credit/creditAuthFace"
    //首页信息获取
    public static let appHomePage = "/api/appHomePage"
    //版本更新
    public static let versionCheck = "/api/forward/versionCheck"
    //费率计算
    public static let calculator = "/api/home/calculator"
    //签署恒生数据迁移协议
    public static let signHsSupplement = "/api/forward/signHsSupplement"
    //帮助中心
    public static let helpList = "/api/forward/helpList"
    //帮助中心详情
    public static let helpGet = "/api/forward/helpGet"
    //借款信息获取
    public static let appBorrowPage = "/api/credit/query"
    
    //埋点统计
    public static let event = "/h5/buryingPoint/add"
    
    
    
    
    //网络请求文案
    public static let responseTitle = "加载中..."
    public static let timeOutRequestTitle = "网络请求超时"
    //    要求：由数字和字母组成，并且要同时含有数字和字母，且长度要在8-16位之间。
    //
    //    ^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$
    //
    //    分开来注释一下：
    //    ^ 匹配一行的开头位置
    //    (?![0-9]+$) 预测该位置后面不全是数字
    //    (?![a-zA-Z]+$) 预测该位置后面不全是字母
    //    [0-9A-Za-z] {8,16} 由8-16位数字或这字母组成
    //    $ 匹配行结尾位置
    //    注：(?!xxxx) 是正则表达式的负向零宽断言一种形式，标识预该位置后不是xxxx字符。
    //    登录密码验证正则表达式
    public static let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,18}$"
    
    //私有参数和公共参数拼接
    public static func addPublicParameters(dic: Dictionary<String,Any>) -> Dictionary<String, Any> {
        var tempDic = [String : Any]()
        let dateStr = NSDate.pd_string(withValue: NSDate(), formatType: .fullYear) ?? ""
        tempDic["requestDate"] = dateStr
        tempDic["requestTime"] = dateStr
        for (key, value) in dic {
            tempDic[key] = value
        }
        return tempDic
    }
    
    public static func getFileBundlePath(_ fileName: String) -> String {
        return Bundle.main.path(forResource: fileName, ofType: nil) ?? ""
    }
}
