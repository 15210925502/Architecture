//
//  CALayer+SDTheme.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "CALayer+SDTheme.h"
#import "NSObject+SDTheme.h"
#import "UIColor+SDExtension.h"
#import <objc/runtime.h>

@interface CALayer ()

@end

@implementation CALayer (SDTheme)

- (void)theme_didChanged {
    [super theme_didChanged];
    if (self.theme_borderColor) {
        self.borderColor = [UIColor sd_colorWithID:self.theme_borderColor].CGColor;
    }
    if (self.theme_shadowColor) {
        self.shadowColor = [UIColor sd_colorWithID:self.theme_shadowColor].CGColor;
    }
    if (self.theme_backgroundColor) {
        self.backgroundColor = [UIColor sd_colorWithID:self.theme_backgroundColor].CGColor;
    }
}

// MARK: - ================ Setter ===========================

- (void)setTheme_borderColor:(NSString *)color {
    self.borderColor = [UIColor sd_colorWithID:color].CGColor;
    objc_setAssociatedObject(self, @selector(theme_borderColor), color, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

- (void)setTheme_shadowColor:(NSString *)color {
    self.shadowColor = [UIColor sd_colorWithID:color].CGColor;
    objc_setAssociatedObject(self, @selector(theme_shadowColor), color, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

- (void)setTheme_backgroundColor:(NSString *)color {
    self.backgroundColor = [UIColor sd_colorWithID:color].CGColor;
    objc_setAssociatedObject(self, @selector(theme_backgroundColor), color, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

// MARK: - ================ Getter ===========================

- (NSString *)theme_borderColor {
    return objc_getAssociatedObject(self, @selector(theme_borderColor));
}

- (NSString *)theme_shadowColor {
    return objc_getAssociatedObject(self, @selector(theme_shadowColor));
}

- (NSString *)theme_backgroundColor {
    return objc_getAssociatedObject(self, @selector(theme_backgroundColor));
}

@end
