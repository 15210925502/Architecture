//
//  NSDate+Extension.m
//
//  Created by mlibai on 16/9/8.
//  Copyright © 2016年 People's Daily Online. All rights reserved.
//

#import "NSDate+Extension.h"
#import "NSString+RegexCategory.h"

#ifndef DateToolsLocalizedStrings
#define DateToolsLocalizedStrings(key) NSLocalizedStringFromTableInBundle(key, @"DateTools", [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DateTools.bundle"]], nil)
#endif

#define hld_Components (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)

#define D_MINUTE     60
#define D_HOUR       (D_MINUTE * D_MINUTE)
#define D_DAY        (24 * D_HOUR)
#define D_WEEK       (7 * D_DAY)

#define CHINESEDAYS1    @[@"初",@"十",@"廿",@"卅",@"　"]
#define CHINESEDAYS2    @[@"日",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"]
#define HEAVENLYSTEMS   @[@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸"]
#define WEEKARRAY       @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"]
#define CONSTELLATIONS  @[@"水瓶座",@"双鱼座",@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座"]

#define   CHINAHOLIDAY @{                \
@"1-1":@"春节",                \
@"1-15":@"元宵",                \
@"5-5":@"端午",                \
@"7-7":@"七夕",                \
@"7-15":@"中元",                \
@"8-15":@"中秋",                \
@"9-9":@"重阳",                \
@"12-8":@"腊八",                \
@"12-23":@"北方小年",                \
@"12-24":@"南方小年",                \
@"12-30":@"除夕"}

#define  WEEKHOLIDAY   @{                \
@"0512":@"世界哮喘日",                     \
@"0520":@"国际母亲节 救助贫困母亲日",         \
@"0530":@"全国助残日",                     \
@"0532":@"国际牛奶日",                     \
@"0626":@"中国文化遗产日",                  \
@"0630":@"国际父亲节",                     \
@"0716":@"国际合作节",                     \
@"0730":@"被奴役国家周",                   \
@"0932":@"国际和平日",                     \
@"0936":@"全民国防教育日",                  \
@"0940":@"国际聋人节 世界儿童日",            \
@"0950":@"世界海事日 世界心脏病日",          \
@"1011":@"国际住房日 世界建筑日 世界人居日",   \
@"1023":@"国际减灾日",                     \
@"1024":@"世界视觉日",                     \
@"1144":@"感恩节",                         \
@"1220":@"国际儿童电视广播日"}

#define  WORLDHOLIDAY      @{                        \
@"0101":@"元旦",                                     \
@"0106":@"中国第13亿人口日",                         \
@"0108":@"周恩来逝世纪念日",                         \
@"0115":@"释迦如来成道日",                         \
@"0121":@"列宁逝世纪念日 国际声援南非日 弥勒佛诞辰",                         \
@"0202":@"世界湿地日",                         \
@"0207":@"二七大罢工纪念日",                         \
@"0210":@"国际气象节",                         \
@"0214":@"情人节",                                     \
@"0215":@"中国12亿人口日",                         \
@"0219":@"邓小平逝世纪念日",                         \
@"0221":@"国际母语日 反对殖民制度斗争日",                             \
@"0222":@"苗族芦笙节",                         \
@"0224":@"第三世界青年日",                         \
@"0228":@"世界居住条件调查日",                         \
@"0301":@"国际海豹日",                                 \
@"0303":@"全国爱耳日",                                     \
@"0305":@"学雷锋纪念日 中国青年志愿者服务日",                         \
@"0308":@"妇女节",                                         \
@"0309":@"保护母亲河日",                         \
@"0311":@"国际尊严尊敬日",                         \
@"0312":@"植树节",                              \
@"0314":@"国际警察日 白色情人节",                         \
@"0315":@"消费者权益日",                         \
@"0316":@"手拉手情系贫困小伙伴全国统一行动日",                         \
@"0317":@"中国国医节 国际航海日 爱尔兰圣帕特里克节",                         \
@"0318":@"全国科技人才活动日",                         \
@"0321":@"世界森林日 消除种族歧视国际日 世界儿歌日 世界睡眠日",                         \
@"0322":@"世界水日",                         \
@"0323":@"世界气象日",                         \
@"0324":@"世界防治结核病日",                         \
@"0325":@"全国中小学生安全教育日",                         \
@"0329":@"中国黄花岗七十二烈士殉难纪念",                         \
@"0330":@"巴勒斯坦国土日",                         \
@"0401":@"愚人节 全国爱国卫生运动月 税收宣传月",                         \
@"0402":@"国际儿童图书日",                      \
@"0407":@"世界卫生日",                         \
@"0411":@"世界帕金森病日",                         \
@"0421":@"全国企业家活动日",                         \
@"0422":@"世界地球日 世界法律日",                         \
@"0423":@"世界图书和版权日",                         \
@"0424":@"亚非新闻工作者日 世界青年反对殖民主义日",                         \
@"0425":@"全国预防接种宣传日",                         \
@"0426":@"世界知识产权日",                         \
@"0430":@"世界交通安全反思日",                         \
@"0501":@"国际劳动节",                         \
@"0503":@"世界哮喘日 世界新闻自由日",                         \
@"0504":@"中国五四青年节 科技传播日",                         \
@"0505":@"碘缺乏病防治日 日本男孩节",                         \
@"0508":@"世界红十字日",                         \
@"0512":@"国际护士节",                         \
@"0515":@"国际家庭日",                         \
@"0517":@"国际电信日",                         \
@"0518":@"国际博物馆日",                         \
@"0520":@"全国学生营养日 全国母乳喂养宣传日",                         \
@"0523":@"国际牛奶日",                         \
@"0526":@"世界向人体条件挑战日",                         \
@"0530":@"中国“五卅”运动纪念日",                         \
@"0531":@"世界无烟日 英国银行休假日",                         \
@"0601":@"国际儿童节",                         \
@"0605":@"世界环境保护日",                         \
@"0614":@"世界献血者日",                         \
@"0617":@"防治荒漠化和干旱日",                         \
@"0620":@"世界难民日",                         \
@"0622":@"中国儿童慈善活动日",                         \
@"0623":@"国际奥林匹克日",                         \
@"0625":@"全国土地日",                         \
@"0626":@"国际禁毒日 国际宪章日 禁止药物滥用和非法贩运国际日 支援酷刑受害者国际日",            \
@"0630":@"世界青年联欢节",                         \
@"0701":@"建党节 香港回归纪念日 中共诞辰 世界建筑日",                         \
@"0702":@"国际体育记者日",                         \
@"0706":@"朱德逝世纪念日",                         \
@"0707":@"七七事变",                         \
@"0711":@"世界人口日 中国航海日",                         \
@"0726":@"世界语创立日",                         \
@"0728":@"第一次世界大战爆发",                         \
@"0730":@"非洲妇女日",                         \
@"0801":@"建军节",                         \
@"0805":@"恩格斯逝世纪念日",                         \
@"0806":@"国际电影节",                         \
@"0808":@"中国男子节",                         \
@"0812":@"国际青年节",                         \
@"0813":@"国际左撇子日",                         \
@"0815":@"日本投降",                         \
@"0826":@"全国律师咨询日",                         \
@"0902":@"日本签署无条件投降书日",                         \
@"0903":@"中国抗日战争胜利纪念日",                         \
@"0905":@"瑞士萨永中世纪节",                         \
@"0906":@"帕瓦罗蒂去世",                         \
@"0908":@"国际扫盲日 国际新闻工作者日",                         \
@"0909":@"毛泽东逝世纪念日",                         \
@"0910":@"中国教师节 世界预防自杀日",                         \
@"0914":@"世界清洁地球日",                         \
@"0916":@"国际臭氧层保护日 中国脑健康日",                         \
@"0918":@"九·一八事变纪念日",                         \
@"0920":@"国际爱牙日",                         \
@"0921":@"世界停火日 预防世界老年性痴呆宣传日",                         \
@"0927":@"世界旅游日",                         \
@"0928":@"孔子诞辰",                         \
@"0930":@"国际翻译日",                         \
@"1001":@"国庆节 世界音乐日 国际老人节",                         \
@"1002":@"国际和平与民主自由斗争日",                         \
@"1004":@"世界动物日",                         \
@"1005":@"国际教师节",                         \
@"1006":@"中国老年节",                         \
@"1008":@"全国高血压日 世界视觉日",                         \
@"1009":@"世界邮政日 万国邮联日",                         \
@"1010":@"辛亥革命纪念日 世界精神卫生日 世界居室卫生日",                         \
@"1013":@"世界保健日 国际教师节 中国少年先锋队诞辰日 世界保健日",                         \
@"1014":@"世界标准日",                         \
@"1015":@"国际盲人节(白手杖节)",                         \
@"1016":@"世界粮食日",                         \
@"1017":@"世界消除贫困日",                         \
@"1020":@"世界骨质疏松日",                         \
@"1022":@"世界传统医药日",                         \
@"1024":@"联合国日 世界发展新闻日",                         \
@"1028":@"世界男性健康日",                         \
@"1031":@"万圣节 世界勤俭日",                         \
@"1102":@"达摩祖师圣诞",                         \
@"1106":@"柴科夫斯基逝世悼念日",                         \
@"1107":@"十月社会主义革命纪念日",                         \
@"1108":@"中国记者日",                         \
@"1109":@"全国消防安全宣传教育日",                         \
@"1110":@"世界青年节",                         \
@"1111":@"光棍节 国际科学与和平周",                         \
@"1112":@"孙中山诞辰纪念日",                         \
@"1114":@"世界糖尿病日",                         \
@"1115":@"泰国大象节",                         \
@"1117":@"国际大学生节 世界学生节 世界戒烟日",                         \
@"1120":@"世界儿童日",                         \
@"1121":@"世界问候日 世界电视日",                         \
@"1126":@"感恩节",                                    \
@"1129":@"国际声援巴勒斯坦人民国际日",                         \
@"1201":@"世界艾滋病日",                         \
@"1202":@"废除一切形式奴役世界日",                         \
@"1203":@"世界残疾人日",                         \
@"1204":@"全国法制宣传日",                         \
@"1205":@"国际经济和社会发展志愿人员日 世界弱能人士日",                         \
@"1207":@"国际民航日",                         \
@"1208":@"国际儿童电视日",                         \
@"1209":@"世界足球日 一二·九运动纪念日",                         \
@"1210":@"世界人权日",                         \
@"1211":@"世界防止哮喘日",                         \
@"1212":@"西安事变纪念日",                         \
@"1213":@"南京大屠杀纪念日",                         \
@"1214":@"国际儿童广播电视节",                         \
@"1215":@"世界强化免疫日",                         \
@"1220":@"澳门回归纪念",                         \
@"1221":@"国际篮球日",                         \
@"1224":@"平安夜",                         \
@"1225":@"圣诞节",                         \
@"1226":@"毛泽东诞辰纪念日 节礼日",                         \
@"1229":@"国际生物多样性日"}

//数组存入阴历1900年到2100年每年中的月天数信息，
//阴历每月只能是29或30天，一年用12（或13）个二进制位表示，对应位为1表30天，否则为29天
int lunarInfo[] = {
    0x04bd8,0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,0x055d2,
    0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,0x095b0,0x14977,
    0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,0x09570,0x052f2,0x04970,
    0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,0x186e3,0x092e0,0x1c8d7,0x0c950,
    0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,
    
    0x06ca0,0x0b550,0x15355,0x04da0,0x0a5b0,0x14573,0x052b0,0x0a9a8,0x0e950,0x06aa0,
    0x0aea6,0x0ab50,0x04b60,0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,
    0x096d0,0x04dd5,0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b6a0,0x195a6,
    0x095b0,0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,
    0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x055c0,0x0ab60,0x096d5,0x092e0,
    
    0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,0x092d0,0x0cab5,
    0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,0x15176,0x052b0,0x0a930,
    0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,0x0a4e0,0x0d260,0x0ea65,0x0d530,
    0x05aa0,0x076a3,0x096d0,0x04bd7,0x04ad0,0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,
    0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0,
    
    0x04b63,0x0937f,0x049f8,0x04970,0x064b0,0x068a6,0x0ea5f,0x06b20,0x0a6c4,0x0aaef,
    0x092e0,0x0d2e3,0x0c960,0x0d557,0x0d4a0,0x0da50,0x05d55,0x056a0,0x0a6d0,0x055d4,
    0x052d0,0x0a9b8,0x0a950,0x0b4a0,0x0b6a6,0x0ad50,0x055a0,0x0aba4,0x0a5b0,0x052b0,
    0x0b273,0x06930,0x07337,0x06aa0,0x0ad50,0x04b55,0x04b6f,0x0a570,0x054e4,0x0d260,
    0x0e968,0x0d520,0x0daa0,0x06aa6,0x056df,0x04ae0,0x0a9d4,0x0a4d0,0x0d150,0x0f252,
    0x0d520};

//最小年限
#define MIN_YEAR 1900
//最大年限 取决下面万年历转化的数据
#define MAX_YEAR 2099
static int DAYS_BEFORE_MONTH[13] = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365};
unsigned int lunarToSolar[200] = {
    0x84B6BF,/*1900*/
    0x04AE53, 0x0A5748, 0x5526BD, 0x0D2650, 0x0D9544, 0x46AAB9, 0x056A4D, 0x09AD42, 0x24AEB6, 0x04AE4A,/*1901-1910*/
    0x6A4DBE, 0x0A4D52, 0x0D2546, 0x5D52BA, 0x0B544E, 0x0D6A43, 0x296D37, 0x095B4B, 0x749BC1, 0x049754,/*1911-1920*/
    0x0A4B48, 0x5B25BC, 0x06A550, 0x06D445, 0x4ADAB8, 0x02B64D, 0x095742, 0x2497B7, 0x04974A, 0x664B3E,/*1921-1930*/
    0x0D4A51, 0x0EA546, 0x56D4BA, 0x05AD4E, 0x02B644, 0x393738, 0x092E4B, 0x7C96BF, 0x0C9553, 0x0D4A48,/*1931-1940*/
    0x6DA53B, 0x0B554F, 0x056A45, 0x4AADB9, 0x025D4D, 0x092D42, 0x2C95B6, 0x0A954A, 0x7B4ABD, 0x06CA51,/*1941-1950*/
    0x0B5546, 0x555ABB, 0x04DA4E, 0x0A5B43, 0x352BB8, 0x052B4C, 0x8A953F, 0x0E9552, 0x06AA48, 0x6AD53C,/*1951-1960*/
    0x0AB54F, 0x04B645, 0x4A5739, 0x0A574D, 0x052642, 0x3E9335, 0x0D9549, 0x75AABE, 0x056A51, 0x096D46,/*1961-1970*/
    0x54AEBB, 0x04AD4F, 0x0A4D43, 0x4D26B7, 0x0D254B, 0x8D52BF, 0x0B5452, 0x0B6A47, 0x696D3C, 0x095B50,/*1971-1980*/
    0x049B45, 0x4A4BB9, 0x0A4B4D, 0xAB25C2, 0x06A554, 0x06D449, 0x6ADA3D, 0x0AB651, 0x095746, 0x5497BB,/*1981-1990*/
    0x04974F, 0x064B44, 0x36A537, 0x0EA54A, 0x86B2BF, 0x05AC53, 0x0AB647, 0x5936BC, 0x092E50, 0x0C9645,/*1991-2000*/
    0x4D4AB8, 0x0D4A4C, 0x0DA541, 0x25AAB6, 0x056A49, 0x7AADBD, 0x025D52, 0x092D47, 0x5C95BA, 0x0A954E,/*2001-2010*/
    0x0B4A43, 0x4B5537, 0x0AD54A, 0x955ABF, 0x04BA53, 0x0A5B48, 0x652BBC, 0x052B50, 0x0A9345, 0x474AB9,/*2011-2020*/
    0x06AA4C, 0x0AD541, 0x24DAB6, 0x04B64A, 0x6a573D, 0x0A4E51, 0x0D2646, 0x5E933A, 0x0D534D, 0x05AA43,/*2021-2030*/
    0x36B537, 0x096D4B, 0xB4AEBF, 0x04AD53, 0x0A4D48, 0x6D25BC, 0x0D254F, 0x0D5244, 0x5DAA38, 0x0B5A4C,/*2031-2040*/
    0x056D41, 0x24ADB6, 0x049B4A, 0x7A4BBE, 0x0A4B51, 0x0AA546, 0x5B52BA, 0x06D24E, 0x0ADA42, 0x355B37,/*2041-2050*/
    0x09374B, 0x8497C1, 0x049753, 0x064B48, 0x66A53C, 0x0EA54F, 0x06AA44, 0x4AB638, 0x0AAE4C, 0x092E42,/*2051-2060*/
    0x3C9735, 0x0C9649, 0x7D4ABD, 0x0D4A51, 0x0DA545, 0x55AABA, 0x056A4E, 0x0A6D43, 0x452EB7, 0x052D4B,/*2061-2070*/
    0x8A95BF, 0x0A9553, 0x0B4A47, 0x6B553B, 0x0AD54F, 0x055A45, 0x4A5D38, 0x0A5B4C, 0x052B42, 0x3A93B6,/*2071-2080*/
    0x069349, 0x7729BD, 0x06AA51, 0x0AD546, 0x54DABA, 0x04B64E, 0x0A5743, 0x452738, 0x0D264A, 0x8E933E,/*2081-2090*/
    0x0D5252, 0x0DAA47, 0x66B53B, 0x056D4F, 0x04AE45, 0x4A4EB9, 0x0A4D4C, 0x0D1541, 0x2D92B5          /*2091-2099*/
};

struct SolarTerm{
    __unsafe_unretained NSString *solarName;
    int solarDate;
};

struct SolarTerm solarTerm[2];

@implementation NSDate (Extension)

- (NSUInteger)getNowTimeStamp {
    return [self timeIntervalSince1970] * 1000;
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
        case PDDateFormatTypeNoSeparatorFullYear:
            return @"yyyyMMdd";
        case PDDateFormatTypeYear:
            return @"yyyy";
        case PDDateFormatTypeFullMonthWithChinese:
            return @"MM月dd日 HH:mm";
        case PDDateFormatTypeFullMonthWithDivider:
            return @"MM-dd HH:mm";
        case PDDateFormatTypeFullMonth:
            return @"MM-dd";
        case PDDateFormatTypeShortMonth:
            return @"M-d";
        case PDDateFormatTypeCompleteMonth:
            return @"MMMM";
        case PDDateFormatTypeIncompleteMonth:
            return @"MMM";
        case PDDateFormatTypeMonth:
            return @"MM";
        case PDDateFormatTypeChinaWeekDay:
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
        case PDDateFormatTypeOnlyHour:
            return @"H";
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
+ (NSString *)monthWithMonthNumber:(NSUInteger)month {
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

+ (NSDate *)timeIntervalTransformeDate:(NSUInteger)timeStamp{
    NSString *timeStampStr = [NSString stringWithFormat:@"%ld",(long)timeStamp];
    return [NSDate dateWithTimeIntervalSince1970:[timeStampStr integerValue]];
}

+ (NSString *)changeTimeStringToString:(NSString *)timeStr
                        fromFormatType:(PDDateFormatType)fromType
                          toFormatType:(PDDateFormatType)toType{
    NSDate *date = [NSDate changeTimeStringToDate:timeStr
                                       formatType:fromType];
    NSString *resultTimeString = [date pd_stringByUsingDateFormatType:toType];
    return  resultTimeString;
}

+ (NSUInteger)changeTimeStringToTimeSp:(NSString *)timeStr formatType:(PDDateFormatType)type{
    NSDate *fromdate = [NSDate changeTimeStringToDate:timeStr formatType:type];
    return [fromdate getNowTimeStamp];
}

+ (NSDate *)changeTimeStringToDate:(NSString *)timeStr formatType:(PDDateFormatType)type{
    NSDateFormatter *format = [NSDate defaultFormatDate];
    if (type == PDDateFormatTypeChinaWeekDay) {
        //自定义星期显示
        format.weekdaySymbols = WEEKARRAY;
    }
    format.dateFormat = [NSDate pd_stringFormatType:type];
    return [format dateFromString:timeStr];
}

- (NSString *)pd_stringWithFormatType:(PDDateFormatType)type{
    return [self pd_stringByUsingDateFormatType:type];
}

+ (NSString *)pd_stringWithValue:(id)time formatType:(PDDateFormatType)type{
    if (!time) {
        return @"";
    }
    if ([time isKindOfClass:[NSDate class]]) {
        return [time pd_stringByUsingDateFormatType:type];
    }else if([time isKindOfClass:[NSNumber class]]){
        NSDate *confromTimesp = [NSDate timeIntervalToDate:time];
        NSString *relustString = [confromTimesp pd_stringByUsingDateFormatType:type];
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
    NSDate *sinceDate = [NSDate timeIntervalTransformeDate:tempTime];
    return sinceDate;
}

- (NSString *)pd_stringByUsingDateFormatType:(PDDateFormatType)type {
    NSDateFormatter *dateFormatter = [NSDate defaultFormatDate];
    if (type == PDDateFormatTypeChinaWeekDay) {
        //自定义星期显示
        dateFormatter.weekdaySymbols = WEEKARRAY;
    }
    dateFormatter.dateFormat = [NSDate pd_stringFormatType:type];
    return [dateFormatter stringFromDate:self];
}

- (NSUInteger)pd_daysAgo {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self toDate:[NSDate date] options:0];
#else
    NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:self toDate:[NSDate date] options:0];
#endif
    return [components day];
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
                NSUInteger minutes = deltaSeconds / D_MINUTE;
                NSUInteger remainder = (NSUInteger)deltaSeconds % D_MINUTE;
                if (remainder > 0 || minutes == 0) {
                    minutes += 1;
                }
                showTime = [sinceDate stringFromFormat:@"%%d %@minutes ago" withValue:minutes];
            }else{
                showTime = [sinceDate pd_stringByUsingDateFormatType:PDDateFormatTypeFullHour];
            }
        }else{
            NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-D_DAY];
            BOOL isYesterday = [NSDate isSameDayWithStartDate:sinceDate
                                                   resultDate:yesterday
                                                     unitFlag:PDDateFormatUnitDay];
            if (isYesterday) {
                showTime = [sinceDate pd_stringByUsingDateFormatType:PDDateFormatTypeYesterdayWithChinese];
            }else{
                showTime = [sinceDate pd_stringByUsingDateFormatType:PDDateFormatTypeFullMonthWithDivider];
            }
        }
    }else{
        showTime = [sinceDate pd_stringByUsingDateFormatType:PDDateFormatTypeDelSeconds];
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
        showTime = [sinceDate pd_stringByUsingDateFormatType:PDDateFormatTypeFullMonth];
    }else{
        showTime = [sinceDate pd_stringByUsingDateFormatType:PDDateFormatTypeFullYear];
    }
    return showTime;
}

//比较两个日期是否为同一天,同一年等
+ (BOOL)isSameDayWithStartDate:(NSDate *)startDate
                    resultDate:(NSDate *)resultDate
                      unitFlag:(PDDateFormatUnit)unit{
    NSUInteger start = [NSDate getNumberWithFromatDate:startDate
                                             unitFlag:unit];
    NSUInteger result = [NSDate getNumberWithFromatDate:resultDate
                                              unitFlag:unit];
    if (start == result) {
        return YES;
    }
    return NO;
}

//那一年，第几月，第几天等等
+ (NSUInteger)getNumberWithFromatDate:(NSDate *)fromatDate
                             unitFlag:(PDDateFormatUnit)unit{
    NSUInteger number = 0;
    NSDateComponents *components = [NSDate getComponentsWithFromatDate:fromatDate
                                                              unitFlag:unit];
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
    return (int)number;
}

+ (NSDateComponents *)getComponentsWithFromatDate:(NSDate *)fromatDate
                                         unitFlag:(PDDateFormatUnit)unit {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = 0;
    switch (unit) {
        case PDDateFormatUnitYear:
        {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
            unitFlags = NSCalendarUnitYear;
#else
            unitFlags = NSYearCalendarUnit;
#endif
        }
            break;
        case PDDateFormatUnitMonth:
        {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
            unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
#else
            unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit;
#endif
        }
            break;
        case PDDateFormatUnitDay:
        {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
            unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
#else
            unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
#endif
        }
            break;
        case PDDateFormatUnitHour:
        {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
            unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
#else
            unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit;
#endif
        }
            break;
        case PDDateFormatUnitMinutes:
        {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
            unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
#else
            unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
#endif
        }
            break;
        case PDDateFormatUnitSeconds:
        {
            //其中 NSCalendarUnitDay 得到的时间会精确到天，时间都为0 如：2017-07-21 00:00:00
            //其中 NSCalendarUnitHour 得到的时间会精确到小时，小时以后的都为0 如：2017-07-21 10:00:00
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
            unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
#else
            unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
#endif
        }
            break;
            
        default:
            break;
    }
    return [calendar components:unitFlags fromDate:fromatDate];
}

+ (NSDate *)getDateWithFromatDate:(NSDate *)fromatDate
                         unitFlag:(PDDateFormatUnit)unit state:(PDDateFormatState)state{
    NSDate *resultDate = nil;
    switch (state) {
        case PDDateFormatState_Start:
        {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [NSDate getComponentsWithFromatDate:fromatDate
                                                                      unitFlag:unit];
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
                     withValue:(NSUInteger)value{
    NSString *tempFormat = @"";
    NSString *localeCode = [BaseTools getCurrentLanguage];
    if([localeCode isEqualToString:@"ru-RU"] || [localeCode isEqualToString:@"uk"]) {
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
    return [NSString stringWithFormat:DateToolsLocalizedStrings(localeFormat), value];
}

+ (NSString *)transformTime:(CGFloat)currentSecond{
    NSString *str = nil;
    if((int)currentSecond < D_HOUR){
        int tempTime = (int)currentSecond / D_MINUTE;
        int tempTime1 = (int)currentSecond % D_MINUTE;
        str = [NSString stringWithFormat:@"%@:%@",[NSDate conversionDate:tempTime],[NSDate conversionDate:tempTime1]];
    }else{
        int tempTime = (int)currentSecond / D_MINUTE / D_MINUTE;
        int tempTime1 = (int)currentSecond % (D_HOUR);
        int tempTime2 = (int)tempTime1 / D_MINUTE;
        int tempTime3 = (int)tempTime1 % D_MINUTE;
        str = [NSString stringWithFormat:@"%@:%@:%@",[NSDate conversionDate:tempTime],[NSDate conversionDate:tempTime2],[NSDate conversionDate:tempTime3]];
    }
    return str;
}

+ (NSString *)conversionDate:(CGFloat)temp{
    NSString *str = nil;
    if (temp < 10) {
        str = [NSString stringWithFormat:@"0%d",(int)temp];
    }else{
        str = [NSString stringWithFormat:@"%d",(int)temp];
    }
    return str;
}

- (NSDate *)pd_dateByAddingUnit:(PDDateFormatUnit)formatUnit
                     numberUnit:(NSUInteger)number{
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

+ (NSUInteger)daysInYear:(NSUInteger)year {
    int i;
    //29*12
    int sum = 348;
    for (i = 0x8000; i > 0x8; i >>= 1) {
        //大月+1天
        sum += (lunarInfo[year - MIN_YEAR] & i) == 0 ? 0 : 1;
    }
    return (sum + [self leapDays:year]); //+闰月的天数
}

+ (NSUInteger)leapDays:(NSUInteger)year {
    if ([self leapMonth:year] != 0) {
        return ((lunarInfo[year - MIN_YEAR] & 0x10000) == 0 ? 29 : 30);
    } else {
        return (0);
    }
}

+ (NSUInteger)monthDaysWithYear:(NSUInteger)year month:(NSUInteger)month {
    return ((lunarInfo[year - MIN_YEAR] & (0x10000 >> month)) == 0 ? 29 : 30);
}

+ (NSUInteger)leapMonth:(NSUInteger)year {
    return (lunarInfo[year - MIN_YEAR] & 0xf);
}

+ (NSDictionary *)lunarWithTimeString:(NSString *)timeStr formatType:(PDDateFormatType)type{
    NSDate *date = [NSDate changeTimeStringToDate:timeStr formatType:type];
    return [date lunar];
}

//根据公立算农历日期
- (NSDictionary *)lunar{
    NSDate *startDate = [NSDate changeTimeStringToDate:@"1900-01-31" formatType:PDDateFormatTypeFullYear];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:startDate toDate:self options:0];
    
    NSUInteger sumdays = components.day;
    //1899-12-21是农历1899年腊月甲子日
    NSUInteger dayCyclical = (NSUInteger)((sumdays + 30) / (86400 / (3600 * 24))) + 10;
    NSUInteger tempdays = 0;
    //农历年
    NSUInteger nongLiYear;
    //计算农历年
    for (nongLiYear = MIN_YEAR; nongLiYear < 2100 && sumdays > 0; nongLiYear++){
        tempdays = [NSDate daysInYear:nongLiYear];
        sumdays -= tempdays;
    }
    if (sumdays < 0){
        sumdays += tempdays;
        nongLiYear--;
    }
    //闰哪个月
    NSUInteger leap = [NSDate leapMonth:nongLiYear];
    //是否闰月标记
    BOOL isLeap = NO;
    //农历月
    int nongLiMonth;
    //计算农历月
    for (nongLiMonth = 1; nongLiMonth < 13 && sumdays > 0; nongLiMonth++){
        //闰月
        if (leap > 0 && nongLiMonth == leap + 1 && !isLeap){
            --nongLiMonth;
            isLeap = YES;
            tempdays = [NSDate leapDays:nongLiYear];
        }else{
            tempdays = [NSDate monthDaysWithYear:nongLiYear month:nongLiMonth];
        }
        //解除闰月
        if (isLeap && nongLiMonth == leap + 1){
            isLeap = NO;
        }
        sumdays -= tempdays;
    }
    //计算农历日
    if (sumdays == 0 && leap > 0 && nongLiMonth == leap + 1){
        if (!isLeap){
            --nongLiMonth;
        }
        isLeap = !isLeap;
    }
    if (sumdays < 0){
        sumdays += tempdays;
        --nongLiMonth;
    }
    NSUInteger nongLiDay = sumdays + 1;
    
    NSString *end = [NSDate pd_stringWithValue:self formatType:PDDateFormatTypeFullYear];
    //获取阳历年月日
    NSArray *key_array = [end componentsSeparatedByString:@"-"];
    int gongLiYear = [key_array[0] intValue];
    int gongLiMonth = [key_array[1] intValue];
    int gongLiDay = [key_array[2] intValue];
    
    //年天干地支
    NSString *yearTGDZStr = [NSDate eraWithInteger:nongLiYear];
    //月天干地支
    NSDictionary *monthTGDZDic = [self getMonthTGDZ];
    //日天干地支
    NSString *dayTG = [NSDate getCyclicalTG:dayCyclical];
    NSString *dayDZ = [NSDate getCyclicalDZ:dayCyclical];
    
    //计算节气
    NSString *solarTermTitle = [NSDate computeSolarTerm:gongLiYear month:gongLiMonth day:gongLiDay];

    //    节日
    NSMutableArray *holiday;
    NSString *chinaHoliday = [NSDate getLunarHoliDay:nongLiMonth day:nongLiDay];
    if (chinaHoliday) {
        if (holiday == nil){
            holiday = [[NSMutableArray alloc] init];
        }
        [holiday addObject:chinaHoliday];
    }
    NSString *normalHoliday = [NSDate getWorldHoliday:gongLiMonth day:gongLiDay];
    if (normalHoliday) {
        if (holiday == nil){
            holiday = [[NSMutableArray alloc] init];
        }
        [holiday addObject:normalHoliday];
    }
    NSString *weekHoliday = [NSDate getWeekHoliday:gongLiYear month:gongLiMonth day:gongLiDay];
    if (weekHoliday) {
        if (holiday == nil){
            holiday = [[NSMutableArray alloc] init];
        }
        [holiday addObject:weekHoliday];
    }
    
    NSUInteger gongLiYearSumDay = [self daysInYear];
    NSUInteger nongLiYearSumDay = [NSDate daysInYear:nongLiYear];
    NSUInteger gongLiMonthDay = [self daysInMonth];
    NSUInteger nongLiMonthDay = [NSDate monthDaysWithYear:nongLiYear month:nongLiMonth];
    BOOL isLeapYear = [self isLeapYear];

    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[NSString stringWithFormat:@"%ld",(long)nongLiYear] forKey:@"year"];
    [resultDic setObject:[NSString stringWithFormat:@"%ld",(long)nongLiMonth] forKey:@"month"];
    [resultDic setObject:[NSString stringWithFormat:@"%ld",(long)nongLiDay] forKey:@"day"];
    [resultDic setObject:[NSString stringWithFormat:@"%ld",(long)gongLiYearSumDay] forKey:@"gongLiYearSumDay"];
    [resultDic setObject:[NSString stringWithFormat:@"%ld",(long)nongLiYearSumDay] forKey:@"nongLiYearSumDay"];
    [resultDic setObject:[NSString stringWithFormat:@"%ld",(long)gongLiMonthDay] forKey:@"gongLiMonthDay"];
    [resultDic setObject:[NSString stringWithFormat:@"%ld",(long)nongLiMonthDay] forKey:@"nongLiMonthDay"];
    if (isLeapYear) {
        [resultDic setObject:[NSString stringWithFormat:@"%d",isLeapYear] forKey:@"isLeapYear"];
//        当前月是否是闰月
        if (isLeap) {
            [resultDic setObject:[NSString stringWithFormat:@"%d",isLeap] forKey:@"isLeapMonth"];
            [resultDic setObject:CHINESEMONTHS1[nongLiMonth - 1] forKey:@"leapMonth"];
        }else{
            NSUInteger leapMonth = [NSDate leapMonth:nongLiYear];
//            有可能是闰年，但是没有闰月  如1988年
            if (leapMonth != 0) {
                [resultDic setObject:CHINESEMONTHS1[leapMonth - 1] forKey:@"leapMonth"];
            }
        }
        NSUInteger leapMonthSumDay = [NSDate leapDays:nongLiYear];
        [resultDic setObject:[NSString stringWithFormat:@"%ld",(long)leapMonthSumDay] forKey:@"leapMonthSumDay"];
    }
    [resultDic setObject:solarTermTitle forKey:@"jq"];
    [resultDic setObject:[yearTGDZStr substringToIndex:1] forKey:@"yearTG"];
    [resultDic setObject:[yearTGDZStr substringFromIndex:1] forKey:@"yearDZ"];
    [resultDic setObject:yearTGDZStr forKey:@"yearTGDZ"];
    [resultDic setObject:[monthTGDZDic objectForKey:@"tg"] forKey:@"monthTG"];
    [resultDic setObject:[monthTGDZDic objectForKey:@"dz"] forKey:@"monthDZ"];
    [resultDic setObject:[monthTGDZDic objectForKey:@"tgdz"] forKey:@"monthTGDZ"];
    [resultDic setObject:dayTG forKey:@"dayTG"];
    [resultDic setObject:dayDZ forKey:@"dayDZ"];
    [resultDic setObject:[dayTG stringByAppendingString:dayDZ] forKey:@"dayTGDZ"];
    if (holiday) {
        [resultDic setObject:holiday forKey:@"holiday"];
    }
    return resultDic.copy;
}

+ (NSString *)lunarToSolarYear:(int)year month:(int)month day:(int)day isLeap:(BOOL)isLeap{
    int dayOffset;
    int leapMonth;
    int i;
    
    if (year < MIN_YEAR || year > MAX_YEAR ||
        month < 1 || month > 12 ||
        day < 1 || day > 30) {
        return @"";
    }
    
    dayOffset = (lunarToSolar[year - MIN_YEAR] & 0x001F) - 1;
    
    if (((lunarToSolar[year - MIN_YEAR] & 0x0060) >> 5) == 2){
        dayOffset += 31;
    }
    
    for (i = 1; i < month; i++) {
        if ((lunarToSolar[year - MIN_YEAR] & (0x80000 >> (i - 1))) == 0){
            dayOffset += 29;
        }else{
            dayOffset += 30;
        }
    }
    
    dayOffset += day;
    leapMonth = (lunarToSolar[year - MIN_YEAR] & 0xf00000) >> 20;
    
    // 这一年有闰月
    if (leapMonth != 0) {
        if (month > leapMonth || (month == leapMonth && isLeap)) {
            if ((lunarToSolar[year - MIN_YEAR] & (0x80000 >> (month - 1))) == 0){
                dayOffset += 29;
            }else{
                dayOffset += 30;
            }
        }
    }
    
    if (dayOffset > 366 || (year % 4 != 0 && dayOffset > 365)) {
        year += 1;
        if (year % 4 == 1){
            dayOffset -= 366;
        }else{
            dayOffset -= 365;
        }
    }
    
    int solarInfo[3];
    for (i = 1; i < 13; i++) {
        int iPos = DAYS_BEFORE_MONTH[i];
        if (year % 4 == 0 && i > 2) {
            iPos += 1;
        }
        
        if (year % 4 == 0 && i == 2 && iPos + 1 == dayOffset) {
            solarInfo[1] = i;
            solarInfo[2] = dayOffset - 31;
            break;
        }
        
        if (iPos >= dayOffset) {
            solarInfo[1] = i;
            iPos = DAYS_BEFORE_MONTH[i - 1];
            if (year % 4 == 0 && i > 2) {
                iPos += 1;
            }
            if (dayOffset > iPos){
                solarInfo[2] = dayOffset - iPos;
            }else if (dayOffset == iPos) {
                if (year % 4 == 0 && i == 2){
                    solarInfo[2] = DAYS_BEFORE_MONTH[i] - DAYS_BEFORE_MONTH[i - 1] + 1;
                }else{
                    solarInfo[2] = DAYS_BEFORE_MONTH[i] - DAYS_BEFORE_MONTH[i - 1];
                }
            } else
                solarInfo[2] = dayOffset;
            break;
        }
    }
    solarInfo[0] = year;
    int resultYear = year;
    int resultMonth = solarInfo[1];
    int resultDay = solarInfo[2];
    return [NSString stringWithFormat:@"%d-%02d-%02d", resultYear, resultMonth, resultDay];
}

+ (NSString *)computeSolarTerm:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day{
    for (NSUInteger n = month * 2 - 1; n <= month * 2; n++){
        double Termdays = [self term:year index:n pd:YES];
        double mdays = [self antiDayDifference:year other:floor(Termdays)];
        //double sm1 = floor(mdays / 100);
        int hour = (int)floor((double)(Termdays - floor(Termdays)) * 24);
        int minute = (int)floor((double)(((Termdays - floor(Termdays)) * 24 - hour) * 60));
        int tMonth = (int)ceil((double)n / 2);
        int tday = (int)mdays % 100;
        
        if (n >= 3){
            solarTerm[n - month * 2 + 1].solarName = [SolarTerms objectAtIndex:(n - 3)];
        }else{
            solarTerm[n - month * 2 + 1].solarName = [SolarTerms objectAtIndex:(n + 21)];
        }
        
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setYear:year];
        [components setMonth:tMonth];
        [components setDay:tday];
        [components setHour:hour];
        [components setMinute:minute];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *ldate = [gregorian dateFromComponents:components];
        
        NSString *tempStr = [NSDate pd_stringWithValue:ldate formatType:PDDateFormatTypeNoSeparatorFullYear];
        
        solarTerm[n - month * 2 + 1].solarDate = [tempStr intValue];
    }
    //24节气
    NSString *solarTermTitle = @"";
    NSUInteger number = year * 10000 + month * 100 + day;
    for (NSUInteger index = 0; index < 2; index++){
        if (solarTerm[index].solarDate == number){
            solarTermTitle = solarTerm[index].solarName;
        }
    }
    return solarTermTitle;
}

+ (double)antiDayDifference:(NSUInteger)year other:(double)other{
    NSUInteger m = 1;
    for (NSUInteger j = 1; j <= 12; j++){
        NSUInteger tem1 = [self dayDifference:year month:(j + 1) day:1];
        NSUInteger tem2 = [self dayDifference:year month:j day:1];
        NSUInteger mL = tem1 - tem2;
        if (other <= mL || j == 12){
            m = j;
            break;
        }else{
            other -= mL;
        }
    }
    return 100 * m + other;
}

+ (double)term:(NSUInteger)year index:(NSUInteger)n pd:(bool)pd{
    //儒略日
    NSUInteger tempYear = year - 100;
    double juD = year * (365.2423112 - 6.4e-14 * tempYear * tempYear - 3.047e-8 * tempYear) + 15.218427 * n + 1721050.71301;
    //角度
    double tht = 3e-4 * year - 0.372781384 - 0.2617913325 * n;
    //年差实均数
    double yrD = (1.945 * sin(tht) - 0.01206 * sin(2 * tht)) * (1.048994 - 2.583e-5 * year);
    //朔差实均数
    double shuoD = -18e-4 * sin(2.313908653 * year - 0.439822951 - 3.0443 * n);
    double temp = juD - [self equivalentStandardDay:year month:1 day:0] - 1721425;
    return (pd) ? (yrD + shuoD + temp) : temp;
}

+ (NSString *)getWeekDay:(NSUInteger)aYear month:(NSUInteger)aMonth week:(NSUInteger)aWeek dayInWeek:(NSUInteger)aDay{
    NSString *dateStr = [NSString stringWithFormat:@"%ld 1 %ld +0000",aMonth,aYear];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"M d yyyy zzzz"];
    NSDate *date = [formater dateFromString:dateStr];
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:date];
    NSUInteger firstWeek = components.weekday - 1;
    NSUInteger result = 0;
    aDay = aDay + 1;
    if(aWeek < 5)    {
        result = (firstWeek > aDay ? 7 : 0) + 7 * (aWeek - 1) + aDay - firstWeek;
    }
    if(result == 0){
        return nil;
    }else{
        return [NSString stringWithFormat:@"%ld",result];
    }
}

+ (double)equivalentStandardDay:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day{
    //Julian的等效标准天数
    NSUInteger tempYear = year - 1;
    double v = tempYear * 365 + floor((double)(tempYear / 4)) + [self dayDifference:year month:month day:day] - 2;
    //Gregorian的等效标准天数
    if (year > 1582){
        v += -floor((double)(tempYear / 100)) + floor((double)(tempYear / 400)) + 2;
    }
    return v;
}

+ (NSUInteger)dayDifference:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day{
    NSUInteger ifG = [self ifGregorian:year month:month day:day opt:1];
    //NSArray *monL = [NSArray arrayWithObjects:, nil];
    NSUInteger monL[] = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    if (ifG == 1){
        if ([self isLeapYear:year]){
            monL[2] += 1;
        }else{
            if (year % 4 == 0){
                monL[2] += 1;
            }
        }
    }
    int v = 0;
    for (int i = 0; i <= month - 1; i++){
        v += monL[i];
    }
    v += day;
    if (year == 1582){
        if (ifG == 1){
            v -= 10;
        }
        if (ifG == -1){
            //infinity
            v = 0;
        }
    }
    return v;
}

+ (NSUInteger)ifGregorian:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day opt:(NSUInteger)opt{
    if (opt == 1){
        if (year > 1582 || (year == 1582 && month > 10) || (year == 1582 && month == 10 && day > 14)){
            //Gregorian
            return 1;
        } else{
            if (year == 1582 && month == 10 && day >= 5 && day <= 14){
                //空
                return -1;
            }else{
                //Julian
                return 0;
            }
        }
    }else if (opt == 2){
        //Gregorian
        return 1;
    }else if (opt == 3){
        //Julian
        return 0;
    }
    return -1;
}

+ (NSUInteger)daysInYear:(NSString *)timeStr formatType:(PDDateFormatType)type{
    NSDate *date = [NSDate changeTimeStringToDate:timeStr formatType:type];
    return [date daysInYear];
}

- (NSUInteger)daysInYear {
    return [self isLeapYear] ? 366 : 365;
}

- (BOOL)isLeapYear{
    NSUInteger year = [[self pd_stringByUsingDateFormatType:PDDateFormatTypeYear] integerValue];
    return [NSDate isLeapYear:year];
}

+ (BOOL)isLeapYear:(NSUInteger)year{
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

+ (NSUInteger)daysInMonth:(NSString *)timeStr formatType:(PDDateFormatType)type{
    NSDate *date = [NSDate changeTimeStringToDate:timeStr formatType:type];
    return [date daysInMonth];
}

- (NSUInteger)daysInMonth:(NSUInteger)month {
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            return 31;
        case 2:
            return [self isLeapYear] ? 29 : 28;
    }
    return 30;
}

- (NSUInteger)daysInMonth {
    NSUInteger mouth = [[self pd_stringByUsingDateFormatType:PDDateFormatTypeMonth] integerValue];
    return [self daysInMonth:mouth];
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

- (NSUInteger)weekOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [[calendar components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSUInteger)nthWeekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:hld_Components fromDate:self];
    return components.weekdayOrdinal;
}

+ (NSString *)dateToConstellationWithTimeStr:(NSString *)timeStr formatType:(PDDateFormatType)type{
    NSDate *date = [NSDate changeTimeStringToDate:timeStr formatType:type];
    return [date dateToConstellation];
}

- (NSString *)dateToConstellation{
    NSUInteger month = [NSDate getNumberWithFromatDate:self
                                             unitFlag:PDDateFormatUnitMonth];
    NSUInteger day = [NSDate getNumberWithFromatDate:self
                                           unitFlag:PDDateFormatUnitDay];
    if (day == NSNotFound || month == NSNotFound) {
        return @"";
    }
    NSString *constellation = nil;
    switch (month) {
        case 1:
        {
            if (day < 20) {
                constellation = CONSTELLATIONS.lastObject;
            }
        }
            break;
        case 2:
        {
            if (day < 19) {
                constellation = CONSTELLATIONS.firstObject;
            }
        }
            break;
        case 3:
        case 5:
        {
            if (day < 21) {
                constellation = CONSTELLATIONS[month - 2];
            }
        }
            break;
        case 4:
        {
            if (day < 20) {
                constellation = CONSTELLATIONS[2];
            }
        }
            break;
        case 6:
        case 12:
        {
            if (day < 22) {
                constellation = CONSTELLATIONS[month - 2];
            }
        }
            break;
        case 7:
        case 8:
        case 9:
        case 11:
        {
            if (day < 23) {
                constellation = CONSTELLATIONS[month - 2];
            }
        }
            break;
        case 10:
        {
            if (day < 24) {
                constellation = CONSTELLATIONS[8];
            }
        }
            break;
            
        default:
            break;
    }
    if (constellation == nil) {
        constellation = CONSTELLATIONS[month - 1];
    }
    return constellation;
}

+ (NSString *)birthdayToAgeWithTimeStr:(NSString *)timeStr formatType:(PDDateFormatType)type{
    NSDate *date = [NSDate changeTimeStringToDate:timeStr formatType:type];
    return [date birthdayToAge];
}

- (NSString *)birthdayToAge{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self toDate:[NSDate date] options:0];
    
    if ([components year] > 0) {
        return [NSString stringWithFormat:@"%ld岁",(long)[components year]];
    }else if([components month] > 0) {
        return [NSString stringWithFormat:@"%ld个月%ld天",(long)[components month],(long)[components day]];
    }else if([components day] > 0){
        return [NSString stringWithFormat:@"%ld天%ld小时",(long)[components day],(long)[components hour]];
    }else if([components hour] > 0){
        return [NSString stringWithFormat:@"%ld小时%ld分%ld秒",(long)[components hour],(long)[components minute],(long)[components second]];
    }else if([components minute] > 0){
        return [NSString stringWithFormat:@"%ld分%ld秒",(long)[components minute],(long)[components second]];
    }else{
        return [NSString stringWithFormat:@"%ld秒",(long)[components second]];
    }
}

+ (NSString *)cDay:(NSUInteger)day {
    NSString *result;
    switch (day) {
        case 10:
            result = @"初十";
            break;
        case 20:
            result = @"二十";
            break;
        case 30:
            result = @"三十";
            break;
        default:
        {
            //取商
            NSString *temp1 = CHINESEDAYS1[(NSUInteger)(day / 10)];
            //取余
            NSString *temp2 = CHINESEDAYS2[day % 10];
            result = [NSString stringWithFormat:@"%@%@",temp1,temp2];
        }
    }
    return result;
}

+ (NSArray *)getKnownTimeZoneNames{
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

- (NSString *)zodiac{
    NSDateComponents *components = [self getNongLi];
    return [NSDate zodiacWithInter:components.year];
}

+ (NSString *)zodiacWithInter:(NSUInteger)year{
    NSUInteger zodiacIndex = (year - 4) % ZODIACS.count;
    return [ZODIACS objectAtIndex:zodiacIndex];
}

- (NSString *)getLunarHoliDay{
    NSDateComponents *localeComp = [self getNongLi];
    NSUInteger month = localeComp.month;
    NSUInteger day = localeComp.day;
    return [NSDate getLunarHoliDay:month day:day];
}

+ (NSString *)getLunarHoliDay:(NSUInteger)month day:(NSUInteger)day{
    NSString *key_str = [NSString stringWithFormat:@"%ld-%ld",(long)month,(long)day];
    return [CHINAHOLIDAY objectForKey:key_str];
}

//年柱
+ (NSDictionary *)getYearTGDZ:(NSString *)timeStr formatType:(PDDateFormatType)type{
    NSDate *date = [NSDate changeTimeStringToDate:timeStr formatType:type];
    return [date getYearTGDZ];
}

- (NSDictionary *)getYearTGDZ{
    NSString *year = [self pd_stringWithFormatType:PDDateFormatTypeYear];
    //1864年是甲子年，每隔六十年一个甲子
    NSUInteger idx = ([year intValue] - 1864) % 60;
    NSString *y = CHINESEYEARS[idx];
    NSString *y_tg = [y substringToIndex:1];
    NSString *y_dz = [y substringFromIndex:1];
    NSDictionary *yearDic = @{
        @"tgdz":y, //年柱
        @"tg":y_tg, //年地支
        @"dz":y_dz //年地支
    };
    return yearDic.copy;
}

+ (NSString *)eraWithInteger:(NSUInteger)year{
    NSUInteger index = (year - 4) % 60;
    NSString *TG = [NSDate getCyclicalTG:index];
    NSString *DZ = [NSDate getCyclicalDZ:index];
    return [NSString stringWithFormat:@"%@%@",TG,DZ];
}

- (NSDictionary *)getMonthTGDZ{
    NSString *timeStr = [NSDate pd_stringWithValue:self formatType:PDDateFormatTypeFullYear];
    return [NSDate getMonthTGDZ:timeStr];
}

+ (NSDictionary *)getMonthTGDZ:(NSString *)timeStr formatType:(PDDateFormatType)type{
    NSString *str = [NSDate changeTimeStringToString:timeStr fromFormatType:type toFormatType:PDDateFormatTypeFullYear];
    return [NSDate getMonthTGDZ:str];
}

+ (NSDictionary *)getMonthTGDZ:(NSString *)timeStr{
    NSArray *timeArray = [timeStr componentsSeparatedByString:@"-"];
    //月天干地支
    NSUInteger tempTag = (([timeArray[0] intValue] - MIN_YEAR) * 12 + [timeArray[1] intValue] + 13);
    NSUInteger tag = tempTag % HEAVENLYSTEMS.count;
    NSString *monthTG = [HEAVENLYSTEMS objectAtIndex:(tag == 0 ? HEAVENLYSTEMS.count : tag) - 1];
    NSUInteger tag1 = tempTag % EARTHLYBRANCHES.count;
    NSString *monthDZ = [EARTHLYBRANCHES objectAtIndex:(tag1 == 0 ? EARTHLYBRANCHES.count : tag1) - 1];
    NSDictionary *dayDic = @{
        @"tgdz":[monthTG stringByAppendingString:monthDZ],
        @"tg":monthTG,
        @"dz":monthDZ
    };
    return dayDic.copy;
}

/*⚠️⚠️⚠️⚠️⚠️⚠️注意！  这个不准可以用+ (NSDictionary *)lunarWithTimeString:(NSString *)timeStr formatType:(PDDateFormatType)type方法⚠️⚠️⚠️⚠️⚠️⚠️*/
//月柱
//甲己之年丙作首，乙庚之岁戊为头；
//丙辛必定寻庚起，丁壬壬位顺行流；
//更有戊癸何方觅，甲寅之上好追求。
- (NSDictionary *)getMonthTGDZStr{
    NSDictionary *date_month = @{
        @"甲、己" : @[@"丙寅" , @"丁卯" , @"戊辰" , @"己巳" , @"庚午" , @"辛未" , @"壬申" , @"癸酉" , @"甲戌" , @"乙亥" , @"丙子" , @"丁丑" ],
        @"乙、庚" : @[@"戊寅" , @"己卯" , @"庚辰" , @"辛巳" , @"壬午" , @"癸未" , @"甲申" , @"乙酉" , @"丙戌" , @"丁亥" , @"戊子" , @"己丑" ],
        @"丙、辛" : @[@"庚寅" , @"辛卯" , @"壬辰" , @"癸巳" , @"甲午" , @"乙未" , @"丙申" , @"丁酉" , @"戊戌" , @"己亥" , @"庚子" , @"辛丑" ],
        @"丁、壬" : @[@"壬寅" , @"癸卯" , @"甲辰" , @"乙巳" , @"丙午" , @"丁未" , @"戊申" , @"己酉" , @"庚戌" , @"辛亥" , @"壬子" , @"癸丑" ],
        @"戊、癸" : @[@"甲寅" , @"乙卯" , @"丙辰" , @"丁巳" , @"戊午" , @"己未" , @"庚申" , @"辛酉" , @"壬戌" , @"癸亥" , @"甲子" , @"乙丑" ]
    };
    NSDictionary *yearDic = [self getYearTGDZ];
    NSString *y_tg = [yearDic objectForKey:@"tg"];
    NSArray * month_arry = [NSArray array];
    if ([@"甲、己" containsString: y_tg]) {
        month_arry = date_month[@"甲、己"];
    }else if ([@"乙、庚" containsString:y_tg]){
        month_arry = date_month[@"乙、庚"];
    }else if ([@"丙、辛" containsString: y_tg]){
        month_arry = date_month[@"丙、辛"];
    }else if ([@"丁、壬" containsString: y_tg]){
        month_arry = date_month[@"丁、壬"];
    }else if ([@"戊、癸" containsString: y_tg]){
        month_arry = date_month[@"戊、癸"];
    }
    NSDateComponents *NongLiCom = [[NSDate date] getNongLi];
    //    计算节气月的起始天
    int index = [self solaComput:NongLiCom.month] - 1;
    
    index = index < 0 ? 11 : index;
    NSString *m = month_arry[index];
    NSString *m_tg = [m substringToIndex:1];
    NSString *m_dz = [m substringFromIndex:1];
    
    NSDictionary *monDic = @{
        @"tgdz":m,
        @"tg":m_tg,
        @"dz":m_dz
    };
    return monDic.copy;
}

//日柱
+ (NSDictionary *)getDayTGDZ:(NSString *)timeStr formatType:(PDDateFormatType)type{
    NSDate *date = [NSDate changeTimeStringToDate:timeStr formatType:type];
    return [date getDayTGDZ];
}

- (NSDictionary *)getDayTGDZ{
    NSDateComponents *datecom = [NSDate getComponentsWithFromatDate:self unitFlag:PDDateFormatUnitMinutes];
    //日
    //  G = 4C + [C / 4] + 5y + [y / 4] + [3 * (M + 1) / 5] + d - 3
    //  Z = 8C + [C / 4] + 5y + [y / 4] + [3 * (M + 1) / 5] + d + 7 + I
    //  其中 C 是世纪数减一，y 是年份后两位，M 是月份，d 是日数。1月和2月按上一年的13月和14月来算。奇数月i=0，偶数月i=6。G 除以10的余数是天干，Z 除以12的余数是地支
    int C_num = (int)datecom.year / 100;
    int Y_num =  datecom.year  %  100;
    int M_num;
    if (datecom.month == 1) {
        M_num = 13;
        Y_num -= 1;
    }else if(datecom.month == 2){
        M_num = 14;
        Y_num -= 1;
    }else{
        M_num = (int)datecom.month;
    }
    int js = (datecom.month % 2) ? 0 : 6;
    int G = 4 * C_num + (C_num / 4) + 5 * Y_num + (Y_num / 4) + (3 * (M_num + 1) / 5) + (int)datecom.day - 3 -1;
    int Z = 8 * C_num + (C_num / 4) + 5 * Y_num + (Y_num/ 4) + (3 * (M_num + 1) / 5) + (int)datecom.day + 7 + js - 1;
    
    NSString *d_tg = [NSDate getCyclicalTG:G];
    NSString *d_dz = [NSDate getCyclicalDZ:Z];
    NSString *d = [d_tg stringByAppendingString:d_dz];
    NSDictionary *dayDic = @{
        @"tgdz":d,
        @"tg":d_tg,
        @"dz":d_dz
    };
    return dayDic.copy;
}

+ (NSDictionary *)hourTGDZ:(NSString *)timeStr formatType:(PDDateFormatType)type{
    NSDate *date = [NSDate changeTimeStringToDate:timeStr formatType:type];
    return [date hourTGDZ];
}

- (NSDictionary *)hourTGDZ{
    int hour = [[NSDate pd_stringWithValue:self formatType:PDDateFormatTypeOnlyHour] intValue];
    int h_inx = (hour + 1) / 2;
    h_inx = h_inx > 11 ? 0 : h_inx;
    NSString *h_dz = EARTHLYBRANCHES[h_inx];
    //日天干
    NSDictionary *dayDic = [self getDayTGDZ];
    NSString *d_tg = dayDic[@"tg"];
    
    NSString *h_tg = @"";
    if ([@"甲己" containsString:d_tg]) {
        h_tg = [NSDate getCyclicalTG:h_inx];
    }else if([@"乙庚"containsString:d_tg]){
        h_tg = [NSDate getCyclicalTG:(h_inx + 2)];
    }else if([@"丙辛"containsString:d_tg]){
        h_tg = [NSDate getCyclicalTG:(h_inx + 4)];
    }else if([@"丁壬"containsString:d_tg]){
        h_tg = [NSDate getCyclicalTG:(h_inx + 6)];
    }else if([@"戊癸"containsString:d_tg]){
        h_tg = [NSDate getCyclicalTG:(h_inx + 8)];
    }
    NSString *h = [h_tg stringByAppendingString:h_dz];
    NSDictionary *hourDic = @{
        @"tgdz":h,
        @"tg":h_tg,
        @"dz":h_dz,
        @"hour":[NSString stringWithFormat:@"%d",hour]
    };
    return hourDic.copy;
}

//    计算节气
- (int)solaComput:(NSUInteger)month{
    /**
     通式寿星公式：[Y×D+C]-L
     [  ]里面取整数；
     Y：年数的后2位数；
     D：0.2422；
     L：Y/4，小寒、大寒、立春、雨水的L：(Y-1)/4
     */
    NSDateComponents *GongLiCom = [NSDate getComponentsWithFromatDate:[NSDate date] unitFlag:PDDateFormatUnitMinutes];
    int year_num = GongLiCom.year % 100;
    
    BOOL C = ((int)(GongLiCom.year / 100) == 19);
    int newMonth = (int)month;
    int aa;
    switch (month) {
        case 1:{//小寒
            aa = (int)(year_num * 0.2422 + (C ? 6.11 : 5.4055) - (year_num - 1) / 4);
            if(GongLiCom.year == 2019) {
                aa -= 1;
            }else if (GongLiCom.year == 1918){
                aa += 1;
            }
            if (month < aa) {
                newMonth = 0;
            }
            NSLog(@"\n----小寒： 1月%d", aa);
        }
            break;
        case 2:{//立春
            aa = (int)(year_num * 0.2422 + (C ? 4.15 : 3.87) - (year_num - 1) / 4);
            if (month < aa) {
                newMonth = 1;
            }
            NSLog(@"\n----立春： 2月%d", aa);
        }
            break;
        case 3:{//惊蛰
            aa = (int)(year_num * 0.2422 + 5.63 - (year_num) / 4);
            if (month < aa) {
                newMonth = 2;
            }
            NSLog(@"\n----惊蛰： 3月%d", aa);
        }
            break;
        case 4:{//清明
            aa = (int)(year_num * 0.2422 + (C ? 5.59 : 4.81) - (year_num) / 4);
            if (GongLiCom.year == 1911) {
                aa += 1;
            }
            if (month < aa) {
                newMonth = 3;
            }
            NSLog(@"\n----清明： 4月%d", aa);
        }
            break;
        case 5:{//立夏
            aa = (int)(year_num * 0.2422 + (C ? 6.318 : 5.52) - (year_num) / 4);
            if (month < aa) {
                newMonth = 4;
            }
            NSLog(@"\n----立夏： 5月%d", aa);
        }
            break;
        case 6:{//芒种
            aa = (int)(year_num * 0.2422 + (C ? 6.5 : 5.678) - (year_num) / 4);
            if (GongLiCom.year == 1902) {
                aa += 1;
            }
            if (month < aa) {
                newMonth = 5;
            }
            NSLog(@"\n----芒种： 6月%d", aa);
        }
            break;
        case 7:{//小暑
            aa = (int)(year_num * 0.2422 + (C ? 7.928 : 7.108) - (year_num) / 4);
            if (GongLiCom.year == 1925 || GongLiCom.year == 2016) {
                aa += 1;
            }
            if (month < aa) {
                newMonth = 6;
            }
            NSLog(@"\n----小暑： 7月%d",aa);
        }
            break;
        case 8:{//立秋
            aa = (int)(year_num * 0.2422 + (C ? 8.44 : 7.5) - (year_num) / 4);
            if (GongLiCom.year == 2002) {
                aa += 1;
            }
            if (month < aa) {
                newMonth = 7;
            }
            NSLog(@"\n----立秋： 8月%d", aa);
        }
            break;
        case 9:{//白露
            aa = (int)(year_num * 0.2422 + (C ? 8.44 : 7.646) - (year_num) / 4);
            if (GongLiCom.year == 1927) {
                aa += 1;
            }
            if (month < aa) {
                newMonth = 8;
            }
            NSLog(@"\n----白露： 9月%d", aa);
        }
            break;
        case 10:{//寒露
            aa = (int)(year_num * 0.2422 + (C ? 9.098 : 8.318) - (year_num) / 4);
            if (month < aa) {
                newMonth = 9;
            }
            NSLog(@"\n----寒露： 10月%d", aa);
        }
            break;
        case 11:{//立冬
            aa = (int)(year_num * 0.2422 + (C ? 8.218 : 7.438) - (year_num) / 4);
            if (GongLiCom.year == 2089) {
                aa += 1;
            }
            if (month < aa) {
                newMonth = 10;
            }
            NSLog(@"\n----立冬： 11月%d", aa);
        }
            break;
        case 12:{//大雪
            aa = (int)(year_num * 0.2422 + (C ? 7.9 : 7.18) - (year_num) / 4);
            if (GongLiCom.year == 1954) {
                aa += 1;
            }
            if (month < aa) {
                newMonth = 11;
            }
            NSLog(@"\n----大雪： 12月%d", aa);
        }
            break;
            
        default:
            aa = 0;
            break;
    }
    return aa;
}

//    天干
+ (NSString *)getCyclicalTG:(NSUInteger)number{
    NSUInteger heavenlyStemIndex = number % HEAVENLYSTEMS.count;
    return [HEAVENLYSTEMS objectAtIndex:heavenlyStemIndex];
}

//    地支
+ (NSString *)getCyclicalDZ:(NSUInteger)number{
    NSUInteger earthlyBrancheIndex = number % EARTHLYBRANCHES.count;
    return [EARTHLYBRANCHES objectAtIndex:earthlyBrancheIndex];
}

+ (NSDateComponents *)getNongLiWithTimeStr:(NSString *)timeStr formatType:(PDDateFormatType)type{
    NSDate *date = [NSDate changeTimeStringToDate:timeStr formatType:type];
    return [date getNongLi];
}

//NongLiCom.year = 甲子数【1-60】
- (NSDateComponents *)getNongLi{
    //    农历时间dateCom
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *NongLiCom = [localeCalendar components:unitFlags fromDate:self];
    NSLog(@"甲子数:%@",NongLiCom);
    return NongLiCom;
}

- (NSUInteger)firstWeekdayInThisMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //设置每周的第一天从周几开始,默认为1,从周日开始
    //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    [calendar setFirstWeekday:1];
    NSDateComponents *comp = [NSDate getComponentsWithFromatDate:self unitFlag:PDDateFormatUnitDay];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday
                                                  inUnit:NSCalendarUnitWeekOfMonth
                                                 forDate:firstDayOfMonthDate];
    //若设置从周日开始算起则需要减一,若从周一开始算起则不需要减
    return firstWeekday - 1;
}

+ (NSString *)getWorldHoliday:(NSUInteger)aMonth day:(NSUInteger)aDay{
    NSString *monthDay;
    if(aMonth < 10 && aDay < 10){
        monthDay = [NSString stringWithFormat:@"0%ld0%ld",(long)aMonth,(long)aDay];
    }else if(aMonth < 10 && aDay > 9){
        monthDay = [NSString stringWithFormat:@"0%ld%ld",(long)aMonth,aDay];
    }else if(aMonth > 9 && aDay < 10){
        monthDay = [NSString stringWithFormat:@"%ld0%ld",(long)aMonth,(long)aDay];
    }else{
        monthDay = [NSString stringWithFormat:@"%ld%ld",(long)aMonth,(long)aDay];
    }
    return [WORLDHOLIDAY objectForKey:monthDay];
}

+ (NSString *)getWeekHoliday:(int)aYear month:(int)aMonth day:(int)aDay{
    NSString *result = nil;
    for (id key in [WEEKHOLIDAY allKeys]) {
        NSString *dictMonth = [key substringToIndex:2];
        int dictWeek = [[[key substringFromIndex:2] substringToIndex:1] intValue];
        int dictDayInWeek = [[[key substringFromIndex:3] substringToIndex:1] intValue];
        if(aMonth == [dictMonth intValue]){
            NSString *resultDay = [self getWeekDay:aYear month:aMonth week:dictWeek dayInWeek:dictDayInWeek];
            if(resultDay){
                if([resultDay intValue] == aDay){
                    result = [WEEKHOLIDAY objectForKey:key];
                }
            }
        }
    }
    return result;
}

@end

