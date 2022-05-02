//
//  NSObject+SDTheme.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "NSObject+SDTheme.h"
#import "NSObject+SDDeallocBlock.h"
#import "SDThemeManager.h"
#import <objc/runtime.h>

static NSString *const kHasRegistChangedThemeNotification;

@interface NSObject ()

@property (nonatomic, copy) void(^theme_changeBlock)(id observer);

@end

@implementation NSObject (SDTheme)

- (void)theme_registChangedNotification {
    NSNumber *hasRegist = objc_getAssociatedObject(self, &kHasRegistChangedThemeNotification);
    if (hasRegist) {
        return;
    }
    objc_setAssociatedObject(self, &kHasRegistChangedThemeNotification, @(YES), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(theme_didChanged) name:SDThemeChangedNotification object:nil];
    __weak typeof(self) weakSelf = self;
    [self sd_executeAtDealloc:^{
        [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
    }];
}

- (void)theme_observerChangedUsingBlock:(void(^)(id observer))themeChangeBlock {
    self.theme_changeBlock = themeChangeBlock;
    [self theme_didChanged];
    [self theme_registChangedNotification];
}

- (void)theme_didChanged {
    if (self.theme_changeBlock) {
        __weak typeof(self) weakSelf = self;
        self.theme_changeBlock(weakSelf);
    }
}

- (void)setTheme_changeBlock:(void (^)(void))block {
    objc_setAssociatedObject(self, @selector(theme_changeBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))theme_changeBlock {
    return objc_getAssociatedObject(self, @selector(theme_changeBlock));
}

@end
