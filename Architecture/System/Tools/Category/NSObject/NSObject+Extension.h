//
//  NSObject+Extension.h
//  Architecture
//
//  Created by 华令冬 on 2020/9/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Extension)

//计算某个事件的耗时
+ (uint64_t)start;
//返回多少秒,startTick参数就是上个方法返回的值
+ (double)endWithStartTick:(uint64_t)startTick;

@end

NS_ASSUME_NONNULL_END
