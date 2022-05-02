//
//  PlusAnimate.h
//  Architecture
//
//  Created by HLD on 2020/5/22.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <UIKit/UIKit.h>

//通知点击按钮协议
@protocol PublishAnimateDelegate <NSObject>

- (void)didSelectBtnWithBtnTag:(NSInteger)tag;

@end


@interface PlusAnimate : UIView

//通知点击按钮代理人
@property(weak,nonatomic) id<PublishAnimateDelegate> delegate;

//弹出动画view
+ (PlusAnimate *)standardPublishAnimateWithView:(UIView *)view;

@end
