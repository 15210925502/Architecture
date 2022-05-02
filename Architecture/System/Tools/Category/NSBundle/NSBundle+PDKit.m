//
//  NSBundle+PDKit.m
//  PDKit
//
//  Created by mlibai on 16/9/2.
//  Copyright © 2016年 People's Daily Online. All rights reserved.
//

#import "NSBundle+PDKit.h"

@implementation NSBundle (PDKit)

- (NSString *)bundleIdentifier {
    return [self infoDictionary][(id)kCFBundleIdentifierKey] ?:@"Unknown";
}

- (NSString *)pd_versionString {
    return [self infoDictionary][(id)kCFBundleVersionKey] ?:@"Unknown";
}

- (NSString *)pd_bundleExecutableName {
    return [self infoDictionary][(id)kCFBundleExecutableKey] ?:@"Unknown";
}

- (NSString *)appVersion {
    return [self infoDictionary][(id)@"CFBundleShortVersionString"] ?:@"Unknown";
}

- (NSString *)pd_bundleName {
    return [self infoDictionary][(id)@"CFBundleDisplayName"] ? : [self infoDictionary][(id)@"CFBundleName"]  ? : @"Unknown";
}

- (NSString *)pd_appIcon{
    //获取app中所有icon名字数组
    NSArray *inforArray = [self infoDictionary][(id)@"CFBundleIcons"][(id)@"CFBundlePrimaryIcon"][(id)@"CFBundleIconFiles"];
    return inforArray.lastObject;
}

- (NSString *)pd_LaunchImageWithOrientation:(NSString *)orientation{
    NSString *launchImage = @"";
    NSArray *launchImageArray = [self infoDictionary][(id)@"UILaunchImages"];
    for (NSDictionary *dic in launchImageArray){
        CGSize imageSize = CGSizeFromString(dic[(id)@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, [UIScreen mainScreen].bounds.size) && [orientation isEqualToString:dic[@"UILaunchImageOrientation"]]) {
            launchImage = dic[(id)@"UILaunchImageName"];
        }
    }
    return launchImage;
}

@end
