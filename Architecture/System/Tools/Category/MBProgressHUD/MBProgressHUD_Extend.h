//
//  MBProgressHUD_Extend.h
//  HUDExtendDemo
//
//  Created by neghao on 2017/6/11.
//  Copyright © 2017年 neghao. All rights reserved.
//

#import "MBProgressHUD.h"

/**
 * 风格为自定义时，在这里设置颜色
 */
#define CustomHudStyleBackgrandColor  [UIColor colorWithWhite:0.f alpha:0.7f]
#define CustomHudStyleContentColor    [UIColor colorWithWhite:1.f alpha:0.7f]

//默认持续显示时间(x秒后消失)
#define MBHUDMinDelayShowTime    1.5
#define MBHUDMaxDelayShowTime    4.0

//设置为1时，调用任何这个扩展内的方法，显示出hud的UI效果都会为黑底白字风格
typedef NS_ENUM(NSInteger, HUDContentStyle) {
    HUDContentDefaultStyle = 0,//默认是白底黑字 Default
    HUDContentBlackStyle = 1,//黑底白字
    HUDContentCustomStyle = 2,//:自定义风格<由自己设置自定义风格的颜色>
};

typedef NS_ENUM(NSInteger, HUDPostion) {
    HUDPostionTop,//上面
    HUDPostionCenten,//中间
    HUDPostionBottom,//下面
};

typedef NS_ENUM(NSInteger, HUDProgressStyle) {
    HUDProgressDeterminate,///双圆环,进度环包在内
    HUDProgressDeterminateHorizontalBar,///横向Bar的进度条
    HUDProgressAnnularDeterminate,///双圆环，完全重合
    HUDProgressCancelationDeterminate,///带取消按钮 - 双圆环 - 完全重合
};

typedef NS_ENUM(NSInteger, EKAppMBProgressType) {
    EKAppMBProgressTypeDefault
};

typedef NS_ENUM(NSInteger, HUDLoadingProgressStyle) {
    /* 开扇型加载进度 */
    HUDLoadingProgressStyleDeterminate,
    /* 横条加载进度 */
    HUDLoadingStyleDeterminateHorizontalBar,
    /* 环形加载进度 */
    HUDLoadingStyleAnnularDeterminate,
};

typedef void((^Cancelation)(MBProgressHUD *hud));
typedef void((^CurrentHud)(MBProgressHUD *hud));


@interface MBProgressHUD ()

@property (nonatomic, copy  ) Cancelation cancelation;
///内容风格
@property (nonatomic, assign, readonly) MBProgressHUD *(^hudContentStyle)(HUDContentStyle hudContentStyle);
///显示位置：有导航栏时在导航栏下在，无导航栏在状态栏下面
@property (nonatomic, assign, readonly) MBProgressHUD *(^hudPostion)(HUDPostion hudPostion);
///进度条风格
@property (nonatomic, assign, readonly) MBProgressHUD *(^hudProgressStyle)(HUDProgressStyle hudProgressStyle);
///标题
@property (nonatomic, copy  , readonly) MBProgressHUD *(^title)(NSString *title);
///详情
@property (nonatomic, copy  , readonly) MBProgressHUD *(^details)(NSString *details);
///自定义图片名
@property (nonatomic, copy  , readonly) MBProgressHUD *(^customIcon)(NSString *customIcon);
///标题颜色
@property (nonatomic, strong, readonly) MBProgressHUD *(^titleColor)(UIColor *titleColor);
///进度条颜色
@property (nonatomic, strong, readonly) MBProgressHUD *(^progressColor)(UIColor *progressColor);
///进度条、标题颜色
@property (nonatomic, strong, readonly) MBProgressHUD *(^allContentColors)(UIColor *allContentColors);
///蒙层背景色
@property (nonatomic, strong, readonly) MBProgressHUD *(^hudBackgroundColor)(UIColor *backgroundColor);
///内容背景色
@property (nonatomic, strong, readonly) MBProgressHUD *(^bezelBackgroundColor)(UIColor *bezelBackgroundColor);

@end
