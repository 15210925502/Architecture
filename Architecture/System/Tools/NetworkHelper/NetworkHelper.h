//
//  NetworkHelper.h
//  MyTestProject
//
//  Created by HLD on 2019/3/11.
//  Copyright © 2019 com.cn.HLD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
@class NSURLSessionTask;

typedef NS_ENUM(NSUInteger, RequestDataType){
    RequestDataTypePost = 1,
    RequestDataTypeGet  = 2,
    RequestDataTypeDelete  = 3
};

typedef NS_ENUM(NSUInteger, HQResponseType){
    kHQResponseTypeJSON = 1, // 默认
    kHQResponseTypeXML  = 2, // xml
    // 特殊情况，一转换服务器就无法识别的，默认会尝试装换成JSON，若识别则需要自己去转换
    kHQResponseTypeData = 3
};

typedef NS_ENUM(NSUInteger, HQRequestType){
    kHQRequestTypeJSON = 1, // 默认
    kHQRequestTypePlainText = 2 // text/html
};

typedef NS_ENUM(NSInteger, HQNetworkStatus) {
    NetworkStatusUnknown           = -1,// 未知网络
    NetworkStatusNotReachable      = 0, // 没网络
    NetworkStatusReachableViaWWAN  = 1, // 2G，3G，4G
    NetworkStatusReachableViaWiFi  = 2  // WIFI
};

// 所有接口返回的类型都是基于NSURLSessionTask，若要接收返回值处理，转换成对应的子类类型
typedef NSURLSessionTask HQURLSessionTask;
typedef void(^HLDHttpRequestSuccess)(id response);
typedef void(^HLDHttpRequestFailed)(NSError *error);
typedef void(^HLDHttpNoNetwork)(void);
/** 缓存的Block */
typedef void(^HttpRequestCache)(id responseCache);
/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^HttpProgress)(NSProgress *progress);
/** 网络状态的Block*/
typedef void(^NetworkStatus)(HQNetworkStatus status);

/**
 *  基于AFNetWorking的网络层封装类
 */
@interface NetworkHelper : AFHTTPSessionManager

//网络请求加载文案，没有设置显示默认
@property (nonatomic,strong) NSString *responseTitle;

//网络请求,是否显示loading图
@property (nonatomic,assign) BOOL isHiddenLoading;

//网络请求,是否显示状态栏上的菊花,默认Yes显示
@property (nonatomic,assign) BOOL isShowNetworkActivityIndicator;

//当前网络状态
@property (nonatomic,assign) HQNetworkStatus currentNetworkStatus;

//当前网络是否可用,返回YES可用
@property (nonatomic,assign) BOOL isNetworkAvailable;

+ (NetworkHelper *)sharedManager;

/**
 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
 */
+ (void)networkStatusWithBlock:(NetworkStatus)networkStatus;

- (void)setRequestSer:(HQRequestType)type;

- (void)setResponseSer:(HQResponseType)type;

/**
 *  配置公共的请求头，只调用一次即可，通常放在应用启动的时候配置就可以了
 *  配置公共参数
 *
 *  @param httpHeaders 只需要将于服务器商定的固定参数设置即可
 */
- (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders;

//请求超时时间，默认60秒
- (void)setTimeout:(NSTimeInterval)timeout;

/**
 *  GET请求接口，若不指定baseurl，可传完整的url
 *
 *  @param url      接口路径
 *  @param progress 请求进度
 *  @param success  接口成功请求到数据的回调
 *  @param failure     接口请求数据失败的回调
 *  @param noNetwork     没有网络回调
 *
 *  @return 返回的对象中可取消请求的API，默认没有缓存
 */
- (HQURLSessionTask *)getWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                        progress:(HttpProgress)progress
                         success:(HLDHttpRequestSuccess)success
                         failure:(HLDHttpRequestFailed)failure
                       noNetwork:(HLDHttpNoNetwork)noNetwork;
- (HQURLSessionTask *)getWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                         success:(HLDHttpRequestSuccess)success
                         failure:(HLDHttpRequestFailed)failure
                       noNetwork:(HLDHttpNoNetwork)noNetwork;

/**
 *  POST请求接口
 *
 *  @param url     接口路径
 *  @param params  接口所需的参数
 *  @param progress 请求进度
 *  @param success 接口成功请求到数据的回调
 *  @param failure    接口请求数据失败的回调
 *  @param noNetwork     没有网络回调
 *
 *  @return 返回的对象中有可能取消请求的API，默认没有缓存
 */
- (HQURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                         progress:(HttpProgress)progress
                          success:(HLDHttpRequestSuccess)success
                          failure:(HLDHttpRequestFailed)failure
                        noNetwork:(HLDHttpNoNetwork)noNetwork;
- (HQURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                          success:(HLDHttpRequestSuccess)success
                          failure:(HLDHttpRequestFailed)failure
                        noNetwork:(HLDHttpNoNetwork)noNetwork;

/**
 *
 *  @param url           请求网络路径
 *  @param cache         是否 缓存
 *  @param httpMethod    模式 GET 还是 POST
 *  @param params        附带的参数
 *  @param responseCache 请求缓存
 *  @param progress      请求进度
 *  @param success       请求成功
 *  @param failure       请求失败
 *  @param noNetwork     没有网络回调
 *
 */
- (HQURLSessionTask *)requestWithUrl:(NSString *)url
                        refreshCache:(BOOL)cache
                           httpMedth:(RequestDataType)httpMethod
                              params:(NSDictionary *)params
                       responseCache:(HttpRequestCache)responseCache
                            progress:(HttpProgress)progress
                             success:(HLDHttpRequestSuccess)success
                             failure:(HLDHttpRequestFailed)failure
                           noNetwork:(HLDHttpNoNetwork)noNetwork;

/**
 *  自定义   图片上传调用方法
 *
 *  @param url                请求的URL地址
 *  @param params             额外的参数
 *  @param arrImage           图片集合数组
 *  @param compressionQuality 压缩比例
 */
- (void)updataWithUrl:(NSString *)url
           withParams:(NSDictionary *)params
            withImage:(NSArray *)arrImage
withCompressionQuality:(CGFloat)compressionQuality
             progress:(HttpProgress)progress
              success:(HLDHttpRequestSuccess)success
                 failure:(HLDHttpRequestFailed)failure;

/**
 *  使用AFNetworking   图片上传调用方法
 *
 *  @param url                请求的url地址
 *  @param parameters         额外的参数
 *  @param images             图片集合数组
 *  @param name               关联名
 *  @param mimeType           数据类型  默认jpeg
 */
- (NSURLSessionTask *)uploadWithURL:(NSString *)url
                         parameters:(NSDictionary *)parameters
                             images:(NSArray<UIImage *> *)images
                               name:(NSString *)name
                           mimeType:(NSString *)mimeType
                           progress:(HttpProgress)progress
                            success:(HLDHttpRequestSuccess)success
                            failure:(HLDHttpRequestFailed)failure;

/**
 *  下载文件
 *
 *  @param url      请求地址
 *  @param fileDir  文件存储目录(默认存储目录为Download)
 *  @param progress 文件下载的进度信息
 *  @param success  下载成功的回调(回调参数filePath:文件的路径)
 *  @param failure  下载失败的回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
- (__kindof NSURLSessionTask *)downloadWithURL:(NSString *)url
                                       fileDir:(NSString *)fileDir
                                      progress:(HttpProgress)progress
                                       success:(void(^)(NSString *filePath))success
                                       failure:(HLDHttpRequestFailed)failure;

/**
 *  取消某个网络请求，如果是要取消某个请求，最好是引用接口所返回来的WXZURLSessionTask对象
 *  然后调用对象的cancel方法。如果不想引用对象，这里额外提供一种方法来实现取消某个请求
 *
 *  @param url URL,可以是绝对URL，也可以是不包括baseurl
 */
- (void)cancelRequestWithURL:(NSString *)url;

//获取公共参数
- (NSDictionary *)getPublicParameters;

/**
 *
 *  取消所有请求
 */
- (void)cancelAllRequest;

@end
