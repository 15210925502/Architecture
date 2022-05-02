//
//  UIButton+BACountDown.m
//  BAButton
//
//  Created by 任子丰 on 16/6/17.
//  Copyright © 2016年 任子丰. All rights reserved.
//

#import "UIButton+BACountDown.h"
#import "UIButton_ConfigurationDefine.h"
#import <objc/runtime.h>

@interface UIButton ()

@property (nonatomic, assign) NSTimeInterval leaveTime;
@property (nonatomic, copy) NSString *normalTitle;
@property (nonatomic, copy) NSString *countDownFormat;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation UIButton (BACountDown)

- (void)setTimer:(dispatch_source_t)timer {
    objc_setAssociatedObject(self, @selector(timer), timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (dispatch_source_t)timer {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLeaveTime:(NSTimeInterval)leaveTime {
    objc_setAssociatedObject(self, @selector(leaveTime), @(leaveTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)leaveTime {
     return  [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setCountDownFormat:(NSString *)countDownFormat {
    objc_setAssociatedObject(self, @selector(countDownFormat), countDownFormat, OBJC_ASSOCIATION_COPY);
}

- (NSString *)countDownFormat {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTimeStoppedCallback:(void (^)(void))timeStoppedCallback {
    objc_setAssociatedObject(self, @selector(timeStoppedCallback), timeStoppedCallback, OBJC_ASSOCIATION_COPY);
}

- (void (^)(void))timeStoppedCallback {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNormalTitle:(NSString *)normalTitle {
    objc_setAssociatedObject(self, @selector(normalTitle), normalTitle, OBJC_ASSOCIATION_COPY);
}

- (NSString *)normalTitle {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)ba_countDownWithTimeInterval:(NSTimeInterval)duration{
    [self ba_countDownWithTimeInterval:duration countDownFormat:nil];
}

- (void)ba_countDownWithTimeInterval:(NSTimeInterval)duration
                     countDownFormat:(NSString *)format{
    if (!format){
        self.countDownFormat = @"%zd秒";
    }else{
        self.countDownFormat = [@"%zd" stringByAppendingString:format];
    }
    self.userInteractionEnabled = NO;
    self.normalTitle = self.titleLabel.text;
    __block NSInteger timeOut = duration; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    WeakSelf(self)
    dispatch_source_set_event_handler(self.timer, ^{
        StrongSelf(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            if (timeOut <= 0) { // 倒计时结束，关闭
                [self ba_cancelTimer];
            } else {
                NSString *title = [NSString stringWithFormat:self.countDownFormat, timeOut];
                [self setTitle:title forState:UIControlStateNormal];
                timeOut --;
            }
        });
    });
    dispatch_resume(self.timer);
}

- (void)ba_countDownCustomWithTimeInterval:(NSTimeInterval)duration block:(BAKit_BAButtonCountDownBlock)block{
    __block NSInteger timeOut = duration; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    WeakSelf(self)
    dispatch_source_set_event_handler(self.timer, ^{
        StrongSelf(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block){
                block(timeOut);
            }
            if (timeOut <= 0){
                // 倒计时结束，关闭
                [self ba_cancelTimer];
            }else{
                timeOut--;
            }
        });
    });
    dispatch_resume(self.timer);
}

- (void)ba_cancelTimer{
    WeakSelf(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        StrongSelf(self)
        self.userInteractionEnabled = YES;
        dispatch_source_cancel(self.timer);
        self.timer = nil;
        // 设置界面的按钮显示 根据自己需求设置
        [self setTitle:self.normalTitle forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
        if (self.timeStoppedCallback) {
            self.timeStoppedCallback();
        }
    });
}

@end
