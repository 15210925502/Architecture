//
//  UIView+PDBlockGesture.m
//  Categories
//
//  Created by zhouXian on 2017/8/16.
//  Copyright © 2017年 zhou. All rights reserved.
//

#import "UIView+PDBlockGesture.h"
#import <objc/runtime.h>

static char pd_kActionHandler_Tap_Block_Key;
static char pd_kActionHandler_TapGesture_Key;
static char pd_kActionHandler_LongPress_Block_Key;
static char pd_kActionHandler_LongPressGesture_Key;
static char pd_kActionHandler_Pan_Block_Key;
static char pd_kActionHandler_PanGesture_Key;
static char pd_kActionHandler_Normal_Block_Key;
static char pd_kActionHandler_Mormal_Key;

static const char *UITapGestureRecognizerKeyForType(GesturesType type) {
    switch (type) {
        case GesturesType_UITapGestureRecognizer:
            return &pd_kActionHandler_TapGesture_Key;
        case GesturesType_UILongPressGestureRecognizer:
            return &pd_kActionHandler_LongPressGesture_Key;
        case GesturesType_UIPanGestureRecognizer:
            return &pd_kActionHandler_PanGesture_Key;
        default:
            return &pd_kActionHandler_Mormal_Key;
    }
}

static const char *ActionHandlerTapBlockKeyForType(GesturesType type) {
    switch (type) {
        case GesturesType_UITapGestureRecognizer:
            return &pd_kActionHandler_Tap_Block_Key;
        case GesturesType_UILongPressGestureRecognizer:
            return &pd_kActionHandler_LongPress_Block_Key;
        case GesturesType_UIPanGestureRecognizer:
            return &pd_kActionHandler_Pan_Block_Key;
        default:
            return &pd_kActionHandler_Normal_Block_Key;
    }
}

@implementation UIView (ZXBlockGesture)

- (void)pd_addActionWithGesturesType:(GesturesType)type Block:(PDGestureActionBlock)block{
    UIGestureRecognizer *gesture = objc_getAssociatedObject(self, UITapGestureRecognizerKeyForType(type));
    if (!gesture){
        switch (type) {
            case GesturesType_UITapGestureRecognizer:
            {
                gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pd_handleActionFor_TapGesture:)];
            }
                break;
            case GesturesType_UILongPressGestureRecognizer:
            {
                gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pd_handleActionFor_LongPressGesture:)];
            }
                break;
            case GesturesType_UIPanGestureRecognizer:
            {
                gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pd_handleActionFor_PanGesture:)];
            }
                break;
                
            default:
                break;
        }
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, UITapGestureRecognizerKeyForType(type), gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, ActionHandlerTapBlockKeyForType(type), block, OBJC_ASSOCIATION_COPY);
}

- (void)pd_handleActionFor_TapGesture:(UITapGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateRecognized){
        PDGestureActionBlock block = objc_getAssociatedObject(self, &pd_kActionHandler_Tap_Block_Key);
        if (block){
            block(gesture);
        }
    }
}

- (void)pd_handleActionFor_LongPressGesture:(UITapGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateRecognized){
        PDGestureActionBlock block = objc_getAssociatedObject(self, &pd_kActionHandler_LongPress_Block_Key);
        if (block){
            block(gesture);
        }
    }
}

- (void)pd_handleActionFor_PanGesture:(UITapGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateRecognized){
        PDGestureActionBlock block = objc_getAssociatedObject(self, &pd_kActionHandler_Pan_Block_Key);
        if (block){
            block(gesture);
        }
    }
}

@end
