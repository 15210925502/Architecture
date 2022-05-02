//
//  VerificationCodButton.h
//  tedddd
//
//  Created by 华令冬 on 2019/6/21.
//  Copyright © 2019 com.cn.HLD. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GETCODETITLE @"获取验证码"
#define COUNTDOWNTITLE @"重新获取"

typedef void(^TimeStoppedCallback)(void);

@interface VerificationCodButton : UIButton

/**
 * 倒计时结束的回调
 */
@property (nonatomic, copy) TimeStoppedCallback back;

/**
 设置倒计时的间隔和倒计时文案
 
 @param duration 倒计时时间
 @param format 可选，传nil默认为 @"%zd秒"
 */
+ (instancetype)createButtonWithTimeInterval:(NSTimeInterval)duration
                             countDownFormat:(NSString *)format
                                    callBack:(TimeStoppedCallback)back;

/**
 * invalidate timer
 */
- (void)cancelTimer;

///设置倒计时
//- (void)setCountdown:(NSTimeInterval)timeOut;
/////手动结束倒计时 离开页面之前 请务必调用
//- (void)cancelCountdown;

@end
