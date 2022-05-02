//
//  Encryptor.h
//  MyTestProject
//
//  Created by 华令冬 on 2020/6/24.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PDCCAlgorithm){
    PDCCAlgorithm_AES128 = 0,
    PDCCAlgorithm_AES = 0,
    PDCCAlgorithm_DES,
    PDCCAlgorithm_3DES,
    PDCCAlgorithm_CAST,
    PDCCAlgorithm_RC4,
    PDCCAlgorithm_RC2,
    PDCCAlgorithm_Blowfish
};

@interface Encryptor : NSObject

/**
 *  将字符进加密成密文。
 *
 *  @param content        加密内容
 *  @param key            密钥
 *  @param algorithm      加密算法
 *  @param base64Encoding 密文是否进行 base64 编码
 *
 *  @return 密文字符串
 */
+ (NSString *)encryptWithContent:(NSString *)content
                             key:(NSString *)key
                byUsingAlgorithm:(PDCCAlgorithm)algorithm
                  base64Encoding:(BOOL)base64Encoding;

/**
 *  把字符串解密成明文。
 *
 *  @param content         加密内容
 *  @param key             密钥
 *  @param algorithm       所使用的加密算法
 *  @param isBase64Encoded 密文字符串是否进行了 base64 编码
 *
 *  @return 明文字符串
 */
+ (NSString *)decryptWithContent:(NSString *)content
                             key:(NSString *)key
                byUsingAlgorithm:(PDCCAlgorithm)algorithm
                 isBase64Encoded:(BOOL)isBase64Encoded;

@end
