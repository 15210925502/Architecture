//
//  MBProgressHUD+Extension.m
//  WJTool
//
//  Created by 陈威杰 on 2017/6/2.
//  Copyright © 2017年 ChenWeiJie. All rights reserved.
//

#import "MBProgressHUD+Extension.h"
#import "WJColouredRibbonAnimation.h"
#import "WJSuccessView.h"
#import "MBProgressHUD.h"
#import "LoadingView.h"
#import <objc/message.h>

@implementation MBProgressHUD (WJExtension)

#pragma mark 显示一些信息

+ (void)wj_showText:(NSString *)text{
    [self wj_showText:text view:nil];
}

+ (void)wj_showSuccess{
    [self wj_showSuccess:nil];
}

+ (void)wj_showSuccess:(NSString *)success{
    [self wj_showSuccess:success
                  toView:nil];
}

+ (void)wj_showSuccess:(NSString *)success
                toView:(UIView *)view{
    [self show:success
 animationType:WJAnimationTypeSuccess
          view:view];
}

+ (void)wj_showSuccess:(NSString *)success
        hideAfterDelay:(NSTimeInterval)time
                toView:(UIView *)view{
    [self show:success
 animationType:WJAnimationTypeSuccess
hideAfterDelay:time
          view:view];
}

+ (void)wj_showError{
    [self wj_showError:nil];
}

+ (void)wj_showError:(NSString *)error{
    [self wj_showError:error
                toView:nil];
}

+ (void)wj_showError:(NSString *)error toView:(UIView *)view{
    [self show:error
 animationType:WJAnimationTypeError
          view:view];
}

+ (void)wj_showError:(NSString *)error
      hideAfterDelay:(NSTimeInterval)time
              toView:(UIView *)view{
    [self show:error
 animationType:WJAnimationTypeError
hideAfterDelay:time
          view:view];
}

+ (void)wj_showIcon:(UIImage *)icon
            message:(NSString *)message{
    [self wj_showIcon:icon
              message:message
                 view:nil];
}

+ (void)wj_showCustomView:(UIView *)customView
           hideAfterDelay:(NSTimeInterval)time
                   toView:(UIView *)view {
    [self wj_showCustomView:customView
                    message:nil
             hideAfterDelay:time
                     toView:view];
}

+ (void)wj_showCustomView:(UIView *)customView
           hideAfterDelay:(NSTimeInterval)time{
    [self wj_showCustomView:customView
                    message:nil
             hideAfterDelay:time
                     toView:nil];
}

+ (void)wj_showMessage:(NSString *)message
        hideAfterDelay:(NSTimeInterval)time
                toView:(UIView *)view
            customView:(UIView *(^)(void))customView{
    [self wj_showCustomView:customView()
                    message:message
             hideAfterDelay:time
                     toView:view];
}

+ (void)wj_showHideAfterDelay:(NSTimeInterval)time
                   customView:(UIView *(^)(void))customView {
    [self wj_showCustomView:customView()
             hideAfterDelay:time
                     toView:nil];
}

+ (instancetype)wj_showActivityLoadingToView:(UIView *)view{
    return [self wj_showActivityLoading:nil
                                 toView:view];
}

+ (instancetype)wj_showActivityLoading{
    return [self wj_showActivityLoadingToView:nil];
}

+ (instancetype)wj_showAnnularLoading:(NSString *)message
                               toView:(UIView *)view {
    return [self wj_showLoadingStyle:HUDLoadingStyleAnnularDeterminate
                             message:message
                              toView:view];
}

+ (instancetype)wj_showAnnularLoading {
    return [self wj_showAnnularLoading:nil
                                toView:nil];
}

+ (instancetype)wj_showDeterminateLoading:(NSString *)message
                                   toView:(UIView *)view {
    return [self wj_showLoadingStyle:HUDLoadingProgressStyleDeterminate
                             message:message
                              toView:view];
}

+ (instancetype)wj_showDeterminateLoading {
    return [self wj_showDeterminateLoading:nil
                                    toView:nil];
}

+ (instancetype)wj_showLoadingStyle:(HUDLoadingProgressStyle)style
                            message:(NSString *)message
                             toView:(UIView *)view{
    MBProgressHUD *hud = createNew(view);
    if (style == HUDLoadingProgressStyleDeterminate) {
        hud.mode = MBProgressHUDModeDeterminate;
    } else if (style == HUDLoadingStyleDeterminateHorizontalBar) {
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    } else if (style == HUDLoadingStyleAnnularDeterminate) {
        hud.mode = MBProgressHUDModeAnnularDeterminate;
    }
    if (message) {
        hud.label.text = message;
    }
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (instancetype)wj_showLoadingStyle:(HUDLoadingProgressStyle)style
                             toView:(UIView *)view {
    return [self wj_showLoadingStyle:style
                             message:nil
                              toView:view];
}

+ (instancetype)wj_showLoadingStyle:(HUDLoadingProgressStyle)style {
    return [self wj_showLoadingStyle:style
                              toView:nil];
}

+ (void)show:(NSString *)text
animationType:(WJAnimationType)animationType
        view:(UIView *)view{
    [self show:text
 animationType:animationType
hideAfterDelay:showTimeWithTitle(text)
          view:view];
}

+ (void)show:(NSString *)text
animationType:(WJAnimationType)animationType
hideAfterDelay:(NSTimeInterval)time
        view:(UIView *)view{
    WJSuccessView *suc = [[WJSuccessView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    suc.wj_animationType = animationType;
    [MBProgressHUD wj_showCustomView:suc
                             message:text
                      hideAfterDelay:time
                              toView:view];
}

+ (void)wj_showSuccessWithColouredRibbonAnimation:(NSString *)message {
    [self wj_showSuccess:message];
    [WJColouredRibbonAnimation wj_showSuccessColouredRibbonAnimationWithHideTime:1.0];
}

+ (void)wj_showSuccessWithColouredRibbonAnimation {
    [self wj_showSuccessWithColouredRibbonAnimation:nil];
}

+ (void)wj_showColouredRibbonAnimationWithHideTime:(NSTimeInterval)time{
    [WJColouredRibbonAnimation wj_showSuccessColouredRibbonAnimationWithHideTime:time];
}

+ (MBProgressHUD *)showLoadTitle:(NSString *)title{
    return [self showLoadTitle:title
                        toView:nil];
}

+ (UIView *)customLoadingViewWithType:(EKAppMBProgressType)eKAppMBProgressType  {
    UIView *customView = nil;
    switch (eKAppMBProgressType) {
        case EKAppMBProgressTypeDefault:
            customView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, [BaseTools adaptedWithValue:(70)], [BaseTools adaptedWithValue:(70)])];
            break;
        default:
            break;
    }
    return customView;
}

- (void)didClickCancelButton {
    if (self.cancelation) {
        self.cancelation(self);
    }
}

- (void)setCancelation:(Cancelation)cancelation {
    objc_setAssociatedObject(self, &cancelationKey, cancelation, OBJC_ASSOCIATION_COPY);
}

- (Cancelation)cancelation {
    return objc_getAssociatedObject(self, &cancelationKey);
}

- (MBProgressHUD *(^)(UIColor *))hudBackgroundColor {
    return ^(UIColor *hudBackgroundColor) {
        self.backgroundView.color = hudBackgroundColor;
        return self;
    };
}

- (MBProgressHUD *(^)(UIView *))toView {
    return ^(UIView *view){
        return self;
    };
}

- (MBProgressHUD *(^)(NSString *))title {
    return ^(NSString *title){
        self.label.text = title;
        return self;
    };
}

- (MBProgressHUD *(^)(NSString *))details {
    return ^(NSString *details){
        self.detailsLabel.text = details;
        return self;
    };
}

- (MBProgressHUD *(^)(NSString *))customIcon {
    return ^(NSString *customIcon) {
        self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:customIcon]];
        return self;
    };
}

- (MBProgressHUD *(^)(UIColor *))titleColor {
    return ^(UIColor *titleColor){
        self.label.textColor = titleColor;
        self.detailsLabel.textColor = titleColor;
        return self;
    };
}

- (MBProgressHUD *(^)(UIColor *))progressColor {
    return ^(UIColor *progressColor) {
        UIColor *titleColor = self.label.textColor;
        self.contentColor = progressColor;
        self.label.textColor = titleColor;
        self.detailsLabel.textColor = titleColor;
        return self;
    };
}

- (MBProgressHUD *(^)(UIColor *))allContentColors {
    return ^(UIColor *allContentColors) {
        self.contentColor = allContentColors;
        return self;
    };
}

- (MBProgressHUD *(^)(UIColor *))bezelBackgroundColor {
    return ^(UIColor *bezelViewColor){
        self.bezelView.backgroundColor = bezelViewColor;
        return self;
    };
}

- (MBProgressHUD *(^)(HUDContentStyle))hudContentStyle {
    return ^(HUDContentStyle hudContentStyle){
        if (hudContentStyle == HUDContentDefaultStyle){
            self.bezelView.style = MBProgressHUDBackgroundStyleBlur;
            self.contentColor = [UIColor blackColor];
            self.bezelView.backgroundColor = [UIColor whiteColor];
        }else if (hudContentStyle == HUDContentBlackStyle) {
            self.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.bezelView.backgroundColor = CustomHudStyleBackgrandColor;
            self.contentColor = [UIColor whiteColor];
            self.detailsLabel.textColor = [UIColor whiteColor];
        } else if (hudContentStyle == HUDContentCustomStyle) {
            self.bezelView.style = MBProgressHUDBackgroundStyleBlur;
            self.contentColor = CustomHudStyleContentColor;
            self.bezelView.backgroundColor = CustomHudStyleBackgrandColor;
        }
        return self;
    };
}

- (MBProgressHUD *(^)(HUDPostion))hudPostion {
    return ^(HUDPostion hudPostion){
        if (hudPostion == HUDPostionTop) {
            self.offset = CGPointMake(0.f, -MBProgressMaxOffset);
        } else if (hudPostion == HUDPostionCenten) {
            self.offset = CGPointMake(0.f, 0.f);
        } else {
            self.offset = CGPointMake(0.f, MBProgressMaxOffset);
        }
        return self;
    };
}

- (MBProgressHUD *(^)(HUDProgressStyle))hudProgressStyle {
    return ^(HUDProgressStyle hudProgressStyle){
        if (hudProgressStyle == HUDProgressDeterminate) {
            self.mode = MBProgressHUDModeDeterminate;
        } else if (hudProgressStyle == HUDProgressAnnularDeterminate) {
            self.mode = MBProgressHUDModeAnnularDeterminate;
        } else if (hudProgressStyle == HUDProgressCancelationDeterminate) {
            self.mode = MBProgressHUDModeDeterminate;
        } else if (hudProgressStyle == HUDProgressDeterminateHorizontalBar) {
            self.mode = MBProgressHUDModeDeterminateHorizontalBar;
        }
        return self;
    };
}

+ (void)hideHUD{
    [self hideHUDForView:nil];
}

+ (void)hideHUDForView:(UIView *)view {
    if (view == nil) {
        view = (UIView *)[BaseTools getKeyWindow];
    }
    [self hideHUDForView:view animated:YES];
}

+ (MBProgressHUD *)showOnlyLoadToView:(UIView *)view {
    return settHUD(view, nil, NO);
}

+ (void)showSuccess:(NSString *)success
             toView:(UIView *)view {
    MBProgressHUD *hud = settHUD(view, success, YES);
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
}

+ (void)wj_showText:(NSString *)text
               view:(UIView *)view{
    // 快速显示一个提示信息
    MBProgressHUD *hud = createNew(view);
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    //设置默认风格
    hud.hudContentStyle(HUDContentBlackStyle);
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hideAnimated:YES
           afterDelay:showTimeWithTitle(text)];
}

+ (void)showOnlyTextTitle:(NSString *)title
                   detail:(NSString *)detail
                   toView:(UIView *)view {
    MBProgressHUD *hud = settHUD(view, title, YES);
    hud.detailsLabel.text = detail;
    hud.mode = MBProgressHUDModeText;
}

+ (void)wj_showIcon:(UIImage *)icon
            message:(NSString *)message
               view:(UIView *)view{
    // 快速显示一个提示信息
    MBProgressHUD *hud = createNew(view);
    // 默认
    //    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = message;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:icon];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:showTimeWithTitle(message)];
}

+ (void)wj_showCustomView:(UIView *)customView
                  message:(NSString *)message
           hideAfterDelay:(NSTimeInterval)time
                   toView:(UIView *)view{
    // 快速显示一个提示信息
    MBProgressHUD *hud = createNew(view);
    if (message) {
        hud.label.text = message;
    }
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.hudContentStyle(HUDContentBlackStyle);
    // 设置自定义view
    hud.customView = customView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 消失时间
    [hud hideAnimated:YES
           afterDelay:time];
}

+ (instancetype)wj_showActivityLoading:(NSString *)message
                                toView:(UIView *)view{
    // 快速显示一个提示信息
    MBProgressHUD *hud = createNew(view);
    // 默认
    hud.mode = MBProgressHUDModeIndeterminate;
    if (message) {
        hud.label.text = message;
    }
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (void)showError:(NSString *)error
           toView:(UIView *)view {
    MBProgressHUD *hud = settHUD(view, error, YES);
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
}

+ (void)showTitleToView:(UIView *)view
                postion:(HUDPostion)postion
                  title:(NSString *)title {
    MBProgressHUD *hud = settHUD(view, title, YES);
    hud.mode = MBProgressHUDModeText;
    hud.hudPostion(postion);
}

+ (void)showDetailToView:(UIView *)view
                 postion:(HUDPostion)postion
                   title:(NSString *)title
                  detail:(NSString *)detail {
    MBProgressHUD *hud = settHUD(view, title, YES);
    hud.detailsLabel.text = detail;
    hud.mode = MBProgressHUDModeText;
    hud.hudPostion(postion);
}

+ (void)showTitleToView:(UIView *)view
                postion:(HUDPostion)postion
           contentStyle:(HUDContentStyle)contentStyle
                  title:(NSString *)title {
    
    MBProgressHUD *hud = settHUD(view, title, YES);
    hud.mode = MBProgressHUDModeText;
    hud.hudContentStyle(contentStyle);
    hud.hudPostion(postion);
}

+ (MBProgressHUD *)showLoadTitle:(NSString *)title
                          toView:(UIView *)view {
    MBProgressHUD *hud = settHUD(view, title, NO);
    hud.mode = MBProgressHUDModeIndeterminate;
    return hud;
}

+ (MBProgressHUD *)showLoadTitle:(NSString *)title
                    contentStyle:(HUDContentStyle)contentStyle
                          toView:(UIView *)view {
    MBProgressHUD *hud = settHUD(view, title, NO);
    hud.hudContentStyle(contentStyle);
    return hud;
}

+ (MBProgressHUD *)showLoadingHUD {
    MBProgressHUD *hud = [self showLoadingHUDToView:nil];
    return hud;
}

+ (MBProgressHUD *)showLoadingHUDWithtitle:(NSString *)title{
    MBProgressHUD *hud = [self showLoadingHUDToView:nil
                                              title:title];
    return hud;
}

+ (MBProgressHUD *)showLoadingHUDToView:(UIView *)view {
    MBProgressHUD *hud = [self showLoadingHUDToView:view
                                              title:nil];
    return hud;
}

+ (MBProgressHUD *)showLoadingHUDToView:(UIView *)view
                                  title:(NSString *)title{
   MBProgressHUD *hud = [self showLoadingHUDToView:view
                                             title:title
                                              type:EKAppMBProgressTypeDefault];
     return hud;
}

+ (MBProgressHUD *)showLoadingHUDToView:(UIView *)view
                                   type:(EKAppMBProgressType)type{
     MBProgressHUD *hud = [self showLoadingHUDToView:view
                                               title:nil
                                                type:type];
       return hud;
}

+ (MBProgressHUD *)showLoadingHUDToView:(UIView *)view
                                  title:(NSString *)title
                                   type:(EKAppMBProgressType)type{
    MBProgressHUD *hud = createNew(view);
    hud.mode = MBProgressHUDModeCustomView;
    hud.hudContentStyle(HUDContentBlackStyle);
    hud.customView = [self customLoadingViewWithType:type];
    hud.label.text = title;
    hud.label.font = [UIFont setFontSizeWithValue:12.f];
    hud.margin = [BaseTools adaptedWithValue:8.0];
    hud.square = YES;
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

+ (void)showTitleTitle:(NSString *)title
          contentStyle:(HUDContentStyle)contentStyle
            afterDelay:(NSTimeInterval)delay
                toView:(UIView *)view {
    MBProgressHUD *hud = settHUD(view, title, NO);
    hud.mode = MBProgressHUDModeText;
    hud.hudContentStyle(contentStyle);
    [hud hideAnimated:YES afterDelay:delay];
}

+ (MBProgressHUD *)showDownTitle:(NSString *)title
                   progressStyle:(HUDProgressStyle)progressStyle
                        progress:(CurrentHud)progress
                          toView:(UIView *)view {
    MBProgressHUD *hud = settHUD(view, title, NO);
    if (progressStyle == HUDProgressDeterminateHorizontalBar) {
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    } else if (progressStyle == HUDProgressDeterminate) {
        hud.mode = MBProgressHUDModeDeterminate;
    } else if (progressStyle == HUDProgressAnnularDeterminate) {
        hud.mode = MBProgressHUDModeAnnularDeterminate;
    }
    if (progress) {
        progress(hud);
    }
    return hud;
}

+ (MBProgressHUD *)showDownTitle:(NSString *)title
                     cancelTitle:(NSString *)cancelTitle
                   progressStyle:(HUDProgressStyle)progressStyle
                        progress:(CurrentHud)progress
                     cancelation:(Cancelation)cancelation
                          toView:(UIView *)view{
    MBProgressHUD *hud = settHUD(view, title, NO);
    if (progressStyle == HUDProgressDeterminateHorizontalBar) {
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    } else if (progressStyle == HUDProgressDeterminate) {
        hud.mode = MBProgressHUDModeDeterminate;
    } else if (progressStyle == HUDProgressAnnularDeterminate) {
        hud.mode = MBProgressHUDModeAnnularDeterminate;
    }
    [hud.button setTitle:cancelTitle ?: NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
    [hud.button addTarget:hud action:@selector(didClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    hud.cancelation = cancelation;
    if (progress) {
        progress(hud);
    }
    return hud;
}

+ (void)showCustomView:(UIImage *)image
                toView:(UIView *)toView
                 title:(NSString *)title {
    MBProgressHUD *hud = settHUD(toView, title, YES);
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
}

+ (MBProgressHUD *)showModelSwitchToView:(UIView *)toView
                                   title:(NSString *)title
                               configHud:(CurrentHud)configHud {
    MBProgressHUD *hud = settHUD(toView, title, NO);
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 100.f);
    if (configHud) {
        configHud(hud);
    }
    return hud;
}

+ (MBProgressHUD *)showDownNSProgressToView:(UIView *)view
                                      title:(NSString *)title {
    MBProgressHUD *hud = settHUD(view, title, NO);
    hud.mode = MBProgressHUDModeDeterminate;
    return hud;
}

+ (MBProgressHUD *)showDownWithNSProgress:(NSProgress *)Progress
                                   toView:(UIView *)view
                                    title:(NSString *)title
                                configHud:(CurrentHud)configHud {
    MBProgressHUD *hud = settHUD(view, title, NO);
    if (configHud) {
        configHud(hud);
    }
    return hud;
}

+ (MBProgressHUD *)showLoadToView:(UIView *)view
                  backgroundColor:(UIColor *)backgroundColor
                            title:(NSString *)title {
    MBProgressHUD *hud = settHUD(view, title, NO);
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.backgroundColor = backgroundColor;
    return hud;
}

+ (MBProgressHUD *)showLoadToView:(UIView *)view
                     contentColor:(UIColor *)contentColor
                            title:(NSString *)title {
    MBProgressHUD *hud = settHUD(view, title, NO);
    hud.contentColor = contentColor;
    return hud;
}

+ (MBProgressHUD *)showLoadToView:(UIView *)view
                     contentColor:(UIColor *)contentColor
                  backgroundColor:(UIColor *)backgroundColor
                            title:(NSString *)title {
    MBProgressHUD *hud = settHUD(view, title, NO);
    hud.contentColor = contentColor;
    hud.backgroundView.color = backgroundColor;
    return hud;
}

+ (MBProgressHUD *)showLoadToView:(UIView *)view
                       titleColor:(UIColor *)titleColor
                   bezelViewColor:(UIColor *)bezelViewColor
                  backgroundColor:(UIColor *)backgroundColor
                            title:(NSString *)title {
    MBProgressHUD *hud = settHUD(view, title, NO);
    hud.label.textColor = titleColor;
    hud.bezelView.backgroundColor = bezelViewColor;
    hud.backgroundView.color = backgroundColor;
    return hud;
}

+ (MBProgressHUD *)createHudToView:(UIView *)view
                             title:(NSString *)title
                         configHud:(CurrentHud)configHud {
    MBProgressHUD *hud = settHUD(view, title, YES);
    if (configHud) {
        configHud(hud);
    }
    return hud;
}

static char cancelationKey;
NS_INLINE MBProgressHUD *createNew(UIView *view) {
    if (view == nil){
        view = (UIView *)[BaseTools getKeyWindow];
    }
    return [MBProgressHUD showHUDAddedTo:view animated:YES];
}

NS_INLINE MBProgressHUD *settHUD(UIView *view, NSString *title, BOOL autoHidden) {
    MBProgressHUD *hud = createNew(view);
    //文字
    hud.label.text = title;
    //支持多行
    hud.label.numberOfLines = 0;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    //设置默认风格
    hud.hudContentStyle(HUDContentBlackStyle);
    if (autoHidden) {
        // x秒之后消失
        [hud hideAnimated:YES
               afterDelay:showTimeWithTitle(title)];
    }
    return hud;
}

NS_INLINE NSTimeInterval showTimeWithTitle(NSString *title){
    NSTimeInterval delayTime = 0.15 * title.length;
    //设置最小1.5 最大 4 秒显示时间
    delayTime = delayTime < MBHUDMinDelayShowTime ? MBHUDMinDelayShowTime : delayTime;
    delayTime = delayTime > MBHUDMaxDelayShowTime ? MBHUDMaxDelayShowTime : delayTime;
    return delayTime;
}

@end
