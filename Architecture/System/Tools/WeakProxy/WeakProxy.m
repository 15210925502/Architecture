//
//  WeakProxy.m
//  解除定时器循环引用
//
//  Created by HLD on 2018/3/29.
//  Copyright © 2018年 HLD. All rights reserved.
//

#import "WeakProxy.h"

@implementation WeakProxy

- (instancetype)initWithTarget:(id)target{
    _target = target;
    return self;
}

+ (instancetype)getWeakProxyWithTarget:(id)target{
    return [[self alloc] initWithTarget:target];
}

//当一个消息转发的动作NSInvocation到来的时候，在这里选择把消息转发给对应的实际处理对象
- (void)forwardInvocation:(NSInvocation *)invocation{
    SEL sel = [invocation selector];
    if ([self.target respondsToSelector:sel]) {
        [invocation invokeWithTarget:self.target];
    }
}

//当一个SEL到来的时候，在这里返回SEL对应的NSMethodSignature
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    return [self.target methodSignatureForSelector:aSelector];
}

//是否响应一个SEL
- (BOOL)respondsToSelector:(SEL)aSelector{
    return [self.target respondsToSelector:aSelector];
}

-(void)dealloc{
    NSLog(@"WeakProxy已释放");
}

@end
