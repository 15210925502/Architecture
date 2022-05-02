//
//  VerifyAppIsInstalled.m
//  Architecture
//
//  Created by HLD on 2022/4/15.
//

#import <UIKit/UIKit.h>
#import "VerifyAppIsInstalled.h"

/*
 ⚠️⚠️⚠️ MobileContainerManager为私有api ⚠️⚠️⚠️
 ⚠️⚠️⚠️ MobileContainerManager为私有api ⚠️⚠️⚠️
 ⚠️⚠️⚠️ MobileContainerManager为私有api ⚠️⚠️⚠️
 */

@implementation VerifyAppIsInstalled

+ (BOOL) verifyAppWithBundle:(NSString *)bundleID{
    __block BOOL isInstall = NO;
    if ([UIDevice systemVersion] >= 11.0) {
        //iOS12间接获取办法
        if ([UIDevice systemVersion] >= 12.0){
            Class lsawsc = objc_getClass("LSApplicationWorkspace");
            NSObject *workspace = [lsawsc performSelector:NSSelectorFromString(@"defaultWorkspace")];
            
            NSArray *plugins = [workspace performSelector:NSSelectorFromString(@"installedPlugins")]; //列出所有plugins
            NSLog(@"installedPlugins:%@",plugins);
            [plugins enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *pluginID = [obj performSelector:(@selector(pluginIdentifier))];
                NSLog(@"pluginID：%@",pluginID);
                if([pluginID containsString:bundleID]){
                    isInstall = YES;
                    return;
                }
            }];
            return isInstall;
        }else{
            //iOS11获取办法
            NSBundle *container = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/MobileContainerManager.framework"];
            if ([container load]) {
                Class appContainer = NSClassFromString(@"MCMAppContainer");
                id test = [appContainer performSelector:@selector(containerWithIdentifier:error:) withObject:bundleID withObject:nil];
                NSLog(@"%@",test);
                return test;
            }else{
                return NO;
            }
        }
    }else{
        //iOS10及以下获取办法
        Class lsawsc = objc_getClass("LSApplicationWorkspace");
        NSObject *workspace = [lsawsc performSelector:NSSelectorFromString(@"defaultWorkspace")];
//        获取手机中安装的所有APP
        NSArray *appList = [workspace performSelector:@selector(allApplications)];
        Class LSApplicationProxy_class = object_getClass(@"LSApplicationProxy");
        for (LSApplicationProxy_class in appList){
            //这里可以查看一些信息
            NSString *bundleID = [LSApplicationProxy_class performSelector:@selector(applicationIdentifier)];
            NSLog(@"%@",bundleID);
            
            NSString *version = [LSApplicationProxy_class performSelector:@selector(bundleVersion)];
            NSLog(@"%@",version);
            
            NSString *shortVersionString = [LSApplicationProxy_class performSelector:@selector(shortVersionString)];
            NSLog(@"%@",shortVersionString);
            
            if ([bundleID isEqualToString:bundleID]) {
                return YES;
            }
        }
        return NO;
    }
    return NO;
}

@end
