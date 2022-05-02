//
//  BaseViewModel.h
//  RebateProject
//
//  Created by HLD on 2019/6/5.
//  Copyright © 2019 com.cn.HLD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkHelper.h"

//swift 请求方式
//class func getRequest( _ url: String, _ params: Dictionary<String, Any>,_ success: @escaping HLDHttpRequestSuccess,_ fail: @escaping HLDHttpRequestFailed) -> (URLSessionTask){
//    let networkHelper = NetworkHelper.sharedManager()
//    return networkHelper?.getWithUrl(url, params: params, success: success, fail: fail) ?? URLSessionTask()
//}
//
//class func postRequest( _ url: String, _ params: Dictionary<String, Any>,_ success: @escaping HLDHttpRequestSuccess,_ fail: @escaping HLDHttpRequestFailed) -> (URLSessionTask){
//    let networkHelper = NetworkHelper.sharedManager()
//    return networkHelper?.post(withUrl: url, params: params, success: success, fail: fail) ?? URLSessionTask()
//}

@interface BaseViewModel : NSObject

- (HQURLSessionTask *)getRequestWithUrl:(NSString *)url
                             parameters:(NSDictionary *)parameters
                                success:(HLDHttpRequestSuccess)success
                                failure:(HLDHttpRequestFailed)failure
                              noNetwork:(HLDHttpNoNetwork)noNetwork;

- (HQURLSessionTask *)postRequestWithUrl:(NSString *)url
                              parameters:(NSDictionary *)parameters
                                 success:(HLDHttpRequestSuccess)success
                                 failure:(HLDHttpRequestFailed)failure
                               noNetwork:(HLDHttpNoNetwork)noNetwork;

@end
