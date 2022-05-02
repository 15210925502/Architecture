//
//  NSMutableDictionary+Extension.m
//  Architecture
//
//  Created by 华令冬 on 2020/6/10.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "NSMutableDictionary+Extension.h"

@implementation NSMutableDictionary (Extension)

+ (NSDictionary *)mergingWithFirstDictionary:(NSDictionary *)firstDic
                                   secondDic:(NSDictionary *)secondDic{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic addEntriesFromDictionary:firstDic];
    [resultDic addEntriesFromDictionary:secondDic];
    return resultDic.copy;
}

- (void)mergingWithDictionary:(NSDictionary *)dict{
    for (id key in [dict allKeys]) {
        id obj = [self mutableDictionaryCopyIfNeeded:[dict objectForKey:key]];
        id localObj = [self mutableDictionaryCopyIfNeeded:[self objectForKey:key]];
        if ([obj isKindOfClass:[NSDictionary class]] &&
            [localObj isKindOfClass:[NSMutableDictionary class]]) {
            // Recursive merge for NSDictionary
            [localObj mergingWithDictionary:obj];
        } else if (obj) {
            [self setObject:obj forKey:key];
        }
    }
}

- (void)mergingWithDictionary:(NSDictionary *)dict
               ignoredDictKey:(NSString *)ignoredKey{
    for (id key in [dict allKeys]) {
        if ([key isEqualToString:ignoredKey]) {
            continue;
        }
        id obj = [self mutableDictionaryCopyIfNeeded:[dict objectForKey:key]];
        id localObj = [self mutableDictionaryCopyIfNeeded:[self objectForKey:key]];
        if ([obj isKindOfClass:[NSDictionary class]] &&
            [localObj isKindOfClass:[NSMutableDictionary class]]) {
            // Recursive merge for NSDictionary
            [localObj mergingWithDictionary:obj];
        } else if (obj) {
            [self setObject:obj forKey:key];
        }
    }
}

- (instancetype)mutableDictionaryCopyIfNeeded:(id)dictObj{
    if ([dictObj isKindOfClass:[NSDictionary class]] &&
        ![dictObj isKindOfClass:[NSMutableDictionary class]]) {
        dictObj = [dictObj mutableCopy];
    }
    return dictObj;
}

@end
