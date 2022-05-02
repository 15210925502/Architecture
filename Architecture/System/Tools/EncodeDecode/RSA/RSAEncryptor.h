//
//  RSAEncryptor.h
//  新用户中心
//
//  Created by 华令冬 on 2017/2/21.
//  Copyright © 2017年 华令冬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAEncryptor : NSObject

//⚠️可以用公钥串加密，用私钥文件进行解密，也可以用公钥文件加密，用私钥串文件进行解密
//⚠️可以用公钥串加密，用私钥文件进行解密，也可以用公钥文件加密，用私钥串文件进行解密
//⚠️可以用公钥串加密，用私钥文件进行解密，也可以用公钥文件加密，用私钥串文件进行解密

//加密方法
/**
 *  使用'.der'公钥文件加密
 *  @param str   需要加密的字符串
 *  @param path  '.der'格式的公钥文件路径
 */
+ (NSString *)encryptString:(NSString *)str
      keyWithContentsOfFile:(NSString *)path;
/**
 *  @param str      需要加密的字符串
 *  @param key      公钥或私钥字符串
 *  @param isSign 是否是公钥  YES为公钥，NO为私钥
 */
+ (NSString *)encryptString:(NSString *)str
                        key:(NSString *)key
                     isSign:(BOOL)isSign;
+ (NSData *)encryptData:(NSData *)data
                    key:(NSString *)key
                 isSign:(BOOL)isSign;

//解密方法
/**
 *  使用'.12'私钥文件解密
 *  @param str       需要解密的字符串
 *  @param path      '.p12'格式的私钥文件路径
 *  @param password  私钥文件密码
 */
+ (NSString *)decryptString:(NSString *)str
      keyWithContentsOfFile:(NSString *)path
                   password:(NSString *)password;
/**
 *  @param str     需要解密的字符串
 *  @param key 私钥或者公钥字符串
 *  @param isSign 是否是公钥  YES为公钥，NO为私钥
 */
+ (NSString *)decryptString:(NSString *)str
                        key:(NSString *)key
                     isSign:(BOOL)isSign;
+ (NSData *)decryptData:(NSData *)data
                    key:(NSString *)key
                 isSign:(BOOL)isSign;

@end
