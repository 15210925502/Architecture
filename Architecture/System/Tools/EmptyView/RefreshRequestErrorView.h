//
//  RefreshRequestErrorView.h
//  RentCarEnterprise
//
//  Created by yyl on 16/10/4.
//  Copyright © 2016年 YunNan YunDi Tech CO,LTD. All rights reserved.
//  请求出错视图

#import "RefreshBaseView.h"

typedef void(^RCRefreshRequestErrorViewBlock)();

@interface RefreshRequestErrorView : RefreshBaseView

@property (nonatomic, strong) UIButton *tipButton;
@property(nonatomic, copy) RCRefreshRequestErrorViewBlock refreshRequestErrorViewBlock;

@end
