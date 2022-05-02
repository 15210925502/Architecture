//
//  SHA1Encryptor.m
//  MyTestProject
//
//  Created by 华令冬 on 2020/6/24.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "SHA1Encryptor.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation SHA1Encryptor

+ (NSString *)pd_sha1:(NSString *_Nullable)content {
    return [[self pd_SHA1:content] lowercaseString];
}

+ (NSString *)pd_SHA1:(NSString *_Nullable)content {
    const char *strData = [content UTF8String];
    unsigned char result[CC_SHA1_DIGEST_LENGTH] = {'\0'};
    CC_SHA1(strData, (CC_LONG)content.length, result);
    NSMutableString *sha1 = [[NSMutableString alloc] init];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [sha1 appendFormat:@"%02X", result[i]];
    }
    return sha1;
}

@end
