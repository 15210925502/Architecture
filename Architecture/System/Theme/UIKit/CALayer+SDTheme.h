//
//  CALayer+SDTheme.h
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (SDTheme)

@property (nonatomic, copy) NSString *theme_borderColor;
@property (nonatomic, copy) NSString *theme_shadowColor;
@property (nonatomic, copy) NSString *theme_backgroundColor;

@end
