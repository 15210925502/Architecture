//
//  SDThemeManager.h
//  SDTheme
//
//  Created by SlashDevelopers on 2018/06/07.
//  Copyright (c) 2018 SlashDevelopers. All rights reserved
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 主题切换通知
FOUNDATION_EXPORT NSString *const SDThemeChangedNotification;

/// 主题管理
@interface SDThemeManager : NSObject

/// 当前主题名称
@property (nonatomic, strong, readonly) NSString *currentTheme;

+ (instancetype)sharedInstance;
/// 初始化主题数组
- (void)setupThemeNameArray:(NSArray *)array;
/// 改变主题
- (BOOL)changeTheme:(NSString *)themeName;

/// 根据配置文件的颜色对照表id,获取颜色值
+ (NSString *)colorStringWithID:(NSString *)colorID;

@end
