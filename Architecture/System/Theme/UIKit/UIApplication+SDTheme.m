//
//  UIApplication+SDTheme.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "UIApplication+SDTheme.h"
#import "UIColor+SDExtension.h"
#import "NSObject+SDTheme.h"
#import <objc/runtime.h>

@interface UIApplication ()

@property (nonatomic, copy) NSString *theme_barColor;

@end

@implementation UIApplication (SDTheme)

- (void)theme_setStatusBarColor:(NSString *)color
                       animated:(BOOL)animated{
    self.theme_barColor = color;
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIStatusBarStyle barStyle = [self barStyleWithColorId:color];
    [self setStatusBarStyle:barStyle animated:animated];
#pragma clang diagnostic pop
    [self theme_registChangedNotification];
}

- (void)theme_didChanged {
    [super theme_didChanged];
    if (self.theme_barColor) {
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIStatusBarStyle barStyle = [self barStyleWithColorId:self.theme_barColor];
        [self setStatusBarStyle:barStyle animated:NO];
#pragma clang diagnostic pop
    }
}

- (UIStatusBarStyle)barStyleWithColorId:(NSString *)colorId {
    UIColor *barColor = [UIColor sd_colorWithID:colorId];
    if (CGColorEqualToColor(barColor.CGColor, [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor)) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

// MARK: - ================ Setters ===========================

- (void)setTheme_barColor:(NSString *)barColorId {
    objc_setAssociatedObject(self, @selector(theme_barColor), barColorId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// MARK: - ================ Getters ===========================

- (NSString *)theme_barColor {
    return objc_getAssociatedObject(self, @selector(theme_barColor));
}

@end
