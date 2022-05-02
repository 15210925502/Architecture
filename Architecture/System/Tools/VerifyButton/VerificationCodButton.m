//
//  VerificationCodButton.m
//  tedddd
//
//  Created by 华令冬 on 2019/6/21.
//  Copyright © 2019 com.cn.HLD. All rights reserved.
//

#import "VerificationCodButton.h"
#import <objc/runtime.h>

static NSString * const ktimer = @"timer";
static NSString * const kleaveTime = @"leaveTime";
static NSString * const kcountDownFormat = @"countDownFormat";
static NSString * const kTimeStoppedCallback = @"TimeStoppedCallback";
static NSString * const knormalTitle = @"normalTitle";

@interface VerificationCodButton()

@property (nonatomic, assign) NSTimeInterval leaveTime;
@property (nonatomic, copy) NSString *normalTitle;
@property (nonatomic, copy) NSString *countDownFormat;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic,assign) NSTimeInterval duration;

@end

@implementation VerificationCodButton

+ (instancetype)createButtonWithTimeInterval:(NSTimeInterval)duration
                             countDownFormat:(NSString *)format
                                    callBack:(TimeStoppedCallback)back {
    return [[self alloc] initWithTimeInterval:duration
                              countDownFormat:format
                                     callBack:back];
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)duration
                     countDownFormat:(NSString *)format
                            callBack:(TimeStoppedCallback)back {
    if (self = [super init]) {
        self.duration = duration;
        self.countDownFormat = format;
        self.back = back;
        [self setTitle:GETCODETITLE forState:UIControlStateNormal];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blueColor];
        self.titleLabel.font = [UIFont setFontSizeWithValue:12.0f];
        WeakSelf(self);
        [self pd_addActionWithGesturesType:GesturesType_UITapGestureRecognizer Block:^(UIGestureRecognizer *gestureRecoginzer) {
            StrongSelf(self);
            if (!self.countDownFormat){
                self.countDownFormat = @"%zd秒";
            }
            self.normalTitle = self.titleLabel.text;
            //倒计时时间
            __block NSInteger timeOut = self.duration;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            //每秒执行
            dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0);
            dispatch_source_set_event_handler(self.timer, ^{
                if (timeOut <= 0) { // 倒计时结束，关闭
                    [self cancelTimer];
                } else {
                    NSString *title = [NSString stringWithFormat:@"%ld%@",timeOut,self.countDownFormat];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setTitle:title forState:UIControlStateNormal];
                        self.userInteractionEnabled = NO;
                    });
                    timeOut--;
                }
            });
            dispatch_resume(self.timer);
        }];
    }
    return self;
}

- (void)cancelTimer {
    dispatch_source_cancel(self.timer);
    self.timer = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        // 设置界面的按钮显示 根据自己需求设置
        [self setTitle:COUNTDOWNTITLE forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
        if (self.back) {
            self.back();
        }
    });
}

- (void)setTimer:(dispatch_source_t)timer {
    [self willChangeValueForKey:ktimer];
    objc_setAssociatedObject(self, &ktimer,
                             timer,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:ktimer];
}

- (dispatch_source_t)timer {
    return objc_getAssociatedObject(self, &ktimer);
}

- (void)setLeaveTime:(NSTimeInterval)leaveTime {
    [self willChangeValueForKey:kleaveTime];
    objc_setAssociatedObject(self, &kleaveTime,
                             @(leaveTime),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kleaveTime];
}

- (NSTimeInterval)leaveTime {
    return [objc_getAssociatedObject(self, &kleaveTime) doubleValue];
}

- (void)setCountDownFormat:(NSString *)countDownFormat {
    [self willChangeValueForKey:kcountDownFormat];
    objc_setAssociatedObject(self, &kcountDownFormat,
                             countDownFormat,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kcountDownFormat];
}

- (NSString *)countDownFormat {
    return objc_getAssociatedObject(self, &kcountDownFormat);
}

- (void)setBack:(void (^)(void))back {
    [self willChangeValueForKey:kTimeStoppedCallback];
    objc_setAssociatedObject(self, &kTimeStoppedCallback,
                             back,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kTimeStoppedCallback];
}

- (void (^)(void))back {
    return objc_getAssociatedObject(self, &kTimeStoppedCallback);
}

- (void)setNormalTitle:(NSString *)normalTitle {
    [self willChangeValueForKey:knormalTitle];
    objc_setAssociatedObject(self, &knormalTitle,
                             normalTitle,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:knormalTitle];
}

- (NSString *)normalTitle {
    return objc_getAssociatedObject(self, &knormalTitle);
}

@end



//static dispatch_source_t _timer;
//
//@implementation VerificationCodButton
//
//- (void)setCountdown:(NSTimeInterval )timeOut{
//    __block int timeout=timeOut; //倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        if(timeout <= 0){ //倒计时结束，关闭
//            [self cancelCountdown];
//        }else{
//            int seconds = timeout;
//            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self setTitle:[NSString stringWithFormat:@"%@(%@)",COUNTDOWNTITLE,strTime] forState:UIControlStateNormal];
//                self.userInteractionEnabled = NO;
//            });
//            timeout--;
//        }
//    });
//    dispatch_resume(_timer);
//}
//
//- (void)cancelCountdown{
//    if(_timer){
//        dispatch_source_cancel(_timer);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //设置界面的按钮显示 根据自己需求设置（倒计时结束后调用）
//             [self setTitle:GETCODETITLE forState:UIControlStateNormal];
//             self.userInteractionEnabled = YES;
//        });
//    }
//}
//
//@end
