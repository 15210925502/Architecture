//
//  BaseViewModel.m
//  RebateProject
//
//  Created by HLD on 2019/6/5.
//  Copyright © 2019 com.cn.HLD. All rights reserved.
//

#import "BaseViewModel.h"

@interface BaseViewModel()

@end

@implementation BaseViewModel

- (HQURLSessionTask *)getRequestWithUrl:(NSString *)url
                             parameters:(NSDictionary *)parameters
                                success:(HLDHttpRequestSuccess)success
                                failure:(HLDHttpRequestFailed)failure
                              noNetwork:(HLDHttpNoNetwork)noNetwork{
    return [[NetworkHelper sharedManager] getWithUrl:url
                                              params:parameters
                                            progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if(failure){
            failure(error);
        }
    } noNetwork:^{
        if (noNetwork) {
            noNetwork();
        }
    }];
}

- (HQURLSessionTask *)postRequestWithUrl:(NSString *)url
                              parameters:(NSDictionary *)parameters
                                 success:(HLDHttpRequestSuccess)success
                                 failure:(HLDHttpRequestFailed)failure
                               noNetwork:(HLDHttpNoNetwork)noNetwork{
    return [[NetworkHelper sharedManager] postWithUrl:url
                                               params:parameters
                                             progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if(failure){
            failure(error);
        }
    } noNetwork:^{
        if (noNetwork) {
            noNetwork();
        }
    }];
}

@end
