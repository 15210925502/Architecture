//
//  SandboxFile.m
//  文件存储
//
//  Created by HLD on 2017/6/14.
//  Copyright © 2017年 HLD. All rights reserved.
//

#import "SandboxFile.h"

@implementation SandboxFile

-(void)beiYongFangFa{
    // 根据components中的元素来构建路径.
    NSString *path = [NSString pathWithComponents:@[@"HLD",@"hld",@"123"]];
    path = [path stringByAppendingPathComponent:@"456.txt"];
    //    提取路径中的最后一个组成部分
    NSLog(@"%@",[path lastPathComponent]);
    //   从路径中最后一个组成部分中提取扩展名
    NSLog(@"%@",[path pathExtension]);
    //   将指定的扩展名添加到现有路径的最后一个组成部分上
    NSLog(@"%@",[path stringByAppendingPathExtension:@"pdf"]);
    //   删除路径中的最后一个组成部分
    NSLog(@"%@",[path stringByDeletingLastPathComponent]);
    //   从文件的最后一部分删除扩展名
    NSLog(@"%@",[path stringByDeletingPathExtension]);
    
    //    常用的NSProcessInfo类(进程相关)
    //    返回当前进程信息
    NSLog(@"%@",[NSProcessInfo processInfo]);
    //     以NSString对象数字的形式返回当前进程的参数
    NSLog(@"%@",[[[NSProcessInfo alloc] init] arguments]);
    //     返回变量/值对字典,以描述当前的环境变量(比如PATH等等)
    NSLog(@"%@",[[[NSProcessInfo alloc] init] environment]);
    //     返回进程PID
    NSLog(@"%d",[[[NSProcessInfo alloc] init] processIdentifier]);
    //     返回当前正在执行的进程名称
    NSLog(@"%@",[[[NSProcessInfo alloc] init] processName]);
    //     每次调用该方法时,都会返回不同的单值字符串,可以生成临时文件名
    NSLog(@"%@",[[[NSProcessInfo alloc] init] globallyUniqueString]);
    //     返回主机系统名
    NSLog(@"%@",[[[NSProcessInfo alloc] init] hostName]);
    //     返回表示操作系统的数字
    NSLog(@"%ld",[[[NSProcessInfo alloc] init] operatingSystem]);
    //     返回操作系统的名称
    NSLog(@"%@",[[[NSProcessInfo alloc] init] operatingSystemName]);
    //     返回操作系统版本
    NSLog(@"%@",[[[NSProcessInfo alloc] init] operatingSystemVersionString]);
    //     修改当前进程名(谨慎使用)
    [[[NSProcessInfo alloc] init] setProcessName:@"888"];
}

+ (instancetype)ba_sharedCache{
    static SandboxFile *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SandboxFile alloc] init];
    });
    return manager;
}

+ (NSString *)GetRootPath:(PathType)type{
    NSString *rootPath = nil;
    switch (type) {
        case PathType_HomeDirectory:
        {
            rootPath = NSHomeDirectory();
        }
            break;
        case PathType_Directory:
        {
            NSArray *Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            rootPath = [Paths objectAtIndex:0];
        }
            break;
        case PathType_Cache:
        {
            NSArray *Paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            rootPath = [Paths objectAtIndex:0];
        }
            break;
        case PathType_Library:
        {
            NSArray *Paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            rootPath = [Paths objectAtIndex:0];
        }
            break;
        case PathType_Tmp:
        {
            rootPath = NSTemporaryDirectory();
        }
            break;
            
        default:
            break;
    }
    return rootPath;
}

+ (NSString *)createAtType:(PathType)type
                  listPath:(id)listPath{
    return [self createAtType:type
                     listPath:listPath
                     fileName:nil];
}

+ (NSString *)createAtType:(PathType)type
                  listPath:(id)listPath
                  fileName:(NSString *)fileName{
    //    根据URL创建目录
    //    提取路径中的最后一个组成部分
    //    [URLString pathExtension]
    //    删除路径中的最后一个组成部分
    //    [URLString stringByDeletingPathExtension]
    
    //    文件是否可读
    //    -(bool) fileHandleForReadingAtPath
    //    文件是否可写
    //    -(void) fileHandleForWritingAtPath
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileDirectory = [SandboxFile GetRootPath:type];
    if ([listPath isKindOfClass:[NSString class]]) {
        fileDirectory = [fileDirectory stringByAppendingPathComponent:listPath];
    }else if([listPath isKindOfClass:[NSArray class]]){
        fileDirectory = [fileDirectory stringByAppendingPathComponent:[NSString pathWithComponents:listPath]];
    }
    if (fileName) {
        if ([self isFileExists:fileDirectory]) {
            fileDirectory = [fileDirectory stringByAppendingPathComponent:fileName];
            if (![self isFileExists:fileDirectory]) {
                [fileManager createFileAtPath:fileDirectory contents:nil attributes:nil];
            }
        }else{
            fileDirectory = [self addSuffix:fileDirectory];
            NSError *error;
            if([fileManager createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:&error]){
                fileDirectory = [fileDirectory stringByAppendingPathComponent:fileName];
                [fileManager createFileAtPath:fileDirectory contents:nil attributes:nil];
            }else{
                NSLog(@"create dir error: %@",error.debugDescription);
            }
        }
    }else{
        fileDirectory = [self addSuffix:fileDirectory];
        if (![self isFileExists:fileDirectory]) {
            NSError *error;
            if(![fileManager createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:&error]){
                NSLog(@"create dir error: %@",error.debugDescription);
            }
        }
    }
    return fileDirectory;
}

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePathString{
    NSURL *URL = [NSURL fileURLWithPath:filePathString];
        NSError *error = nil;
        //SURLIsExcludedFromBackupKey: 不被备份;
        BOOL success = [URL setResourceValue:[NSNumber numberWithBool: YES] forKey:NSURLIsExcludedFromBackupKey error: &error];
        if(!success) {
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
}

+ (NSString *)addSuffix:(NSString *)pathStr{
    NSString *lastStr = [pathStr substringFromIndex:pathStr.length - 1];
    if (![lastStr isEqualToString:@"/"]) {
        pathStr = [pathStr stringByAppendingString:@"/"];
    }
    return pathStr;
}

+ (BOOL)writeFile:(id)Object
    specifiedFile:(NSString *)path{
    return [Object writeToFile:path atomically:YES];
}

+ (NSData *)getDataForType:(PathType)type
                  listPath:(id)listPath
                  fileName:(NSString *)fileName{
    if (fileName == nil) {
        return nil;
    }
    NSString *path = nil;
    if (listPath != nil) {
        if ([listPath isKindOfClass:[NSString class]]) {
            path = [[SandboxFile GetRootPath:type] stringByAppendingPathComponent:listPath];
        }else if([listPath isKindOfClass:[NSArray class]]){
            path = [NSString pathWithComponents:listPath];
            path = [[SandboxFile GetRootPath:type] stringByAppendingPathComponent:path];
        }
    }
    path = [path stringByAppendingPathComponent:fileName];
    return [[NSFileManager defaultManager] contentsAtPath:path];
}

+ (NSArray *)getSubpathsWithAbsolutePth:(NSString *)absolutePth{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSArray *file;
    if (absolutePth) {
        file = [fileManage subpathsAtPath:absolutePth];
    }
    return file;
}

+ (NSArray *)getSubpathsAtType:(PathType)type
                      ListPath:(id)listPath{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *path = nil;
    if (listPath != nil) {
        if ([listPath isKindOfClass:[NSString class]]) {
            path = [[SandboxFile GetRootPath:type] stringByAppendingPathComponent:listPath];
        }else if([listPath isKindOfClass:[NSArray class]]){
            //            根据components中的元素来构建路径.
            path = [NSString pathWithComponents:listPath];
            path = [[SandboxFile GetRootPath:type] stringByAppendingPathComponent:path];
        }
    }
    NSArray *file = [fileManage subpathsAtPath:path];
    return file;
}

+ (NSArray *)findAllFileWithType:(NSString *)type
                         andPath:(NSString *)path
                        listType:(ListType)listType{
    NSFileManager *manager = [NSFileManager defaultManager];
    //深度遍历路径及其子路径下所有文件以及文件夹
    NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath:path];
    //文件及文件夹名称数组
    NSMutableArray *fileNameListArray = [NSMutableArray array];
    //路径下所有文件和文件夹
    NSString *allPath;
    while ((allPath = [dirEnum nextObject]) != nil){
        [fileNameListArray addObject:allPath];
    }
    //所需文件数组
    NSMutableArray *fileArray = [NSMutableArray array];
    //遍历所有所有文件和文件夹名称数组
    [fileNameListArray enumerateObjectsUsingBlock:^(NSString *filePath, NSUInteger idx, BOOL * _Nonnull stop) {
        //后缀名称
        NSString *lastPath = [filePath pathExtension];
        //判断后缀名称是否是需要类型
        if([lastPath isEqualToString:type]){
            //是
            if (listType == ListType_FilePath) {
                [fileArray addObject:[NSString stringWithFormat:@"%@%@",[self addSuffix:path],filePath]];
            }else if(listType == ListType_File){
                [fileArray addObject:path];
            }
        }else{
            //不是
        }
    }];
    return fileArray;
}

+ (BOOL)isFileExists:(NSString *)filepath{
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

+ (BOOL)removeAllFilesInPath:(NSString *)filePath{
    BOOL result = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtPath:filePath];
        NSString *fileName = nil;
        while (fileName = [directoryEnumerator nextObject]) {
            NSString *fullFileName = [filePath stringByAppendingPathComponent:fileName];
            NSDictionary *fileAttr = [directoryEnumerator fileAttributes];
            NSString *fileType = [fileAttr objectForKey:NSFileType];
            if ([fileType isEqualToString:NSFileTypeDirectory]) {
                result = [[self class] removeAllFilesInPath:fullFileName];
            }
            NSError *error = nil;
            if (![fileManager removeItemAtPath:fullFileName error:&error]) {
                result = NO;
                break;
            }else {
                result = YES;
            }
        }
    }
    return result;
}

#pragma mark - 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    CGFloat folderSize = 0.0f;
    
    // -------------------   方法1   -------------------
    // 文件属性
    //    NSDictionary *attrs = [fileManager attributesOfItemAtPath:path error:nil];
    //    // 如果这个文件或者文件夹不存在,或者路径不正确直接返回0;
    //    if (attrs == nil){
    //        return 0;
    //    }
    //    // 如果是文件夹
    //    if ([attrs.fileType isEqualToString:NSFileTypeDirectory]) {
    //        //        NSArray *enumerator = [fileManager subpathsAtPath:path];
    //        //        或者
    //        NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:path];
    //
    //        for (NSString *subPath in enumerator) {
    //            NSString *fullPath = [path stringByAppendingPathComponent:subPath];
    //            folderSize += [self ba_fileSizeAtPath:fullPath];
    //        }
    //    }else{
    //        folderSize += [self ba_fileSizeAtPath:path];
    //    }
    
    // -------------------   方法2   -------------------
    BOOL isDir = NO;
    BOOL exist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    // 判断路径是否存在
    if (!exist){
        return 0;
    }
    // 是文件夹
    if (isDir) {
        //        NSArray *enumerator = [fileManager subpathsAtPath:path];
        //        或者
        NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:path];
        for (NSString *subPath in enumerator) {
            NSString *fullPath = [path stringByAppendingPathComponent:subPath];
            folderSize += [self ba_fileSizeAtPath:fullPath];
        }
    }else{ // 是文件
        folderSize += [self ba_fileSizeAtPath:path];
    }
    return folderSize;
}

#pragma mark - 计算单个文件大小
- (CGFloat)ba_fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size / 1024.0 / 1024.0;
    }
    return 0;
}

+ (NSString *)prettyBytes:(unsigned long long)byteCount{
    float numberOfBytes = byteCount;
    int multiplyFactor = 0;
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB",@"EB",@"ZB",@"YB",nil];
    while (numberOfBytes > 1024) {
        numberOfBytes /= 1024;
        multiplyFactor++;
    }
    return [NSString stringWithFormat:@"%4.2f %@",numberOfBytes, [tokens objectAtIndex:multiplyFactor]];
}

#pragma mark - 清除缓存
- (void)ba_myClearCacheAction{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [SandboxFile GetRootPath:PathType_Cache];
        NSLog(@"cachPath===%@",cachPath);
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        NSLog(@"files :%lu",(unsigned long)[files count]);
        NSLog(@"file === %@",files);
        for (NSString *p in files){
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        [self performSelectorOnMainThread:@selector(ba_clearCacheSuccess) withObject:nil waitUntilDone:YES];});
}

- (void)ba_clearCacheSuccess{
    NSLog(@"清理成功");
}

/**
 检查是否遵守了NSCoding协议，是否实现了归档方法
 
 @param obj 待归档解档的对象
 @return 检查结果状态
 */
+ (BOOL)checkEncodeWithCoder:(id)obj {
    // && [obj conformsToProtocol:@protocol(NSCoding)]
    return ([obj respondsToSelector:@selector(encodeWithCoder:)]);
}

+ (BOOL)writeData:(id)data
           toPath:(NSString *)path
         fileName:(NSString *)fileName {
    BOOL result = NO;
    
    //    解决 Swift 环境下变更 Xcode 工程名后使用 NSKeyedUnarchiver 解档引起的崩溃问题
    NSString *className = [NSString stringWithFormat:@"%@.UserModel",[[NSBundle mainBundle] pd_bundleName]];
    [NSKeyedArchiver setClassName:className forClass:NSClassFromString(@"UserModel")];
    
    //判断obj里是否实现了归档方法
    if (![self checkEncodeWithCoder:data]) {
        NSLog(@"%@ 没有实现encodeWithCoder方法",data);
        return result;
    }
    NSString *cachePath = [SandboxFile CreatePath:path];
    NSString *filePathName = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    
    NSData *extendedData;
    if (@available(iOS 11, tvOS 11, macOS 10.13, watchOS 4, *)) {
        NSError *error;
        extendedData = [NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:NO error:&error];
        if (error) {
            NSLog(@"NSKeyedArchiver archive failed with error: %@", error);
        }
    } else {
        @try {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            extendedData = [NSKeyedArchiver archivedDataWithRootObject:data];
#pragma clang diagnostic pop
        } @catch (NSException *exception) {
            NSLog(@"NSKeyedArchiver archive failed with exception: %@", exception);
        }
    }
    if (extendedData) {
        result = [NSKeyedArchiver archiveRootObject:extendedData toFile:filePathName];
    }
    return result;
}

+ (instancetype)readDataFromBranch:(NSString *)path
                          fileName:(NSString *)fileName{
    
    //    解决 Swift 环境下变更 Xcode 工程名后使用 NSKeyedUnarchiver 解档引起的崩溃问题
    NSString *className = [NSString stringWithFormat:@"%@.UserModel",[[NSBundle mainBundle] pd_bundleName]];
    [NSKeyedUnarchiver setClass:NSClassFromString(@"UserModel") forClassName:className];
    
    NSString *cachePath = [SandboxFile CreatePath:path];
    NSString *filePathName = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    
    id result;
    NSData *extendedData = [NSKeyedUnarchiver unarchiveObjectWithFile:filePathName];
    if (extendedData) {
        id extendedObject;
        if (@available(iOS 11, tvOS 11, macOS 10.13, watchOS 4, *)) {
            NSError *error;
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:extendedData error:&error];
            unarchiver.requiresSecureCoding = NO;
            extendedObject = [unarchiver decodeTopLevelObjectForKey:NSKeyedArchiveRootObjectKey error:&error];
            if (error) {
                NSLog(@"NSKeyedUnarchiver unarchive failed with error: %@", error);
            }
        } else {
            @try {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                extendedObject = [NSKeyedUnarchiver unarchiveObjectWithData:extendedData];
#pragma clang diagnostic pop
            } @catch (NSException *exception) {
                NSLog(@"NSKeyedUnarchiver unarchive failed with exception: %@", exception);
            }
        }
        result = extendedObject;
    }
    return result;
}

+ (BOOL)deleteFileForListPath:(id)listPath
                     fileName:(NSString *)fileName{
    return [self deleteFileForType:PathType_Library
                          listPath:listPath
                          fileName:fileName];
}

+ (BOOL)deleteFileForType:(PathType)type
                 listPath:(id)listPath
                 fileName:(NSString *)fileName{
    BOOL result = NO;
    NSString *delPath = [SandboxFile GetRootPath:type];
    if (listPath != nil) {
        if ([listPath isKindOfClass:[NSString class]]) {
            delPath = [[SandboxFile GetRootPath:type] stringByAppendingPathComponent:listPath];
        }else if([listPath isKindOfClass:[NSArray class]]){
            delPath = [NSString pathWithComponents:listPath];
            delPath = [[SandboxFile GetRootPath:type] stringByAppendingPathComponent:delPath];
        }
    }
    if (fileName != nil) {
        delPath = [delPath stringByAppendingPathComponent:fileName];
        if([[NSFileManager defaultManager] fileExistsAtPath:delPath]){
            result = [[NSFileManager defaultManager] removeItemAtPath:delPath error:nil];
        }
    }else{
        result = [SandboxFile removeAllFilesInPath:delPath];
    }
    return result;
}

+ (NSString *)CreatePath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *FileDirectory = [SandboxFile GetRootPath:PathType_Library];
    if (path != nil) {
        FileDirectory = [FileDirectory stringByAppendingPathComponent:path];
    }
    if ([self isFileExists:FileDirectory]){
        NSLog(@"exist,%@",FileDirectory);
    }else{
        NSError *error;
        if(![fileManager createDirectoryAtPath:FileDirectory withIntermediateDirectories:YES attributes:nil error:&error]){
            NSLog(@"create dir error: %@",error.debugDescription);
        }
    }
    return FileDirectory;
}

@end
