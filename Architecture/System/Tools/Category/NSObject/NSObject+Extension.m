//
//  NSObject+Extension.m
//  Architecture
//
//  Created by 华令冬 on 2020/9/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "NSObject+Extension.h"
#import <mach/mach.h>

@implementation NSObject (Extension)

//获取当前系统的Mach绝对时刻
//是一个CPU/总线依赖函数，返回一个基于系统启动后的时钟"嘀嗒"数。在macOS上可以确保它的行为，并且，它包含系统时钟所包含的所有时间区域。其可获取纳秒级的精度。(注: 时钟嘀嗒数在每次手机重启后，都会重新开始计数，而且iPhone锁屏进入休眠之后，tick也会暂停计数)
+ (uint64_t)getTick{
    // 单位事纳秒
    uint64_t nTick = mach_absolute_time();
    return nTick;
}

+ (uint64_t)start{
    return [self getTick];
}

+ (double)endWithStartTick:(uint64_t)startTick{
    uint64_t endTick = [self getTick];
    uint64_t nTotalTick = endTick - startTick;
    
    mach_timebase_info_data_t _timebaseInfo;
//    函数用于获取当前系统时钟嘀嗒数转换信息。(主要是获取当前设备的转换分子和分母)
    mach_timebase_info(&_timebaseInfo);
    //ns 转换为 s
//    通常，转换是通过分子（info.numer）除以分母(info.denom).这里乘以一个1e-9来获取秒数
    return nTotalTick * _timebaseInfo.numer / _timebaseInfo.denom / 1e9;
}

@end
