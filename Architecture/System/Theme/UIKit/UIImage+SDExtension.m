//
//  UIImage+SDExtension.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "UIImage+SDExtension.h"

@implementation UIImage (SDExtension)

+ (UIImage *)sd_imageWithName:(NSString *)imageName {
    if (!imageName) {
        return nil;
    }
    NSString *themeName = [SDThemeManager sharedInstance].currentTheme;
    NSString *imageNameStr = [imageName stringByAppendingString:@"_"];
    imageNameStr = [imageNameStr stringByAppendingString:themeName];
    UIImage *image = [UIImage imageNamed:imageNameStr];
    NSAssert(image, @"未找到对应图片-%@", imageName);
    return image;
}

//根据颜色id获取图片
+ (UIImage *)sd_imageWithColorID:(NSString *)colorID{
    UIColor *color = [UIColor sd_colorWithID:colorID];
    return [self sd_imageWithColor:color];
}

+ (UIImage *)sd_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
