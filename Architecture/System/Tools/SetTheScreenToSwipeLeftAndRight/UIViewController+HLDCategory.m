//
//  UIViewController+HLDCategory.m
//  Architecture
//
//  Created by HLD on 2020/5/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "UIViewController+HLDCategory.h"

static const void *HLDInteractivePopKey = @"HLDInteractivePopKey";
static const void *HLDFullScreenPopKey  = @"HLDFullScreenPopKey";
static const void *HLDPopMaxDistanceKey = @"HLDPopMaxDistanceKey";
static const void *HLDPushDelegateKey   = @"HLDPushDelegateKey";

@implementation UIViewController (HLDCategory)

// 方法交换
+ (void)load {
    // 保证其只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        hld_swizzled_method(class, @selector(viewDidAppear:) ,@selector(hld_viewDidAppear:));
    });
}

- (void)hld_viewDidAppear:(BOOL)animated {
    // 在每次视图出现的时候重新设置当前控制器的手势
    [[NSNotificationCenter defaultCenter] postNotificationName:HLD_VC_PROPERTY_CHANGED_NOTIFICATION object:@{@"viewController": self}];
    [self hld_viewDidAppear:animated];
}

- (BOOL)hld_interactivePopDisabled {
    return [objc_getAssociatedObject(self, HLDInteractivePopKey) boolValue];
}

- (void)setHld_interactivePopDisabled:(BOOL)hld_interactivePopDisabled {
    objc_setAssociatedObject(self, HLDInteractivePopKey, @(hld_interactivePopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // 当属性改变时，发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:HLD_VC_PROPERTY_CHANGED_NOTIFICATION object:@{@"viewController": self}];
}

- (BOOL)hld_fullScreenPopDisabled {
    return [objc_getAssociatedObject(self, HLDFullScreenPopKey) boolValue];
}

- (void)setHld_fullScreenPopDisabled:(BOOL)hld_fullScreenPopDisabled {
    objc_setAssociatedObject(self, HLDFullScreenPopKey, @(hld_fullScreenPopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // 当属性改变时，发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:HLD_VC_PROPERTY_CHANGED_NOTIFICATION object:@{@"viewController": self}];
}

- (CGFloat)hld_popMaxAllowedDistanceToLeftEdge {
    return [objc_getAssociatedObject(self, HLDPopMaxDistanceKey) floatValue];
}

- (void)setHld_popMaxAllowedDistanceToLeftEdge:(CGFloat)hld_popMaxAllowedDistanceToLeftEdge {
    objc_setAssociatedObject(self, HLDPopMaxDistanceKey, @(hld_popMaxAllowedDistanceToLeftEdge), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 当属性改变时，发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:HLD_VC_PROPERTY_CHANGED_NOTIFICATION object:@{@"viewController": self}];
}

- (id<HLDVCRightSlidePushDelegate>)hld_rightSlidePushDelegate {
    return objc_getAssociatedObject(self, HLDPushDelegateKey);
}

- (void)setHld_rightSlidePushDelegate:(id<HLDVCRightSlidePushDelegate>)hld_rightSlidePushDelegate {
    objc_setAssociatedObject(self, HLDPushDelegateKey, hld_rightSlidePushDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
