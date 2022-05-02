//
//  UITabBarItem+SDTheme.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "UITabBarItem+SDTheme.h"
#import "NSObject+SDTheme.h"
#import "UIImage+SDExtension.h"
#import <objc/runtime.h>

@implementation UITabBarItem (SDTheme)

- (void)theme_didChanged {
    [super theme_didChanged];
    if (self.theme_selectedImage) {
        self.selectedImage = [[UIImage sd_imageWithName:self.theme_selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}

// MARK: - ================ Setters ===========================

- (void)setTheme_selectedImage:(NSString *)image {
    self.selectedImage = [[UIImage sd_imageWithName:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    objc_setAssociatedObject(self, @selector(theme_selectedImage), image, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

// MARK: - ================ Getters ===========================

- (NSString *)theme_selectedImage {
    return objc_getAssociatedObject(self, @selector(theme_selectedImage));
}

@end
