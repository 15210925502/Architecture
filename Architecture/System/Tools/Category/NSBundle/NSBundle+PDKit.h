//
//  NSBundle+PDKit.h
//  PDKit
//
//  Created by mlibai on 16/9/2.
//  Copyright © 2016年 People's Daily Online. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBundle (PDKit)

/**
 *  对应 info.plist 中的 “Bundle identifier” 或配置选项卡 General 中的 “Bundle Identifier”。
 *
 *  @return  bundle id
 */
- (NSString *)bundleIdentifier;

/**
 *  对应 info.plist 中的 “Bundle Version” 或配置选项卡 General 中的 “Build”。
 *
 *  @return  build version
 */
- (NSString *)pd_versionString;

/**
 * 对应配置选项卡 General 中的 “TARGETS名字”。
 *
 *  @return  Bundle Executable
 */
- (NSString *)pd_bundleExecutableName;

/**
 * 对应 info.plist 中的 “Bundle versions string, short, 或配置选项卡 General 中的 “Verson”。
 *
 *  @return  short Verson
 */
- (NSString *)appVersion;

/**
 *  对应 info.plist 中的 “Bundle display name, 或配置选项卡 General 中的 “Display Name”。
 *
 *  @return  Bundle Name
 */
- (NSString *)pd_bundleName;

/**
 *  对应 Assets.xcassets 中的 “AppIcon
 *
 *  @return  App Icon
 */
- (NSString *)pd_appIcon;

/**
 *  对应 Assets.xcassets 中的 “LaunchImage
 *  orientation     横屏请设置成 @"Landscape"    竖屏请设置成 @"Portrait"
 if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)) {
    orientation = @"Portrait";
 } else {
    orientation = @"Landscape";
 }
 *  @return  LaunchImage
 */
- (NSString *)pd_LaunchImageWithOrientation:(NSString *)orientation;

@end
