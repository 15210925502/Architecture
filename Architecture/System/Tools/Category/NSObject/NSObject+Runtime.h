//
//  NSObject+Runtime.h
//  Architecture
//
//  Created by 华令冬 on 2020/9/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@interface NSObject (Runtime)

/**
 Swizzle class method.
 
 @param oriSel Original selector.
 @param swiSel Swizzled selector.
 */
+ (void)swizzleClassMethodWithOriginSel:(SEL)oriSel
                            swizzledSel:(SEL)swiSel;

/**
 Swizzle instance method.
 
 @param oriSel Original selector.
 @param swiSel Swizzled selector.
 */
+ (void)swizzleInstanceMethodWithOriginSel:(SEL)oriSel
                               swizzledSel:(SEL)swiSel;

/// Swizzle method.
/// @param method1 Method1
/// @param method2 Method2
+ (void)swizzleMethod:(Method)method1 anotherMethod:(Method)method2;

/**
 Get all property names.
 
 @return Property name array.
 */
+ (NSArray *)getPropertyNames;

/**
 Get all property names.
 
 @return Property name array.
 */
- (NSArray *)getPropertyNames;

/**
 Get all instance method names;
 */
+ (NSArray *)getInstanceMethodNames;

/**
 Get all class method names;
 */
+ (NSArray *)getClassMethodNames;

/**
 Add CGFloat property.
 
 @param number CGFloat value.
 @param key Key.
 */
- (void)setCGFloatProperty:(CGFloat)number key:(const char *)key;

/**
 Get CGFloat property.
 
 @param key Key.
 @return CGFloat value.
 */
- (CGFloat)getCGFloatProperty:(const char *)key;

@end

