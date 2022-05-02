//
//  MD5Encryptor.m
//  MyTestProject
//
//  Created by 华令冬 on 2020/6/24.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "MD5Encryptor.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation MD5Encryptor

+ (NSString * _Nullable)pd_md5:(NSString *_Nullable)content {
    if(content == nil || [content length] == 0){
        return nil;
    }
    const char *cStr = [content UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", digest[i]];
    }
    return [output copy];
}

+ (NSString * _Nullable)pd_MD5:(NSString *_Nullable)content {
    return [[self pd_md5:content] uppercaseString];
}

@end
