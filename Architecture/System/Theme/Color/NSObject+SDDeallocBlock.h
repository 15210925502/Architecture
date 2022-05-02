//
//  NSObject+SDDeallocBlock.h
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SDDeallocBlock)

- (void)sd_executeAtDealloc:(void (^)(void))block;

@end
