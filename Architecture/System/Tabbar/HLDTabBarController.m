//
//  HLDTabBarController.m
//  Architecture
//
//  Created by HLD on 2020/5/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "HLDTabBarController.h"

@interface HLDTabBarController ()<UITabBarControllerDelegate>

//    当前选中的tabBarItem
@property (nonatomic,assign) NSInteger currentSelectTabBarIndex;
//    tabBarItem的tag
@property (nonatomic,assign) NSInteger tabBarItemTag;

@end

@implementation HLDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置代理监听tabBar的点击
    self.delegate = self;
    self.tabBarItemTag = 0;
    
    HLDNavigationConfig *config = [HLDNavigationConfig sharedManage];
    
    EasyNavigationOptions *options = [EasyNavigationOptions shareInstance];
    
    options.titleColor = config.navigationTitleColor;
    options.buttonTitleFont = [UIFont setFontSizeWithValue:config.navigationTitleFontSize];
    options.buttonTitleColor = config.navigationButtonNormalTitleColor;
    options.buttonTitleColorHieght = config.navigationButtonSelectedTitleColor;
    options.navigationBackButtonImage = [UIImage sd_imageWithName:config.navigationBackButtonImage];
    
    self.tabbar = [[HLDTabBar alloc] init];
    [self setValue:self.tabbar forKeyPath:@"tabBar"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.selectedIndex = [HLDNavigationConfig sharedManage].selectTabBarIndex;
    self.currentSelectTabBarIndex = self.selectedIndex;
}

- (void)addChildController:(UIViewController *)controller title:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName{
    EasyNavigationController *nav = [[EasyNavigationController alloc] initWithRootViewController:controller];
    nav.hld_rightSlidePushEnable = YES;
    nav.tabBarItem.title = title;
    //    UIImageRenderingModeAlwaysOriginal:让图片原样显示
    nav.tabBarItem.image = [[UIImage sd_imageWithName:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[UIImage sd_imageWithName:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.tag = self.tabBarItemTag ++;
    [self setSelectedTitleTextWithTabbarItem:nav.tabBarItem];
    [self addChildViewController:nav];
}

- (void)addCenterController:(UIViewController *)controller title:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName bulgeHeight:(CGFloat)bulgeHeight{
    [self.tabbar tabBarItemWithTitle:title normalImageName:normalImageName selectedImageName:selectedImageName tag:self.tabBarItemTag bulgeHeight:bulgeHeight];
    [self addChildController:controller title:nil normalImageName:nil selectedImageName:nil];
}

#pragma mark - 设置文字、图片选中的状态效果
- (void)setSelectedTitleTextWithTabbarItem:(UITabBarItem *)tabbarItem{
    HLDNavigationConfig *config = [HLDNavigationConfig sharedManage];
    // 正常状态下的文字
    NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
    normalAttr[NSForegroundColorAttributeName] = config.tabBarNormalTextColor;
    normalAttr[NSFontAttributeName] = [UIFont setFontSizeWithValue:config.tabBarTitleFontSize];
    // 设置对应的颜色
    [tabbarItem setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    
    // 选中状态下的文字
    NSMutableDictionary *selectedAttr = [NSMutableDictionary dictionary];
    selectedAttr[NSForegroundColorAttributeName] = [UIColor sd_colorWithID:config.tabBarSelectedTextColor];
    selectedAttr[NSFontAttributeName] = [UIFont setFontSizeWithValue:config.tabBarTitleFontSize];
    [tabbarItem setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"点击的item:%ld Title:%@",(long)item.tag,item.title);
}

//1、视图将要切换时调用，viewController为将要显示的控制器，如果返回的值为NO，则无法点击其它分栏了（viewController指代将要显示的控制器）
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    NSLog(@"被选中的控制器将要显示的按钮");
    [self removeTabBarButtonAnimation];
    return YES;
}

//2、视图已经切换后调用，viewController 是已经显示的控制器
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"视图显示后调用");
    HLDNavigationConfig *config = [HLDNavigationConfig sharedManage];
    if (config.animationButtonIndex == self.selectedIndex) {
        [self addTabBarButtonAnimationWithImageArray:config.animationImageNameArray];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeTabBarButtonAnimation];
        });
    }
    self.currentSelectTabBarIndex = self.selectedIndex;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    NSLog(@"设置选中按钮下标");
    [self removeTabBarButtonAnimation];
    if (selectedIndex >= self.viewControllers.count){
        @throw [NSException exceptionWithName:@"selectedTabbarError"
                                       reason:@"No controller can be used,Because of index beyond the viewControllers,Please check the configuration of tabbar."
                                     userInfo:nil];
    }
    [super setSelectedIndex:selectedIndex];
}

- (void)addTabBarButtonAnimationWithImageArray:(NSArray *)array{
    if (self.currentSelectTabBarIndex == self.selectedIndex) {
        UIImageView *imageView = [self getTabBarBtnImageView];
        NSMutableArray *animationImageArray = [NSMutableArray arrayWithCapacity:array.count];
        for (NSString *imageName in array) {
            [animationImageArray addObject:[UIImage sd_imageWithName:imageName]];
        }
        imageView.animationImages = animationImageArray.copy;
        imageView.animationDuration = animationImageArray.count * 0.08;
        [imageView startAnimating];
    }
}

- (void)removeTabBarButtonAnimation{
    UIImageView *imageView = [self getTabBarBtnImageView];
    [imageView stopAnimating];
}

//获取tabBarBtn的图片
- (UIImageView *)getTabBarBtnImageView{
    UIButton *tabBarBtn = self.tabBar.subviews[self.selectedIndex + 1];
    Class clase = NSClassFromString(@"UITabBarSwappableImageView");
    UIImageView *imageView = nil;  // 获取对应的ImageView，添加动画。
    for (UIView *view in tabBarBtn.subviews) {
        if ([view isKindOfClass:clase]) {
            imageView = (UIImageView *)view;
            break;
        }
    }
    return imageView;
}

- (void)setHLDTabBarHidden:(BOOL)hidden animated:(BOOL)animated{
    NSTimeInterval time = animated ? 0.3 : 0.0;
    if (hidden) {
        [UIView animateWithDuration:time animations:^{
            self.tabBar.topValue = BaseTools.screenHeight;
        }completion:^(BOOL finished) {
            self.tabBar.hidden = YES;
        }];
    }else{
        self.tabBar.hidden = NO;
        [UIView animateWithDuration:time animations:^{
            self.tabBar.topValue = BaseTools.screenHeight - self.tabbar.heightValue;
        }];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
