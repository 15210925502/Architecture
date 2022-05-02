//
//  NSDictionary+SDTheme.m
//  Theme
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "NSDictionary+SDTheme.h"
#import "NSAttributedString+SDTheme.h"
#import "UIColor+SDExtension.h"

@implementation NSDictionary (SDTheme)

- (NSDictionary *)theme_replaceTitleTextAttributes {
    if (!self[SDThemeForegroundColorAttributeName]) {
        return self;
    }
    NSMutableDictionary *tmpAttributes = [self mutableCopy];
    tmpAttributes[NSForegroundColorAttributeName] = [UIColor sd_colorWithID:self[SDThemeForegroundColorAttributeName]];
    return [tmpAttributes copy];
}

@end

