//
//  RefreshNoNetworkView.h
//  RentCarEnterprise
//
//  Created by yyl on 16/10/4.
//  Copyright © 2016年 YunNan YunDi Tech CO,LTD. All rights reserved.
//  没有网络提示视图

#import "RefreshBaseView.h"

typedef void(^RCRefreshNoNetworkViewBlock)(void);

@interface RefreshNoNetworkView : RefreshBaseView

@property (nonatomic, strong) UIButton *tipButton;
@property(nonatomic, copy) RCRefreshNoNetworkViewBlock refreshNoNetworkViewBlock;

@end
