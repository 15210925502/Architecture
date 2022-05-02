//
//  ReplicatorAnimation.h
//  Animation
//
//  Created by administrator on 17/2/4.
//  Copyright © 2017年 animation.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplicatorAnimation : NSObject

// 波纹
+ (CALayer *)replicatorLayer_Circle;

// 波浪
+ (CALayer *)replicatorLayer_Wave;
+ (void)replicatorLayer_Wave:(CALayer *)layer;

// 三角形
+ (CALayer *)replicatorLayer_Triangle;

// 网格
+ (CALayer *)replicatorLayer_Grid;

// 震东条
+ (CALayer *)replicatorLayer_Shake;

// 转圈动画
+ (CALayer *)replicatorLayer_Round;

// 心动画
+ (CALayer *)replicatorLayer_Heart;

@end
