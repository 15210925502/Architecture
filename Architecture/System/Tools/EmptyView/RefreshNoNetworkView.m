//
//  RefreshNoNetworkView.m
//  RentCarEnterprise
//
//  Created by yyl on 16/10/4.
//  Copyright © 2016年 YunNan YunDi Tech CO,LTD. All rights reserved.
//

#import "RefreshNoNetworkView.h"

@implementation RefreshNoNetworkView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.tipLabel.text = @"好像没有网络";
        self.tipImageView.image = [UIImage sd_imageWithName:@"wifi"];
        
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
    
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@([BaseTools adaptedWithValue:90] + [BaseTools navBarHeight]));
    }];
    CGSize size = [self.tipLabel.text boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT)
                                                      font:self.tipLabel.font
                                               lineSpacing:0.0];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(@(leftWidth));
        make.top.equalTo(self.tipImageView.mas_bottom).offset([BaseTools adaptedWithValue:25]);
        make.height.equalTo(@(size.height));
    }];
    CGFloat buttonHeight = [BaseTools adaptedWithValue:35];
    [self.tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.tipLabel.mas_bottom).offset([BaseTools adaptedWithValue:40]);
        make.width.equalTo(@([BaseTools adaptedWithValue:110]));
        make.height.equalTo(@(buttonHeight));
    }];
    self.tipButton.layer.cornerRadius = buttonHeight / 2.0;
}

- (UIButton *)tipButton {
    if (!_tipButton) {
        _tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tipButton setTitle:@"重新加载" forState: UIControlStateNormal];
        [_tipButton theme_setTitleColor:@"FFFFFF" forState:UIControlStateNormal];
        _tipButton.titleLabel.font = [UIFont setFontSizeWithValue:15];
        _tipButton.theme_backgroundColor = @"E1514C";
        [_tipButton addTarget:self action:@selector(tipButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _tipButton.adjustsImageWhenHighlighted = NO;
        _tipButton.layer.masksToBounds = YES;
    }
    return _tipButton;
}

- (void)tipButtonClick:(UIButton *)button {
    !self.refreshNoNetworkViewBlock ?: self.refreshNoNetworkViewBlock();
}

@end
