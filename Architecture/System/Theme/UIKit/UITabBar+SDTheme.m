//
//  UITabBar+SDTheme.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "UITabBar+SDTheme.h"
#import "NSObject+SDTheme.h"
#import "UIColor+SDExtension.h"
#import <objc/runtime.h>

@interface UITabBar ()

@end

@implementation UITabBar (SDTheme)

- (void)theme_didChanged {
    [super theme_didChanged];
    if (self.theme_barTintColor) {
        self.barTintColor = [UIColor sd_colorWithID:self.theme_barTintColor];
    }
    if (self.theme_unselectedItemTintColor) {
        if (@available(iOS 10.0, *)) {
            UIColor *color = [UIColor sd_colorWithID:self.theme_unselectedItemTintColor];
            self.unselectedItemTintColor = color;
        } else {
            // Fallback on earlier versions
        }
    }
}

// MARK: - ================ Setters ===========================

- (void)setTheme_barTintColor:(NSString *)barTintColor {
    self.barTintColor = [UIColor sd_colorWithID:barTintColor];
    objc_setAssociatedObject(self, @selector(theme_barTintColor), barTintColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

// MARK: - ================ Getters ===========================

- (NSString *)theme_barTintColor {
    return objc_getAssociatedObject(self, @selector(theme_barTintColor));
}

// MARK: - ================ Setters ===========================

- (void)setTheme_unselectedItemTintColor:(NSString *)unselectedItemTintColor {
    if (@available(iOS 10.0, *)) {
        self.unselectedItemTintColor = [UIColor sd_colorWithID:unselectedItemTintColor];
        objc_setAssociatedObject(self, @selector(theme_unselectedItemTintColor), unselectedItemTintColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self theme_registChangedNotification];
    } else {
        // Fallback on earlier versions
    }
}

// MARK: - ================ Getters ===========================

- (NSString *)theme_unselectedItemTintColor {
    return objc_getAssociatedObject(self, @selector(theme_unselectedItemTintColor));
}

@end
