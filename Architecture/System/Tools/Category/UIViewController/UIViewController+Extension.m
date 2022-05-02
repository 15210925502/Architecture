//
//  UIViewController+Extension.m
//  YMOCCodeStandard
//
//  Created by iOS on 2018/9/18.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    if (@available(iOS 13.0, *)) {
        static UIView *statusBar = nil;
        if(!statusBar) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                UIWindow *tempWindow = [BaseTools getKeyWindow];
                statusBar = [[UIView alloc] initWithFrame:tempWindow.windowScene.statusBarManager.statusBarFrame];
                [tempWindow addSubview:statusBar];
                statusBar.backgroundColor = color;
            });
        }else{
            statusBar.backgroundColor = color;
        }
    }else{
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = color;
        }
    }
}

#pragma mark -- 返回到指定的控制器
- (void)ym_backToController:(NSString *)controllerName animated:(BOOL)animaed {
    if (self.navigationController) {
        NSArray *controllers = self.navigationController.viewControllers;
        NSArray *result = [controllers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [evaluatedObject isKindOfClass:NSClassFromString(controllerName)];
        }]];
        
        if (result.count > 0) {
            [self.navigationController popToViewController:result[0] animated:animaed];
        }
    }
}

- (void)backToController:(NSString *)controllerName animated:(BOOL)animaed{
    if (self.navigationController) {
        NSArray *controllers = self.navigationController.viewControllers;
        for (UIViewController *VC in controllers) {
            if ([VC isKindOfClass:[controllerName class]]) {
                [self.navigationController popToViewController:VC animated:animaed];
                return;
            }
        }
    }
}

- (void)backRootVCAddNewVC:(UIViewController *)newVC{
    [self.navigationController pushViewController:newVC animated:YES];
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray:[self.navigationController viewControllers]];
    
    // 逆序遍历
    for (UIViewController *vc in [navigationArray reverseObjectEnumerator]) {
       if (vc != navigationArray.firstObject && vc != navigationArray.lastObject) {
           [navigationArray removeObject:vc];
       }
    }
    [self.navigationController setViewControllers:navigationArray animated:YES];
}

- (void)addChildController:(UIViewController *)childController intoView:(UIView *)view  {
    [self addChildViewController:childController];
    [view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
}

@end
