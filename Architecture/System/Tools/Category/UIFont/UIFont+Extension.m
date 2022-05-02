//
//  UIFont+Extension.m
//  Architecture
//
//  Created by 华令冬 on 2020/6/10.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)

+ (UIFont *)setFontSizeWithValue:(CGFloat)value{
    if (value >= 0) {
        return [UIFont systemFontOfSize:[BaseTools adaptedWithValue:value]];
    }else{
        return [UIFont systemFontOfSize:[BaseTools adaptedWithValue:11]];
    }
}

+ (UIFont *)setBoldSystemFontOfSizeWithValue:(CGFloat)value{
    if (value >= 0) {
        return [UIFont boldSystemFontOfSize:[BaseTools adaptedWithValue:value]];
    }else{
        return [UIFont boldSystemFontOfSize:[BaseTools adaptedWithValue:11]];
    }
}

+ (UIFont *)setItalicSystemFontOfSizeWithValue:(CGFloat)value{
    if (value >= 0) {
        return [UIFont italicSystemFontOfSize:[BaseTools adaptedWithValue:value]];
    }else{
        return [UIFont italicSystemFontOfSize:[BaseTools adaptedWithValue:11]];
    }
}

+ (UIFont *)setFontWithName:(NSString *)fontName size:(CGFloat)value{
    if (fontName.length > 0) {
        if (value >= 0) {
            return [UIFont fontWithName:fontName size:[BaseTools adaptedWithValue:value]];
        }else{
            return [UIFont fontWithName:fontName size:[BaseTools adaptedWithValue:11]];
        }
    }else{
        return [self setFontSizeWithValue:value];
    }
}

@end
