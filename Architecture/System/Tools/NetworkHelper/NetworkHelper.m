//
//  NetworkHelper.m
//  MyTestProject
//
//  Created by HLD on 2019/3/11.
//  Copyright © 2019 com.cn.HLD. All rights reserved.
//

#import "NetworkHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import "MBProgressHUD+Extension.h"

//请求数组
static NSMutableArray *requestTasks;
//是否添加缓存
static BOOL refreshCache = NO;
//是否验证当前网络
static BOOL zx_shoulObtainLocalWhenUnconnected = YES;

static inline NSString *cachePath(){
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/WZXNetworkingCaches"];
}

@interface NetworkHelper ()

@property (nonatomic,strong) NSURLSessionDownloadTask *downloadTask;

@end

@implementation NetworkHelper

+ (NetworkHelper *)sharedManager{
    static NetworkHelper *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:ConfigurationFile.baseURLString]];
        //设置序列化
        [_sharedManager setRequestSer:kHQRequestTypeJSON];
        [_sharedManager setResponseSer:kHQResponseTypeData];
        _sharedManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        //忽略证书(如果需要验证自建证书(无效证书)，需要设置为YES)
        _sharedManager.securityPolicy.allowInvalidCertificates = YES;
        // 是否需要验证域名，默认为YES;
        _sharedManager.securityPolicy.validatesDomainName = NO;
        //        证书路径
        NSData *cerData = [NSData dataWithContentsOfFile:@""];
        if (cerData) {
            _sharedManager.securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
        }
        _sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                         @"text/html",
                                                                                         @"text/json",
                                                                                         @"text/plain",
                                                                                         @"text/javascript",
                                                                                         @"text/xml",
                                                                                         @"image/*"]];
        
        //设置公共参数
        NSDictionary *publicParameters = [_sharedManager getPublicParameters];
        [_sharedManager configCommonHttpHeaders:publicParameters];
        
        //设置最大并发数
        _sharedManager.operationQueue.maxConcurrentOperationCount = 5;
        _sharedManager.isShowNetworkActivityIndicator = YES;
    });
    //设置超时时间
    [_sharedManager setTimeout:60];
    if(zx_shoulObtainLocalWhenUnconnected){
        [NetworkHelper networkStatusWithBlock:^(HQNetworkStatus status) {
            _sharedManager.currentNetworkStatus = status;
        }];
    }
    return _sharedManager;
}

- (BOOL)isNetworkAvailable{
    return [NetworkHelper sharedManager].currentNetworkStatus != NetworkStatusNotReachable;
}

- (void)setTimeout:(NSTimeInterval)timeout{
    self.requestSerializer.timeoutInterval = timeout;
}

- (void)setNetworkActivityIndicatorVisible:(BOOL)state{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = state;
    self.isShowNetworkActivityIndicator = YES;
}

- (void)setRequestSer:(HQRequestType)type{
    switch (type) {
        case kHQRequestTypeJSON:{
            self.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        }
        case kHQRequestTypePlainText:{
            self.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        }
        default:{
            break;
        }
    }
}

- (void)setResponseSer:(HQResponseType)type{
    switch (type) {
        case kHQResponseTypeJSON:{
            self.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        }
        case kHQResponseTypeXML:{
            self.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        }
        case kHQResponseTypeData:{
            self.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        }
        default:
            break;
    }
}

- (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders{
    for(NSString *key in httpHeaders.allKeys) {
        if(httpHeaders[key] != nil){
            [self.requestSerializer setValue:httpHeaders[key] forHTTPHeaderField:key];
        }
    }
}

- (HQURLSessionTask *)getWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                         success:(HLDHttpRequestSuccess)success
                         failure:(HLDHttpRequestFailed)failure
                       noNetwork:(HLDHttpNoNetwork)noNetwork{
    return [self getWithUrl:url
                     params:params
                   progress:nil
                    success:success
                    failure:failure
                  noNetwork:noNetwork];
}

- (HQURLSessionTask *)getWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                        progress:(HttpProgress)progress
                         success:(HLDHttpRequestSuccess)success
                         failure:(HLDHttpRequestFailed)failure
                       noNetwork:(HLDHttpNoNetwork)noNetwork{
    return [self requestWithUrl:url
                   refreshCache:refreshCache
                      httpMedth:RequestDataTypeGet
                         params:params
                  responseCache:nil
                       progress:progress
                        success:success
                        failure:failure
                      noNetwork:noNetwork];
}

- (HQURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                          success:(HLDHttpRequestSuccess)success
                          failure:(HLDHttpRequestFailed)failure
                        noNetwork:(HLDHttpNoNetwork)noNetwork{
    return [self postWithUrl:url
                      params:params
                    progress:nil
                     success:success
                     failure:failure
                   noNetwork:noNetwork];
}

- (HQURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                         progress:(HttpProgress)progress
                          success:(HLDHttpRequestSuccess)success
                          failure:(HLDHttpRequestFailed)failure
                        noNetwork:(HLDHttpNoNetwork)noNetwork{
    return  [self requestWithUrl:url
                    refreshCache:refreshCache
                       httpMedth:RequestDataTypePost
                          params:params
                   responseCache:nil
                        progress:progress
                         success:success
                         failure:failure
                       noNetwork:noNetwork];
}

#pragma mark - 上传图片文件
- (NSURLSessionTask *)uploadWithURL:(NSString *)url
                         parameters:(NSDictionary *)parameters
                             images:(NSArray<UIImage *> *)images
                               name:(NSString *)name
                           mimeType:(NSString *)mimeType
                           progress:(HttpProgress)progress
                            success:(HLDHttpRequestSuccess)success
                            failure:(HLDHttpRequestFailed)failure{
    NSURLSessionDataTask *dataTask = [self POST:url
                                     parameters:parameters
                                        headers:nil
                      constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //压缩-添加-上传图片
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            long index = idx;
            
            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
            long long totalMilliseconds = interval * 1000;
            NSString *fileName = [NSString stringWithFormat:@"%lld.png", totalMilliseconds];
            NSString *tempName = [NSString stringWithFormat:@"%@%ld", mimeType ? mimeType : @"jpeg", index];
            // NSLog(@"fileName = %@   tempName = %@", fileName, tempName);
            NSString *tempMimeTpe = [NSString stringWithFormat:@"image/%@",mimeType ? mimeType : @"jpeg"];
            [formData appendPartWithFileData:imageData
                                        name:tempName
                                    fileName:fileName
                                    mimeType:tempMimeTpe];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allTasks] removeObject:task];
        [self setNetworkActivityIndicatorVisible:NO];
        if(success){
          success(responseObject);
        }
        //        NSLog(@"responseObject = %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allTasks] removeObject:task];
        [self setNetworkActivityIndicatorVisible:NO];
        if(failure){
          failure(error);
        }
        //        NSLog(@"error = %@",error);
    }];
    if(dataTask){
        [[self allTasks] addObject:dataTask];
    }
    return dataTask;
}

- (void)updataWithUrl:(NSString *)url
           withParams:(NSDictionary *)params
            withImage:(NSArray *)arrImage
withCompressionQuality:(CGFloat)compressionQuality
             progress:(HttpProgress)progress
              success:(HLDHttpRequestSuccess)success
                 failure:(HLDHttpRequestFailed)failure{
    //检查参数是否正确
    if (!url|| !arrImage) {
        NSLog(@"参数不完整");
        return;
    }
    if ([url rangeOfString:@"http://"].location == NSNotFound) {
        url = [NSString stringWithFormat:@"http://%@",url];
    }
    //初始化
    NSString *hyphens = @"--";
    NSString *boundary = @"--------boundary";
    NSString *end = @"\r\n";
    //初始化数据
    NSMutableData *myRequestData1 = [NSMutableData data];
    //添加图片资源
    for (int i = 0; i < arrImage.count; i++) {
        if (![arrImage[i] isKindOfClass:[UIImage class]]) {
            return;
        }
        //获取资源
        UIImage *image = arrImage[i];
        //得到图片的data
        NSData *data = UIImageJPEGRepresentation(image,compressionQuality);
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        //所有字段的拼接都不能缺少，要保证格式正确
        [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableString *fileTitle=[[NSMutableString alloc]init];
        //要上传的文件名和key，服务器端接收
        [fileTitle appendFormat:@"Content-Disposition: form-data; name=\"upload_file%d\"; filename=\"file%u.jpg\"",i,i];
        [fileTitle appendString:end];
        [fileTitle appendString:[NSString stringWithFormat:@"Content-Type: image/jpeg%@",end]];
        [fileTitle appendString:end];
        [myRequestData1 appendData:[fileTitle dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:data];
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    //    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    //    [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    //    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //添加其他参数
    for(int i = 0;i < [keys count];i ++){
        NSMutableString *body = [[NSMutableString alloc]init];
        [body appendString:hyphens];
        [body appendString:boundary];
        [body appendString:end];
        //得到当前key
        NSString *key = [keys objectAtIndex:i];
        //添加字段名称
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"%@%@",key,end,end];
        
        //添加字段的值
        [body appendFormat:@"%@",[params objectForKey:key]];
        [body appendString:end];
        [myRequestData1 appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"添加字段的值==%@",[params objectForKey:key]);
    }
    
    //拼接结束~~~
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //根据url初始化request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    //设置HTTPHeader中Content-Type的值
    NSString *content = [[NSString alloc]initWithFormat:@"multipart/form-data;boundary=%@",boundary];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData1 length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData1];
    //http method
    [request setHTTPMethod:@"POST"];
    //回调返回值
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    //出现任何服务器端返回的错误，交给block处理
                    [self handleCallbackWithError:connectionError failure:failure];
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                // 尝试解析成JSON
                NSError *error = nil;
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if(error != nil){
                    if (failure) {
                        //出现任何服务器端返回的错误，交给block处理
                        [self handleCallbackWithError:connectionError failure:failure];
                    }
                }else{
                    if (success){
                        [self successResponse:response callback:success];
                    }
                }
            });
        }
    }];
}

#pragma mark - 下载文件
- (__kindof NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      progress:(HttpProgress)progress
                                       success:(void(^)(NSString *filePath))success
                                       failure:(HLDHttpRequestFailed)failure{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    WeakSelf(self)
    self.downloadTask = [self downloadTaskWithRequest:request
                                        progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
        //        NSLog(@"下载进度:%.2f%%",100.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //        NSLog(@"downloadDir = %@",downloadDir);
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        StrongSelf(self)
        [[self allTasks] removeObject:self.downloadTasks];
        [self setNetworkActivityIndicatorVisible:NO];
        if (success) {
            success(filePath.absoluteString);
        }
        failure && error ? failure(error) : nil;
    }];
    //开始下载
    [self.downloadTask resume];
    if (self.downloadTask) {
        [[self allTasks] addObject:self.downloadTask];
    }
    return self.downloadTask;
}

- (HQURLSessionTask *)requestWithUrl:(NSString *)url
                        refreshCache:(BOOL)cache
                           httpMedth:(RequestDataType)httpMethod
                              params:(NSDictionary *)params
                       responseCache:(HttpRequestCache)responseCache
                            progress:(HttpProgress)progress
                             success:(HLDHttpRequestSuccess)success
                             failure:(HLDHttpRequestFailed)failure
                           noNetwork:(HLDHttpNoNetwork)noNetwork{
    NSString *requestUrl = nil;
    if (self.baseURL) {
        requestUrl = [self.baseURL absoluteString];
        if ([requestUrl hasSuffix:@"/"]) {
            requestUrl = [requestUrl substringToIndex:[requestUrl length] - 1];
        }
    }else{
        requestUrl = ConfigurationFile.baseURLString;
    }
    requestUrl = [NSString stringWithFormat:@"%@%@",requestUrl,url];
        
    // 获取缓存
    if(cache){
        id response = [self cahceResponseWithURL:requestUrl parameters:params];
        if(response){
            if(success){
                [self successResponse:response callback:success];
                [self logWithSuccessResponse:response url:requestUrl params:params];
            }
        }else{
            if (![NetworkHelper sharedManager].isNetworkAvailable) {
                self.isHiddenLoading = NO;
                if (noNetwork) {
                    noNetwork();
                }
                return nil;
            }
        }
    }else{
        if (![NetworkHelper sharedManager].isNetworkAvailable) {
            self.isHiddenLoading = NO;
            if (noNetwork) {
                noNetwork();
            }
            return nil;
        }
    }
    [self setNetworkActivityIndicatorVisible:self.isShowNetworkActivityIndicator];
//    requestUrl = [self encodeUrl:requestUrl];
    NSDictionary *resultDic = [NSMutableDictionary mergingWithFirstDictionary:params
                                                                    secondDic:[self getPublicParameters]];
    HQURLSessionTask *session = nil;
    if (!self.isHiddenLoading) {
        if (self.responseTitle == nil) {
            [MBProgressHUD showLoadingHUDWithtitle:ConfigurationFile.responseTitle];
        }else{
            [MBProgressHUD showLoadingHUDWithtitle:self.responseTitle];
        }
    }
    if(httpMethod == RequestDataTypeGet){
        NSString *parameterStr = [NSString jsonStringWithDic:resultDic];
        NSString *urlStr = [requestUrl stringByAppendingString:@"?"];
        urlStr = [urlStr stringByAppendingString:parameterStr];
        session = [self GET:urlStr
                 parameters:nil
                    headers:nil
                   progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self setNetworkActivityIndicatorVisible:NO];
            [self successResponse:responseObject callback:success];
            if (cache) {
                [self cacheResponseObject:responseObject
                                  request:task.currentRequest
                               parameters:resultDic];
                //                [NetworkCache saveResponseCache:responseObject forKey:url];
            }
            [[self allTasks] removeObject:task];
            [self logWithSuccessResponse:responseObject url:requestUrl params:resultDic];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self setNetworkActivityIndicatorVisible:NO];
            [[self allTasks] removeObject:task];
            if ([error code] < 0 && cache) {// 获取缓存
                id response = [self cahceResponseWithURL:requestUrl parameters:resultDic];
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        [self logWithSuccessResponse:response url:requestUrl params:resultDic];
                    }
                } else {
                    [self handleCallbackWithError:error failure:failure];
                    [self logWithFailError:error url:requestUrl params:resultDic];
                }
            } else {
                [self handleCallbackWithError:error failure:failure];
                [self logWithFailError:error url:requestUrl params:resultDic];
            }
        }];
    } else if (httpMethod == RequestDataTypePost){
        NSLog(@"%@",resultDic);
        session = [self POST:requestUrl
                  parameters:resultDic
                     headers:nil
                    progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                progress(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self setNetworkActivityIndicatorVisible:NO];
            [self successResponse:responseObject callback:success];
            if(cache){
                [self cacheResponseObject:responseObject request:task.currentRequest parameters:resultDic];
                //                [NetworkCache saveResponseCache:responseObject forKey:url];
            }
            [[self allTasks] removeObject:task];
            [self logWithSuccessResponse:responseObject url:requestUrl params:resultDic];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self setNetworkActivityIndicatorVisible:NO];
            [[self allTasks] removeObject:task];
            if([error code] < 0 && cache){
                // 获取缓存
                id response = [self cahceResponseWithURL:requestUrl parameters:resultDic];
                if(response){
                    if(success){
                        [self successResponse:response callback:success];
                        [self logWithSuccessResponse:response url:requestUrl params:resultDic];
                    }
                }else {
                    [self handleCallbackWithError:error failure:failure];
                    [self logWithFailError:error url:requestUrl params:resultDic];
                }
            } else {
                [self handleCallbackWithError:error failure:failure];
                [self logWithFailError:error url:requestUrl params:resultDic];
            }
        }];
    }
    if(session){
        [[self allTasks] addObject:session];
    }
    return session;
}

- (instancetype)cahceResponseWithURL:(NSString *)url parameters:(id)params{
    id cacheData = nil;
    if(url){
        NSString *directoryPath = cachePath();
        NSString *absoluteURL = [NSString generateGETAbsoluteURL:url params:params];
        NSString *key = [MD5Encryptor pd_md5:absoluteURL];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if(data){
            cacheData = data;
        }
    }
    return cacheData;
}

- (void)successResponse:(id)responseData callback:(HLDHttpRequestSuccess)success{
    if (!self.isHiddenLoading) {
        [MBProgressHUD hideHUD];
    }
    self.isHiddenLoading = NO;
    self.responseTitle = nil;
    id parseData = [self tryToParseData:responseData];
    if ([parseData isKindOfClass:[NSDictionary class]]) {
        NSString *errorCode = [(NSDictionary *)parseData objectForKey:@"responseCode"];
        if (![errorCode isEqualToString:@"200"]) {
            NSString *errorMessage = [(NSDictionary *)parseData objectForKey:@"responseDesc"];
            if ([errorCode isEqualToString:@"401"]) {
                AlertView *alertView = [AlertView presentHiddenTitleOneButtonAlert:errorMessage :@"确认" :nil :^{
                    [[UserManager sharedManager] deleteAccountAndClearAutoRefreshState];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackRootViewController" object:nil];
                }];
                alertView.contentLabel.textAlignment = NSTextAlignmentCenter;
            }else{
                [MBProgressHUD wj_showText:errorMessage];
            }
        }
    }
    if(success){
        success(parseData);
    }
}

- (void)handleCallbackWithError:(NSError *)error
                        failure:(HLDHttpRequestFailed)failure{
    if (!self.isHiddenLoading) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD wj_showText:ConfigurationFile.timeOutRequestTitle];
    }
    self.isHiddenLoading = NO;
    self.responseTitle = nil;
    if(failure){
        failure(error);
    }
}

- (id)tryToParseData:(id)responseData{
    if([responseData isKindOfClass:[NSData class]] && responseData != nil){
        // 尝试解析成JSON
        NSError *error = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        if(error != nil){
            return responseData;
        }else{
            return response;
        }
    }else{
        return responseData;
    }
}

- (void)logWithSuccessResponse:(id)response
                           url:(NSString *)url
                        params:(NSDictionary *)params{
//    NSLog(@"\nRequest success, URL: %@\n params:%@\n response:%@\n\n",
//          [NSString generateGETAbsoluteURL:url params:params],
//          params,
//          [self tryToParseData:response]);
}

- (void)logWithFailError:(NSError *)error
                     url:(NSString *)url
                  params:(id)params{
    NSString *format = @" params: ";
    if(params == nil || ![params isKindOfClass:[NSDictionary class]]){
        format = @"";
        params = @"";
    }
    if([error code] == NSURLErrorCancelled){
//        NSLog(@"\nRequest was canceled mannully, URL: %@ %@%@\n\n",
//              [NSString generateGETAbsoluteURL:url params:params],
//              format,
//              params);
    } else{
//        NSLog(@"\nRequest error, URL: %@ %@%@\n errorInfos:%@\n\n",
//              [NSString generateGETAbsoluteURL:url params:params],
//              format,
//              params,
//              [error localizedDescription]);
    }
}

- (void)cacheResponseObject:(id)responseObject
                    request:(NSURLRequest *)request
                 parameters:(id)params{
    if(request && responseObject && ![responseObject isKindOfClass:[NSNull class]]){
        NSString *directoryPath = cachePath();
        
        NSError *error = nil;
        if(![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]){
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
            if(error){
                return;
            }
        }
        
        NSString *absoluteURL = [NSString generateGETAbsoluteURL:request.URL.absoluteString
                                                          params:params];
        NSString *key = [MD5Encryptor pd_md5:absoluteURL];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSData *data = nil;
        if([dict isKindOfClass:[NSData class]]){
            data = responseObject;
        }else{
            data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        }
        if(data && error == nil){
            [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
        }
    }
}

- (NSMutableArray *)allTasks{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(requestTasks == nil){
            requestTasks = [[NSMutableArray alloc] init];
        }
    });
    return requestTasks;
}

- (void)cancelAllRequest{
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(HQURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if([task isKindOfClass:[HQURLSessionTask class]]){
                [task cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    };
    //    或者
    //    [self.operationQueue cancelAllOperations];
}

- (void)cancelRequestWithURL:(NSString *)url{
    if(!url){
        return;
    }
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(HQURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if([task isKindOfClass:[HQURLSessionTask class]] && [task.currentRequest.URL.absoluteString hasSuffix:url]){
                [task cancel];
                [[self allTasks] removeObject:task];
                return ;
            }
        }];
    };
}

- (NSDictionary *)getPublicParameters{
    NSMutableDictionary *publicParameters = [[NSMutableDictionary alloc] init];
    
    NSString *currentDate = [NSDate pd_stringWithValue:[NSDate date] formatType:PDDateFormatTypeFullYear];
    [publicParameters setObject:currentDate forKey:@"requestDate"];
    [publicParameters setObject:currentDate forKey:@"requestTime"];
    
    return publicParameters.copy;
}

#pragma mark - 开始监听网络
+ (void)networkStatusWithBlock:(NetworkStatus)networkStatus{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [reachabilityManager startMonitoring];
        [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            networkStatus ? networkStatus((HQNetworkStatus)status) : nil;
        }];
    });
}

@end
