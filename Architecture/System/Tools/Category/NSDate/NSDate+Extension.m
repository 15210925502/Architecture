//
//  NSDate+Extension.m
//
//
//  Created by mlibai on 16/9/8.
//  Copyright © 2016年 People's Daily Online. All rights reserved.
//

#import "NSDate+Extension.h"
#import "NSString+RegexCategory.h"

#ifndef NSDateTimeAgoLocalizedStrings
#define NSDateTimeAgoLocalizedStrings(key) NSLocalizedStringFromTableInBundle(key, @"NSDateTimeAgo", [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"NSDateTimeAgo.bundle"]], nil)
#endif

#define hld_Components (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)

#define D_MINUTE     60
#define D_HOUR       (D_MINUTE * D_MINUTE)
#define D_DAY        (24 * D_HOUR)
#define D_WEEK       (7 * D_DAY)

@implementation NSDate (Extension)

+ (NSInteger)getNowTimeStamp {
    NSInteger timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
    return timeStamp;
}

+ (NSDateFormatter *)defaultFormatDate{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    return dateFormatter;
}

+ (NSString *)pd_stringFormatType:(PDDateFormatType)type {
    switch (type) {
        case PDDateFormatTypeDefault:
            return @"yyyy-MM-dd HH:mm:ss";
        case PDDateFormatTypeDelSeconds:
            return @"yyyy-MM-dd HH:mm";
        case PDDateFormatTypeDefaultWithChinese:
            return @"yyyy年MM月dd日 HH:mm";
        case PDDateFormatTypeFullYear:
            return @"yyyy-MM-dd";
        case PDDateFormatTypeShortYear:
            return @"Y-M-d";
        case PDDateFormatTypeYearMoth:
            return @"yyyy-MM";
        case PDDateFormatTypeYear:
            return @"yyyy";
        case PDDateFormatTypeFullMonthWithChinese:
            return @"MM月dd日 HH:mm";
        case PDDateFormatTypeFullMonthWithDivider:
            return @"MM-dd HH:mm";
        case PDDateFormatTypeFullMonth:
            return @"MM-dd";
        case PDDateFormatTypeShortMonthWithChinese:
            return @"M月d日";
        case PDDateFormatTypeShortMonth:
            return @"M-d";
        case PDDateFormatTypeFullDayWithDivider:
            return @"dd HH:mm";
        case PDDateFormatTypeShortDay:
            return @"d";
        case PDDateFormatTypeCompleteMonth:
            return @"MMMM";
        case PDDateFormatTypeIncompleteMonth:
            return @"MMM";
        case PDDateFormatTypeMonth:
            return @"MM";
        case PDDateFormatTypeWeekDay:
            return @"EEEE";
        case PDDateFormatTypeShortWeekDay:
            return @"EEE";
        case PDDateFormatTypeFullTime:
            return @"HH:mm:ss";
        case PDDateFormatTypeShortTime:
            return @"H:m:s";
        case PDDateFormatTypeFullHour:
            return @"HH:mm";
        case PDDateFormatTypeShortHour:
            return @"H:m";
        case PDDateFormatTypeYesterdayWithChinese:
            return @"昨天 HH:mm";
    }
}

/**
 *  Get the month as a localized string from the given month number
 *
 *  @param month The month to be converted in string
 *  [1 - January]
 *  [2 - February]
 *  [3 - March]
 *  [4 - April]
 *  [5 - May]
 *  [6 - June]
 *  [7 - July]
 *  [8 - August]
 *  [9 - September]
 *  [10 - October]
 *  [11 - November]
 *  [12 - December]
 *
 *  @return Return the given month as a localized string
 */
+ (NSString *)monthWithMonthNumber:(NSInteger)month {
    switch(month) {
        case 1:
            return @"January";
            break;
        case 2:
            return @"February";
            break;
        case 3:
            return @"March";
            break;
        case 4:
            return @"April";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"June";
            break;
        case 7:
            return @"July";
            break;
        case 8:
            return @"August";
            break;
        case 9:
            return @"September";
            break;
        case 10:
            return @"October";
            break;
        case 11:
            return @"November";
            break;
        case 12:
            return @"December";
            break;
        default:
            break;
    }
    return @"";
}

- (NSString *)dateTransformeTimeInterval{
    return [NSString stringWithFormat:@"%ld", (long)[self timeIntervalSince1970]];
}

+ (NSDate *)timeIntervalTransformeDate:(id)timeStamp{
    NSString *timeStampStr = [NSString stringWithFormat:@"%@",timeStamp];
    return [NSDate dateWithTimeIntervalSince1970:[timeStampStr integerValue]];
}

+ (NSString *)changeTimeStringToString:(NSString *)timeStr
                        fromFormatType:(PDDateFormatType)fromType
                          toFormatType:(PDDateFormatType)toType{
    NSDate *date = [NSDate changeTimeStringToDate:timeStr
                                       formatType:fromType];
    NSString *resultTimeString = [NSDate pd_stringByUsingDateFormatDate:date
                                                             formatType:toType];
    return  resultTimeString;
}

+ (NSUInteger)changeTimeStringToTimeSp:(NSString *)timeStr
                            formatType:(PDDateFormatType)type{
    NSDate *fromdate = [NSDate changeTimeStringToDate:timeStr
                                           formatType:type];
    return [fromdate timeIntervalSince1970];
}

+ (NSDate *)changeTimeStringToDate:(NSString *)timeStr
                        formatType:(PDDateFormatType)type{
    NSDateFormatter *format = [NSDate defaultFormatDate];
    NSString *formatString = [NSDate pd_stringFormatType:type];
    [format setDateFormat:formatString];
    NSDate *fromdate = [format dateFromString:timeStr];
    return fromdate;
}

+ (NSString *)pd_stringWithValue:(id)time
                      formatType:(PDDateFormatType)type{
    if (!time) {
        return @"";
    }
    if ([time isKindOfClass:[NSDate class]]) {
        return [self pd_stringByUsingDateFormatDate:time
                                         formatType:type];
    }if([time isKindOfClass:[NSString class]]){
        if (IsNullOrEmptyOfNSString(time)) {
            return @"";
        }
        NSDate *fromdate = [self timeIntervalTransformeDate:time];
        NSString *timeStr = [self pd_stringByUsingDateFormatDate:fromdate
                                                      formatType:type];
        return timeStr;
    }else if([time isKindOfClass:[NSNumber class]]){
        NSDate *confromTimesp = [self timeIntervalToDate:time];
        NSString *relustString = [NSDate pd_stringByUsingDateFormatDate:confromTimesp
                                                             formatType:type];
        return relustString;
    }else{
        return @"";
    }
}

+ (NSDate *)timeIntervalToDate:(id)timeStamp{
    NSString *timeStampStr = [NSString stringWithFormat:@"%@",timeStamp];
    NSTimeInterval tempTime;
    NSString *subStringTiemStamp = [[timeStampStr componentsSeparatedByString:@"."] firstObject];
    if (subStringTiemStamp.length > 10) {
        tempTime = [subStringTiemStamp doubleValue] / 1000;
    }else{
        tempTime = [timeStampStr doubleValue];
    }
    NSDate *sinceDate = [NSDate timeIntervalTransformeDate:@(tempTime)];
    return sinceDate;
}

+ (NSString *)pd_stringByUsingDateFormatDate:(NSDate *)formatDate
                                  formatType:(PDDateFormatType)type {
    if (!formatDate) {
        return @"";
    }
    NSString *formatString = [NSDate pd_stringFormatType:type];
    NSDateFormatter *dateFormatter = [NSDate defaultFormatDate];
    dateFormatter.dateFormat = formatString;
    return [dateFormatter stringFromDate:formatDate];
}

+ (NSString *)pd_designatedDateFormatFromNsstring:(id)timeStamp{
    if (!timeStamp) {
        return @"";
    }
    NSString *showTime = @"";
    NSDate *sinceDate = [self timeIntervalToDate:timeStamp];
    NSDate *nowDate = [NSDate date];
    BOOL isSameYear = [NSDate isSameDayWithStartDate:sinceDate
                                          resultDate:nowDate
                                            unitFlag:PDDateFormatUnitYear];
    if(isSameYear) {
        BOOL isSameDay = [NSDate isSameDayWithStartDate:sinceDate
                                             resultDate:nowDate
                                               unitFlag:PDDateFormatUnitDay];
        double deltaSeconds = fabs([sinceDate timeIntervalSinceDate:nowDate]);
        if (isSameDay) {
            if (deltaSeconds <= 30 * D_MINUTE) {
                NSInteger minutes = deltaSeconds / D_MINUTE;
                NSInteger remainder = (NSInteger)deltaSeconds % D_MINUTE;
                if (remainder > 0 || minutes == 0) {
                    minutes += 1;
                }
                showTime = [sinceDate stringFromFormat:@"%%d %@minutes ago" withValue:minutes];
            }else{
                showTime = [NSDate pd_stringByUsingDateFormatDate:sinceDate
                                                       formatType:PDDateFormatTypeFullHour];
            }
        }else{
            NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-D_DAY];
            BOOL isYesterday = [NSDate isSameDayWithStartDate:sinceDate
                                                   resultDate:yesterday
                                                     unitFlag:PDDateFormatUnitDay];
            if (isYesterday) {
                showTime = [NSDate pd_stringByUsingDateFormatDate:sinceDate
                                                       formatType:PDDateFormatTypeYesterdayWithChinese];
            }else{
                showTime = [NSDate pd_stringByUsingDateFormatDate:sinceDate
                                                       formatType:PDDateFormatTypeFullMonthWithDivider];
            }
        }
    }else{
        showTime = [NSDate pd_stringByUsingDateFormatDate:sinceDate
                                               formatType:PDDateFormatTypeDelSeconds];
    }
    return showTime;
}

+ (NSString *)pd_DateIsThereYearsFormatFromNsstring:(id)timeStamp{
    if (!timeStamp) {
        return @"";
    }
    NSString *showTime = @"";
    NSDate *sinceDate = [self timeIntervalToDate:timeStamp];
    NSDate *nowDate = [NSDate date];
    
    BOOL isSameYear = [NSDate isSameDayWithStartDate:sinceDate
                                          resultDate:nowDate
                                            unitFlag:PDDateFormatUnitYear];
    if(isSameYear) {
        showTime = [NSDate pd_stringByUsingDateFormatDate:sinceDate
                                               formatType:PDDateFormatTypeFullMonth];
    }else{
        showTime = [NSDate pd_stringByUsingDateFormatDate:sinceDate
                                               formatType:PDDateFormatTypeFullYear];
    }
    return showTime;
}

+ (BOOL)isSameDayWithDate:(NSDate *)date
                 unitFlag:(PDDateFormatUnit)unit{
    return [self isSameDayWithStartDate:date
                             resultDate:[NSDate date]
                               unitFlag:unit];
}

+ (BOOL)isSameDayWithStartDate:(NSDate *)startDate
                    resultDate:(NSDate *)resultDate
                      unitFlag:(PDDateFormatUnit)unit{
    if (startDate != nil && resultDate != nil) {
        NSInteger start = [NSDate getNumberWithFromatDate:startDate
                                                 unitFlag:unit];
        NSInteger result = [NSDate getNumberWithFromatDate:resultDate
                                                  unitFlag:unit];
        if (start == result) {
            return YES;
        }
    }
    return NO;
}

//哪一年，第几月，第几天等等
+ (NSInteger)getNumberWithFromatDate:(NSDate *)fromatDate
                             unitFlag:(PDDateFormatUnit)unit{
    NSInteger number = 0;
    NSDateComponents *components = [NSDate getComponentsWithFromatDate:fromatDate];
    switch (unit) {
        case PDDateFormatUnitYear:
        {
            number = [components year];
        }
            break;
        case PDDateFormatUnitMonth:
        {
            number = [components month];
        }
            break;
        case PDDateFormatUnitDay:
        {
            number = [components day];
        }
            break;
        case PDDateFormatUnitHour:
        {
            number = [components hour];
        }
            break;
        case PDDateFormatUnitMinutes:
        {
            number = [components minute];
        }
            break;
        case PDDateFormatUnitSeconds:
        {
            number = [components second];
        }
            break;
            
        default:
            break;
    }
    return number;
}

+ (NSDateComponents *)getComponentsWithFromatDate:(NSDate *)fromatDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);
    NSDateComponents *components = [calendar components:unitFlags
                                               fromDate:fromatDate];
    return components;
}

+ (NSDate *)getDateWithFromatDate:(NSDate *)fromatDate
                         unitFlag:(PDDateFormatUnit)unit
                            state:(PDDateFormatState)state{
    NSDate *resultDate = nil;
    switch (state) {
        case PDDateFormatState_Start:
        {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [NSDate getComponentsWithFromatDate:fromatDate];
            resultDate = [calendar dateFromComponents:components];
        }
            break;
        case PDDateFormatState_End:
        {
            NSDate *startDate = [NSDate getDateWithFromatDate:fromatDate
                                                     unitFlag:unit
                                                        state:PDDateFormatState_Start];
            NSDate *endDate = [startDate pd_dateByAddingUnit:unit
                                                  numberUnit:1];
            resultDate = [endDate pd_dateByAddingUnit:PDDateFormatUnitSeconds
                                           numberUnit:-1];
        }
            break;
            
        default:
            break;
    }
    return resultDate;
}

- (NSString *)stringFromFormat:(NSString *)format
                     withValue:(NSInteger)value{
    NSString *tempFormat = @"";
    if([[UIDevice languageCode] isEqual:@"ru"]) {
        int XY = (int)floor(value) % 100;
        int Y = (int)floor(value) % 10;
        if(Y == 0 || Y > 4 || (XY > 10 && XY < 15)){
            tempFormat = @"";
        }
        if(Y > 1 && Y < 5 && (XY < 10 || XY > 20)){
            tempFormat = @"_";
        }
        if(Y == 1 && XY != 11){
            tempFormat = @"__";
        }
    }
    NSString *localeFormat = [NSString stringWithFormat:format,tempFormat];
    return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), value];
}

+ (NSString *)transformTime:(CGFloat)currentSecond{
    NSString *str = nil;
    if((int)currentSecond < D_HOUR){
        int tempTime = (int)currentSecond / D_MINUTE;
        int tempTime1 = (int)currentSecond % D_MINUTE;
        str = [NSString stringWithFormat:@"%@:%@",[NSDate conversionData:tempTime],[NSDate conversionData:tempTime1]];
    }else{
        int tempTime = (int)currentSecond / D_MINUTE / D_MINUTE;
        int tempTime1 = (int)currentSecond % (D_HOUR);
        int tempTime2 = (int)tempTime1 / D_MINUTE;
        int tempTime3 = (int)tempTime1 % D_MINUTE;
        str = [NSString stringWithFormat:@"%@:%@:%@",[NSDate conversionData:tempTime],[NSDate conversionData:tempTime2],[NSDate conversionData:tempTime3]];
    }
    return str;
}

+ (NSString *)conversionData:(CGFloat)temp{
    NSString *str = nil;
    if (temp < 10) {
        str = [NSString stringWithFormat:@"0%d",(int)temp];
    }else{
        str = [NSString stringWithFormat:@"%d",(int)temp];
    }
    return str;
}

- (NSDate *)pd_dateByAddingUnit:(PDDateFormatUnit)formatUnit
                     numberUnit:(NSInteger)number{
    NSDate *newDate = nil;
    if (formatUnit == PDDateFormatUnitYear ||
        formatUnit == PDDateFormatUnitMonth ||
        formatUnit == PDDateFormatUnitWeek ||
        formatUnit == PDDateFormatUnitDay) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        switch (formatUnit) {
            case PDDateFormatUnitYear:
            {
                [adcomps setYear:number];
            }
                break;
            case PDDateFormatUnitMonth:
            {
                [adcomps setMonth:number];
            }
                break;
            case PDDateFormatUnitWeek:
            {
                [adcomps setWeekOfYear:number];
            }
                break;
            case PDDateFormatUnitDay:
            {
                [adcomps setDay:number];
            }
                break;
                
            default:
                break;
        }
        newDate = [calendar dateByAddingComponents:adcomps
                                            toDate:self
                                           options:0];
    }else{
        NSTimeInterval timeInterval = 0;
        switch (formatUnit) {
            case PDDateFormatUnitHour:
            {
                timeInterval = D_HOUR * number;
            }
                break;
            case PDDateFormatUnitMinutes:
            {
                timeInterval = D_MINUTE * number;
            }
                break;
            case PDDateFormatUnitSeconds:
            {
                timeInterval = number;
            }
                break;
                
            default:
                break;
        }
        NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + timeInterval;
        newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    }
    return newDate;
}

- (NSUInteger)daysInYear {
    return [self isLeapYear] ? 366 : 365;
}

- (BOOL)isLeapYear{
    NSUInteger year = [[NSDate pd_stringByUsingDateFormatDate:self
                                                   formatType:PDDateFormatTypeYear] integerValue];
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)isLeapMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

+ (NSUInteger)daysInMonth:(NSDate *)date month:(NSUInteger)month {
    switch (month) {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            return 31;
        case 2:
            return [date isLeapYear] ? 29 : 28;
    }
    return 30;
}

- (NSUInteger)daysInMonth {
    NSUInteger mouth = [[NSDate pd_stringByUsingDateFormatDate:self
                                                    formatType:PDDateFormatTypeMonth] integerValue];
    return [NSDate daysInMonth:self
                         month:mouth];
}

- (BOOL)isTypicallyWorkday{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:hld_Components fromDate:self];
    if ((components.weekday == 1) || (components.weekday == 7)){
        return NO;
    }
    return YES;
}

- (NSUInteger)weekOfYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitYear forDate:self];
}

- (NSInteger)weekOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [[calendar components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)nthWeekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:hld_Components fromDate:self];
    return components.weekdayOrdinal;
}

- (NSUInteger)pd_daysAgo {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay) fromDate:self toDate:[NSDate date] options:0];
#else
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit) fromDate:self toDate:[NSDate date] options:0];
#endif
    return [components day];
}

- (NSString *)dateToConstellation{
    NSInteger month = [NSDate getNumberWithFromatDate:self
                                             unitFlag:PDDateFormatUnitMonth];
    NSInteger day = [NSDate getNumberWithFromatDate:self
                                           unitFlag:PDDateFormatUnitDay];
    if (day == NSNotFound || month == NSNotFound) {
        return nil;
    }
    NSArray *constellations = @[@"水瓶座", @"双鱼座", @"白羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座", @"摩羯座"];
    NSString *constellation = nil;
    switch (month) {
        case 1:
        {
            if (day < 20) {
                constellation = constellations.lastObject;
            }
        }
            break;
        case 2:
        {
            if (day < 19) {
                constellation = constellations.firstObject;
            }
        }
            break;
        case 3:
        case 5:
        {
            if (day < 21) {
                constellation = constellations[month - 2];
            }
        }
            break;
        case 4:
        {
            if (day < 20) {
                constellation = constellations[2];
            }
        }
            break;
        case 6:
        case 12:
        {
            if (day < 22) {
                constellation = constellations[month - 2];
            }
        }
            break;
        case 7:
        case 8:
        case 9:
        case 11:
        {
            if (day < 23) {
                constellation = constellations[month - 2];
            }
        }
            break;
        case 10:
        {
            if (day < 24) {
                constellation = constellations[8];
            }
        }
            break;
            
        default:
            break;
    }
    if (constellation == nil) {
        constellation = constellations[month - 1];
    }
    return constellation;
}

- (NSString *)birthdayToAge{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour) fromDate:self toDate:[NSDate date] options:0];
    
    if ([components year] > 0) {
        return [NSString stringWithFormat:@"%ld岁",(long)[components year]];
    }else if([components month] > 0) {
        return [NSString stringWithFormat:@"%ld个月%ld天",(long)[components month],(long)[components day]];
    }else{
        return [NSString stringWithFormat:@"%ld天%ld小时",(long)[components day],(long)[components hour]];
    }
}

- (NSString *)getChineseCalendar{
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅",    @"丁卯",    @"戊辰",    @"己巳",    @"庚午",    @"辛未",    @"壬申",    @"癸酉",
                             @"甲戌",    @"乙亥",    @"丙子",    @"丁丑", @"戊寅",    @"己卯",    @"庚辰",    @"辛己",    @"壬午",    @"癸未",
                             @"甲申",    @"乙酉",    @"丙戌",    @"丁亥",    @"戊子",    @"己丑",    @"庚寅",    @"辛卯",    @"壬辰",    @"癸巳",
                             @"甲午",    @"乙未",    @"丙申",    @"丁酉",    @"戊戌",    @"己亥",    @"庚子",    @"辛丑",    @"壬寅",    @"癸丑",
                             @"甲辰",    @"乙巳",    @"丙午",    @"丁未",    @"戊申",    @"己酉",    @"庚戌",    @"辛亥",    @"壬子",    @"癸丑",
                             @"甲寅",    @"乙卯",    @"丙辰",    @"丁巳",    @"戊午",    @"己未",    @"庚申",    @"辛酉",    @"壬戌",    @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:self];
    if(self){
        NSString *y_str = [chineseYears objectAtIndex:localeComp.year - 1];
        NSString *m_str = [chineseMonths objectAtIndex:localeComp.month - 1];
        NSString *d_str = [chineseDays objectAtIndex:localeComp.day - 1];
        
        NSString *chineseCal_str =[NSString stringWithFormat: @"%@年%@月%@",y_str,m_str,d_str];
        return chineseCal_str;
    }
    return @"请重选一次";
}

- (NSArray *)getKnownTimeZoneNames{
    NSArray *zoneArrs = [NSTimeZone knownTimeZoneNames];
    for (NSString *names in zoneArrs) {
        //时区
        NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:names];
        //设置格式
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setTimeZone:timeZone];
        NSString *string = [dateFormatter stringFromDate:[NSDate date]];
        NSLog(@"string:%@,[timeZone name]:%@",string,[timeZone name]);
    }
    return zoneArrs;
}

@end
