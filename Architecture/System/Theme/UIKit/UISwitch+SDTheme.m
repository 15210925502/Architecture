//
//  UISwitch+SDTheme.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "UISwitch+SDTheme.h"
#import "NSObject+SDTheme.h"
#import "UIColor+SDExtension.h"
#import <objc/runtime.h>

@interface UISwitch ()

@end

@implementation UISwitch (SDTheme)

- (void)theme_didChanged {
    [super theme_didChanged];
    if (self.theme_onTintColor) {
        UIColor *color = [UIColor sd_colorWithID:self.theme_onTintColor];
        self.onTintColor = color;
    }
    if (self.theme_thumbTintColor) {
        UIColor *color = [UIColor sd_colorWithID:self.theme_thumbTintColor];
        self.thumbTintColor = color;
    }
}

// MARK: - ================ Setter ===========================

- (void)setTheme_onTintColor:(NSString *)color {
    self.onTintColor = [UIColor sd_colorWithID:color];
    objc_setAssociatedObject(self, @selector(theme_onTintColor), color, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

- (void)setTheme_thumbTintColor:(NSString *)color {
    self.thumbTintColor = [UIColor sd_colorWithID:color];
    objc_setAssociatedObject(self, @selector(theme_thumbTintColor), color, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

// MARK: - ================ Getter ===========================

- (NSString *)theme_onTintColor {
    return objc_getAssociatedObject(self, @selector(theme_onTintColor));
}

- (NSString *)theme_thumbTintColor {
    return objc_getAssociatedObject(self, @selector(theme_thumbTintColor));
}

@end
