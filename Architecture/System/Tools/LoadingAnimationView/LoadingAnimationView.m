//
//  LoadingAnimationView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "LoadingAnimationView.h"

static LoadingAnimationView *loadView;

@interface LoadingAnimationView()

//旋转图片
@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation LoadingAnimationView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        [self startAnimating];
    }
    return self;
}

+ (LoadingAnimationView *)showView:(UIView *)view
                         imageName:(NSString *)name
                             frame:(CGRect)frame{
    loadView = [[LoadingAnimationView alloc] initWithFrame:frame];
    //背景的颜色
    loadView.backgroundColor = [UIColor clearColor];
    loadView.imageView.image = [UIImage sd_imageWithName:name];
    loadView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (view == nil){
        view = (UIView *)[BaseTools getKeyWindow];
    }
    loadView.center = view.center;
    [view addSubview:loadView];
    return loadView;
}

- (void)startAnimating{
    //先判断是否已设置动画，如果已设置则执行动画
    if([self.imageView.layer animationForKey:@"rotationAnimation"]){
        //如果动画正在执行则返回，避免重复执行动画
        if (self.imageView.layer.speed == 1) {
            //speed == 1表示动画正在执行
            return;
        }
        //让动画执行
        self.imageView.layer.speed = 1;
        //取消上次设置的时间
        self.imageView.layer.beginTime = 0;
        //获取上次动画停留的时刻
        CFTimeInterval pauseTime = self.imageView.layer.timeOffset;
        //取消上次记录的停留时刻
        self.imageView.layer.timeOffset = 0;
        //计算暂停的时间，设置相对于父坐标系的开始时间
        self.imageView.layer.beginTime = [self.imageView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    }else{//没有设置动画
        //添加动画
        [self addAnimation];
    }
}

- (void)addAnimation{
    //旋转动画
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 2.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.additive = YES;
    rotationAnimation.repeatCount = NSIntegerMax;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    //添加动画之后，再让动画执行，否则可能出现动画不执行的情况
    [self startAnimating];
}

- (void)stopAnimating{
    [self stopAnimatingSaveTimeOffset:NO];
}

- (void)stopAnimatingSaveTimeOffset:(BOOL)isSave{
    //如果动画已经暂停，则返回，避免重复，时间会记录错误，造成动画继续后不能连续。
     if (self.imageView.layer.speed == 0) {
         return;
     }
    
    if (isSave) {
        //将当前动画执行到的时间保存到layer的timeOffet中
        //一定要先获取时间再暂停动画
        CFTimeInterval pausedTime = [self.imageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        //将动画暂停
        self.imageView.layer.speed = 0;
        //记录动画暂停时间
        self.imageView.layer.timeOffset = pausedTime;
    }else{
        [self.imageView.layer removeAnimationForKey:@"rotationAnimation"];
    }
}

+ (void)hide{
    if (loadView) {
        [loadView removeFromSuperview];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

- (void)dealloc{
    [self.imageView.layer removeAnimationForKey:@"rotationAnimation"];
}

@end
