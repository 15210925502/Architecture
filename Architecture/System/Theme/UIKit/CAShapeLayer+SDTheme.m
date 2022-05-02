//
//  CAShapeLayer+SDTheme.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "CAShapeLayer+SDTheme.h"
#import "NSObject+SDTheme.h"
#import "UIColor+SDExtension.h"
#import <objc/runtime.h>

@implementation CAShapeLayer (SDTheme)

- (void)theme_didChanged {
    [super theme_didChanged];
    if (self.theme_fillColor) {
        self.fillColor = [UIColor sd_colorWithID:self.theme_fillColor].CGColor;
    }
    if (self.theme_strokeColor) {
        self.strokeColor = [UIColor sd_colorWithID:self.theme_strokeColor].CGColor;
    }
}

// MARK: - ================ Setter ===========================

- (void)setTheme_fillColor:(NSString *)color {
    self.fillColor = [UIColor sd_colorWithID:color].CGColor;
    objc_setAssociatedObject(self, @selector(theme_fillColor), color, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

- (void)setTheme_strokeColor:(NSString *)color {
    self.strokeColor = [UIColor sd_colorWithID:color].CGColor;
    objc_setAssociatedObject(self, @selector(theme_strokeColor), color, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

// MARK: - ================ Getter ===========================

- (NSString *)theme_fillColor {
    return objc_getAssociatedObject(self, @selector(theme_fillColor));
}

- (NSString *)theme_strokeColor {
    return objc_getAssociatedObject(self, @selector(theme_strokeColor));
}

@end
