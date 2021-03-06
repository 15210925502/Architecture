//
//  HSUpdateApp.h
//  HSUpdateAppDemo
//
//  Created by 侯帅 on 2017/5/8.
//  Copyright © 2017年 com.houshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpdateAlert.h"

/**
 block回调
 
 @param currentVersion 当前版本号
 @param storeVersion 商店版本号
 @param openUrl 跳转到商店的地址
 @param isUpdate 是否为最新版本
 */
typedef void(^UpdateBlock)(NSString *currentVersion,NSString *storeVersion, NSString *openUrl,BOOL isUpdate,NSString *updateContent);
typedef void(^SuccessBlock)(id responseObject,NSInteger statusCode);
typedef void(^FailureBlock)(NSError *e,NSInteger statusCode,NSString *errorMsg);

@interface UpdateApp : NSObject

+ (UpdateApp *)sharedManager;

/**
 一行代码实现检测app是否为最新版本。appId，bundelId，随便传一个 或者都传nil 即可实现检测。

 @param appId    项目APPID，10位数字，有值默认为APPID检测，可传nil
 @param bundelId 项目bundelId，有值默认为bundelId检测，可传nil
 @param block    检测结果block回调
 */
- (void)updateWithAPPID:(NSString *)appId
          withBundleId:(NSString *)bundelId
                 block:(UpdateBlock)block;

@end
