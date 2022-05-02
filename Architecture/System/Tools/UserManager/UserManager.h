//
//  UserManager.h
//  新用户中心
//
//  Created by HLD on 2017/2/15.
//  Copyright © 2017年 HLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserManager : NSObject

//只弹窗一次
@property (nonatomic,assign) BOOL isYuQiShowTanChang;
@property (nonatomic,assign) BOOL isPingTaiBianGengShowTanChang;

//首页是否需要自动刷新
@property (nonatomic,assign) BOOL isHomeAutoRefresh;
//借款是否需要自动刷新
@property (nonatomic,assign) BOOL isBorrowAutoRefresh;
//还款是否需要自动刷新
@property (nonatomic,assign) BOOL ishuanKuanAutoRefresh;
//我的是否需要自动刷新
@property (nonatomic,assign) BOOL isMineAutoRefresh;

+ (instancetype)sharedManager;

//保存用户信息
- (BOOL)saveAccount:(id)userModel;

//更新用户信息
- (BOOL)updateAccount:(id)userModel;

//清除用户信息
- (BOOL)purgeAccount;

//获取用户信息
- (id)getCurrentAccount;

//获取用户昵称
- (NSString *)getCurrentAccountNickName;

//获token,请求后H5时添加，拼接在地址后面
- (NSString *)getCurrentAccountToken;

//获appToken,请求后台数据时添加，添加在content里和body平级
- (NSString *)getCurrentAccountAppToken;

//获signature
- (NSString *)getCurrentAccountSignature;

//获签到状态
- (BOOL)getCurrentAccountStatus;

//获连续签到天数
- (NSInteger)getCurrentAccountSeriesDay;

//获金鹏卡号
- (NSString *)getCurrentAccountCardNumber;

//获手机号
- (NSString *)getCurrentAccountPhone;

//获是否设置了登录密码
- (BOOL)getCurrentAccountIsSetPassword;

//现金贷授信状态（ENABLED: 启用，DISABLED: 禁用，OVERDUE: 过期，NOCREDIT:未授信，CREDIT_ING:授信中，CREDIT_FAILED:授信失败）
- (NSString *)getCurrentAccountCashCreditStatus;

//嗨贷授信状态（ENABLED: 启用，DISABLED: 禁用，OVERDUE: 过期，NOCREDIT:未授信，CREDIT_ING:授信中，CREDIT_FAILED:授信失败）
- (NSString *)getCurrentAccountHiCreditStatus;

//获积分数
- (NSInteger)getCurrentAccountPoints;

//获取客户现金贷状态，在活体识别后使用
- (NSString *)getCurrentAccountCreditCash;

//是否显示嗨贷
- (BOOL)getShowHiLoan;

//是否登录状态
- (BOOL)isLogin;

//把每个页面都设置成需要自动刷新
- (void)setAutoRefreshState;

//把每个页面都设置成需要自动刷新
- (void)deleteAccountAndClearAutoRefreshState;

@end
