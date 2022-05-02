//
//  NSAttributedString+SDTheme.h
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSAttributedStringKey const SDThemeForegroundColorAttributeName;

@interface NSAttributedString (SDTheme)

/// 取得真实颜色值
- (NSAttributedString *)theme_replaceRealityColor;

@end
