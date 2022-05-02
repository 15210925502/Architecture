//
//  HLDCenterTabBarButton.m
//  Architecture
//
//  Created by HLD on 2020/5/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "HLDCenterTabBarButton.h"

@implementation HLDCenterTabBarButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        HLDNavigationConfig *config = [HLDNavigationConfig sharedManage];
        self.titleLabel.font = [UIFont setFontSizeWithValue:config.tabBarTitleFontSize];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self theme_setTitleColor:config.tabBarNormalTextColor forState:UIControlStateNormal];
        [self theme_setTitleColor:config.tabBarSelectedTextColor forState:UIControlStateSelected];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (CGRectEqualToRect(self.frame, CGRectZero)){
        return;
    }
    if (self.titleLabel.text == nil) {
        self.imageView.frame = self.bounds;
    }else{
        CGFloat titleLabelHeight = [BaseTools adaptedWithValue:14];
        self.titleLabel.frame = CGRectMake(0,self.heightValue - titleLabelHeight,self.widthValue,titleLabelHeight);
        self.imageView.frame = CGRectMake(0,0,self.widthValue,self.heightValue - titleLabelHeight);
    }
}

- (void)setHighlighted:(BOOL)highlighted{

}

@end
