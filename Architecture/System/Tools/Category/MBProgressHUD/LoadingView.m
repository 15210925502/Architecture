//
//  LoadingView.m
//  Architecture
//
//  Created by HLD on 2020/6/4.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "LoadingView.h"
#import "LoadingAnimationView.h"

@implementation LoadingView{
    UIImageView *_logoImageV;
}

//自定义MBProgressHUD的customView要设置下面这个方法和把translatesAutoresizingMaskIntoConstraints设置为NO
- (CGSize)intrinsicContentSize {
    return self.bounds.size;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        _logoImageV = [[UIImageView alloc] initWithImage:[UIImage sd_imageWithName:@"LoadingLogo"]];
               _logoImageV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
               [self addSubview:_logoImageV];
        
        [LoadingAnimationView showView:self
                             imageName:@"LoadingAnimate"
                                 frame:self.bounds];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _logoImageV.center = CGPointMake(self.widthValue / 2, self.heightValue / 2);
}

- (void)dealloc{
    [LoadingAnimationView hide];
}

@end
