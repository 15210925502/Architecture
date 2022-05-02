//
//  UIColor+Extension.m
//  PDKit
//
//  Created by mlibai on 16/9/2.
//  Copyright © 2016年 People's Daily Online. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)randomColor{
    return [UIColor pd_colorWithRed:arc4random() % 255  green:arc4random() % 255  blue:arc4random() % 255  alpha:1.0];
}

+ (UIColor *)randomReturnColor {
    //  0.0 to 1.0
    CGFloat hue = (arc4random() % 256 / 256.0 );
    //  0.5 to 1.0, away from white
    CGFloat saturation = (arc4random() % 128 / 256.0 ) + 0.5;
    //  0.5 to 1.0, away from black
    CGFloat brightness = (arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (UIColor *)pd_colorWithRed:(UInt64)red green:(UInt64)green blue:(UInt64)blue alpha:(UInt64)alpha {
    CGFloat r = (CGFloat)((CGFloat)(red) / 255.0);
    CGFloat g = (CGFloat)((CGFloat)(green) / 255.0);
    CGFloat b = (CGFloat)((CGFloat)(blue) / 255.0);
    CGFloat a = (CGFloat)((CGFloat)(alpha) / 255.0);
    NSLog(@"%f",r);
    NSLog(@"%f",g);
    NSLog(@"%f",b);
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (UIColor *)pd_colorWithRGB:(UInt32)aHexColorValue {
    UInt8 redValue   = (UInt8)(aHexColorValue >> 16);
    UInt8 greenValue = (UInt8)((aHexColorValue & 0x00FF00) >> 8);
    UInt8 blueValue  = (UInt8)((aHexColorValue & 0x0000FF) >> 0);
    return [UIColor pd_colorWithRed:redValue green:greenValue blue:blueValue alpha:0xFF];
}

+ (UIColor *)pd_colorWithRGBA:(UInt32)aHexColorValue {
    UInt8 redValue   = (UInt8)(aHexColorValue >> 24);
    UInt8 greenValue = (UInt8)((aHexColorValue & 0x00FF0000) >> 16);
    UInt8 blueValue  = (UInt8)((aHexColorValue & 0x0000FF00) >> 8);
    UInt8 alphaValue = (UInt8)((aHexColorValue & 0x000000FF) >> 0);
    return [UIColor pd_colorWithRed:redValue green:greenValue blue:blueValue alpha:alphaValue];
}

+ (NSString *)colorToRGBStringWithColor:(UIColor *)color {
    const CGFloat *cs = CGColorGetComponents(color.CGColor);
    int r = cs[0] * 255;
    int g = cs[1] * 255;
    int b = cs[2] * 255;
    return [NSString stringWithFormat:@"RGB:%d,%d,%d",r,g,b];
}

+ (NSString *)colorToHexStringWithRGBRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    NSString *rStr = [self toHex:red];
    NSString *gStr = [self toHex:green];
    NSString *bStr = [self toHex:blue];
    return [NSString stringWithFormat:@"#%@%@%@", rStr, gStr, bStr];
}

+ (NSString *)colorToRGBStringWithHexString:(NSString *)hexString {
    NSArray *array = [self rgbArrayWithHexString:hexString];
    return [NSString stringWithFormat:@"RGB:%ld,%ld,%ld", (long)[array[0] integerValue], (long)[array[1] integerValue], (long)[array[2] integerValue]];
}

+ (NSString *)colorToHexStringWithColor:(UIColor *)color{
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *cs = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:cs[0]
                                green:cs[0]
                                 blue:cs[0]
                                alpha:cs[1]];
    }else if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    const CGFloat *cs = CGColorGetComponents(color.CGColor);
    
    //    方法一
    NSString *r = [self toHex:cs[0] * 255];
    NSString *g = [self toHex:cs[1] * 255];
    NSString *b = [self toHex:cs[2] * 255];
    NSString *result = [NSString stringWithFormat:@"#%@%@%@",r,g,b];
    
    //    方法二
    //    十六进制输出
//    NSString *result = [NSString stringWithFormat:@"#%02X%02X%02X", (int)(cs[0] * 255.0),
//                        (int)(cs[1] * 255.0),
//                        (int)(cs[2] * 255.0)];
    
    result = [result stringByAppendingFormat:@"%02lx",
              (unsigned long)(color.lgf_Alpha * 255.0 + 0.5)];
    return result;
}

+ (UIColor *)colorWithHexString:(NSString *)hexString{
    // 获取目标字符串，替换字符并转换成大写字符串
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch([colorString length]){
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue  = [self colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red   = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue  = [self colorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue  = [self colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red   = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue  = [self colorComponentFrom:colorString start:6 length:2];
            break;
        default: // 抛出异常
            [NSException raise:@"无效的颜色值" format:@"颜色值%@是无效的. 正确的格式是#RBG、#ARGB、#RRGGBB或#AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWithColor:(UIColor *)color alpha:(CGFloat)alpha{
    if([color isEqual:[UIColor whiteColor]])
        return [UIColor colorWithWhite:1.000 alpha:alpha];
    if([color isEqual:[UIColor blackColor]])
        return [UIColor colorWithWhite:0.000 alpha:alpha];
    
    // 使用CGColorGetComponents方法，获取'color'关联的颜色组件
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    return [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string
                        start:(NSUInteger)start
                       length:(NSUInteger)length{
    // 截取字符
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *doubleSubstring = [NSString stringWithFormat:@"%@%@", substring, substring];
    NSString *fullHex = (length == 2 ? substring : doubleSubstring);
    unsigned hexComponent;
    // 字符转成hex，可选前缀为“0x”或“ 0X ”
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)colorAtPoint:(CGPoint )point image:(UIImage *)image{
    if (point.x < 0 || point.y < 0){
        return nil;
    }
    CGImageRef imageRef = image.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    if (point.x >= width || point.y >= height){
        return nil;
    }
    unsigned char *rawData = malloc(height * width * 4);
    if (!rawData){
        return nil;
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    if (!context) {
        free(rawData);
        return nil;
    }
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    int byteIndex = (bytesPerRow * point.y) + point.x * bytesPerPixel;
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    
    UIColor *result = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    free(rawData);
    return result;
}

+ (UIColor *)colorAtPixel:(CGPoint)point image:(UIImage *)image{
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point)) {
        return nil;
    }
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = image.CGImage;
    NSUInteger width = image.size.width;
    NSUInteger height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    
//    返回颜色
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
//    返回16进制颜色值
//    return[NSString stringWithFormat:@"#%02X%02X%02X",pixelData[0],pixelData[1],pixelData[2]];
}

+ (NSArray *)getRGBDictionaryByColor:(UIColor *)originColor {
    CGFloat r = 0.0f;
    CGFloat g = 0.0f;
    CGFloat b = 0.0f;
    CGFloat a = 0.0f;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [originColor getRed:&r green:&g blue:&b alpha:&a];
    }else {
        const CGFloat *components = CGColorGetComponents(originColor.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    return @[@(r),@(g),@(b),@(a)];
}

+ (NSArray *)transColorBeginColor:(UIColor *)beginColor andEndColor:(UIColor *)endColor {
    NSArray<NSNumber *> *beginColorArr = [self getRGBDictionaryByColor:beginColor];
    NSArray<NSNumber *> *endColorArr = [self getRGBDictionaryByColor:endColor];
    return @[@([endColorArr[0] doubleValue] - [beginColorArr[0] doubleValue]),@([endColorArr[1] doubleValue] - [beginColorArr[1] doubleValue]),@([endColorArr[2] doubleValue] - [beginColorArr[2] doubleValue])];
}

+ (UIColor *)getColorWithColor:(UIColor *)beginColor andCoe:(double)coe andEndColor:(UIColor *)endColor {
    NSArray *beginColorArr = [self getRGBDictionaryByColor:beginColor];
    NSArray *marginArray = [self transColorBeginColor:beginColor andEndColor:endColor];
    double red = [beginColorArr[0] doubleValue] + coe * [marginArray[0] doubleValue];
    double green = [beginColorArr[1] doubleValue] + coe * [marginArray[1] doubleValue];
    double blue = [beginColorArr[2] doubleValue] + coe * [marginArray[2] doubleValue];
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)gradientFromColor:(UIColor *)fromColor
                       toColor:(UIColor *)toColor
                   widthHeight:(NSInteger)value
          verticalOrTransverse:(BOOL)flag{
    CGSize size;
    if(flag){
        size = CGSizeMake(value, 1);
    }else{
        size = CGSizeMake(1, value);
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray *colors = [NSArray arrayWithObjects:(id)fromColor.CGColor, (id)toColor.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    if(flag){
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(size.width, 1), 0);
    }else{
       CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

+ (void)componentsWithColor:(UIColor *)color {
    NSUInteger num = CGColorGetNumberOfComponents(color.CGColor);
    const CGFloat *colorComponents = CGColorGetComponents(color.CGColor);
    for (int i = 0; i < num; ++i) {
        NSLog(@"color components %d: %f", i, colorComponents[i]);
    }
}

+ (NSArray<NSString *> *)rgbArrayWithHexString:(NSString *)hexString {
    // String should be 6 or 8 characters
    NSString *cString = [self filterHexString:hexString];
    // cString 格式不合要求
    if (cString == nil) {
        return nil;
    }
    // 16进制字符串
    NSRange range;
    range.location = 0;
    range.length = 2;
    // r  @"DF" --> @"223"
    NSString *rString = [self toRGB:[cString substringWithRange:range]];
    //g
    range.location = 2;
    NSString *gString = [self toRGB:[cString substringWithRange:range]];
    //b
    range.location = 4;
    NSString *bString = [self toRGB:[cString substringWithRange:range]];
    //    // Scan values  // 没用到这个 @"DF" --> 223
    //    unsigned int r, g, b;
    //    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    //    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    //    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    NSArray *array = @[rString, gString, bString];
    return array;
}

// 如果hexString不合要求, 则返回nil
+ (NSString *)filterHexString:(NSString *)hexString {
    //删除字符串中的空格
    NSString *tempHexString = [[hexString stripInPlace] uppercaseString];
    if ([tempHexString length] < 6){
        return nil;
    }
    // strip 0X if it appears
    //如果是0X开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([tempHexString hasPrefix:@"0X"]){
        tempHexString = [tempHexString substringFromIndex:2];
    }
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([tempHexString hasPrefix:@"0x"]){
        tempHexString = [tempHexString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([tempHexString hasPrefix:@"#"]){
        tempHexString = [tempHexString substringFromIndex:1];
    }
    if ([tempHexString length] != 6){
        return nil;
    }
    return tempHexString;
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    NSString *cString = [self filterHexString:color];
    if (cString == nil) {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    //    方法一
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((CGFloat)r / 255.0f) green:((CGFloat)g / 255.0f) blue:((CGFloat)b / 255.0f) alpha:alpha];
    
    //    方法二
    //    rString = [self toRGB:rString];
    //    gString = [self toRGB:gString];
    //    bString = [self toRGB:bString];
    //    return [UIColor colorWithRed:([rString floatValue] / 255.0f) green:([gString floatValue] / 255.0f) blue:([bString floatValue] / 255.0f) alpha:alpha];
}

// 将int型的十进制转成 16进制 (默认都转成16进制的)  注意:前面没有补0
+ (NSString *)toHex:(int)tmpid{
    int ttmpig = tmpid % 16;
    int tmp = tmpid / 16;
    NSString *nLetterValue = [self zhuanHuan1:ttmpig];
    NSString *nStrat = [self zhuanHuan1:tmp];
    NSString *endtmp = [[NSString alloc] initWithFormat:@"%@%@",nStrat,nLetterValue];
    return endtmp;
}

// 将 16进制字符串 转成 10进制字符串 注意:只能两位
+ (NSString *)toRGB:(NSString *)tmpid{
    // 第一位
    NSString *firstStr = [tmpid substringToIndex:1];
    int first = [self zhuanHuan:firstStr];
    
    // 第二位
    NSString *secondStr = [tmpid substringFromIndex:1];
    int second = [self zhuanHuan:secondStr];
    
    //    NSLog(@"first = %d, second = %d", first, second);
    int result = first * 16 + second;
    return [NSString stringWithFormat:@"%d", result];
}

+ (int)zhuanHuan:(NSString *)str{
    int result;
    if ([str isEqualToString:@"A"]) {
        result = 10;
    }else if ([str isEqualToString:@"B"]) {
        result = 11;
    }else if ([str isEqualToString:@"C"]) {
        result = 12;
    }else if ([str isEqualToString:@"D"]) {
        result = 13;
    }else if ([str isEqualToString:@"E"]) {
        result = 14;
    }else if ([str isEqualToString:@"F"]) {
        result = 15;
    }else {
        result = str.intValue;
    }
    return result;
}

+ (NSString *)zhuanHuan1:(int)tempInt{
    NSString *nLetterValue = nil;
    switch (tempInt){
        case 10:
            nLetterValue = @"A";
            break;
        case 11:
            nLetterValue = @"B";
            break;
        case 12:
            nLetterValue = @"C";
            break;
        case 13:
            nLetterValue = @"D";
            break;
        case 14:
            nLetterValue = @"E";
            break;
        case 15:
            nLetterValue = @"F";
            break;
        default:nLetterValue = [[NSString alloc] initWithFormat:@"%i",tempInt];
    }
    return nLetterValue;
}

CGFloat colorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)colorWithImage:(UIImage *)image atPoint:(CGPoint)point {
    if (point.x < 0 || point.y < 0){
        return nil;
    }
    CGImageRef imageRef = image.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    if (point.x >= width || point.y >= height){
        return nil;
    }
    unsigned char *rawData = malloc(height * width * 4);
    if (!rawData){
        return nil;
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast
                                                 | kCGBitmapByteOrder32Big);
    if (!context) {
        free(rawData);
        return nil;
    }
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    int byteIndex = (bytesPerRow * point.y) + point.x * bytesPerPixel;
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    
    UIColor *result = nil;
    result = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    free(rawData);
    return result;
}

+ (UIColor *)mostColorWithImage:(UIImage *)image{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize = CGSizeMake(5, 5);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width * 4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char *data = CGBitmapContextGetData (context);
    if (data == NULL){
        return nil;
    }
    NSCountedSet *cls = [NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    for (int x = 0; x < thumbSize.width; x++) {
        for (int y = 0; y < thumbSize.height; y++) {
            int offset = 4 * (x * y);
            int red = data[offset];
            int green = data[offset + 1];
            int blue = data[offset + 2];
            int alpha =  data[offset + 3];
            //去除透明
            if (alpha > 0) {
                //去除白色
                if (red == 255 && green == 255 && blue == 255) {
                    
                }else{
                    NSArray *clr = @[@(red),@(green),@(blue),@(alpha)];
                    [cls addObject:clr];
                }
            }
        }
    }
    CGContextRelease(context);
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor = nil;
    NSUInteger MaxCount = 0;
    while ((curColor = [enumerator nextObject]) != nil ){
        NSUInteger tmpCount = [cls countForObject:curColor];
        if ( tmpCount < MaxCount ){
            continue;
        }
        MaxCount = tmpCount;
        MaxColor = curColor;
    }
    return [UIColor colorWithRed:([MaxColor[0] intValue] / 255.0f)
                           green:([MaxColor[1] intValue] / 255.0f)
                            blue:([MaxColor[2] intValue] / 255.0f)
                           alpha:([MaxColor[3] intValue] / 255.0f)];
}

- (CGFloat)lgf_Red {
    CGFloat r = 0, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)lgf_Green {
    CGFloat r, g = 0, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)lgf_Blue {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)lgf_Alpha {
    return CGColorGetAlpha(self.CGColor);
}

- (CGFloat)lgf_Hue {
    CGFloat h = 0, s, b, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return h;
}

- (CGFloat)lgf_Saturation {
    CGFloat h, s = 0, b, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return s;
}

- (CGFloat)lgf_Brightness {
    CGFloat h, s, b = 0, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return b;
}

@end
