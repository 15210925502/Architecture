//
//  UITableView+SDTheme.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "UITableView+SDTheme.h"
#import "NSObject+SDTheme.h"
#import "UIColor+SDExtension.h"
#import <objc/runtime.h>

@implementation UITableView (SDTheme)

- (void)theme_didChanged {
    [super theme_didChanged];
    if (self.theme_separatorColor) {
        self.separatorColor = [UIColor sd_colorWithID:self.theme_separatorColor];
    }
}

// MARK: - ================ Setters ===========================

- (void)setTheme_separatorColor:(NSString *)separatorColor {
    self.separatorColor = [UIColor sd_colorWithID:separatorColor];
    objc_setAssociatedObject(self, @selector(theme_separatorColor), separatorColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

// MARK: - ================ Getters ===========================

- (NSString *)theme_separatorColor {
    return objc_getAssociatedObject(self, @selector(theme_separatorColor));
}

@end
