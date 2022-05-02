//
//  SHA1Encryptor.h
//  MyTestProject
//
//  Created by 华令冬 on 2020/6/24.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHA1Encryptor : NSObject

/** SHA1加密后输出， 全小写 */
+ (NSString * _Nullable)pd_sha1:(NSString *_Nullable)content;

/** SHA1加密后输出， 全大写 */
+ (NSString * _Nullable)pd_SHA1:(NSString *_Nullable)content;

@end
