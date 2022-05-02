//
//  RefreshHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "RefreshHeader.h"

@interface RefreshHeader()

@property (nonatomic,strong) LoadingAnimationView *loadingView;

@end

@implementation RefreshHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare{
    [super prepare];
    
    self.loadingView = [LoadingAnimationView showView:self
                                            imageName:@"refresh"
                                                frame:CGRectZero];
}

- (void)placeSubviews{
    [super placeSubviews];
    CGFloat widthHeight = [BaseTools adaptedWithValue:25];
    self.loadingView.frame = CGRectMake((self.widthValue - widthHeight) / 2, (self.heightValue - widthHeight) / 2, widthHeight, widthHeight);
}

- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            [self.loadingView stopAnimating];
            break;
        case MJRefreshStatePulling:
            [self.loadingView stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            [self.loadingView startAnimating];
            break;
        default:
            break;
    }
}

@end
