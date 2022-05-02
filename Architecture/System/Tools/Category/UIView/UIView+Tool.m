
#import "UIView+Tool.h"
#import <objc/runtime.h>

#define kValidDirections [NSArray arrayWithObjects: @"top", @"bottom", @"left", @"right",nil]

@interface UIView ()

@property (nonatomic, strong, readwrite) UIViewController *currentVC;
@property (nonatomic, strong, readwrite) UINavigationController *currentNavigationController;
@property (nonatomic, strong, readwrite) UIWindow *currentWindow;
@property (nonatomic, strong, readwrite) UIViewController *topVC;

@end

@implementation UIView (Tool)

- (UIWindow *)currentWindow {
    self.currentWindow = [self mainWindow];
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCurrentWindow:(UIWindow *)currentWindow {
    objc_setAssociatedObject(self, @selector(currentWindow), currentWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)currentVC {
    self.currentVC = [self returnViewController];
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCurrentVC:(UIViewController *)currentVC {
    objc_setAssociatedObject(self, @selector(currentVC), currentVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationController *)currentNavigationController {
    self.currentNavigationController = [self returnViewController].navigationController;
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCurrentNavigationController:(UINavigationController *)currentNavigationController {
    objc_setAssociatedObject(self, @selector(currentNavigationController), currentNavigationController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)topVC {
    self.topVC = [self returnTopVC];
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTopVC:(UIViewController *)topVC {
    objc_setAssociatedObject(self, @selector(topVC), topVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)returnViewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

//获取当前window
- (UIWindow *)mainWindow{
    UIApplication *application = [UIApplication sharedApplication];
    id appDelegate = application.delegate;
    if (appDelegate && [appDelegate respondsToSelector:@selector(window)]) {
        return [appDelegate window];
    }else{
        NSArray *windows = application.windows;
        if ([windows count] == 1) {
            return [windows firstObject];
        } else {
            for (UIWindow *window in windows) {
                if (window.windowLevel == UIWindowLevelNormal) {
                    return window;
                }
            }
        }
        return nil;
    }
}

- (UIViewController *)returnTopVC {
    UIViewController *topController = nil;
    UIView *frontView = [[self.currentWindow subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:UIViewController.class]) {
        topController = nextResponder;
    } else {
        topController = self.currentWindow.rootViewController;
    }
    while ([topController isKindOfClass:UITabBarController.class] ||
           [topController isKindOfClass:UINavigationController.class]) {
        if ([topController isKindOfClass:UITabBarController.class]) {
            topController = ((UITabBarController *)topController).selectedViewController;
        } else if ([topController isKindOfClass:UINavigationController.class]) {
            topController = ((UINavigationController *)topController).topViewController;
        }
    }
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

- (void)createGradientWithColors:(NSArray *)colors direction:(UIViewLinearGradientDirection)direction{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    
    NSMutableArray *mutableColors = colors.mutableCopy;
    for(int i = 0; i < colors.count; i++){
        UIColor *currentColor = colors[i];
        [mutableColors replaceObjectAtIndex:i withObject:(id)currentColor.CGColor];
    }
    gradient.colors = mutableColors;
    
    switch (direction){
        case UIViewLinearGradientDirectionVertical:
        {
            gradient.startPoint = CGPointMake(0.5f, 0.0f);
            gradient.endPoint = CGPointMake(0.5f, 1.0f);
            break;
        }
        case UIViewLinearGradientDirectionHorizontal:
        {
            gradient.startPoint = CGPointMake(0.0f, 0.5f);
            gradient.endPoint = CGPointMake(1.0f, 0.5f);
            break;
        }
        case UIViewLinearGradientDirectionDiagonalFromLeftToRightAndTopToDown:
        {
            gradient.startPoint = CGPointMake(0.0f, 0.0f);
            gradient.endPoint = CGPointMake(1.0f, 1.0f);
            break;
        }
        case UIViewLinearGradientDirectionDiagonalFromLeftToRightAndDownToTop:
        {
            gradient.startPoint = CGPointMake(0.0f, 1.0f);
            gradient.endPoint = CGPointMake(1.0f, 0.0f);
            break;
        }
        case UIViewLinearGradientDirectionDiagonalFromRightToLeftAndTopToDown:
        {
            gradient.startPoint = CGPointMake(1.0f, 0.0f);
            gradient.endPoint = CGPointMake(0.0f, 1.0f);
            break;
        }
        case UIViewLinearGradientDirectionDiagonalFromRightToLeftAndDownToTop:
        {
            gradient.startPoint = CGPointMake(1.0f, 1.0f);
            gradient.endPoint = CGPointMake(0.0f, 0.0f);
            break;
        }
        default:
        {
            break;
        }
    }
    [self.layer insertSublayer:gradient atIndex:0];
}

/**
 *  @brief  截图一个view中所有视图 包括旋转缩放效果
 *
 *  @param maxWidth 限制缩放的最大宽度 保持默认传0
 *
 *  @return 截图
 */
- (UIImage *)screenshot:(CGFloat)maxWidth{
    CGAffineTransform oldTransform = self.transform;
    CGAffineTransform scaleTransform = CGAffineTransformIdentity;
    if (!isnan(maxWidth) && maxWidth>0) {
        CGFloat maxScale = maxWidth/CGRectGetWidth(self.frame);
        CGAffineTransform transformScale = CGAffineTransformMakeScale(maxScale, maxScale);
        scaleTransform = CGAffineTransformConcat(oldTransform, transformScale);
    }
    if(!CGAffineTransformEqualToTransform(scaleTransform, CGAffineTransformIdentity)){
        self.transform = scaleTransform;
    }
    
    CGRect actureFrame = self.frame; //已经变换过后的frame
    CGRect actureBounds= self.bounds;//CGRectApplyAffineTransform();
    
    UIGraphicsBeginImageContextWithOptions(actureFrame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context,actureFrame.size.width/2, actureFrame.size.height/2);
    CGContextConcatCTM(context, self.transform);
    CGPoint anchorPoint = self.layer.anchorPoint;
    CGContextTranslateCTM(context, -actureBounds.size.width * anchorPoint.x, -actureBounds.size.height * anchorPoint.y);
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.transform = oldTransform;
    return screenshot;
}

- (void)cutTheRoundedWithByRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void) makeInsetShadowWithRadius:(float)radius Color:(UIColor *)color Directions:(NSArray *)directions{
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    shadowView.backgroundColor = [UIColor clearColor];
    
    // Ignore duplicate direction
    NSMutableDictionary *directionDict = [[NSMutableDictionary alloc] init];
    for (NSString *direction in directions){
        [directionDict setObject:@"1" forKey:direction];
    }
    
    for (NSString *direction in directionDict) {
        // Ignore invalid direction
        if ([kValidDirections containsObject:direction]){
            CAGradientLayer *shadow = [CAGradientLayer layer];
            if ([direction isEqualToString:@"top"]) {
                [shadow setStartPoint:CGPointMake(0.5, 0.0)];
                [shadow setEndPoint:CGPointMake(0.5, 1.0)];
                shadow.frame = CGRectMake(0, 0, self.bounds.size.width, radius);
            }else if ([direction isEqualToString:@"bottom"]){
                [shadow setStartPoint:CGPointMake(0.5, 1.0)];
                [shadow setEndPoint:CGPointMake(0.5, 0.0)];
                shadow.frame = CGRectMake(0, self.bounds.size.height - radius, self.bounds.size.width, radius);
            } else if ([direction isEqualToString:@"left"]){
                shadow.frame = CGRectMake(0, 0, radius, self.bounds.size.height);
                [shadow setStartPoint:CGPointMake(0.0, 0.5)];
                [shadow setEndPoint:CGPointMake(1.0, 0.5)];
            } else if ([direction isEqualToString:@"right"]){
                shadow.frame = CGRectMake(self.bounds.size.width - radius, 0, radius, self.bounds.size.height);
                [shadow setStartPoint:CGPointMake(1.0, 0.5)];
                [shadow setEndPoint:CGPointMake(0.0, 0.5)];
            }
            
            shadow.colors = [NSArray arrayWithObjects:(id)[color CGColor], (id)[[UIColor clearColor] CGColor], nil];
            [shadowView.layer insertSublayer:shadow atIndex:0];
        }
    }
    [self addSubview:shadowView];
}

#pragma mark - 设置虚线边框
- (void)addDashBorderWithWidth:(CGFloat)borderWidth dashPattern:(NSArray<NSNumber *> *)dashPattern color:(UIColor *)color{
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = self.bounds;
    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    borderLayer.lineWidth = borderWidth;
    //圆角
    borderLayer.lineJoin = kCALineJoinRound;
    //虚线边框
    borderLayer.lineDashPattern = dashPattern;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = color.CGColor;
    [self.layer addSublayer:borderLayer];
}

- (void)viewShaking{
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    keyFrame.duration = 0.3;
    CGFloat x = self.layer.position.x;
    keyFrame.values = @[@(x - 30), @(x - 30), @(x + 20), @(x - 20), @(x + 10), @(x - 10), @(x + 5), @(x - 5)];
    [self.layer addAnimation:keyFrame forKey:@"shake"];
}

+ (UIView *)getUIStatusBarModern {
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        // We can still get statusBar using the following code, but this is not recommended.
        UIWindow *tempWindow = [BaseTools getKeyWindow];
        UIStatusBarManager *statusBarManager = tempWindow.windowScene.statusBarManager;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
            UIView *_localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
            if ([_localStatusBar respondsToSelector:@selector(statusBar)]) {
                return [_localStatusBar performSelector:@selector(statusBar)];
            }
        }
#pragma clang diagnostic pop
    }
#endif
    return [[UIApplication sharedApplication] valueForKey:@"_statusBar"];
}

- (UIView *)getUIStatusBarModern {
    return [[self class] getUIStatusBarModern];
}

@end
