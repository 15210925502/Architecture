//
//  HLDTabBarController.h
//  Architecture
//
//  Created by HLD on 2020/5/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLDTabBar.h"

@interface HLDTabBarController : UITabBarController

@property (nonatomic,strong) HLDTabBar *tabbar;

/**
 * 添加子控制器
 * @param controller          需管理的子控制器
 * @param title               底部文字
 * @param normalImageName     未选中的图片名
 * @param selectedImageName   选中的图片名
 */
- (void)addChildController:(UIViewController *)controller title:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName;

/**
 * 设置中间按钮
 * @param controller          需管理的子控制器，控制器可以为nil，实现代理方法，自定义操作
 * @param title               底部文字，可以不传，不传图片占据整个控件
 * @param normalImageName     未选中的图片名
 * @param selectedImageName   选中的图片名
 * @param bulgeHeight         凸起的高度，为0不凸起
 */
- (void)addCenterController:(UIViewController *)controller title:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName bulgeHeight:(CGFloat)bulgeHeight;

/**
 * 隐藏tabbar
 * @param hidden            是否隐藏
 * @param animated          是否执行动画
 * 以下是swift调用方法
 * (self.tabBarController as! HLDTabBarController).setHLDTabBarHidden(true, animated: false)
 */
- (void)setHLDTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

/**
 * 为tabBarButton添加动画
 * @param array            动画图片数组
 */
- (void)addTabBarButtonAnimationWithImageArray:(NSArray *)array;

/**
 * 移除tabBarButton动画
 */
- (void)removeTabBarButtonAnimation;

@end
