//
//  UIView+Frame.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)leftValue{
    return self.frame.origin.x;
}

- (void)setLeftValue:(CGFloat)leftValue{
    CGRect frame = self.frame;
    frame.origin.x = leftValue;
    self.frame = frame;
}

- (CGFloat)rightValue{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRightValue:(CGFloat)rightValue{
    CGRect frame = self.frame;
    frame.origin.x = rightValue - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)topValue{
    return self.frame.origin.y;
}

- (void)setTopValue:(CGFloat)topValue{
    CGRect frame = self.frame;
    frame.origin.y = topValue;
    self.frame = frame;
}

- (CGFloat)bottomValue{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottomValue:(CGFloat)bottomValue{
    CGRect frame = self.frame;
    frame.origin.y = bottomValue - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)widthValue{
    return self.frame.size.width;
}

- (void)setWidthValue:(CGFloat)widthValue{
    CGRect frame = self.frame;
    frame.size.width = widthValue;
    self.frame = frame;
}

- (CGFloat)heightValue{
    return self.frame.size.height;
}

- (void)setHeightValue:(CGFloat)heightValue{
    CGRect frame = self.frame;
    frame.size.height = heightValue;
    self.frame = frame;
}

- (CGFloat)centerXValue {
    return self.center.x;
}

- (void)setCenterXValue:(CGFloat)centerXValue {
    self.center = CGPointMake(centerXValue, self.center.y);
}

- (CGFloat)centerYValue {
    return self.center.y;
}

- (void)setCenterYValue:(CGFloat)centerYValue {
    self.center = CGPointMake(self.center.x, centerYValue);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin.x = origin.x;
    frame.origin.y = origin.y;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    self.frame = frame;
}

@end
