//
//  UIView+SDTheme.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "UIView+SDTheme.h"
#import "NSObject+SDTheme.h"
#import "UIColor+SDExtension.h"
#import <objc/runtime.h>

@interface UIView ()

@end

@implementation UIView (SDTheme)

- (void)theme_didChanged {
    [super theme_didChanged];
    if (self.theme_backgroundColor) {
        self.backgroundColor = [UIColor sd_colorWithID:self.theme_backgroundColor];
    }
    if (self.theme_tintColor) {
        self.tintColor = [UIColor sd_colorWithID:self.theme_tintColor];
    }
}

// MARK: - ================ Setters ===========================

- (void)setTheme_backgroundColor:(NSString *)backgroundColorId {
    self.backgroundColor = [UIColor sd_colorWithID:backgroundColorId];
    objc_setAssociatedObject(self, @selector(theme_backgroundColor), backgroundColorId, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

- (void)setTheme_tintColor:(NSString *)tintColorId {
    self.tintColor = [UIColor sd_colorWithID:tintColorId];
    objc_setAssociatedObject(self, @selector(theme_tintColor), tintColorId, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

- (void)setSd_background:(NSString *)sd_background {
    self.theme_backgroundColor = sd_background;
}

// MARK: - ================ Getters ===========================

- (NSString *)theme_backgroundColor {
    return objc_getAssociatedObject(self, @selector(theme_backgroundColor));
}

- (NSString *)theme_tintColor {
    return objc_getAssociatedObject(self, @selector(theme_tintColor));
}

- (NSString *)sd_background {
    return self.theme_backgroundColor;
}

@end
