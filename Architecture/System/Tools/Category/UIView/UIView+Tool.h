
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

//线性梯度的方向
typedef NS_ENUM(NSInteger, UIViewLinearGradientDirection){
    UIViewLinearGradientDirectionVertical = 0,                           //垂直
    UIViewLinearGradientDirectionHorizontal,                            //水平
    UIViewLinearGradientDirectionDiagonalFromLeftToRightAndTopToDown,   //从左到右，从上到下
    UIViewLinearGradientDirectionDiagonalFromLeftToRightAndDownToTop,   //从左到右，从下到上
    UIViewLinearGradientDirectionDiagonalFromRightToLeftAndTopToDown,   //从右到左，从上到下
    UIViewLinearGradientDirectionDiagonalFromRightToLeftAndDownToTop    //从右到左，从下到上
};

@interface UIView (Tool)

/** 视图所在父控制器 */
@property (nonatomic, strong, readonly) UIViewController *currentVC;
/** 视图所在导航控制器 */
@property (nonatomic, strong, readonly) UINavigationController *currentNavigationController;
/** 当前window,获取window */
@property (nonatomic, strong, readonly) UIWindow *currentWindow;
/** 获取顶层的 UIViewController 实例 */
@property (nonatomic, strong, readonly) UIViewController *topVC;

//晃动动画执行
- (void)viewShaking;

/**
 *  @author Jakey
 *  @brief  截图一个view中所有视图 包括旋转缩放效果
 *  @param maxWidth 限制缩放的最大宽度 保持默认传0
 *  @return 截图
 */
- (UIImage *)screenshot:(CGFloat)maxWidth;

//获取状态栏视图
+ (UIView *)getUIStatusBarModern;
- (UIView *)getUIStatusBarModern;

/**
 *  切除指定圆角
 *  调用此方法前需要先设置frame
 *  @param corners  指定裁剪的角,可以用"|"进行组合
 *  @param cornerRadii  圆角的大小
 */
- (void)cutTheRoundedWithByRoundingCorners:(UIRectCorner)corners
                               cornerRadii:(CGSize)cornerRadii;

/*!
 *  渐变色
 *
 *  @param colors    颜色
 *  @param direction 方向，横向还是纵向
 */
- (void)createGradientWithColors:(NSArray *)colors
                       direction:(UIViewLinearGradientDirection)direction;

//NSArray *directions = [NSArray arrayWithObjects:@"top", @"bottom", @"left" , @"right" , nil];
//给视图添加阴影边框和透明度
- (void) makeInsetShadowWithRadius:(float)radius
                             Color:(UIColor *)color
                        Directions:(NSArray *)directions;

/**
 *  添加虚线边框(调用此方法前需要先设置frame)
 *  @param borderWidth 边框宽度(虚线线条厚度)
 *  @param dashPattern @[@有色部分的宽度,@无色部分的宽度]
 *  @param color   虚线颜色
 */
- (void)addDashBorderWithWidth:(CGFloat)borderWidth
                   dashPattern:(NSArray<NSNumber *> *)dashPattern
                         color:(UIColor *)color;

@end
