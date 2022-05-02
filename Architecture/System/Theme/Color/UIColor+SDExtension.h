//
//  UIColor+SDExtension.h
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SDExtension)

/// 根据颜色对照表的id获取颜色
+ (UIColor *)sd_colorWithID:(NSString *)colorID;

@end
