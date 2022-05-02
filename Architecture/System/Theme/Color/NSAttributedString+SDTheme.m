//
//  NSAttributedString+SDTheme.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "NSAttributedString+SDTheme.h"
#import "UIColor+SDExtension.h"

NSAttributedStringKey const SDThemeForegroundColorAttributeName = @"SDThemeForegroundColorAttributeName";

@implementation NSAttributedString (SDTheme)

- (NSAttributedString *)theme_replaceRealityColor {
    NSMutableAttributedString *tmpAttributedText = [self mutableCopy];
    [self enumerateAttributesInRange:NSMakeRange(0, self.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        if (!attrs[SDThemeForegroundColorAttributeName]) {
            return;
        }
        NSMutableDictionary *tmpAttrs = [attrs mutableCopy];
        tmpAttrs[NSForegroundColorAttributeName] = [UIColor sd_colorWithID:attrs[SDThemeForegroundColorAttributeName]];
        [tmpAttributedText setAttributes:tmpAttrs range:range];
    }];
    return tmpAttributedText;
}

@end
