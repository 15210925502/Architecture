//
//  WeakProxy.h
//  解除定时器循环引用
//
//  Created by HLD on 2018/3/29.
//  Copyright © 2018年 HLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakProxy : NSProxy

@property (weak,nonatomic,readonly)id target;

+ (instancetype)getWeakProxyWithTarget:(id)target;
- (instancetype)initWithTarget:(id)target;

@end
