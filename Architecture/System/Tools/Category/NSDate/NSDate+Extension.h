//
//  NSDate+Extension.h
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
    PDDateFormatTypeNoSeparatorFullYear,            // yyyyMMdd                       20160913
    PDDateFormatTypeYear,                           // yyyy                             2016
    PDDateFormatTypeFullMonthWithChinese,           // MM月dd日 HH:mm                    11月05日 13：04
    PDDateFormatTypeFullMonthWithDivider,           // MM-dd HH:mm                      11-05 13：04
    PDDateFormatTypeFullMonth,                      // MM-dd                            09-13
    PDDateFormatTypeShortMonth,                     // M-d                              9-13
    PDDateFormatTypeCompleteMonth,                  // MMMM                             例如 January
    PDDateFormatTypeIncompleteMonth,                // MMM                              例如 Jan
    PDDateFormatTypeMonth,                          // MM                               09
    PDDateFormatTypeChinaWeekDay,                   // 汉字星期                           星期日
    PDDateFormatTypeWeekDay,                        // EEEE                             例如 Sunday
    PDDateFormatTypeShortWeekDay,                   // EEE                              例如 Sun
    PDDateFormatTypeFullTime,                       // HH:mm:ss                         13:02:46
    PDDateFormatTypeShortTime,                      // H:m:s                            13:2:46
    PDDateFormatTypeFullHour,                       // HH:mm                            13:02
    PDDateFormatTypeShortHour,                      // H:m                              13:2
    PDDateFormatTypeOnlyHour,                       // H                                13
    PDDateFormatTypeYesterdayWithChinese            // 昨天 HH:mm                        昨天 13:02
};

/** 预设的几种日期格式 */
typedef NS_ENUM(NSUInteger, PDDateFormatUnit) {
    PDDateFormatUnitYear             = 0,           // 年
    PDDateFormatUnitMonth,                          // 月
    PDDateFormatUnitDay,                            // 日
    PDDateFormatUnitWeek,                           // 周
    PDDateFormatUnitHour,                           // 时
    PDDateFormatUnitMinutes,                        // 分
    PDDateFormatUnitSeconds,                        // 秒
};

/** 开始和结束时间 */
typedef NS_ENUM(NSUInteger, PDDateFormatState) {
    PDDateFormatState_Start           = 0,             // 开始时间
    PDDateFormatState_End,                             // 结束时间
};

#define CHINESEMONTHS   @[@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"冬",@"腊"]
#define CHINESEMONTHS1   @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二"]
#define EARTHLYBRANCHES @[@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥"]
#define ZODIACS         @[@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪"]
#define CHINESEYEARS    @[@"甲子",@"乙丑",@"丙寅",@"丁卯",@"戊辰",@"己巳",@"庚午",@"辛未",@"壬申",@"癸酉",@"甲戌",@"乙亥",@"丙子",@"丁丑",@"戊寅",@"己卯",@"庚辰",@"辛巳",@"壬午",@"癸未",@"甲申",@"乙酉",@"丙戌",@"丁亥",@"戊子",@"己丑",@"庚寅",@"辛卯",@"壬辰",@"癸巳",@"甲午",@"乙未",@"丙申",@"丁酉",@"戊戌",@"己亥",@"庚子",@"辛丑",@"壬寅",@"癸丑",@"甲辰",@"乙巳",@"丙午",@"丁未",@"戊申",@"己酉",@"庚戌",@"辛亥",@"壬子",@"癸丑",@"甲寅",@"乙卯",@"丙辰",@"丁巳",@"戊午",@"己未",@"庚申",@"辛酉",@"壬戌",@"癸亥"]
#define SolarTerms  @[@"立春", @"雨水", @"惊蛰", @"春分", @"清明", @"谷雨", @"立夏", @"小满", @"芒种", @"夏至", @"小暑", @"大暑", @"立秋", @"处暑", @"白露", @"秋分", @"寒露", @"霜降", @"立冬", @"小雪", @"大雪", @"冬至", @"小寒", @"大寒"]

@interface NSDate (Extension)

/**
 *  将时间转化成指定格式的字符串。
 *  例如:1499939659 转成 2017-07-13 17:54:19 等格式
 *
 *  @param time  （date类型、Number类型时间截）
 *  @param type           日期格式枚举
 *
 *  @return NSString      对象
 */
+ (NSString *)pd_stringWithValue:(id)time formatType:(PDDateFormatType)type;
- (NSString *)pd_stringWithFormatType:(PDDateFormatType)type;

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

#pragma mark - 返回当前时间截
- (NSUInteger)getNowTimeStamp;

//时间截转成Date
+ (NSDate *)timeIntervalTransformeDate:(NSUInteger)timeStamp;

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
                     numberUnit:(NSUInteger)number;

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

//距离该日期还有几天
- (NSUInteger)pd_daysAgo;
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
 *  比较两个日期是否相同
 *
 *  @param startDate   比较日期
 *  @param resultDate  被比较日期
 *  @param unit        比较标准
 *
 *  @return BOOL
 */
+ (BOOL)isSameDayWithStartDate:(NSDate *)startDate resultDate:(NSDate *)resultDate unitFlag:(PDDateFormatUnit)unit;

//判断是否为闰年
- (BOOL)isLeapYear;

//农历闰哪个月 1-12 , 没闰传回 0
+ (NSUInteger)leapMonth:(NSUInteger)year;

//农历闰月的天数
+ (NSUInteger)leapDays:(NSUInteger)year;

//获取指定月份的农历天数
+ (NSUInteger)monthDaysWithYear:(NSUInteger)year month:(NSUInteger)month;

//获取当前月份的阳历天数
- (NSUInteger)daysInMonth;
//获取指定月份的阳历天数
- (NSUInteger)daysInMonth:(NSUInteger)month;
+ (NSUInteger)daysInMonth:(NSString *)timeStr formatType:(PDDateFormatType)type;
//获取一年中阳历的总天数
- (NSUInteger)daysInYear;
+ (NSUInteger)daysInYear:(NSString *)timeStr formatType:(PDDateFormatType)type;
//获取一年中农历的总天数
+ (NSUInteger)daysInYear:(NSUInteger)year;

//农历日期、天干地支、节气、假日
/**
 返回一个字典
 字典参数说明：
 year                    : 农历哪一年
 month                   : 农历哪一月
 day                     : 农历哪一天
 yearTG                  : 年的天干
 yearDZ                  : 年的地支
 yearTGDZ                : 年的天干地支
 monthTG                 : 月的天干
 monthDZ                 : 月的地支
 monthTGDZ               : 月的天干地支
 dayTG                   : 天的天干
 dayDZ                   : 天的地支
 dayTGDZ                 : 日的天干地支
 jq                      : 节气
 holiday                 : 节日（数组）
 gongLiYearSumDay        : 公历一年总天数
 nongLiYearSumDay        : 农历一年总天数
 gongLiMonthDay          : 公历当月总天数
 nongLiMonthDay          : 农历当月总天数
 isLeapYear              : 是否是闰年
 isLeapMonth             : 是否为闰月
 leapMonth               : 闰几月
 leapMonthSumDay         : 闰月的天数
 */
- (NSDictionary *)lunar;
//timeStr : 时间字符串 如： 1988-12-12
//type    : 传入字符串时间的格式 如：PDDateFormatTypeFullYear
+ (NSDictionary *)lunarWithTimeString:(NSString *)timeStr formatType:(PDDateFormatType)type;

//根据农历日期算阳历日期
/**
 * year      农历年
 * month     农历月
 * day       农历日
 * isLeap    是否闰月
 */
+ (NSString *)lunarToSolarYear:(int)year month:(int)month day:(int)day isLeap:(BOOL)isLeap;

//NongLiCom.year = 甲子数【1-60】
- (NSDateComponents *)getNongLi;
+ (NSDateComponents *)getNongLiWithTimeStr:(NSString *)timeStr formatType:(PDDateFormatType)type;

//年柱
//获取农历的哪一年：天干地支年（如：1988年为戊辰年）
- (NSDictionary *)getYearTGDZ;
+ (NSDictionary *)getYearTGDZ:(NSString *)timeStr formatType:(PDDateFormatType)type;
+ (NSString *)eraWithInteger:(NSUInteger)year;

//月柱
- (NSDictionary *)getMonthTGDZ;
+ (NSDictionary *)getMonthTGDZ:(NSString *)timeStr formatType:(PDDateFormatType)type;

//日柱
- (NSDictionary *)getDayTGDZ;
+ (NSDictionary *)getDayTGDZ:(NSString *)timeStr formatType:(PDDateFormatType)type;

//时柱
/**
 * 日上起时
 * 甲己还生甲，乙庚丙作初，
 * 丙辛从戊起，丁壬庚子居，
 * 戊癸何方发，壬子是真途。
 * 子时   23—1点，     丑时   1—3点，
 * 寅时   3—5点，      卯时   5—7点，
 * 辰时   7—9点，      巳时   9—11点，
 * 午时   11—13点，    未时   13—15点，
 * 申时   15—17点，    酉时   17—19点，
 * 戌时   19—21点，    亥时   21—23点
 */
- (NSDictionary *)hourTGDZ;
+ (NSDictionary *)hourTGDZ:(NSString *)timeStr formatType:(PDDateFormatType)type;

//农历时间转成汉字  如：11 转成十一
+ (NSString *)cDay:(NSUInteger)day;

//获取农历节日
- (NSString *)getLunarHoliDay;

//日期转星座
- (NSString *)dateToConstellation;
+ (NSString *)dateToConstellationWithTimeStr:(NSString *)timeStr formatType:(PDDateFormatType)type;

//计算日期年份的生肖
- (NSString *)zodiac;
+ (NSString *)zodiacWithInter:(NSUInteger)year;

//生日转年龄
- (NSString *)birthdayToAge;
+ (NSString *)birthdayToAgeWithTimeStr:(NSString *)timeStr formatType:(PDDateFormatType)type;

//转成英文月份
+ (NSString *)monthWithMonthNumber:(NSUInteger)month;

//是否为工作日
- (BOOL)isTypicallyWorkday;

//获取该日期是该年的第几周（感觉不太准）
- (NSUInteger)weekOfYear;

#pragma mark - 获取该日期 当前月第几周 范围(1~5)
- (NSUInteger)weekOfMonth;
- (NSUInteger)nthWeekday;

#pragma mark -- 获得当前月份第一天星期几 0表示周天，1表示周一
- (NSUInteger)firstWeekdayInThisMonth;

//获取时区名字
+ (NSArray *)getKnownTimeZoneNames;

@end

