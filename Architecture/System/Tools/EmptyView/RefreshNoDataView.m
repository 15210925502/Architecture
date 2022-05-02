//
//  RefreshNoDataView.m
//  YunDiRentCar
//
//  Created by yyl on 16/12/31.
//  Copyright © 2016年 YunDi.Tech. All rights reserved.
//

#import "RefreshNoDataView.h"

@implementation RefreshNoDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.tipLabel.text = @"暂时没有记录";
        self.tipImageView.image = [UIImage sd_imageWithName:@"no_Data"];
        
        [self addSubview:self.tipImageView];
        [self addSubview:self.tipLabel];
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
}

@end
