//
//  UIImageView+SDTheme.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "UIImageView+SDTheme.h"
#import "NSObject+SDTheme.h"
#import "UIImage+SDExtension.h"
#import <objc/runtime.h>

@interface UIImageView ()

@end

@implementation UIImageView (SDTheme)

- (void)theme_didChanged {
    [super theme_didChanged];
    if (self.theme_image) {
        self.image = [UIImage sd_imageWithName:self.theme_image];
    }
}

// MARK: - ================ Setters ===========================

- (void)setTheme_image:(NSString *)image {
    self.image = [UIImage sd_imageWithName:image];
    objc_setAssociatedObject(self, @selector(theme_image), image, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

- (void)setSd_image:(NSString *)sd_image {
    self.theme_image = sd_image;
}

// MARK: - ================ Getters ===========================

- (NSString *)theme_image {
    return objc_getAssociatedObject(self, @selector(theme_image));
}

- (NSString *)sd_image {
    return self.theme_image;
}

@end
