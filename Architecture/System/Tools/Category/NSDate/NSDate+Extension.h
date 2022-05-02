//
//  NSDate+Extension.h
//  
//
//  Created by mlibai on 16/9/8.
//  Copyright © 2016年 People's Daily Online. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 * 把国际化打开，选择工程 PROJECT 下面的Localizations下添加相应的语言
 */

/** 预设的几种日期格式 */
/** 年份如果用大Y会是这周的年份，小y才是标准的年份 */
/**
 G: 公元时代，例如AD公元
 yy: 年的后2位
 yyyy: 完整年
 MM: 月，显示为1-12
 MMM: 月，显示为英文月份简写,如 Jan
 MMMM: 月，显示为英文月份全称，如 Janualy
 dd: 日，2位数表示，如02
 d: 日，1-2位显示，如 2
 EEE: 简写星期几，如Sun
 EEEE: 全写星期几，如Sunday
 aa: 上下午，AM/PM
 H: 时，24小时制，0-23
 K：时，12小时制，0-11
 m: 分，1-2位
 mm: 分，2位
 s: 秒，1-2位
 ss: 秒，2位
 S: 毫秒
 */
typedef NS_ENUM(NSUInteger, PDDateFormatType) {
    PDDateFormatTypeDefault               = 0,      // yyyy-MM-dd HH:mm:ss              2016-09-13 13:02:46
    PDDateFormatTypeDefaultWithChinese,             // yyyy年MM月dd日 HH:mm              2016年09月04日 05:08
    PDDateFormatTypeDelSeconds,                     // yyyy-MM-dd HH:mm                 2016-09-13 13:02
    PDDateFormatTypeFullYear,                       // yyyy-MM-dd                       2016-09-13
    PDDateFormatTypeShortYear,                      // y-M-d                            2016-9-13
    PDDateFormatTypeYearMoth,                       // yyyy-MM                          2016-09
    PDDateFormatTypeYear,                           // yyyy                             2016
    PDDateFormatTypeFullMonthWithChinese,           // MM月dd日 HH:mm                    11月05日 13:04
    PDDateFormatTypeFullMonthWithDivider,           // MM-dd HH:mm                      11-05 13:04
    PDDateFormatTypeFullMonth,                      // MM-dd                            09-13
    PDDateFormatTypeShortMonthWithChinese,          // M月d日                            9月13日
    PDDateFormatTypeShortMonth,                     // M-d                              9-13
    PDDateFormatTypeFullDayWithDivider,             // dd HH:mm                         09 9-13
    PDDateFormatTypeShortDay,                       // d                                9
    PDDateFormatTypeCompleteMonth,                  // MMMM                             例如 January
    PDDateFormatTypeIncompleteMonth,                // MMM                              例如 Jan
    PDDateFormatTypeMonth,                          // MM                               09
    PDDateFormatTypeWeekDay,                        // EEEE                             例如 Sunday
    PDDateFormatTypeShortWeekDay,                   // EEE                              例如 Sun
    PDDateFormatTypeFullTime,                       // HH:mm:ss                         13:02:46
    PDDateFormatTypeShortTime,                      // H:m:s                            13:2:46
    PDDateFormatTypeFullHour,                       // HH:mm                            13:02
    PDDateFormatTypeShortHour,                      // H:m                              13:2
    PDDateFormatTypeYesterdayWithChinese            // 昨天 HH:mm                        昨天 13:02
};

/** 预设的几种日期格式 */
typedef NS_ENUM(NSUInteger, PDDateFormatUnit) {
    PDDateFormatUnitYear             = 0,           // 年
    PDDateFormatUnitMonth,                          // 月
    PDDateFormatUnitWeek,                           // 周
    PDDateFormatUnitDay,                            // 日
    PDDateFormatUnitHour,                           // 时
    PDDateFormatUnitMinutes,                        // 分
    PDDateFormatUnitSeconds,                        // 秒
};

/** 开始和结束时间 */
typedef NS_ENUM(NSUInteger, PDDateFormatState) {
    PDDateFormatState_Start           = 0,             // 开始时间
    PDDateFormatState_End,                             // 结束时间
};

@interface NSDate (Extension)

//获取整形的年、月、日、时、分、秒
+ (NSInteger)getNumberWithFromatDate:(NSDate *)fromatDate
                            unitFlag:(PDDateFormatUnit)unit;

/**
 *  将时间转化成指定格式的字符串。例如:1499939659 转成 2017-07-13 17:54:19 等格式
 *
 *  @param time  （字符串、Number、data类型）时间截
 *  @param type           日期格式枚举
 *
 *  @return NSString      对象
 */
+ (NSString *)pd_stringWithValue:(id)time
                      formatType:(PDDateFormatType)type;

/**
 *  将YYYY-MM-dd HH:mm:ss格式时间转换成时间
 *
 *  @param timeStr         时间字符串 如2017-05-11 15:24:45
 *  @param type  日期格式枚举 和timeStr格式一样 如PDDateFormatTypeDefault
 *
 *  @return NSDate 对象
 */
+ (NSDate *)changeTimeStringToDate:(NSString *)timeStr
                        formatType:(PDDateFormatType)type;

/**
 *  将YYYY-MM-dd HH:mm:ss格式时间转换成时间截
 *
 *  @param timeStr         时间字符串 如2017-05-11 15:24:45
 *  @param type  日期格式枚举 和timeStr格式一样 如PDDateFormatTypeDefault
 *
 *  @return NSUInteger
 */
+ (NSUInteger)changeTimeStringToTimeSp:(NSString *)timeStr
                            formatType:(PDDateFormatType)type;

/**
 *  修改日期字符串的格式
 *
 *  @param timeStr  时间字符串 时间长度要是13位应该先除以1000后再传入(如 1549296000000)或者不除用137行这个方法
 *  @param fromType 原始日期格式
 *  @param toType   目标日期格式
 *  @return 修改后的日期字符串
 */
+ (NSString *)changeTimeStringToString:(NSString *)timeStr
                        fromFormatType:(PDDateFormatType)fromType
                          toFormatType:(PDDateFormatType)toType;

/**
 *  日期添加时间后的日期 如果是日期的前一段时间，上个月，下个月，上一年，下一年，上几年，下几个月等，上一段时间传负数
 *
 *  @param formatUnit 添加对象，如天或分或秒等
 *  @param number  日期添加个数，如1，表示 分、天、年等
 *
 *  @return NSDate 添加后的时间对象
 */
- (NSDate *)pd_dateByAddingUnit:(PDDateFormatUnit)formatUnit
                     numberUnit:(NSInteger)number;

/**
 *  获取当天、年、月等的开始时间（获取当天的凌晨），当前月的1号等等 比如 unit为PDDateFormatUnitDay时会精确到天 返回 2017-07-21 00:00:00  当天凌晨时间
 *  获取当天、年、月等的结束时间（获取当天、年、月等的最后一秒），当前月的1号等等 比如 unit为PDDateFormatUnitSeconds时会精确到秒 返回 2017-07-21 23:59:59  当天最后一秒的时间
 *
 *  @param fromatDate  日期
 *  @param unit        精确到是单位
 *  @param state       开始时间或者结束时间
 *
 *  @return NSDateComponents 精确到的时间值
 */
+ (NSDate *)getDateWithFromatDate:(NSDate *)fromatDate
                         unitFlag:(PDDateFormatUnit)unit
                            state:(PDDateFormatState)state;

#pragma mark - 返回当前时间戳
+ (NSInteger)getNowTimeStamp;

//date转时间戳
- (NSString *)dateTransformeTimeInterval;

//时间戳转成Date
+ (NSDate *)timeIntervalTransformeDate:(id)timeStamp;

/**
 *  将日期转化成指定格式的字符串。 例如:刚刚、多少小时前，几天前等格式
 *
 *  @param timeStamp 时间截
 *
 *  @return NSString 对象
 */
+ (NSString *)pd_designatedDateFormatFromNsstring:(id)timeStamp;

/**
 *  将日期转化成指定格式的字符串,是本年的只显示年月，不是本年显示年月日
 *
 *  @param timeStamp 时间截
 *
 *  @return NSString 对象
 */
+ (NSString *)pd_DateIsThereYearsFormatFromNsstring:(id)timeStamp;

/**
 *  将总时长转换成十分秒  例如返回 01:15:20这种格式
 *
 *  @param currentSecond 时间长度
 *
 *  @return NSString 对象
 */
+ (NSString *)transformTime:(CGFloat)currentSecond;

/**
 *  比较两个日期是否为同一天,同一年等
 *
 *  @param startDate   比较日期
 *  @param resultDate  被比较日期
 *  @param unit        比较标准
 *
 *  @return BOOL
 */
+ (BOOL)isSameDayWithStartDate:(NSDate *)startDate
                    resultDate:(NSDate *)resultDate
                      unitFlag:(PDDateFormatUnit)unit;
+ (BOOL)isSameDayWithDate:(NSDate *)date
                 unitFlag:(PDDateFormatUnit)unit;

//获取一年中的总天数
- (NSUInteger)daysInYear;

//判断是否为闰年
- (BOOL)isLeapYear;

#pragma mark - 是闰月
- (BOOL)isLeapMonth;

//转成英文月份
+ (NSString *)monthWithMonthNumber:(NSInteger)month;

/**
 *  获取指定月份的天数
 *
 *  @param date   日期，相当于哪一年的
 *  @param month  月份
 *
 *  @return 多少天
 */
+ (NSUInteger)daysInMonth:(NSDate *)date month:(NSUInteger)month;

//获取当前月份的天数
- (NSUInteger)daysInMonth;

//是否为工作日
- (BOOL)isTypicallyWorkday;

//获取该日期是该年的第几周
- (NSUInteger)weekOfYear;

#pragma mark - 相对于月的第几周 范围(1~5)
- (NSInteger)weekOfMonth;

#pragma mark - 当前时间 当前月第几个星期
- (NSInteger)nthWeekday;

//距离该日期前几天
- (NSUInteger)pd_daysAgo;

//日期转星座
- (NSString *)dateToConstellation;

//生日转年龄
- (NSString *)birthdayToAge;

//根据 date 获取 农历
- (NSString *)getChineseCalendar;

//获取已知时区名字
- (NSArray *)getKnownTimeZoneNames;

@end

