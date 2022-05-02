//
//  UIView+Empty.m
//  YunDiRentCar
//
//  Created by yyl on 16/12/31.
//  Copyright © 2016年 YunDi.Tech. All rights reserved.
//

#import "UIView+Empty.h"
#import <objc/runtime.h>
#import "RefreshNoNetworkView.h"
#import "RefreshRequestErrorView.h"
#import "Masonry.h"
#import "NetworkHelper.h"

static char refreshingBlockKey;
static char refreshNoNetworkViewKey;
static char refreshRequestErrorViewKey;
static char refreshNoDataViewKey;
static char loadErrorTypeKey;

@implementation UIView (Empty)

@dynamic loadErrorType;

- (void)setLoadErrorType:(YYLLoadErrorType)loadErrorType {
    if (self.refreshNoNetworkView.superview)
        [self.refreshNoNetworkView removeFromSuperview];
    if (self.refreshRequestErrorView.superview)
        [self.refreshRequestErrorView removeFromSuperview];
    if (self.refreshNoDataView.superview)
        [self.refreshNoDataView removeFromSuperview];
    if (loadErrorType == YYLLoadErrorTypeNoNetwork) {
        [self addSubview:self.refreshNoNetworkView];
    } else if (loadErrorType == YYLLoadErrorTypeRequest) {
        [self addSubview:self.refreshRequestErrorView];
    } else if (loadErrorType == YYLLoadErrorTypeNoData) {
        [self addSubview:self.refreshNoDataView];
    }
    objc_setAssociatedObject(self, &loadErrorTypeKey, @(loadErrorType), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setErrorTpye:(YYLLoadErrorType)type
        refreshBlock:(RefreshCurrentDataBlock)block{
    self.refreshingBlock = block;
    self.loadErrorType = type;
}

- (UIView *)refreshNoNetworkView {
    RefreshNoNetworkView *rNoNetworkView = objc_getAssociatedObject(self, &refreshNoNetworkViewKey);
    if (!rNoNetworkView) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        rNoNetworkView = [[RefreshNoNetworkView alloc] initWithFrame:frame];
        __weak typeof(self) weakSelf = self;
        rNoNetworkView.refreshNoNetworkViewBlock = ^() {
            if (weakSelf.refreshingBlock && [NetworkHelper sharedManager].isNetworkAvailable) {
                weakSelf.refreshingBlock();
                weakSelf.loadErrorType = YYLLoadErrorTypeDefalt;
            }
        };
        self.refreshNoNetworkView = rNoNetworkView;
    }
    return rNoNetworkView;
}

- (void)setRefreshNoNetworkView:(UIView *)refreshNoNetworkView {
    if (refreshNoNetworkView) {
        objc_setAssociatedObject(self, &refreshNoNetworkViewKey, refreshNoNetworkView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UIView *)refreshRequestErrorView {
    RefreshRequestErrorView *rRequestErrorView = objc_getAssociatedObject(self, &refreshRequestErrorViewKey);
    if (!rRequestErrorView) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        rRequestErrorView = [[RefreshRequestErrorView alloc] initWithFrame:frame];
        __weak typeof(self) weakSelf = self;
        rRequestErrorView.refreshRequestErrorViewBlock = ^() {
            !weakSelf.refreshingBlock? :weakSelf.refreshingBlock();
        };
        self.refreshRequestErrorView = rRequestErrorView;
    }
    return rRequestErrorView;
}

- (void)setRefreshRequestErrorView:(RefreshRequestErrorView *)refreshRequestErrorView {
    if (refreshRequestErrorView) {
        objc_setAssociatedObject(self, &refreshRequestErrorViewKey, refreshRequestErrorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UIView *)refreshNoDataView {
    UIView *rNoDataView = objc_getAssociatedObject(self, &refreshNoDataViewKey);
    if (!rNoDataView) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        rNoDataView = [[RefreshNoDataView alloc] initWithFrame:frame];
        objc_setAssociatedObject(self, &refreshNoDataViewKey, rNoDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return rNoDataView;
}

- (void)setRefreshNoDataView:(UIView *)refreshNoDataView {
    if (refreshNoDataView) {
        objc_setAssociatedObject(self, &refreshNoDataViewKey, refreshNoDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setRefreshingBlock:(RefreshCurrentDataBlock)refreshingBlock {
    objc_setAssociatedObject(self, &refreshingBlockKey, refreshingBlock, OBJC_ASSOCIATION_COPY);
}

- (RefreshCurrentDataBlock)refreshingBlock {
    RefreshCurrentDataBlock refreshingBlock = objc_getAssociatedObject(self, &refreshingBlockKey);
    return refreshingBlock;
}

- (YYLLoadErrorType)loadErrorType {
    return [objc_getAssociatedObject(self, &loadErrorTypeKey) integerValue];
}

@end
