//
//  UIView+PDBlockGesture.h
//  Categories
//
//  Created by zhouXian on 2017/8/16.
//  Copyright © 2017年 zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GesturesType){
    GesturesType_UITapGestureRecognizer           = (0),                        //点击
    GesturesType_UILongPressGestureRecognizer,                                  //长按
    GesturesType_UIPanGestureRecognizer,                                        //拖拽
};

typedef void (^PDGestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);

@interface UIView (PDBlockGesture)
/**
 *  @brief  添加tap手势
 *
 *  @param type 手势类型
 *  @param block        代码块
 */
- (void)pd_addActionWithGesturesType:(GesturesType)type Block:(PDGestureActionBlock)block;

@end
