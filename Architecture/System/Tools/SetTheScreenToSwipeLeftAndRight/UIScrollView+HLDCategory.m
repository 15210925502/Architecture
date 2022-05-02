//
//  UIScrollView+HLDCategory.m
//  Architecture
//
//  Created by HLD on 2020/5/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "UIScrollView+HLDCategory.h"
#import <objc/runtime.h>

static const void *HLDLeftGestureEnableDelegateKey   = @"HLDLeftGestureEnableDelegateKey";

@implementation UIScrollView (HLDCategory)

- (BOOL)hld_leftGestureEnable {
    return [objc_getAssociatedObject(self, HLDLeftGestureEnableDelegateKey) boolValue];
}

- (void)setHld_leftGestureEnable:(BOOL)hld_leftGestureEnable {
    objc_setAssociatedObject(self, HLDLeftGestureEnableDelegateKey, @(hld_leftGestureEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//此方法返回YES时，手势事件会一直往下传递(允许多手势触发)，不论当前层次是否对该事件进行响应。
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return [self panBack:gestureRecognizer];
//}

//返回值是返回是否生效。此方法在gesture recognizer视图转出UIGestureRecognizerStatePossible状态时调用，
//如果返回NO,则转换到UIGestureRecognizerStateFailed;
//如果返回YES,则继续识别触摸序列
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    //滑动速度
//    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
//    CGPoint location = [gestureRecognizer locationInView:self];
//    NSLog(@"velocity.x:%f----location.x:%d",velocity.x,(int)location.x%(int)[UIScreen mainScreen].bounds.size.width);
//    //x方向速度>0为右滑动，反之为左滑动
//    if (velocity.x > 0) {
//
//    }else{
//
//    }
    
    if (!self.hld_leftGestureEnable) {
        return YES;
    }
    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    return YES;
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGestureRecognizer) {
        CGPoint point = [self.panGestureRecognizer translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        // 设置手势滑动的位置距屏幕左边的区域
        CGFloat locationDistance = [UIScreen mainScreen].bounds.size.width;
        if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStatePossible) {
            CGPoint location = [gestureRecognizer locationInView:self];
            if (point.x > 0 && location.x < locationDistance && self.contentOffset.x <= 0) {
                return YES;
            }
            
            // 临界点：scrollView滑动到最后一屏时的x轴的位置，可根据需求改变
            CGFloat criticalPoint = self.contentSize.width - [UIScreen mainScreen].bounds.size.width;
            
            // point.x < 0 代表左滑
            // 当UIScrollView滑动到临界点时，则不再响应UIScrollView的滑动手势，防止与右滑push功能冲突
            if (point.x < 0 && self.contentOffset.x == criticalPoint) {
                return YES;
            }
        }
    }
    return NO;
}

@end
