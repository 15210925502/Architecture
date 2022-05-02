//
//  UINavigationController+HLDCategory.h
//  Architecture
//
//  Created by HLD on 2020/5/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLDDelegateHandler.h"

@interface UINavigationController (HLDCategory)<HLDVCRightScrollPushDelegate>

/** 是否开启右滑push操作，默认是NO */
@property (nonatomic, assign) BOOL hld_rightSlidePushEnable;

@end
