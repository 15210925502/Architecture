//
//  SDThemeManager.m
//  SDTheme
//
//  Created by SlashDevelopers on 2018/06/07.
//  Copyright (c) 2018 SlashDevelopers. All rights reserved
//

#import "SDThemeManager.h"

NSString *const SDThemeChangedNotification = @"SDThemeChangedNotification";
NSString *const SDThemeCurrent = @"SDThemeCurrent";

@interface SDThemeManager()

@property (nonatomic, strong) NSString *currentTheme;
/// 颜色对照表
@property (nonatomic, copy) NSDictionary *colorsMap;
/// 主题数组
@property (nonatomic, copy) NSArray *themeArray;

@end

@implementation SDThemeManager
@synthesize currentTheme = _currentTheme;

// MARK: - ================ Public M ===========================

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SDThemeManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[SDThemeManager alloc] init];
    });
    return instance;
}

- (void)setupThemeNameArray:(NSArray *)array {
    self.themeArray = array;
}

- (void)setCurrentTheme:(NSString *)currentTheme{
    if (_currentTheme != currentTheme) {
        _currentTheme = currentTheme;
        [NSUserDefaults saveUserDefaultsObject:currentTheme forKey:SDThemeCurrent];
    }
}

- (NSString *)currentTheme{
    if (!_currentTheme) {
        _currentTheme = [[NSUserDefaults standardUserDefaults] objectForKey:SDThemeCurrent];
    }
    return _currentTheme;
}

- (BOOL)changeTheme:(NSString *)themeName {
    if (![_themeArray containsObject:themeName]) {
        NSAssert([_themeArray containsObject:themeName],@"所启用的主题不存在 - 请检查是否添加了该%@主题的设置",themeName);
        return NO;
    }
    if ([self.currentTheme isEqualToString:themeName] && self.colorsMap) {
        return NO;
    }
    NSString *themeNameStr = [@"ColorsMap_" stringByAppendingString:themeName];
    NSString *mapPath = [[NSBundle mainBundle] pathForResource:themeNameStr ofType:@"plist"];
    if (!mapPath) {
         NSAssert(!!mapPath,@"所启用的主题配置文件不存在 - 请检查是否添加了该%@主题的配置文件",themeName);
        return NO;
    }
    self.currentTheme = themeName;
    NSDictionary *colorsMap = [NSDictionary dictionaryWithContentsOfFile:mapPath];
    self.colorsMap = colorsMap;
    [self sendChangeThemeNotification];
    return YES;
}

+ (NSString *)colorStringWithID:(NSString *)colorID {
    NSDictionary *colorDict = [[SDThemeManager sharedInstance].colorsMap valueForKeyPath:@"ColorID"];
    return colorDict[colorID];
}

// MARK: - ================ Private M ===========================

- (void)sendChangeThemeNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:SDThemeChangedNotification object:nil];
}

@end
