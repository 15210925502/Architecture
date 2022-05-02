//
//  NSObject+Runtime.m
//  Architecture
//
//  Created by 华令冬 on 2020/9/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "NSObject+Runtime.h"

@implementation NSObject (Runtime)

+ (void)swizzleClassMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Class cls = object_getClass(self);
    
    Method originAddObserverMethod = class_getClassMethod(cls, oriSel);
    Method swizzledAddObserverMethod = class_getClassMethod(cls, swiSel);
    
    [self swizzleMethod:originAddObserverMethod anotherMethod:swizzledAddObserverMethod];
}

+ (void)swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Method originAddObserverMethod = class_getInstanceMethod(self, oriSel);
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, swiSel);
    
    [self swizzleMethod:originAddObserverMethod anotherMethod:swizzledAddObserverMethod];
}

+ (void)swizzleMethod:(Method)method1 anotherMethod:(Method)method2 {
    method_exchangeImplementations(method1, method2);
}

+ (NSArray *)getPropertyNames {
    // Property count
    unsigned int count;
    // Get property list
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    // Get names
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        // objc_property_t
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        if (name.length) {
            [array addObject:name];
        }
    }
    free(properties);
    return array;
}

- (NSArray *)getPropertyNames {
    return [[self class] getPropertyNames];
}

+ (NSArray *)getInstanceMethodNames {
    unsigned int count;
    // Get methods list.
    Method *methods = class_copyMethodList([self class], &count);
    // Get name
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL sel = method_getName(method);
        NSString *name = NSStringFromSelector(sel);
        if (name.length) {
            [array addObject:name];
        }
    }
    free(methods);
    return array;
}

+ (NSArray *)getClassMethodNames {
    unsigned int count;
    // Get methods list.
    Method *methods = class_copyMethodList(object_getClass([self class]), &count);
    // Get name
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL sel = method_getName(method);
        NSString *name = NSStringFromSelector(sel);
        if (name.length) {
            [array addObject:name];
        }
    }
    free(methods);
    return array;
}


- (void)setCGFloatProperty:(CGFloat)number key:(const char *)key {
    objc_setAssociatedObject(self, key, @(number), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)getCGFloatProperty:(const char *)key {
    return (CGFloat)[objc_getAssociatedObject(self, key) doubleValue];
}

@end
