//
//  UITextField+SDTheme.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "UITextField+SDTheme.h"
#import "NSObject+SDTheme.h"
#import "NSAttributedString+SDTheme.h"
#import "UIColor+SDExtension.h"
#import <objc/runtime.h>

@interface UITextField ()

@end

@implementation UITextField (SDTheme)

- (void)theme_didChanged {
    [super theme_didChanged];
    if (self.theme_textColor) {
        self.textColor = [UIColor sd_colorWithID:self.theme_textColor];
    }
    if (self.attributedPlaceholder) {
        self.attributedPlaceholder = self.attributedPlaceholder.theme_replaceRealityColor;
    }
}

// MARK: - ================ Setters ===========================

- (void)setTheme_textColor:(NSString *)color {
    self.textColor = [UIColor sd_colorWithID:color];
    objc_setAssociatedObject(self, @selector(theme_textColor), color, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

- (void)setTheme_attributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    self.attributedPlaceholder = attributedPlaceholder.theme_replaceRealityColor;
    [self theme_registChangedNotification];
}

// MARK: - ================ Getters ===========================

- (NSString *)theme_textColor {
    return objc_getAssociatedObject(self, @selector(theme_textColor));
}

- (NSAttributedString *)theme_attributedPlaceholder {
    return self.attributedPlaceholder;
}

@end
