//
//  RefreshBaseView.m
//  YYLrefresh_Example
//
//  Created by 华令冬 on 2020/10/30.
//  Copyright © 2020 yanyulin. All rights reserved.
//

#import "RefreshBaseView.h"

@implementation RefreshBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIView *view = self.superview;
    self.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        self.frame = CGRectMake(0, 0, CGRectGetWidth(newSuperview.frame), CGRectGetHeight(newSuperview.frame));
    }
}

- (UIImageView *)tipImageView {
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] init];
    }
    return _tipImageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.font = [UIFont setFontSizeWithValue:17];
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

@end
