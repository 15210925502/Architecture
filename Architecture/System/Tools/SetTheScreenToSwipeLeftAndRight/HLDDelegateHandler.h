//
//  HLDDelegateHandler.h
//  Architecture
//
//  Created by HLD on 2020/5/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 ⚠️不用关心此类中所有方法和属性
 ⚠️不用关心此类中所有方法和属性
 ⚠️不用关心此类中所有方法和属性
 */

// 右滑push代理
@protocol HLDVCRightScrollPushDelegate <NSObject>

- (void)rightSlidePushNext;

@end







// 此类用于处理UINavigationControllerDelegate的代理方法
@interface HLDNavigationControllerDelegate: NSObject<UINavigationControllerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, weak) id<HLDVCRightScrollPushDelegate> rightScrollPushDelegate;

// 手势Action
- (void)panGestureAction:(UIPanGestureRecognizer *)gesture;

@end








// 此类用于处理UIGestureRecognizerDelegate的代理方法
@interface HLDPopGestureRecognizerDelegate : NSObject<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;
// 系统返回手势的target
@property (nonatomic, strong) id systemTarget;
@property (nonatomic, strong) HLDNavigationControllerDelegate *customTarget;

@end
