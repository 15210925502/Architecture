//
//  Encryptor.m
//  MyTestProject
//
//  Created by 华令冬 on 2020/6/24.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "Encryptor.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation Encryptor

+ (NSString *)encryptWithContent:(NSString *)content
                             key:(NSString *)key
                byUsingAlgorithm:(PDCCAlgorithm)algorithm
                  base64Encoding:(BOOL)base64Encoding {
    const void *vsourceString;
    size_t sourceStringBufferSize;
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    sourceStringBufferSize = [data length];
    vsourceString = (const void *)[data bytes];
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (sourceStringBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = (uint8_t *)malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *)[key UTF8String];
    ccStatus = CCCrypt(kCCEncrypt, algorithm, kCCOptionECBMode | kCCOptionPKCS7Padding , vkey, kCCKeySize3DES, nil, vsourceString, sourceStringBufferSize, (void *)bufferPtr, bufferPtrSize, &movedBytes);
    NSData *myData = [NSData dataWithBytesNoCopy:bufferPtr length:movedBytes freeWhenDone:YES];
    if (base64Encoding) {
        return [myData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
    } else {
        return [[NSString alloc] initWithData:myData encoding:(NSUTF8StringEncoding)];
    }
}

+ (NSString *)decryptWithContent:(NSString *)content
                             key:(NSString *)key
                byUsingAlgorithm:(PDCCAlgorithm)algorithm
                 isBase64Encoded:(BOOL)isBase64Encoded {
    const void *vsourceString;
    size_t sourceStringBufferSize;
    
    NSData *EncryptData = nil;
    if (isBase64Encoded) {
        EncryptData = [[NSData alloc] initWithBase64EncodedString:content options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    } else {
        EncryptData = [content dataUsingEncoding:(NSUTF8StringEncoding)];
    }
    
    sourceStringBufferSize = [EncryptData length];
    vsourceString          = [EncryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (sourceStringBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = (uint8_t *)malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *)[key UTF8String];
    ccStatus = CCCrypt(kCCDecrypt, algorithm, kCCOptionECBMode | kCCOptionPKCS7Padding , vkey, kCCKeySize3DES, nil, vsourceString, sourceStringBufferSize, (void *)bufferPtr, bufferPtrSize, &movedBytes);
    
    return [[NSString alloc] initWithBytesNoCopy:(void *)bufferPtr length:movedBytes encoding:NSUTF8StringEncoding freeWhenDone:YES];
}

@end
