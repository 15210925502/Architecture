//
//  WMZCodeView.h
//  ZKVerifyViewDemo
//
//  Created by 华令冬 on 2019/5/23.
//  Copyright © 2019 bestdew. All rights reserved.
//

//点击文本验证
//点击文本验证
//点击文本验证
#import <UIKit/UIKit.h>

typedef void (^callBack) (BOOL success);

NS_ASSUME_NONNULL_BEGIN

@interface WMZCodeView : UIView

- (void)addCodeViewWithWitgFrame:(CGRect)rect withBlock:(callBack)block;

@end

NS_ASSUME_NONNULL_END
