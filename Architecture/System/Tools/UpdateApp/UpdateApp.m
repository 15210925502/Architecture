//
//  HSUpdateApp.m
//  HSUpdateAppDemo
//
//  Created by 侯帅 on 2017/5/8.
//  Copyright © 2017年 com.houshuai. All rights reserved.
//

#import "UpdateApp.h"

@interface UpdateApp()

@property (nonatomic,strong) BaseViewModel *dataViewModel;

@end

@implementation UpdateApp

+ (instancetype)sharedManager{
    static UpdateApp *updateApp = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        updateApp = [[self alloc] init];
    });
    return updateApp;
}

- (void)updateWithAPPID:(NSString *)appId
           withBundleId:(NSString *)bundelId
                  block:(UpdateBlock)block{
    NSString *currentVersion = [NSBundle mainBundle].appVersion;
    NSString *urlStr = @"";
    //应用信息地址
    if (appId != nil) {
        //App ID
        urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",appId];
        NSLog(@"【1】当前为APPID检测，您设置的APPID为:%@  当前版本号为:%@",appId,currentVersion);
    }else if (bundelId != nil){
        //bundleId
        urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@&country=cn",bundelId];
        NSLog(@"【1】当前为BundelId检测，您设置的bundelId为:%@  当前版本号为:%@",bundelId,currentVersion);
    }else{
        NSString *currentBundelId = [NSBundle mainBundle].bundleIdentifier;
        urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@&country=cn",currentBundelId];
        NSLog(@"【1】当前为自动检测检测,  当前版本号为:%@",currentVersion);
    }
    urlStr = ConfigurationFile.versionCheck;
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self checkVersionWithUrl:urlStr];
}

- (void)checkVersionWithUrl:(NSString *)url{
    NSMutableDictionary *privateParametersDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    
    [bodyDic setObject:[NSBundle mainBundle].appVersion forKey:@"versionNo"];
    [bodyDic setObject:@"iOS" forKey:@"platform"];
    [contentDic setObject:bodyDic forKey:@"body"];
    [privateParametersDic setObject:contentDic forKey:@"content"];
    
    [NetworkHelper sharedManager].isHiddenLoading = YES;
    [NetworkHelper sharedManager].isShowNetworkActivityIndicator = NO;
    [self.dataViewModel postRequestWithUrl:url
                                parameters:privateParametersDic
                                   success:^(id response) {
        
        UpdateVersionRequestStatusModel *updateModle = [UpdateVersionRequestStatusModel mj_objectWithKeyValues:response];
        if ([updateModle.responseCode isEqualToString:@"200"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![updateModle.contentModel.versionNo isEqualToString:updateModle.contentModel.versionNoLocal]) {
                    [UpdateAlert showUpdateAlertWithModel:updateModle.contentModel];
                }
            });
        }
    } failure:nil
                                 noNetwork:nil];
}

- (BaseViewModel *)dataViewModel{
    if (!_dataViewModel) {
        _dataViewModel = [[BaseViewModel alloc] init];
    }
    return _dataViewModel;
}

@end
