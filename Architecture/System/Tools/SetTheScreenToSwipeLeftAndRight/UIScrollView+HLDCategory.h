//
//  UIScrollView+HLDCategory.h
//  Architecture
//
//  Created by HLD on 2020/5/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HLDCategory)

//是否开启UIScrollView左滑返回手势处理，默认为NO
//此属性不开启，右滑push手势也不可用
@property (nonatomic, assign) BOOL hld_leftGestureEnable;

@end
