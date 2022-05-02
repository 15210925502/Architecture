//
//  SandboxFile.h
//  文件存储
//
//  Created by HLD on 2017/6/14.
//  Copyright © 2017年 HLD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PathType){
    PathType_HomeDirectory = 0,  //Home
    PathType_Directory     = 1,  //document
    PathType_Cache         = 2,  //Cache
    PathType_Library       = 3,  //Library
    PathType_Tmp           = 4,  //Tmp
};

typedef NS_ENUM(NSInteger, ListType){
    ListType_FilePath = 0,  //文件名路径列表
    ListType_File     = 1,  //文件名列表
};

@interface SandboxFile : NSObject

@property (nonatomic, assign) CGFloat cacheSize;

//删除文件单利方法
+ (instancetype)ba_sharedCache;

//获取根目录路径
+ (NSString *)GetRootPath:(PathType)type;

/**
 *  获取目录列表里所有的文件名
 *
 *  @param absolutePth      绝对路径地址
 *
 *  @return NSArray
 */
+ (NSArray *)getSubpathsWithAbsolutePth:(NSString *)absolutePth;

/**
 *  获取目录列表里所有的文件名
 *
 *  @param type      根目录
 *  @param listPath  拼接地址，可以为字符串或者数组 不传设为nil
 *
 *  @return NSArray
 */
+ (NSArray *)getSubpathsAtType:(PathType)type
                      ListPath:(id)listPath;

/**
 @param type 文件类型
 @param path 文件所在文件夹路径
 @param listType 查找路径及其子路径下所有指定类型文件   或者    查找路径及其子路径下所有指定类型文件所在文件夹路径
 @return 查找所有
 */
+ (NSArray *)findAllFileWithType:(NSString *)type
                         andPath:(NSString *)path
                        listType:(ListType)listType;

//创建目录文件，不带文件名 listPath可以为字符串或者数组
+ (NSString *)createAtType:(PathType)type
                  listPath:(id)listPath;
//创建目录文件,带文件名 listPath可以为字符串或者数组
+ (NSString *)createAtType:(PathType)type
                  listPath:(id)listPath
                  fileName:(NSString *)fileName;

//如果我们的APP需要存放比较大的文件的时候，同时又不希望被系统清理掉，那我么我们就需要把我们的资源保存在Documents目录下，但是我们又不希望他会被iCloud备份，因此就有了这个方法
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePathString;

//是否存在该文件
+ (BOOL)isFileExists:(NSString *)filepath;

//写入NsArray或者NSDictionary文件
+ (BOOL)writeFile:(id)Object
    specifiedFile:(NSString *)path;

/**
 写文件
 文件都存到library路径下
 path : 存储文件的路径的相对路径，不包含文件名
 fileName : 文件的名字
 */
+ (BOOL)writeData:(id)file
           toPath:(NSString *)path
         fileName:(NSString *)fileName;

/**
 读文件
 文件都存到library路径下
 path : 存储文件的路径的相对路径，不包含文件名
 fileName : 文件的名字
 */
+ (instancetype)readDataFromBranch:(NSString *)path
                          fileName:(NSString *)fileName;

/**
 *  删除指定文件
 *
 *  @param listPath  拼接地址，可以为字符串或者数组 不传设为nil
 *  @param fileName  文件名   不传设为nil
 *
 */
+ (BOOL)deleteFileForListPath:(id)listPath
                     fileName:(NSString *)fileName;

/**
 *  删除指定文件
 *
 *  @param type      根目录
 *  @param listPath  拼接地址，可以为字符串或者数组 不传设为nil
 *  @param fileName  文件名   不传设为nil
 *
 */
+ (BOOL)deleteFileForType:(PathType)type
                 listPath:(id)listPath
                 fileName:(NSString *)fileName;

/**
 *  获取数据
 *
 *  @param type      根目录
 *  @param listPath  拼接地址，可以为字符串或者数组 不传设为nil
 *  @param fileName  文件名
 *
 *  @return 数据  Data
 */
+ (NSData *)getDataForType:(PathType)type
                  listPath:(id)listPath
                  fileName:(NSString *)fileName;

/*!
 *  计算目录大小和单个文件大小
 *  @param path path路径
 *  @return 计算目录大小
 */
- (CGFloat)folderSizeAtPath:(NSString *)path;

/*!
 *  计算单个文件大小
 *  @param path path路径
 *  @return 计算单个文件大小
 */
- (CGFloat)ba_fileSizeAtPath:(NSString *)path;

/**
 *  @brief:给定的字节数返回说明
 *  @paramnumBytes
 *  @return 返回一个字节数的文字说明
 */
+ (NSString *)prettyBytes:(uint64_t)numBytes;

//清除缓存
- (void)ba_myClearCacheAction;

//清除缓存成功回调
- (void)ba_clearCacheSuccess;

@end
