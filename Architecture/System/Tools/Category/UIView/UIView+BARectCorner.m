//
//  UIView+BARectCorner.m
//  BAButton
//
//  Created by boai on 2017/5/19.
//  Copyright © 2017年 boai. All rights reserved.
//

#import "UIView+BARectCorner.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIButton_ConfigurationDefine.h"

@implementation UIView (BARectCorner)

- (void)ba_view_setViewRectCornerType:(BAKit_ViewRectCornerType)type
                     viewCornerRadius:(CGFloat)viewCornerRadius{
    self.ba_viewCornerRadius = viewCornerRadius;
    self.ba_viewRectCornerType = type;
}

/**
 快速切圆角，带边框、边框颜色
 
 @param type 圆角样式
 @param viewCornerRadius 圆角角度
 @param borderWidth 边线宽度
 @param borderColor 边线颜色
 */
- (void)ba_view_setViewRectCornerType:(BAKit_ViewRectCornerType)type
                     viewCornerRadius:(CGFloat)viewCornerRadius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor{
    self.ba_viewCornerRadius = viewCornerRadius;
    self.ba_viewRectCornerType = type;
    self.ba_viewBorderWidth = borderWidth;
    self.ba_viewBorderColor = borderColor;
}

#pragma mark - view 的 角半径，默认 CGSizeMake(0, 0)
- (void)setupViewCornerType{
    UIRectCorner corners;
    CGSize cornerRadii;
    
    cornerRadii = CGSizeMake(self.ba_viewCornerRadius, self.ba_viewCornerRadius);
    if (self.ba_viewCornerRadius == 0){
        cornerRadii = CGSizeMake(0, 0);
    }
    
    switch (self.ba_viewRectCornerType){
        case BAKit_ViewRectCornerTypeBottomLeft:
        {
            corners = UIRectCornerBottomLeft;
        }
            break;
        case BAKit_ViewRectCornerTypeBottomRight:
        {
            corners = UIRectCornerBottomRight;
        }
            break;
        case BAKit_ViewRectCornerTypeTopLeft:
        {
            corners = UIRectCornerTopLeft;
        }
            break;
        case BAKit_ViewRectCornerTypeTopRight:
        {
            corners = UIRectCornerTopRight;
        }
            break;
        case BAKit_ViewRectCornerTypeBottomLeftAndBottomRight:
        {
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        }
            break;
        case BAKit_ViewRectCornerTypeTopLeftAndTopRight:
        {
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
        }
            break;
        case BAKit_ViewRectCornerTypeBottomLeftAndTopLeft:
        {
            corners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
        }
            break;
        case BAKit_ViewRectCornerTypeBottomRightAndTopLeft:
        {
            corners = UIRectCornerBottomRight | UIRectCornerTopLeft;
        }
            break;
        case BAKit_ViewRectCornerTypeBottomRightAndTopRight:
        {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight;
        }
            break;
        case BAKit_ViewRectCornerTypeBottomRightAndTopRightAndTopLeft:
        {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft;
        }
            break;
        case BAKit_ViewRectCornerTypeBottomRightAndTopRightAndBottomLeft:
        {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerBottomLeft;
        }
            break;
        case BAKit_ViewRectCornerTypeAllCorners:
        {
            corners = UIRectCornerAllCorners;
        }
            break;
            
        default:
            break;
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                     byRoundingCorners:corners
                                                           cornerRadii:cornerRadii];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.frame = self.bounds;
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.path = bezierPath.CGPath;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = self.ba_viewBorderColor.CGColor;
    borderLayer.lineWidth = self.ba_viewBorderWidth;
    borderLayer.frame = self.bounds;
    
    self.layer.mask = shapeLayer;
    [self.layer addSublayer:borderLayer];
}

#pragma mark - setter / getter
- (void)setBa_viewRectCornerType:(BAKit_ViewRectCornerType)ba_viewRectCornerType{
    objc_setAssociatedObject(self, @selector(ba_viewRectCornerType), @(ba_viewRectCornerType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setupViewCornerType];
}

- (BAKit_ViewRectCornerType)ba_viewRectCornerType{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setBa_viewCornerRadius:(CGFloat)ba_viewCornerRadius{
    objc_setAssociatedObject(self, @selector(ba_viewCornerRadius), @(ba_viewCornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)ba_viewCornerRadius{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setBa_viewBorderWidth:(CGFloat)ba_viewBorderWidth{
    objc_setAssociatedObject(self, @selector(ba_viewBorderWidth), @(ba_viewBorderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setupViewCornerType];
}

- (CGFloat)ba_viewBorderWidth{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setBa_viewBorderColor:(UIColor *)ba_viewBorderColor{
    objc_setAssociatedObject(self, @selector(ba_viewBorderColor), ba_viewBorderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setupViewCornerType];
}

- (UIColor *)ba_viewBorderColor{
    return objc_getAssociatedObject(self, _cmd);
}

/**
 UIView：点击音效结束后的回调，实际情况可参考里面注释
 
 @param soundID soundID description
 @param clientData clientData description
 */
void soundCompleteCallback(SystemSoundID soundID, void *clientData) {
    NSLog(@"播放完成");
    //    AudioServicesRemoveSystemSoundCompletion (mySSID);
    //    UILabel *label = (__bridge UILabel *)data;
    //    label.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
}

- (void)ba_viewPlaySoundEffectWithFileName:(NSString *)name isNeedShock:(BOOL)isNeedShock{
    // 1、获取音效文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    // 2、创建音效文件 URL
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    // 3、音效声音的唯一标示 soundID
    SystemSoundID soundID = 0;
    
    /**
     * inFileUrl: 音频文件 url
     * outSystemSoundID: 声音 id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    // 4、将音效加入到系统音效服务中，NSURL 需要桥接成 CFURLRef，会返回一个长整形 soundID，用来做音效的唯一标示
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    // 5、如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    // 6、播放音频
    AudioServicesPlaySystemSound(soundID);
    
    if (isNeedShock){
        // 7、播放音效并震动
        AudioServicesPlayAlertSound(soundID);
    }
}

@end
