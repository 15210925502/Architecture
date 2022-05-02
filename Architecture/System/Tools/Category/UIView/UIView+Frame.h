//
//  UIView+Frame.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

//⚠️注意：后面添加Value的属性都是跟系统冲突的，所以添加了一个Value

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

@property (nonatomic) CGFloat widthValue;
@property (nonatomic) CGFloat heightValue;

@property(nonatomic) CGFloat leftValue;
@property(nonatomic) CGFloat topValue;
@property(nonatomic) CGFloat rightValue;
@property(nonatomic) CGFloat bottomValue;

@property (nonatomic) CGFloat centerXValue;
@property (nonatomic) CGFloat centerYValue;

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

@end
