//
//  MSAnimatedDotView.m
//  MSCycleScrollView
//
//  Created by TuBo on 2018/12/26.
//  Copyright © 2018 turBur. All rights reserved.
//

#import "MSAnimatedDotView.h"

@implementation MSAbstractDotView

- (instancetype)init{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                 userInfo:nil];
}

- (void)changeActivityState:(BOOL)active dotView:(nonnull MSAbstractDotView *)dotView pageDotSize:(CGSize)pageDotSize{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                 userInfo:nil];
}

@end

@implementation MSAnimatedDotView

//动画完成时间
static CGFloat const kAnimateDuration = 1;

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization{
    self.pageDotColor = [UIColor whiteColor];
    self.backgroundColor    = [UIColor clearColor];
    self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2;
    self.layer.borderColor  = self.pageDotColor.CGColor;
    self.layer.borderWidth  = 2;
}

- (void)changeActivityState:(BOOL)active
                    dotView:(nonnull MSAbstractDotView *)dotView
                pageDotSize:(CGSize)pageDotSize{
    if (active) {
        [self animateToActiveState];
    } else {
        [self animateToDeactiveState];
    }
}

- (void)animateToActiveState{
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = self.pageDotColor;
        self.transform = CGAffineTransformMakeScale(1.4, 1.4);
    } completion:nil];
}

- (void)animateToDeactiveState{
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end
