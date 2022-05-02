//
//  HLDTabBar.h
//  Architecture
//
//  Created by HLD on 2020/5/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLDCenterTabBarButton.h"
@class HLDTabBar;

@protocol HLDTabBarDelegate <NSObject>

@optional
/*! 中间按钮点击会通过这个代理通知你通知 */
- (void)tabbar:(HLDTabBar *)tabbar clickForCenterButton:(HLDCenterTabBarButton *)centerButton;

@end

@interface HLDTabBar : UITabBar

/** 委托 */
@property(nonatomic,weak) id<HLDTabBarDelegate> hldDelegate;

/**
 * 设置中间按钮
 * @param title               底部文字
 * @param normalImageName     未选中的图片名
 * @param selectedImageName   选中的图片名
 * @param tag                 标记
 * @param bulgeHeight         凸起的高度，为0不凸起
 */
- (void)tabBarItemWithTitle:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName tag:(NSInteger)tag bulgeHeight:(CGFloat)bulgeHeight;

@end
