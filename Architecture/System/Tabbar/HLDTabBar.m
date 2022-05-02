//
//  HLDTabBar.m
//  Architecture
//
//  Created by HLD on 2020/5/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "HLDTabBar.h"

@interface HLDTabBar ()

@property (nonatomic, strong) HLDCenterTabBarButton *centerBtn;
/** border */
@property (nonatomic,strong) CAShapeLayer *border;

@end

@implementation HLDTabBar

- (instancetype)init{
    self = [super init];
    if (self) {
        self.shadowImage = [[UIImage alloc] init];
        self.backgroundImage = [[UIImage alloc] init];
        
        HLDNavigationConfig *config = [HLDNavigationConfig sharedManage];
        self.theme_backgroundColor = config.tabBarBackgroundColor;
        if (config.tabBarBorderHeight > 0) {
            self.border.theme_fillColor = config.tabBarBordergColor;
        }
        
        if (@available(iOS 10.0, *)) {
            // 正常状态下文字颜色
            self.theme_unselectedItemTintColor = config.tabBarNormalTextColor;
        } else {

        }
    }
    return self;
}

- (void)tabBarItemWithTitle:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName tag:(NSInteger)tag bulgeHeight:(CGFloat)bulgeHeight{
    self.centerBtn = [HLDCenterTabBarButton buttonWithType:UIButtonTypeCustom];
    [self.centerBtn setImage:[[UIImage sd_imageWithName:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.centerBtn setImage:[[UIImage sd_imageWithName:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [self.centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.centerBtn setTitle:title forState:UIControlStateNormal];
    [self.centerBtn setTitle:title forState:UIControlStateSelected];
    self.centerBtn.bulgeHeight = [BaseTools adaptedWithValue:bulgeHeight];
    self.centerBtn.tag = tag;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.centerBtn) {
        int btnIndex = 0;
        for (UIView *btn in self.subviews){
            if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                if (btnIndex == self.centerBtn.tag) {
                    self.centerBtn.frame = CGRectMake(0, -self.centerBtn.bulgeHeight, btn.widthValue, btn.heightValue + self.centerBtn.bulgeHeight);
                    [btn insertSubview:self.centerBtn atIndex:0];
                    break;
                }
                btnIndex++;
            }
        }
    }
    CGFloat tabBarBorderHeight = [HLDNavigationConfig sharedManage].tabBarBorderHeight;
    if (tabBarBorderHeight > 0) {
        self.border.path = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,CGRectGetWidth(self.bounds),tabBarBorderHeight)].CGPath;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.centerBtn && self.isHidden == NO) {
        CGPoint newP = [self convertPoint:point toView:self.centerBtn];
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( [self.centerBtn pointInside:newP withEvent:event]) {
            return self.centerBtn;
        }else{ //如果点不在发布按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
    }
    //tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
    return [super hitTest:point withEvent:event];
}

- (void)centerBtnClick:(HLDCenterTabBarButton *)button{
//    以下判断控制器是否为nil，是执行代理方法，不是直接显示控制器
   UIWindow *myWindow = [BaseTools getKeyWindow];
    HLDTabBarController *tabBarController = (HLDTabBarController *)myWindow.rootViewController;
    NSArray *VCArray = tabBarController.viewControllers;
    if (VCArray.count > self.centerBtn.tag) {
        EasyNavigationController *centNavVC = [VCArray objectAtIndex:self.centerBtn.tag];
        if ([centNavVC isKindOfClass:[EasyNavigationController class]]) {
            if (centNavVC.topViewController != nil) {
                if (tabBarController.selectedIndex != self.centerBtn.tag) {
                    tabBarController.selectedIndex = self.centerBtn.tag;
                }
                return;
            }
        }
    }
    if ([self.hldDelegate respondsToSelector:@selector(tabbar:clickForCenterButton:)]) {
        [self.hldDelegate tabbar:self clickForCenterButton:button];
    }
}

- (CAShapeLayer *)border{
    if (!_border) {
        _border = [CAShapeLayer layer];
        [self.layer insertSublayer:_border atIndex:0];
    }
    return _border;
}

@end
