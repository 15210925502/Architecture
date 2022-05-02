//
//  UIImage+SDExtension.h
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDThemeManager.h"
#import "UIColor+SDExtension.h"

@interface UIImage (SDExtension)

/// 获取图片
+ (UIImage *)sd_imageWithName:(NSString *)imageName;

//根据颜色id获取图片
+ (UIImage *)sd_imageWithColorID:(NSString *)colorID;

//根据颜色获取图片
+ (UIImage *)sd_imageWithColor:(UIColor *)color;

@end
