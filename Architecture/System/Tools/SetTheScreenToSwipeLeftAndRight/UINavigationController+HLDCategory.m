//
//  UINavigationController+HLDCategory.m
//  Architecture
//
//  Created by HLD on 2020/5/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "UINavigationController+HLDCategory.h"
#import "UIViewController+HLDCategory.h"

@implementation UINavigationController (HLDCategory)

// 方法交换
+ (void)load {
    // 保证其只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        hld_swizzled_method(class, @selector(viewDidLoad), @selector(hld_viewDidLoad));
    });
}

- (void)hld_viewDidLoad {
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:HLD_VC_PROPERTY_CHANGED_NOTIFICATION object:nil];
    [self hld_viewDidLoad];
}

#pragma mark - Notification Handle
- (void)handleNotification:(NSNotification *)notify {
    UIViewController *vc = (UIViewController *)notify.object[@"viewController"];
    BOOL isRootVC = vc == self.viewControllers.firstObject;
    if (vc.hld_interactivePopDisabled) { // 禁止滑动
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = NO;
    }else if (vc.hld_fullScreenPopDisabled) { // 禁止全屏滑动，支持边缘滑动
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.panGesture];
        self.interactivePopGestureRecognizer.delaysTouchesBegan = YES;
        self.interactivePopGestureRecognizer.delegate = self.popGestureDelegate;
        self.interactivePopGestureRecognizer.enabled = !isRootVC;
    }else {// 支持全屏滑动
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = NO;
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.screenPanGesture];
        if (!isRootVC && ![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.panGesture]) {
            [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.panGesture];
            self.panGesture.delegate = self.popGestureDelegate;
        }
        if (self.hld_rightSlidePushEnable) {
            [self.panGesture addTarget:self.navDelegate action:@selector(panGestureAction:)];
        }else {
            SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
            [self.panGesture addTarget:[self systemTarget] action:internalAction];
        }
    }
}

- (BOOL)hld_rightSlidePushEnable {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHld_rightSlidePushEnable:(BOOL)hld_rightSlidePushEnable {
    objc_setAssociatedObject(self, @selector(hld_rightSlidePushEnable), @(hld_rightSlidePushEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HLDPopGestureRecognizerDelegate *)popGestureDelegate {
    HLDPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (!delegate) {
        delegate = [[HLDPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        delegate.systemTarget         = [self systemTarget];
        delegate.customTarget         = self.navDelegate;
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (HLDNavigationControllerDelegate *)navDelegate {
    HLDNavigationControllerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (!delegate) {
        delegate = [[HLDNavigationControllerDelegate alloc] init];
        delegate.navigationController = self;
        delegate.rightScrollPushDelegate         = self;
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIScreenEdgePanGestureRecognizer *)screenPanGesture {
    UIScreenEdgePanGestureRecognizer *panGesture = objc_getAssociatedObject(self, _cmd);
    if (!panGesture) {
        panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.navDelegate action:@selector(panGestureAction:)];
        panGesture.edges = UIRectEdgeLeft;
        objc_setAssociatedObject(self, _cmd, panGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGesture;
}

- (UIPanGestureRecognizer *)panGesture {
    UIPanGestureRecognizer *panGesture = objc_getAssociatedObject(self, _cmd);
    if (!panGesture) {
        panGesture = [[UIPanGestureRecognizer alloc] init];
        panGesture.maximumNumberOfTouches = 1;
        objc_setAssociatedObject(self, _cmd, panGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGesture;
}

- (id)systemTarget {
    NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
    id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
    return internalTarget;
}

#pragma mark - HLDVCRightScrollPushDelegate
- (void)rightSlidePushNext {
    // 获取当前控制器
    UIViewController *currentVC = self.visibleViewController;
    if ([currentVC.hld_rightSlidePushDelegate respondsToSelector:@selector(rightSlidePushToNextViewController)]) {
        [currentVC.hld_rightSlidePushDelegate rightSlidePushToNextViewController];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HLD_VC_PROPERTY_CHANGED_NOTIFICATION object:nil];
}

@end
