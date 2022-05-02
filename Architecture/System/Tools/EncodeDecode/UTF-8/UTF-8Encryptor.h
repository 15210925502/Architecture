//
//  UTF-8Encryptor.h
//  MyTestProject
//
//  Created by 华令冬 on 2020/6/24.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UTF_8Encryptor : NSObject

#pragma mark - URL以utf-8编码一个字符串
+ (NSString *_Nullable)stringByEncode:(NSString *_Nullable)content;

#pragma mark - URL以utf-8解码一个字符串
+ (NSString *_Nullable)stringByDecode:(NSString *_Nullable)content;

@end
