//
//  NSMutableDictionary+Extension.h
//  Architecture
//
//  Created by 华令冬 on 2020/6/10.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (Extension)

//系统字典合并
+ (NSDictionary *)mergingWithFirstDictionary:(NSDictionary *)firstDic
                                   secondDic:(NSDictionary *)secondDic;

/**
 合并两个字典

 @param dict 被合并的字典
 */
- (void)mergingWithDictionary:(NSDictionary *)dict;

/**
 合并两个字典

 @param dict       被合并的字典
 @param ignoredKey 忽略的Key
 */
- (void)mergingWithDictionary:(NSDictionary *)dict
               ignoredDictKey:(NSString *)ignoredKey;


@end

NS_ASSUME_NONNULL_END
