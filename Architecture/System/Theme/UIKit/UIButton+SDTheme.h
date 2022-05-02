//
//  UIButton+SDTheme.h
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SDTheme)

- (void)theme_setImage:(NSString *)imageName
              forState:(UIControlState)state;

- (void)theme_setBackgroundImage:(NSString *)imageName
                        forState:(UIControlState)state;

- (void)theme_setTitleColor:(NSString *)color
                   forState:(UIControlState)state;

- (void)theme_setBackgroundColor:(NSString *)color
                        forState:(UIControlState)state;

- (void)theme_setAttributedTitle:(NSAttributedString *)title
                        forState:(UIControlState)state;

@end
