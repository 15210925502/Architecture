//
//  UIViewController+Extension.h
//  YMOCCodeStandard
//
//  Created by iOS on 2018/9/18.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Extension)

///    设置状态栏的背景颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color;

/**
 返回到指定的控制器
 
 @param controllerName 要返回的控制器的名字
 @param animaed 是否有动画
 */
- (void)ym_backToController:(NSString *)controllerName animated:(BOOL)animaed;
- (void)backToController:(NSString *)controllerName animated:(BOOL)animaed;
///    返回根控制器后并添加新控制器
- (void)backRootVCAddNewVC:(UIViewController *)newVC;

/**
 * 在当前视图控制器中添加子控制器，将子控制器的视图添加到 view 中
 *
 * @param childController 要添加的子控制器
 * @param view            要添加到的视图
 */
- (void)addChildController:(UIViewController *)childController intoView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
