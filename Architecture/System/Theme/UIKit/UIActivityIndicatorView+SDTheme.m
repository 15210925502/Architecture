//
//  UIActivityIndicatorView+SDTheme.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "UIActivityIndicatorView+SDTheme.h"
#import "NSObject+SDTheme.h"
#import "UIColor+SDExtension.h"
#import <objc/runtime.h>

@implementation UIActivityIndicatorView (SDTheme)

- (void)theme_didChanged {
    [super theme_didChanged];
    if (self.theme_color) {
        self.color = [UIColor sd_colorWithID:self.theme_color];
    }
}

// MARK: - ================ Setters ===========================

- (void)setTheme_color:(NSString *)color {
    self.color = [UIColor sd_colorWithID:color];
    objc_setAssociatedObject(self, @selector(theme_color), color, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

// MARK: - ================ Getters ===========================

- (NSString *)theme_color {
    return objc_getAssociatedObject(self, @selector(theme_color));
}

@end
