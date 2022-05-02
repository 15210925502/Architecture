//
//  UIFont+Extension.h
//  Architecture
//
//  Created by 华令冬 on 2020/6/10.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Extension)

//字体适配
//系统默认字体
+ (UIFont *)setFontSizeWithValue:(CGFloat)value;
//加粗字体
+ (UIFont *)setBoldSystemFontOfSizeWithValue:(CGFloat)value;
//斜体字体
+ (UIFont *)setItalicSystemFontOfSizeWithValue:(CGFloat)value;
//设置字体名称和字体大小
+ (UIFont *)setFontWithName:(NSString *)fontName size:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END
