//
//  MBProgressHUD+Extension.h
//  Tool
//
//  Created by 陈威杰 on 2017/6/2.
//  Copyright © 2017年 ChenWeiJie. All rights reserved.
//

#import "MBProgressHUD.h"
#import "MBProgressHUD_Extend.h"

@interface MBProgressHUD (Extension)

#pragma mark - 显示纯文本信息
/**
 只显示文字
 */
+ (void)wj_showText:(NSString *)text;
+ (void)wj_showText:(NSString *)text
               view:(UIView *)view;
/**
 纯文字标题 + 详情
 */
+ (void)showOnlyTextTitle:(NSString *)title
                   detail:(NSString *)detail
                   toView:(UIView *)view;
/**
 纯文字 + 自定位置 x秒后自动消失
 
 @param delay 延迟消失时间
 */
+ (void)showTitleTitle:(NSString *)title
           contentStyle:(HUDContentStyle)contentStyle
             afterDelay:(NSTimeInterval)delay
                toView:(UIView *)view;
#pragma mark - 等待动画
/**
    只有加载图
 */
+ (MBProgressHUD *)showOnlyLoadToView:(UIView *)view;
/**
 文字 + 加载图
 */
/**
 文字 + 加载图
 */
+ (MBProgressHUD *)showLoadTitle:(NSString *)title;
+ (MBProgressHUD *)showLoadTitle:(NSString *)title
                          toView:(UIView *)view;
/**
 文字 + 加载图 + 自定风格
 */
+ (MBProgressHUD *)showLoadTitle:(NSString *)title
                    contentStyle:(HUDContentStyle)contentStyle
                          toView:(UIView *)view;

#pragma mark - 自定义加载动画
//动画下面没有文字
+ (MBProgressHUD *)showLoadingHUD;
+ (MBProgressHUD *)showLoadingHUDToView:(UIView *)view;
+ (MBProgressHUD *)showLoadingHUDToView:(UIView *)view type:(EKAppMBProgressType)type;
//动画下面有文字
+ (MBProgressHUD *)showLoadingHUDWithtitle:(NSString *)title;
+ (MBProgressHUD *)showLoadingHUDToView:(UIView *)view title:(NSString *)title type:(EKAppMBProgressType)type;

#pragma mark - 显示操作成功或失败信息（自定义view打勾打叉动画）
/**
 只显示打勾动画HUD
 */
+ (void)wj_showSuccess;

/**
 显示成功信息，同时会有一个打勾的动画
 
 @param success 成功信息提示文本
 */
+ (void)wj_showSuccess:(NSString *)success;
/**
 显示成功信息，同时会有一个打勾的动画
 
 @param success 成功信息提示文本
 @param view 展示的View
 */
+ (void)wj_showSuccess:(NSString *)success
                toView:(UIView *)view;

/**
 *  显示成功信息，打勾没有动画
 */
+ (void)showSuccess:(NSString *)success
             toView:(UIView *)view;
/**
 显示成功信息，同时会有一个打勾的动画

 @param success 成功信息提示文本
 @param time HUD展示时长
 @param view 展示的View
 */
+ (void)wj_showSuccess:(NSString *)success
      hideAfterDelay:(NSTimeInterval)time
              toView:(UIView *)view;
/**
 只显示打叉动画HUD
 */
+ (void)wj_showError;

/**
 显示失败信息，同时有打叉的动画
 
 @param error 错误信息提示文本
 */
+ (void)wj_showError:(NSString *)error;
/**
 显示失败信息，同时有打叉的动画
 
 @param error 错误信息提示文本
 @param view 展示的View
 */
+ (void)wj_showError:(NSString *)error
              toView:(UIView *)view;
/**
 显示失败信息，同时有打叉的动画
 
 @param error 错误信息
 @param time HUD展示时长
 @param view 展示的view
 */
+ (void)wj_showError:(NSString *)error
      hideAfterDelay:(NSTimeInterval)time
              toView:(UIView *)view;
/**
 *  显示失败信息，打叉没有动画
 */
+ (void)showError:(NSString *)error
           toView:(UIView *)view;

#pragma mark - 自己设置提示信息的 图标
/**
显示带有自定义icon图标消息HUD

@param icon 图标
@param message 消息正文
*/
+ (void)wj_showIcon:(UIImage *)icon
            message:(NSString *)message;
/**
显示带有自定义icon图标消息HUD

@param icon 图标
@param message 消息正文
@param view 展示的view
*/
+ (void)wj_showIcon:(UIImage *)icon
            message:(NSString *)message
               view:(UIView *)view;

#pragma mark - 有加载进度的HUD
/**
 只显示菊花加载动画，不会自动消失，需要在你需要移除的时候调用 wj_hideHUDForView: 等移除方法
 
 @return MBProgressHUD对象，可以通过它调用MBProgressHUD中的方法
 */
+ (instancetype)wj_showActivityLoading;
/**
 只显示菊花加载动画，不会自动消失，需要在你需要移除的时候调用 wj_hideHUDForView: 等移除方法
 
 @param view 展示的View
 @return MBProgressHUD对象，可以通过它调用MBProgressHUD中的方法
 */
+ (instancetype)wj_showActivityLoadingToView:(UIView *)view;
/**
 显示菊花加载状态，不会自动消失，需要在你需要移除的时候调用 wj_hideHUDForView: 等移除方法
 
 @param message 消息正文
 @param view 展示的view
 @return MBProgressHUD对象，可以通过它调用MBProgressHUD中的方法
 */
+ (instancetype)wj_showActivityLoading:(NSString *)message
                                toView:(UIView *)view;
/**
 只显示加载进度的HUD，不显示消息文本，设置HUD的progress请通过 HUD 对象调用 showAnimated: whileExecutingBlock: 等方法
 
 @param style 进度条样式
 @return MBProgressHUD对象，可以通过它调用MBProgressHUD中的方法
 */
+ (instancetype)wj_showLoadingStyle:(HUDLoadingProgressStyle)style;
/**
 只显示加载进度的HUD，不显示消息文本，设置HUD的progress请通过 HUD 对象调用 showAnimated: whileExecutingBlock: 等方法
 
 @param style 进度条样式
 @param view 展示的View
 @return MBProgressHUD对象，可以通过它调用MBProgressHUD中的方法
 */
+ (instancetype)wj_showLoadingStyle:(HUDLoadingProgressStyle)style
                             toView:(UIView *)view;
/**
 加载进度的HUD，设置HUD的progress请通过 HUD 对象调用 showAnimated: whileExecutingBlock: 等方法
 
 使用举例：
 MBProgressHUD *hud = [MBProgressHUD wj_showLoadingStyle:HUDLoadingProgressStyleDeterminate message:@"正在加载..." toView:nil];
 [hud showAnimated:YES whileExecutingBlock:^{
 float progress = 0.0f;
 while (progress < 1.0f) {
 hud.progress = progress;
 hud.labelText = [NSString stringWithFormat:@"正在加载...%.0f%%", progress * 100];
 progress += 0.01f;
 usleep(50000);
 }
 } completionBlock:^{
 [MBProgressHUD wj_hideHUD];
 // [hud removeFromSuperViewOnHide];
 }];
 
 @param style 进度条样式
 @param message 消息正文，传nil不显示
 @param view 展示的View
 @return MBProgressHUD对象，可以通过它调用MBProgressHUD中的方法
 */
+ (instancetype)wj_showLoadingStyle:(HUDLoadingProgressStyle)style
                            message:(NSString *)message
                             toView:(UIView *)view;
/**
 文字 + 进度条
 
 @param progressStyle 进度条风格
 @param progress 当前进度值
 */
+ (MBProgressHUD *)showDownTitle:(NSString *)title
                   progressStyle:(HUDProgressStyle)progressStyle
                        progress:(CurrentHud)progress
                          toView:(UIView *)view;
/**
 文字 + 进度条 + 取消按钮
 
 @param progressStyle 进度条风格
 @param progress 当前进度值
 @param cancelTitle 取消按钮名称
 @param cancelation 取消按钮的点击事件
 */
+ (MBProgressHUD *)showDownToView:(UIView *)view
                    progressStyle:(HUDProgressStyle)progressStyle
                            title:(NSString *)title
                      cancelTitle:(NSString *)cancelTitle
                         progress:(CurrentHud)progress
                      cancelation:(Cancelation)cancelation;
/**
 只显示环形加载状态指示器，不显示文本消息
 
 @return MBProgressHUD对象，可以通过它调用MBProgressHUD中的方法
 */
+ (instancetype)wj_showAnnularLoading;
/**
 显示环形加载状态指示器
 
 @param message 消息正文，传nil不显示
 @param view 展示的View
 @return MBProgressHUD对象，可以通过它调用MBProgressHUD中的方法
 */
+ (instancetype)wj_showAnnularLoading:(NSString *)message
                               toView:(UIView *)view;
/**
 只显示扇形饼状加载进度指示器，不显示文本消息
 
 @return MBProgressHUD对象，可以通过它调用MBProgressHUD中的方法
 */
+ (instancetype)wj_showDeterminateLoading;
/**
 扇形饼状加载进度
 
 @return MBProgressHUD对象，可以通过它调用MBProgressHUD中的方法
 */
+ (instancetype)wj_showDeterminateLoading:(NSString *)message
                                   toView:(UIView *)view;
#pragma mark - 自定义HUD中显示的view
/**
 自定义HUD中显示的view
 
 @param customView 自定义的view
 @param time 多少秒后消失
 */
+ (void)wj_showCustomView:(UIView *)customView
           hideAfterDelay:(NSTimeInterval)time;
+ (void)wj_showCustomView:(UIView *)customView
           hideAfterDelay:(NSTimeInterval)time
                   toView:(UIView *)view;
/**
自定义HUD中显示的view

@param customView 自定义的view
@param message 消息正文，传nil只显示自定义的view在HUD上
@param time 多少秒后消失
@param view 展示的view
*/
+ (void)wj_showCustomView:(UIView *)customView
                  message:(NSString *)message
           hideAfterDelay:(NSTimeInterval)time
                   toView:(UIView *)view;
/**
 自定义HUD中显示的view, 闭包返回自定义的View
 
 @param time 多少秒后消失
 @param customView 返回自定义UIView
 */
+ (void)wj_showHideAfterDelay:(NSTimeInterval)time
                   customView:(UIView *(^)(void))customView;
/**
自定义HUD中显示的view, 闭包返回自定义的View

@param message 消息正文
@param time 多少秒后消失
@param view 展示的view
@param customView 返回自定义UIView
*/
+ (void)wj_showMessage:(NSString *)message
        hideAfterDelay:(NSTimeInterval)time
                toView:(UIView *)view
            customView:(UIView *(^)(void))customView;
/**
 纯文字标题 + 自定位置 - 自动消失
 
 @param postion 位置：上、中、下
 */
+ (void)showTitleToView:(UIView *)view
                postion:(HUDPostion)postion
                  title:(NSString *)title;
/**
 纯文字标题 + 详情 + 自定位置 - 自动消失
 
 @param postion 配置hud其它属性
 */
+ (void)showDetailToView:(UIView *)view
                 postion:(HUDPostion)postion
                   title:(NSString *)title
                  detail:(NSString *)detail;
/**
 纯文字 + 自定位置、风格 - 自动消失
 
 @param postion 位置
 @param contentStyle 风格
 */
+ (void)showTitleToView:(UIView *)view
                postion:(HUDPostion)postion
           contentStyle:(HUDContentStyle)contentStyle
                  title:(NSString *)title;
/**
 文字 + 自定图片
 @param image 图片
 */
+ (void)showCustomView:(UIImage *)image
                toView:(UIView *)toView
                 title:(NSString *)title;
/**
 文字 + 默认加载图 + 自定朦胧层背景色
 
 @param backgroundColor 自定背景色
 */
+ (MBProgressHUD *)showLoadToView:(UIView *)view
                  backgroundColor:(UIColor *)backgroundColor
                            title:(NSString *)title;
/**
 文字 + 默认加载图 + 自定文字、加载图颜色
 
 @param contentColor 自定文字、加载图颜色
 */
+ (MBProgressHUD *)showLoadToView:(UIView *)view
                     contentColor:(UIColor *)contentColor
                            title:(NSString *)title;
/**
 文字 + 默认加载图 + 自定文图内容颜色 + 自定朦胧层背景色
 
 @param contentColor 自定文字、加载图颜色
 @param backgroundColor + 自定朦胧层背景色
 */
+ (MBProgressHUD *)showLoadToView:(UIView *)view
                     contentColor:(UIColor *)contentColor
                  backgroundColor:(UIColor *)backgroundColor
                            title:(NSString *)title;
/**
 文字 + 默认加载图 + 自定文字及加载图颜色 + 自定朦胧层背景色
 
 @param titleColor 自定文字
 @param bezelViewColor 加载图背景颜色
 @param backgroundColor + 自定朦胧层背景色
 */
+ (MBProgressHUD *)showLoadToView:(UIView *)view
                       titleColor:(UIColor *)titleColor
                   bezelViewColor:(UIColor *)bezelViewColor
                  backgroundColor:(UIColor *)backgroundColor
                            title:(NSString *)title;
/**
 状态变换
 
 @param configHud 配置hud其它属性
 */
+ (MBProgressHUD *)showModelSwitchToView:(UIView *)toView
                                   title:(NSString *)title
                               configHud:(CurrentHud)configHud;
/**
 文字 + 进度 网络请求
 
 @param configHud 配置hud其它属性
 */
+ (MBProgressHUD *)showDownWithNSProgress:(NSProgress *)Progress
                                   toView:(UIView *)view
                                    title:(NSString *)title
                                configHud:(CurrentHud)configHud;
/**
 创建一个新的hud
 
 @param configHud 配置hud其它属性
 */
+ (MBProgressHUD *)createHudToView:(UIView *)view
                             title:(NSString *)title
                         configHud:(CurrentHud)configHud;
#pragma mark - 操作成功 & 彩带粒子碎花祝贺HUD效果
/**
 显示操作成功HUD的同时伴随碎花粒子动画效果，可用于祝贺的场景
 
 @param message 祝贺消息
 */
+ (void)wj_showSuccessWithColouredRibbonAnimation:(NSString *)message;
/**
 显示操作成功HUD的同时伴随碎花粒子动画效果，可用于祝贺的场景
 */
+ (void)wj_showSuccessWithColouredRibbonAnimation;

#pragma mark - 自行调用彩带粒子碎花效果方法
/**
 显示碎花粒子效果
 */
+ (void)wj_showColouredRibbonAnimationWithHideTime:(NSTimeInterval)time;

#pragma mark - 移除HUD

/**
 从当前展示的View上移除HUD
 */
+ (void)hideHUD;

/**
 从view上移除HUD
 
 @param view 展示HUD的View
 */
+ (void)hideHUDForView:(UIView *)view;

@end
