//
//  UIColor+Extension.h
//  PDKit
//
//  Created by mlibai on 16/9/2.
//  Copyright © 2016年 People's Daily Online. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

//创建一个随机UIColor对象
+ (UIColor *)randomColor;
+ (UIColor *)randomReturnColor;

/**
 *  通过 RGBA 值创建颜色对象。
 *
 *  @param red   0 ~ 255
 *  @param green 0 ~ 255
 *  @param blue  0 ~ 255
 *  @param alpha 0 ~ 255
 *
 *  @return UIColor 对象
 */
+ (UIColor *)pd_colorWithRed:(UInt64)red
                       green:(UInt64)green
                        blue:(UInt64)blue
                       alpha:(UInt64)alpha;

/**
 *  通过16进制的颜色值，创建 UIColor 对象。
 *  @param aHexColorValue 十六进制 RGB 或 RGBA 值，如 0xFFAABB
 *  @return UIColor 对象
 */
+ (UIColor *)pd_colorWithRGB:(UInt32)aHexColorValue;
+ (UIColor *)pd_colorWithRGBA:(UInt32)aHexColorValue;

/**
 16进制 -> 颜色
 @param hexString 16进制字符串
 @return 转得的色值
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)color
                          alpha:(CGFloat)alpha;

/**
 *  颜色 -> RGB
 *  返回颜色格式 : 192,192,222
 */
+ (NSString *)colorToRGBStringWithColor:(UIColor *)color;

/**
 *  16进制 -> RGB颜色
 *  @param hexString : @“#123456”、 @“0X123456”、@“0x123456” 、 @“123456” 四种格式
 *  返回颜色格式 : RGB:192,192,222
 */
+ (NSString *)colorToRGBStringWithHexString:(NSString *)hexString;

/**
 *  RGB -> 16进制颜色
 *  返回颜色格式 : #123456
 */
+ (NSString *)colorToHexStringWithRGBRed:(CGFloat)red
                                   green:(CGFloat)green
                                    blue:(CGFloat)blue;

/**
 *  将颜 -> 16进制
 *  返回颜色格式 : #123456FF
 */
+ (NSString *)colorToHexStringWithColor:(UIColor *)color;

/*!
 *  从已知UIColor对象和Alpha对象得到一个UIColor对象
 */
+ (UIColor *)colorWithColor:(UIColor *)color
                      alpha:(CGFloat)alpha;

/*!
 *  获取字符，转换数据类型，改变部分字体颜色
 *  @param string string
 *  @param start  开始位置
 *  @param length 截取长度
 *  @return float
 */
+ (CGFloat)colorComponentFrom:(NSString *)string
                        start:(NSUInteger)start
                       length:(NSUInteger)length;

/**
 *  @brief  取图片某一点的颜色
 *  @param point 某一点
 *  @param image 图片
 *  @return 颜色
 */
+ (UIColor *)colorAtPoint:(CGPoint)point
                    image:(UIImage *)image;

/**
 *  @brief  取某一像素的颜色
 *  @param point 一像素
 *  @param image 图片
 *  @return 颜色
 */
+ (UIColor *)colorAtPixel:(CGPoint)point
                    image:(UIImage *)image;

/**
 得到一个颜色的原始值 RGBA
 @param originColor 传入颜色
 @return 颜色值数组
 */
+ (NSArray *)getRGBDictionaryByColor:(UIColor *)originColor;

/**
 得到两个值的色差
 
 @param beginColor 起始颜色
 @param endColor 终止颜色
 @return 色差数组
 */
+ (NSArray *)transColorBeginColor:(UIColor *)beginColor
                      andEndColor:(UIColor *)endColor;

/**
 传入两个颜色和系数
 @param beginColor 开始颜色
 @param coe 系数（0->1）
 @param endColor 终止颜色
 @return 过度颜色
 */
+ (UIColor *)getColorWithColor:(UIColor *)beginColor
                        andCoe:(double)coe
                   andEndColor:(UIColor *)endColor;

/**
 *  @brief  渐变颜色
 *  @param fromColor             开始颜色
 *  @param toColor               结束颜色
 *  @param value                 渐变宽度或者高度
 *  @param flag                  YES表示横向，NO表示纵向
 *  @return 渐变颜色
 */
+ (UIColor *)gradientFromColor:(UIColor *)fromColor
                       toColor:(UIColor *)toColor
                   widthHeight:(NSInteger)value
          verticalOrTransverse:(BOOL)flag;

//测试方法: 打印color的元素
+ (void)componentsWithColor:(UIColor *)color;

#pragma mark - 取图片某一点的颜色
/**
 @param point 某一点
 @return 颜色
 */
+ (UIColor *)colorWithImage:(UIImage *)image atPoint:(CGPoint)point;

#pragma mark - 获取图片主色调
+ (UIColor *)mostColorWithImage:(UIImage *)image;

#pragma mark - RGB颜色空间中颜色的红色分量值。属性的值是一个在`0.0`到`1.0`范围内的浮点数。
- (CGFloat)lgf_Red;
#pragma mark - RGB颜色空间中颜色的绿色分量值。
- (CGFloat)lgf_Green;
#pragma mark - RGB颜色空间中颜色的蓝色分量值。
- (CGFloat)lgf_Blue;
#pragma mark - HSB颜色空间中的颜色色调分量值。
- (CGFloat)lgf_Hue;
#pragma mark - HSB颜色空间中颜色的饱和度分量值。
- (CGFloat)lgf_Saturation;
#pragma mark - HSB颜色空间中的颜色亮度分量值。
- (CGFloat)lgf_Brightness;
#pragma mark - 颜色的alpha分量值。
- (CGFloat)lgf_Alpha;

@end
