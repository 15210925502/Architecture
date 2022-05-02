//
//  VerifyAlertView.h
//  RebateProject
//
//  Created by 华令冬 on 2019/6/17.
//  Copyright © 2019 com.cn.HLD. All rights reserved.
//

//拼图验证
//拼图验证
//拼图验证
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VerifyState) {
    VerifyStateNot,         // 未验证（弹出验证码弹窗后，用户未进行验证，直接点击关闭按钮））
    VerifyStateFail,        // 验证失败（达到验证失败次数上限）
    VerifyStateSuccess,     // 验证成功（在允许的最大验证失败次数内，通过验证）
    VerifyStateIncomplete,  // 未完成验证（未达到允许的最大验证失败次数，点击了关闭按钮）
};

typedef void(^VerificationResults)(VerifyState state);

@interface VerifyAlertView : UIView

/** 验证状态 */
@property (nonatomic, readonly) VerifyState state;
/** 最大验证次数（默认 1，最小值 1） */
@property (nonatomic) NSUInteger maximumVerifyNumber;
/** 验证结果回调 */
@property (nullable, nonatomic, copy) VerificationResults results;

/**
 指定初始化

 @param maxNumber 最大验证次数
 @param results 验证结果回调
 @return 实例对象
 */
- (instancetype)initWithMaximumVerifyNumber:(NSUInteger)maxNumber
                                    results:(nullable VerificationResults)results NS_DESIGNATED_INITIALIZER;

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

/** 弹出 */
- (void)show;

@end

NS_ASSUME_NONNULL_END
