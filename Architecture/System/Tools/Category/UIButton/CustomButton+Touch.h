//
//  CustomButton+Touch.h
//  test
//
//  Created by 华令冬 on 2020/12/21.
//

/**
 *UIButton防止重复点击
 *UIButton防止重复点击
 *UIButton防止重复点击
 */
#import "CustomButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomButton (Touch)

/** 时间间隔 */
@property(nonatomic, assign) NSTimeInterval cs_eventInterval;

@end

NS_ASSUME_NONNULL_END
