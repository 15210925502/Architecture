//
//  NSObject+MutableAttributedString.m
//  RebateProject
//
//  Created by 华令冬 on 2019/6/12.
//  Copyright © 2019 com.cn.HLD. All rights reserved.
//

#import "NSObject+MutableAttributedString.h"

@implementation NSObject (MutableAttributedString)

- (NSMutableAttributedString *)createAttributedStringWithContentString:(NSString *)content
                                                          contentColor:(UIColor *)contentColor
                                                           contentFont:(UIFont *)contentFont
                                                            unitString:(NSString *)unit
                                                             unitColor:(UIColor *)unitColor
                                                              unitFont:(UIFont *)unitFont{
    NSMutableAttributedString *finalStr = [[NSMutableAttributedString alloc] init];
    if (!IsNullOrEmptyOfNSString(content)) {
        NSAttributedString *contentStr = [[NSAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName:contentFont, NSForegroundColorAttributeName:contentColor}];
        [finalStr appendAttributedString:contentStr];
    }
    if (!IsNullOrEmptyOfNSString(unit)) {
        NSAttributedString *unitStr = [[NSAttributedString alloc] initWithString:unit attributes:@{NSFontAttributeName:unitFont, NSForegroundColorAttributeName:unitColor}];
        [finalStr appendAttributedString:unitStr];
    }
    return finalStr;
}

- (NSMutableAttributedString *)createAttributedStringWithContentArray:(NSArray *)contentArray
                                                    contentColorArray:(NSArray *)contentColorArray
                                                     contentFontArray:(NSArray *)contentFontArray{
    NSMutableAttributedString *finalStr = [[NSMutableAttributedString alloc] init];
    for(int index = 0;index < contentArray.count; index++){
        NSString *contentString = [contentArray objectAtIndex:index];
        UIColor *contentColor = [UIColor blackColor];
        if (contentColorArray.count > index) {
            contentColor = [contentColorArray objectAtIndex:index];
        }
        UIFont *contentFont = [UIFont systemFontOfSize:[BaseTools adaptedWithValue:10]];
        if (contentFontArray.count > index) {
            contentFont = [contentFontArray objectAtIndex:index];
        }
        NSAttributedString *unitStr = [[NSAttributedString alloc] initWithString:contentString attributes:@{NSFontAttributeName:contentFont, NSForegroundColorAttributeName:contentColor}];
        [finalStr appendAttributedString:unitStr];
    }
    return finalStr;
}

@end
