//
//  NSObject+MutableAttributedString.h
//  RebateProject
//
//  Created by 华令冬 on 2019/6/12.
//  Copyright © 2019 com.cn.HLD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MutableAttributedString)

//富文本

- (NSMutableAttributedString *)createAttributedStringWithContentString:(NSString *)content
                                                          contentColor:(UIColor *)contentColor
                                                           contentFont:(UIFont *)contentFont
                                                            unitString:(NSString *)unit
                                                             unitColor:(UIColor *)unitColor
                                                              unitFont:(UIFont *)unitFont;

- (NSMutableAttributedString *)createAttributedStringWithContentArray:(NSArray *)contentArray
                                                    contentColorArray:(NSArray *)contentColorArray
                                                     contentFontArray:(NSArray *)contentFontArray;

@end

NS_ASSUME_NONNULL_END
