//
//  LoadingAnimationView.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingAnimationView : UIView

//view: 添加到哪个视图上
//name:旋转图片
//frame:大小
//自动开启动画
+ (LoadingAnimationView *)showView:(UIView *)view
                         imageName:(NSString *)name
                             frame:(CGRect)frame;

//开启动画
- (void)startAnimating;
//停止动画，不保存动画暂停时间
- (void)stopAnimating;
//停止动画，保存动画暂停时间
- (void)stopAnimatingSaveTimeOffset:(BOOL)isSave;

//移除视图并停止动画
+ (void)hide;

@end
