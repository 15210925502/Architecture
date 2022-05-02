//
//  UIViewController+HLDCategory.h
//  Architecture
//
//  Created by HLD on 2020/5/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define HLD_VC_PROPERTY_CHANGED_NOTIFICATION    @"HLDVCPropertyChangedNotification"

// 使用static inline创建静态内联函数，方便调用
static inline void hld_swizzled_method(Class class ,SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL isAdd = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (isAdd) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}



/**
 *  右滑push代理
 */
// 交给单独控制器处理
@protocol HLDVCRightSlidePushDelegate <NSObject>

//有滑push代理方法重写
@optional
- (void)rightSlidePushToNextViewController;

@end





@interface UIViewController (HLDCategory)

/** 是否禁止当前控制器的滑动返回(包括全屏返回和边缘返回)，默认为NO */
@property (nonatomic, assign) BOOL hld_interactivePopDisabled;
/** 是否禁止当前控制器的全屏滑动返回(是否禁止全屏滑动，支持边缘滑动)，默认为NO */
@property (nonatomic, assign) BOOL hld_fullScreenPopDisabled;
/** 全屏滑动时，滑动区域距离屏幕左边的最大位置，默认是0：表示全屏都可滑动 */
@property (nonatomic, assign) CGFloat hld_popMaxAllowedDistanceToLeftEdge;
/** 右滑push代理 */
@property (nonatomic, assign) id<HLDVCRightSlidePushDelegate> hld_rightSlidePushDelegate;

@end
