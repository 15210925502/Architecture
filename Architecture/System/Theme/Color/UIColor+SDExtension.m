//
//  UIColor+SDExtension.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "UIColor+SDExtension.h"
#import "SDThemeManager.h"

@implementation UIColor (SDExtension)

+ (UIColor *)sd_colorWithID:(NSString *)colorID {
    NSString *xxStr = [colorID stripInPlace];
    if (!xxStr) {
        return [UIColor clearColor];
    }
    NSString *tempStr = [xxStr uppercaseString];
    tempStr = [SDThemeManager colorStringWithID:tempStr];
    if (tempStr == nil) {
        tempStr = [xxStr lowercaseString];
        tempStr = [SDThemeManager colorStringWithID:tempStr];
        NSAssert(tempStr, @"未找到对应颜色-%@", colorID);
    }
    return [UIColor colorWithHexString:tempStr];
}

@end
