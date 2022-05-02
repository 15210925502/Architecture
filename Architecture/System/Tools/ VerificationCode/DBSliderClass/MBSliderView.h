//
//  SliderView.h
//  Slider
//  //滑块动画
//  Created by Mathieu Bolard on 02/02/12.
//  Copyright (c) 2012 Streettours. All rights reserved.
//

//滑动解锁
//滑动解锁
//滑动解锁
#import <UIKit/UIKit.h>

@interface MBSliderLabel : UILabel {
    NSTimer *animationTimer;
    CGFloat gradientLocations[3];
    int animationTimerCount;
}

@property (nonatomic, assign) BOOL animated;

@end

@protocol MBSliderViewDelegate;

@interface MBSliderView : UIView {
    UISlider *_slider;
    MBSliderLabel *_label;
    BOOL _sliding;
}

//文本
@property (nonatomic, strong) NSString *text;
//闪动字体颜色
@property (nonatomic, strong) UIColor *labelColor;
//滑块颜色
@property (nonatomic, strong) UIColor *thumbColor;
@property (nonatomic) BOOL enabled;
//留给xib
@property (nonatomic,assign) id<MBSliderViewDelegate> delegate;

@end

//代理
@protocol MBSliderViewDelegate <NSObject>

- (void) sliderDidSlide:(MBSliderView *)slideView;

@end
