//
//  CustomButton+Touch.m
//  test
//
//  Created by 华令冬 on 2020/12/21.
//

#import "CustomButton+Touch.h"
#import <objc/runtime.h>

static char *const kEventIntervalKey = "kEventIntervalKey"; // 时间间隔
static char *const kEventInvalidKey = "kEventInvalidKey";   // 是否失效

@interface CustomButton()

/** 是否失效 - 即不可以点击 */
@property(nonatomic, assign) BOOL cs_eventInvalid;

@end

@implementation CustomButton (Touch)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selA =  @selector(sendAction:to:forEvent:);
        SEL selB =  @selector(cs_sendAction:to:forEvent:);
        // 交换方法
        Method methodA = class_getInstanceMethod(self, selA);
        Method methodB = class_getInstanceMethod(self, selB);
        //将 methodB的实现 添加到系统方法中 也就是说 将 methodA方法指针添加成 方法methodB的  返回值表示是否添加成功
        BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
        //添加成功了 说明 本类中不存在methodB 所以此时必须将方法b的实现指针换成方法A的，否则 b方法将没有实现。
        if (isAdd) {
            class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
        }else{
            //添加失败了 说明本类中 有methodB的实现，此时只需要将 methodA和methodB的IMP互换一下即可。
            method_exchangeImplementations(methodA, methodB);
        }
    });
}

#pragma mark - click
- (void)cs_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (!self.cs_eventInvalid) {
        self.cs_eventInvalid = YES;
        [self cs_sendAction:action to:target forEvent:event];
        [self performSelector:@selector(setCs_eventInvalid:) withObject:@(NO) afterDelay:self.cs_eventInterval];
    }
}

#pragma mark - set | get
- (NSTimeInterval)cs_eventInterval {
    return [objc_getAssociatedObject(self, kEventIntervalKey) doubleValue];
}

- (void)setCs_eventInterval:(NSTimeInterval)cs_eventInterval {
    objc_setAssociatedObject(self, kEventIntervalKey, @(cs_eventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)cs_eventInvalid {
    return [objc_getAssociatedObject(self, kEventInvalidKey) boolValue];
}

- (void)setCs_eventInvalid:(BOOL)cs_eventInvalid {
    objc_setAssociatedObject(self, kEventInvalidKey, @(cs_eventInvalid), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
