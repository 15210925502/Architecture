//
//  UISegmentedControl+SDTheme.h
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISegmentedControl (SDTheme)

- (void)theme_setTitleTextAttributes:(NSDictionary *)attributes
                            forState:(UIControlState)state;

@end
