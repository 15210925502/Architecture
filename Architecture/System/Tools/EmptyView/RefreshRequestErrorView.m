//
//  RefreshRequestErrorView.m
//  RentCarEnterprise
//
//  Created by yyl on 16/10/4.
//  Copyright © 2016年 YunNan YunDi Tech CO,LTD. All rights reserved.
//

#import "RefreshRequestErrorView.h"

@implementation RefreshRequestErrorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.tipLabel.text = @"请求失败，请稍后重试";
        self.tipImageView.image = [UIImage sd_imageWithName:@"requestError"];
        
        [self addSubview:self.tipImageView];
        [self addSubview:self.tipLabel];
        [self addSubview:self.tipButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat leftWidth = 20;
    CGFloat labelWidth = CGRectGetWidth(self.frame) - leftWidth * 2;
    
    self.tipImageView.frame = CGRectMake((CGRectGetWidth(self.frame) - self.tipImageView.image.size.width) / 2.0, (CGRectGetHeight(self.frame) - self.tipImageView.image.size.height) / 2.0, self.tipImageView.image.size.width, self.tipImageView.image.size.height);
    CGSize size = [self.tipLabel.text boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT)
                                                      font:self.tipLabel.font
                                               lineSpacing:0.0];
    self.tipLabel.frame = CGRectMake(leftWidth, CGRectGetMaxY(self.tipImageView.frame) + 20, labelWidth, size.height);
    self.tipButton.frame = CGRectMake((self.frame.size.width - 120) / 2, CGRectGetMaxY(self.tipLabel.frame) + 20, 120, 40);
}

- (UIButton *)tipButton {
    if (!_tipButton) {
        _tipButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_tipButton setTitle:@"点击刷新" forState: UIControlStateNormal];
        [_tipButton setTitleColor:[UIColor colorWithRed:36 / 255.0 green:191.0 / 255.0 blue:161.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        _tipButton.titleLabel.font = [UIFont setFontSizeWithValue:13];
        _tipButton.layer.cornerRadius = 5;
        _tipButton.clipsToBounds = YES;
        _tipButton.layer.borderWidth = 1.0f;
        _tipButton.layer.borderColor = [UIColor colorWithRed:36 / 255.0 green:191.0 / 255.0 blue:161.0 / 255.0 alpha:1.0].CGColor;
        [_tipButton addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipButton;
}

- (void)tap {
    !self.refreshRequestErrorViewBlock ?: self.refreshRequestErrorViewBlock();
}

@end
