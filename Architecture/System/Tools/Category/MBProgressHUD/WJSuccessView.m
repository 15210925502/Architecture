//
//  WJSuccessView.m
//  WJTool
//
//  Created by 陈威杰 on 2017/6/3.
//  Copyright © 2017年 ChenWeiJie. All rights reserved.
//

#import "WJSuccessView.h"

static CGFloat lineWidth = 4.0f;
static CGFloat circleDuriation = 0.5f;
static CGFloat checkDuration = 0.2f;

#define BlueColor [UIColor colorWithRed:16/255.0 green:142/255.0 blue:233/255.0 alpha:1]

@implementation WJSuccessView{
    UIView * _logoView;
    CALayer *_animationLayer;
}

- (CGSize)intrinsicContentSize {
    return self.bounds.size;
}

- (instancetype)initWithFrame:(CGRect)frame withState:(BOOL)state{
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)setWj_animationType:(WJAnimationType)wj_animationType{
    _wj_animationType = wj_animationType;
    if (wj_animationType == WJAnimationTypeSuccess) {
        [self drawSuccessHUD];
    }else if (wj_animationType == WJAnimationTypeError) {
        [self drawFailHUD];
    }
}

- (void)drawSuccessHUD{
    _animationLayer = [CALayer layer];
    _animationLayer.bounds = self.bounds;
    _animationLayer.position = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
    [self.layer addSublayer:_animationLayer];
    [self circleAnimation];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.8 * circleDuriation * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [self checkAnimation];
    });
}

//画圆
- (void)circleAnimation {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = _animationLayer.bounds;
    [_animationLayer addSublayer:circleLayer];
    circleLayer.fillColor =  [[UIColor clearColor] CGColor];
    circleLayer.strokeColor  = BlueColor.CGColor;
    circleLayer.lineWidth = lineWidth;
    circleLayer.lineCap = kCALineCapRound;
    
    CGFloat radius = _animationLayer.bounds.size.width / 2.0f - lineWidth / 2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:circleLayer.position radius:radius startAngle:-M_PI / 2 endAngle:M_PI * 3 / 2 clockwise:true];
    circleLayer.path = path.CGPath;
    
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    circleAnimation.duration = circleDuriation;
    circleAnimation.fromValue = @(0.0f);
    circleAnimation.toValue = @(1.0f);
    [circleAnimation setValue:@"circleAnimation" forKey:@"animationName"];
    [circleLayer addAnimation:circleAnimation forKey:@"strokeEnd"];
}

//对号
- (void)checkAnimation {
    CGFloat a = _animationLayer.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a * 2.7 / 10,a * 5.4 / 10)];
    [path addLineToPoint:CGPointMake(a * 4.5 / 10,a * 7 / 10)];
    [path addLineToPoint:CGPointMake(a * 7.8 / 10,a * 3.8 / 10)];
    
    CAShapeLayer *checkLayer = [CAShapeLayer layer];
    checkLayer.path = path.CGPath;
    checkLayer.fillColor = [UIColor clearColor].CGColor;
    checkLayer.strokeColor = BlueColor.CGColor;
    checkLayer.lineWidth = lineWidth;
    checkLayer.lineCap = kCALineCapRound;
    checkLayer.lineJoin = kCALineJoinRound;
    [_animationLayer addSublayer:checkLayer];
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    checkAnimation.duration = checkDuration;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    [checkAnimation setValue:@"checkAnimation" forKey:@"animationName"];
    [checkLayer addAnimation:checkAnimation forKey:@"strokeEnd"];
}

- (void)drawFailHUD{
    _logoView = [[UIView alloc] initWithFrame:self.frame];
    //曲线建立开始点和结束点
    //1. 曲线的中心
    //2. 曲线半径
    //3. 开始角度
    //4. 结束角度
    //5. 顺/逆时针方向
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.frame) / 2.0f, CGRectGetHeight(self.frame) / 2.0f) radius:self.frame.size.width / 2.0f startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //对拐角和中心处理
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
    //对号第一部分的起始
    [path moveToPoint:CGPointMake(self.frame.size.width / 4.0f, self.frame.size.width / 4.0f)];
    CGPoint pl =CGPointMake(self.frame.size.width / 4.0f * 3, self.frame.size.width / 4.0f * 3);
    [path addLineToPoint:pl];
    
    //对号第二部分起始
    [path moveToPoint:CGPointMake(self.frame.size.width / 4.0f * 3, self.frame.size.width / 4.0f)];

    CGPoint p2 = CGPointMake(self.frame.size.width / 4.0f, self.frame.size.width /4.0f * 3);
    [path addLineToPoint:p2];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    //内部填充颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    //线条颜色
    layer.strokeColor = BlueColor.CGColor;
    //线条宽度
    layer.lineWidth = lineWidth;
    layer.path = path.CGPath;
    //动画设置
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = circleDuriation + checkDuration;
    [layer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    [_logoView.layer addSublayer:layer];
    [self addSubview:_logoView];
}

@end
