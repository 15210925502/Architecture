//
//  UserManager.m
//  新用户中心
//
//  Created by HLD on 2017/2/15.
//  Copyright © 2017年 HLD. All rights reserved.
//

#import "UserManager.h"
#import "SandboxFile.h"

#define kFSAccountKey   @"kFSAccountKey"

@interface UserManager()

@property (nonatomic,strong) UserModel *userModel;

@end

@implementation UserManager

+ (instancetype)sharedManager {
    static UserManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[UserManager alloc] init];
        [_manager setAutoRefreshState];
        [_manager setAutoTaiChuangState];
    });
    return _manager;
}

- (BOOL)updateAccount:(UserModel *)userModel {
    BOOL result = NO;
    result = [self purgeAccount];
    if (result) {
        result = [self saveAccount:userModel];
    }
    return result;
}

- (BOOL)saveAccount:(UserModel *)userModel {
    BOOL result = [SandboxFile writeData:userModel toPath:@"UserCenter" fileName:@"User_Information"];
    if (result) {
        self.userModel = [self readCurrentModle];
    }
    return result;
}

- (BOOL)purgeAccount {
    BOOL result = [SandboxFile deleteFileForListPath:@"UserCenter" fileName:@"User_Information"];
    if (result) {
        self.userModel = nil;
    }
    return result;
}

- (UserModel *)getCurrentAccount {
    if (!self.userModel) {
        self.userModel = [self readCurrentModle];
    }
    return self.userModel;
}

- (UserModel *)readCurrentModle {
    return [SandboxFile readDataFromBranch:@"UserCenter" fileName:@"User_Information"];
}

- (NSString *)getCurrentAccountNickName{
    UserModel *userModel = [self getCurrentAccount];
    return userModel.nickname ? : @"";
}

- (NSString *)getCurrentAccountToken{
    UserModel *userModel = [self getCurrentAccount];
    return userModel.token ? : @"";
}

- (NSString *)getCurrentAccountAppToken{
    UserModel *userModel = [self getCurrentAccount];
    return userModel.appToken ? : @"";
}

- (NSString *)getCurrentAccountSignature{
    UserModel *userModel = [self getCurrentAccount];
    return userModel.signature ? : @"";
}

- (BOOL)getCurrentAccountStatus{
    UserModel *userModel = [self getCurrentAccount];
    return userModel.status;
}

- (NSInteger)getCurrentAccountSeriesDay{
    UserModel *userModel = [self getCurrentAccount];
    return userModel.seriesDay;
}

- (NSString *)getCurrentAccountCardNumber{
    UserModel *userModel = [self getCurrentAccount];
    return userModel.cardNumber ? : @"";
}

- (NSString *)getCurrentAccountPhone{
    UserModel *userModel = [self getCurrentAccount];
    return userModel.loginMobile ? : @"";
}

- (BOOL)getCurrentAccountIsSetPassword{
    UserModel *userModel = [self getCurrentAccount];
    return userModel.isSetPassword;
}

- (NSString *)getCurrentAccountCashCreditStatus{
    UserModel *userModel = [self getCurrentAccount];
    return userModel.cashCreditStatus;
}

- (NSString *)getCurrentAccountHiCreditStatus{
    UserModel *userModel = [self getCurrentAccount];
    return userModel.hiCreditStatus;
}

- (NSInteger)getCurrentAccountPoints{
    UserModel *userModel = [self getCurrentAccount];
    return userModel.points;
}

//    客户未现金贷授信：NO_CREDIT、已现金贷授信：HAVE_CREDIT、已现金贷授信，但额度已过期：CREDIT_EXPIRED
- (NSString *)getCurrentAccountCreditCash{
    UserModel *userModel = [self getCurrentAccount];
    return userModel.creditCash;
}

- (BOOL)getShowHiLoan{
    UserModel *userModel = [self getCurrentAccount];
    return userModel.showHiLoan;
}

- (BOOL)isLogin{
    UserModel *obj = [self getCurrentAccount];
    if (obj) {
        return YES;
    }
    return NO;
}

- (void)setAutoRefreshState{
    self.isHomeAutoRefresh = YES;
    self.isBorrowAutoRefresh = YES;
    self.ishuanKuanAutoRefresh = YES;
    self.isMineAutoRefresh = YES;
}

- (void)setAutoTaiChuangState{
    self.isYuQiShowTanChang = YES;
    self.isPingTaiBianGengShowTanChang = YES;
}

- (void)deleteAccountAndClearAutoRefreshState{
    UserManager *sharedManager = [UserManager sharedManager];
    [sharedManager purgeAccount];
    [sharedManager setAutoRefreshState];
    [sharedManager setAutoTaiChuangState];
}

@end
