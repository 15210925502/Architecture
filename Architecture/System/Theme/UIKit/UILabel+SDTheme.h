//
//  UILabel+SDTheme.h
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SDTheme)

@property (nonatomic, copy) NSString *theme_textColor;
@property (nonatomic, copy) IBInspectable NSString *sd_textColor;
@property (nonatomic, copy) NSAttributedString *theme_attributedText;

@end
