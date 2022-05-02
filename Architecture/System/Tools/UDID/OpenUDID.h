//
//  OpenUDID.h
//  openudid
//
//  initiated by Yann Lechelle (cofounder @Appsfire) on 8/28/11.
//  Copyright 2011 OpenUDID.org
//

#import <Foundation/Foundation.h>

@interface OpenUDID : NSObject

//返回MD5后的值
+ (NSString *)valueForMD5;
+ (NSString *)value;
+ (NSString *)valueWithError:(NSError **)error;
+ (void)setOptOut:(BOOL)optOutValue;
/*
 @brief:设置存取取UUID的key,app启动期间仅仅执行一次
 @param uuidKey:UUID的key值,为空的情况下调用getBundleId
 */
+ (void)setUUIdKey:(NSString *)uuidKey;
//返回唯一标识符
+ (NSString *)uniqueIdentifier;
+ (NSString *)pd_UUID;

@end
