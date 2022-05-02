//
//  UIView+Empty.h
//  YunDiRentCar
//
//  Created by yyl on 16/12/31.
//  Copyright © 2016年 YunDi.Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshNoDataView.h"

typedef enum : NSUInteger {
    YYLLoadErrorTypeDefalt,         //移除视图
    YYLLoadErrorTypeNoNetwork,      //没有网络
    YYLLoadErrorTypeRequest,        //请求接口 后台报错
    YYLLoadErrorTypeNoData,         //当前页面没有数据
} YYLLoadErrorType;

typedef void(^RefreshCurrentDataBlock)(void);

@interface UIView (Empty)

@property(nonatomic, copy) RefreshCurrentDataBlock refreshingBlock;

/**
 *  设置页面显示的类型
 */
@property(nonatomic, assign) YYLLoadErrorType loadErrorType;

/**
 *  没有网络时显示的视图
 */
@property(nonatomic, strong) UIView *refreshNoNetworkView;

/**
 *  访问出错时显示的视图
 */
@property(nonatomic, strong) UIView *refreshRequestErrorView;

/**
 *  没有数据显示的视图
 */
@property(nonatomic, strong) UIView *refreshNoDataView;

- (void)setErrorTpye:(YYLLoadErrorType)type
        refreshBlock:(RefreshCurrentDataBlock)block;

@end
