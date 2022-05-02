//
//  HLDDelegateHandler.m
//  Architecture
//
//  Created by HLD on 2020/5/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "HLDDelegateHandler.h"
#import "UIViewController+HLDCategory.h"
#import "UINavigationController+HLDCategory.h"

@implementation HLDPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    // 忽略跟控制器
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    // 忽略禁用手势
    UIViewController *topVC = self.navigationController.viewControllers.lastObject;
    if (topVC.hld_interactivePopDisabled) {
        return NO;
    }
    
    CGPoint transition = [gestureRecognizer translationInView:gestureRecognizer.view];
    
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    
    if (transition.x < 0) {
        if (self.navigationController.hld_rightSlidePushEnable) {
            [gestureRecognizer removeTarget:self.systemTarget action:action];
            [gestureRecognizer addTarget:self.customTarget action:@selector(panGestureAction:)];
        }else {
            return NO;
        }
    }else {
        // 忽略超出手势区域
        CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
        CGFloat maxAllowDistance  = topVC.hld_popMaxAllowedDistanceToLeftEdge;
        if (maxAllowDistance > 0 && beginningLocation.x > maxAllowDistance) {
            return NO;
        }else{
            [gestureRecognizer removeTarget:self.customTarget action:@selector(panGestureAction:)];
            [gestureRecognizer addTarget:self.systemTarget action:action];
        }
    }
    // 忽略导航控制器正在做转场动画
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    return YES;
}

@end








@interface HLDNavigationControllerDelegate()

@property (nonatomic, assign) BOOL isGesturePush;

@end

@implementation HLDNavigationControllerDelegate

#pragma mark - 滑动手势处理
- (void)panGestureAction:(UIPanGestureRecognizer *)gesture {
    // 进度
    CGFloat progress    = [gesture translationInView:gesture.view].x / gesture.view.bounds.size.width;
    CGPoint translation = [gesture velocityInView:gesture.view];
    
    // 在手势开始的时候判断是push操作还是pop操作
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.isGesturePush = translation.x < 0 ? YES : NO;
    }
    
    // push时 progress < 0 需要做处理
    if (self.isGesturePush) {
        progress = -progress;
    }
    
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.isGesturePush) {
            if (self.navigationController.hld_rightSlidePushEnable && [self.rightScrollPushDelegate respondsToSelector:@selector(rightSlidePushNext)]) {
                [self.rightScrollPushDelegate rightSlidePushNext];
            }
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        self.isGesturePush  = NO;
    }
}

@end
