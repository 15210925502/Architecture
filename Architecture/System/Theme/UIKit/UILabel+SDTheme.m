//
//  UILabel+SDTheme.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "UILabel+SDTheme.h"
#import "NSObject+SDTheme.h"
#import "NSAttributedString+SDTheme.h"
#import "UIColor+SDExtension.h"
#import <objc/runtime.h>

@interface UILabel()

@end

@implementation UILabel (SDTheme)

- (void)theme_didChanged {
    [super theme_didChanged];
    if (self.theme_textColor) {
        self.textColor = [UIColor sd_colorWithID:self.theme_textColor];
    }
    if (self.attributedText) {
        self.attributedText = self.attributedText.theme_replaceRealityColor;
    }
}

// MARK: - ================ Setters ===========================

- (void)setTheme_textColor:(NSString *)color {
    self.textColor = [UIColor sd_colorWithID:color];
    objc_setAssociatedObject(self, @selector(theme_textColor), color, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

- (void)setTheme_attributedText:(NSAttributedString *)attributedText {
    self.attributedText = attributedText.theme_replaceRealityColor;
    [self theme_registChangedNotification];
}

- (void)setSDTextColorID:(NSString *)SDTextColorID {
    self.theme_textColor = SDTextColorID;
}

- (void)setSd_textColor:(NSString *)sd_textColor {
    self.theme_textColor = sd_textColor;
}

// MARK: - ================ Getters ===========================

- (NSString *)theme_textColor {
    return objc_getAssociatedObject(self, @selector(theme_textColor));
}

- (NSAttributedString *)theme_attributedText {
    return self.attributedText;
}

- (NSString *)sd_textColor {
    return self.theme_textColor;
}

@end
