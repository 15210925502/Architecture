//
//  UIPageControl+SDTheme.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "UIPageControl+SDTheme.h"
#import "NSObject+SDTheme.h"
#import "UIColor+SDExtension.h"
#import <objc/runtime.h>

@interface UIPageControl ()

@end

@implementation UIPageControl (SDTheme)

- (void)theme_didChanged {
    [super theme_didChanged];
    if (self.theme_pageIndicatorTintColor) {
        self.pageIndicatorTintColor = [UIColor sd_colorWithID:self.theme_pageIndicatorTintColor];
    }
    if (self.theme_currentPageIndicatorTintColor) {
        self.currentPageIndicatorTintColor = [UIColor sd_colorWithID:self.theme_currentPageIndicatorTintColor];
    }
}

// MARK: - ================ Setters ===========================

- (void)setTheme_pageIndicatorTintColor:(NSString *)pageIndicatorTintColor {
    [self setPageIndicatorTintColor:[UIColor sd_colorWithID:pageIndicatorTintColor]];
    objc_setAssociatedObject(self, @selector(theme_pageIndicatorTintColor), pageIndicatorTintColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

- (void)setTheme_currentPageIndicatorTintColor:(NSString *)currentPageIndicatorTintColor {
    [self setCurrentPageIndicatorTintColor:[UIColor sd_colorWithID:currentPageIndicatorTintColor]];
    objc_setAssociatedObject(self, @selector(theme_currentPageIndicatorTintColor), currentPageIndicatorTintColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

// MARK: - ================ Getters ===========================

- (NSString *)theme_pageIndicatorTintColor {
    return objc_getAssociatedObject(self, @selector(theme_pageIndicatorTintColor));
}

- (NSString *)theme_currentPageIndicatorTintColor {
    return objc_getAssociatedObject(self, @selector(theme_currentPageIndicatorTintColor));
}

@end
