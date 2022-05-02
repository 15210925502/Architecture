/**
 *  正则表达式简单说明
 *  语法：
 .       匹配除换行符以外的任意字符
 \w      匹配字母或数字或下划线或汉字
 \s      匹配任意的空白符
 \d      匹配数字
 \b      匹配单词的开始或结束
 ^       匹配字符串的开始
 $       匹配字符串的结束
 *       重复零次或更多次
 +       重复一次或更多次
 ?       重复零次或一次
 {n}     重复n次
 {n,}     重复n次或更多次
 {n,m}     重复n到m次
 \W      匹配任意不是字母，数字，下划线，汉字的字符
 \S      匹配任意不是空白符的字符
 \D      匹配任意非数字的字符
 \B      匹配不是单词开头或结束的位置
 [^x]     匹配除了x以外的任意字符
 [^aeiou]匹配除了aeiou这几个字母以外的任意字符
 *?      重复任意次，但尽可能少重复
 +?      重复1次或更多次，但尽可能少重复
 ??      重复0次或1次，但尽可能少重复
 {n,m}?     重复n到m次，但尽可能少重复
 {n,}?     重复n次以上，但尽可能少重复
 \a      报警字符(打印它的效果是电脑嘀一声)
 \b      通常是单词分界位置，但如果在字符类里使用代表退格
 \t      制表符，Tab
 \r      回车
 \v      竖向制表符
 \f      换页符
 \n      换行符
 \e      Escape
 \0nn     ASCII代码中八进制代码为nn的字符
 \xnn     ASCII代码中十六进制代码为nn的字符
 \unnnn     Unicode代码中十六进制代码为nnnn的字符
 \cN     ASCII控制字符。比如\cC代表Ctrl+C
 \A      字符串开头(类似^，但不受处理多行选项的影响)
 \Z      字符串结尾或行尾(不受处理多行选项的影响)
 \z      字符串结尾(类似$，但不受处理多行选项的影响)
 \G      当前搜索的开头
 \p{name}     Unicode中命名为name的字符类，例如\p{IsGreek}
 (?>exp)     贪婪子表达式
 (?<x>-<y>exp)     平衡组
 (?im-nsx:exp)     在子表达式exp中改变处理选项
 (?im-nsx)       为表达式后面的部分改变处理选项
 (?(exp)yes|no)     把exp当作零宽正向先行断言，如果在这个位置能匹配，使用yes作为此组的表达式；否则使用no
 (?(exp)yes)     同上，只是使用空表达式作为no
 (?(name)yes|no) 如果命名为name的组捕获到了内容，使用yes作为表达式；否则使用no
 (?(name)yes)     同上，只是使用空表达式作为no
 
 捕获
 (exp)               匹配exp,并捕获文本到自动命名的组里
 (?<name>exp)        匹配exp,并捕获文本到名称为name的组里，也可以写成(?'name'exp)
 (?:exp)             匹配exp,不捕获匹配的文本，也不给此分组分配组号
 零宽断言
 (?=exp)             匹配exp前面的位置
 (?<=exp)            匹配exp后面的位置
 (?!exp)             匹配后面跟的不是exp的位置
 (?<!exp)            匹配前面不是exp的位置
 注释
 (?#comment)         这种类型的分组不对正则表达式的处理产生任何影响，用于提供注释让人阅读
 
 *  表达式：\(?0\d{2}[) -]?\d{8}
 *  这个表达式可以匹配几种格式的电话号码，像(010)88886666，或022-22334455，或02912345678等。
 *  我们对它进行一些分析吧：
 *  首先是一个转义字符\(,它能出现0次或1次(?),然后是一个0，后面跟着2个数字(\d{2})，然后是)或-或空格中的一个，它出现1次或不出现(?)，
 *  最后是8个数字(\d{8})
 */

/**
 常用正则表达式大全！（例如：匹配中文、匹配html）
 
 匹配中文字符的正则表达式： [u4e00-u9fa5]
 　　评注：匹配中文还真是个头疼的事，有了这个表达式就好办了
 
 　　匹配双字节字符(包括汉字在内)：[^x00-xff]
 　　评注：可以用来计算字符串的长度（一个双字节字符长度计2，ASCII字符计1）
 
 　　匹配空白行的正则表达式：ns*r
 　　评注：可以用来删除空白行
 
 匹配0-9的数字和点，第一个要为数字的正则表达式：^\\d+(\\.\\d+)?$
 
 　　匹配HTML标记的正则表达式：<(S*?)[^>]*>.*?|<.*? />
 　　评注：网上流传的版本太糟糕，上面这个也仅仅能匹配部分，对于复杂的嵌套标记依旧无能为力
 
 　　匹配首尾空白字符的正则表达式：^s*|s*$
 　　评注：可以用来删除行首行尾的空白字符(包括空格、制表符、换页符等等)，非常有用的表达式
 
 　　匹配Email地址的正则表达式：w+([-+.]w+)*@w+([-.]w+)*.w+([-.]w+)*
 　　评注：表单验证时很实用
 
 　　匹配网址URL的正则表达式：[a-zA-z]+://[^s]*
 　　评注：网上流传的版本功能很有限，上面这个基本可以满足需求
 
 　　匹配帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)：^[a-zA-Z][a-zA-Z0-9_]{4,15}$
 　　评注：表单验证时很实用
 
 　　匹配国内电话号码：d{3}-d{8}|d{4}-d{7}
 　　评注：匹配形式如 0511-4405222 或 021-87888822
 
 　　匹配腾讯QQ号：[1-9][0-9]{4,}
 　　评注：腾讯QQ号从10000开始
 
 　　匹配中国邮政编码：[1-9]d{5}(?!d)
 　　评注：中国邮政编码为6位数字
 
 　　匹配身份证：d{15}|d{18}
 　　评注：中国的身份证为15位或18位
 
 　　匹配ip地址：d+.d+.d+.d+
 　　评注：提取ip地址时有用
 
 　　匹配特定数字：
 　　^[1-9]d*$　 　 //匹配正整数
 　　^-[1-9]d*$ 　 //匹配负整数
 　　^-?[1-9]d*$　　 //匹配整数
 　　^[1-9]d*|0$　 //匹配非负整数（正整数 + 0）
 　　^-[1-9]d*|0$　　 //匹配非正整数（负整数 + 0）
 　　^[1-9]d*.d*|0.d*[1-9]d*$　　 //匹配正浮点数
 　　^-([1-9]d*.d*|0.d*[1-9]d*)$　 //匹配负浮点数
 　　^-?([1-9]d*.d*|0.d*[1-9]d*|0?.0+|0)$　 //匹配浮点数
 　　^[1-9]d*.d*|0.d*[1-9]d*|0?.0+|0$　　 //匹配非负浮点数（正浮点数 + 0）
 　　^(-([1-9]d*.d*|0.d*[1-9]d*))|0?.0+|0$　　//匹配非正浮点数（负浮点数 + 0）
 　　评注：处理大量数据时有用，具体应用时注意修正
 
 　　匹配特定字符串：
 　　^[A-Za-z]+$　　//匹配由26个英文字母组成的字符串
 　　^[A-Z]+$　　//匹配由26个英文字母的大写组成的字符串
 　　^[a-z]+$　　//匹配由26个英文字母的小写组成的字符串
 　　^[A-Za-z0-9]+$　　//匹配由数字和26个英文字母组成的字符串
 　　^w+$　　//匹配由数字、26个英文字母或者下划线组成的字符串
 　　在使用RegularExpressionValidator验证控件时的验证功能及其验证表达式介绍如下:
 　　只能输入数字：“^[0-9]*$”
 　　只能输入n位的数字：“^d{n}$”
 　　只能输入至少n位数字：“^d{n,}$”
 　　只能输入m-n位的数字：“^d{m,n}$”
 　　只能输入零和非零开头的数字：“^(0|[1-9][0-9]*)$”
 　　只能输入有两位小数的正实数：“^[0-9]+(.[0-9]{2})?$”
 　　只能输入有1-3位小数的正实数：“^[0-9]+(.[0-9]{1,3})?$”
 　　只能输入非零的正整数：“^+?[1-9][0-9]*$”
 　　只能输入非零的负整数：“^-[1-9][0-9]*$”
 　　只能输入长度为3的字符：“^.{3}$”
 　　只能输入由26个英文字母组成的字符串：“^[A-Za-z]+$”
 　　只能输入由26个大写英文字母组成的字符串：“^[A-Z]+$”
 　　只能输入由26个小写英文字母组成的字符串：“^[a-z]+$”
 　　只能输入由数字和26个英文字母组成的字符串：“^[A-Za-z0-9]+$”
 　　只能输入由数字、26个英文字母或者下划线组成的字符串：“^w+$”
 　　验证用户密码:“^[a-zA-Z]w{5,17}$”正确格式为：以字母开头，长度在6-18之间，
 　　只能包含字符、数字和下划线。
 　　验证是否含有^%&'',;=?$"等字符：“[^%&'',;=?$x22]+”
 　　只能输入汉字：“^[u4e00-u9fa5],{0,}$”
 　　验证Email地址：“^w+[-+.]w+)*@w+([-.]w+)*.w+([-.]w+)*$”
 　　验证InternetURL：“^http://([w-]+.)+[w-]+(/[w-./?%&=]*)?$”
 　　验证电话号码：“^((d{3,4})|d{3,4}-)?d{7,8}$”
 　　正确格式为：“XXXX-XXXXXXX”，“XXXX-XXXXXXXX”，“XXX-XXXXXXX”，
 　　“XXX-XXXXXXXX”，“XXXXXXX”，“XXXXXXXX”。
 　　验证身份证号（15位或18位数字）：“^d{15}|d{}18$”
 　　验证一年的12个月：“^(0?[1-9]|1[0-2])$”正确格式为：“01”-“09”和“1”“12”
 　　验证一个月的31天：“^((0?[1-9])|((1|2)[0-9])|30|31)$”
 　　正确格式为：“01”“09”和“1”“31”。
 
 　　匹配中文字符的正则表达式： [u4e00-u9fa5]
 　　匹配双字节字符(包括汉字在内)：[^x00-xff]
 　　匹配空行的正则表达式：n[s| ]*r
 　　匹配HTML标记的正则表达式：/<(.*)>.*|<(.*) />/
 　　匹配首尾空格的正则表达式：(^s*)|(s*$)
 　　匹配Email地址的正则表达式：w+([-+.]w+)*@w+([-.]w+)*.w+([-.]w+)*
 　　匹配网址URL的正则表达式：http://([w-]+.)+[w-]+(/[w- ./?%&=]*)?
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

//__nullable和__nonnull。从字面上我们可以猜到，__nullable表示对象可以是NULL或nil，而__nonnull表示对象不应该为空
//开始：NS_ASSUME_NONNULL_BEGIN  结束：NS_ASSUME_NONNULL_END  这两个要配合使用，在其区间的属性都会获得nonnull属性
NS_ASSUME_NONNULL_BEGIN

/**
 *  密码强度级别枚举，从0到6
 */
typedef NS_ENUM(NSInteger, PasswordStrengthLevel){
    PasswordStrengthLevelVeryWeak = 0,
    PasswordStrengthLevelWeak,
    PasswordStrengthLevelAverage,
    PasswordStrengthLevelStrong,
    PasswordStrengthLevelVeryStrong,
    PasswordStrengthLevelSecure,
    PasswordStrengthLevelVerySecure
};

NSString *NilString(id string);//如果是nil返回@""
NSString *NullString(id string);//如果是nil返回@"0"
NSString *NilNumString(id string);//如果是nil返回@"0.00"

//判断字符串不为空 如果为空返回YES，否则返回NO
#define IsNullOrEmptyOfNSString(string) ((![string isKindOfClass:[NSString class]]) || [string isEqualToString:@""] || (string == nil) || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"] || [string isEqualToString:@"null"] || [string isEqualToString:@"nil"] || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)

@interface NSString (RegexCategory)

//内容找出对应的笑脸
- (NSString *)stringByReplacingEmojiCheatCodesWithUnicode;
//笑脸找出对应的内容
- (NSString *)stringByReplacingEmojiUnicodeWithCheatCodes;

//将中文URL转UTF8
- (NSString *)encodeUrl;

//iOS中对字符串进行UTF-8编码(encodeURIComponent编码)：输出str字符串的UTF-8格式 如:(华令冬   转成   %E5%8D%8E%E4%BB%A4%E5%86%AC)
- (NSString *)addingPercentEscapesUsingEncoding;

//encodeURIComponent编码进行解码：把str字符串以UTF-8规则进行解码  如:(%E5%8D%8E%E4%BB%A4%E5%86%AC   转成   华令冬)
- (NSString *)replacingPercentEscapesUsingEncoding;

//字符串 转Unicode
+ (NSString *)utf8ToUnicode:(NSString *)string;
//Unicode 转字符串
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;
//Unicode转化为汉字  如：@"\\u36\\u32\\u31\\u33\\u32\\u5f\\u63\\u6d\\u73\\u5f\\u36\\u32\\u31\\u33\\u32"
- (NSString *)replaceUnicode;

//是否包含emoji表情
- (BOOL)pd_stringContainsEmoji;

//移除emoji表情
- (instancetype)pd_removedEmojiString;

//删除左边的空格和回车
- (NSString *)leftStripInPlace;

//删除右边的空格和回车
- (NSString *)rightStripInPlace;

//删除左右边的空格和回车
- (NSString *)stripInPlace;

//字母转成成大写
- (NSString *)uppercaseInPlace;

//字母转成成小写
- (NSString *)lowercaseInPlace;

//首字母变大写
- (NSString *)mj_firstCharUpper;

//首字母变小写
- (NSString *)mj_firstCharLower;

//小写字母转换成大写，大写字母转换成小写
- (NSString *)swapcaseInPlace;

//驼峰转下划线（loveYou -> love_you）
- (NSString *)mj_underlineFromCamel;

//下划线转驼峰（love_you -> loveYou）
- (NSString *)mj_camelFromUnderline;

//把第一次出现的什么转换成什么，后面出现的不转换
- (NSString *)substituteFirstInPlace:(NSString *)pattern with:(NSString *)sub;

//把最后一次出现的什么转换成什么，前面出现的不转换
- (NSString *)substituteLastInPlace:(NSString *)pattern with:(NSString *)sub;

//把所有出现的什么转换成什么
- (NSString *)stringByReplacingAllInPlace:(NSString *)pattern with:(NSString *)sub;

//传入字典，拼接成请求参数的json字符串返回
+ (NSString *)pd_JsonStringSplitWithDic:(NSDictionary *)splitDic;

//传入url和参数，来得到一个完整的url get请求地址
+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(id)params;

/**
 截取URL中的参数
 @param urlStr URL
 @return 字典形式的参数
 */
+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr;

/**
 获取url中的参数并返回
 @param urlString 带参数的url
 @return @[NSString:无参数url, NSDictionary:参数字典]
 */
- (NSArray *)getParamsWithUrlString:(NSString *)urlString;
//用encodeURIComponent编码后的url用此方法获取参数
- (NSDictionary *)parameterWithUrlString:(NSString *)urlString;
- (NSDictionary *)dictionaryWithUrlString:(NSString *)urlString;

// 字典转JSON字符串方法
+ (NSString *)convertToJsonData:(NSDictionary *)dict;

// JSON字符串转化为字典，JSON可以为字典，字符串或data
+ (NSDictionary *)dictionaryWithJsonString:(id _Nullable)JSON;

//判断是不是整形
- (BOOL)mj_isPureInt;

/**
 *  @brief 是否包含字符串
 *  @param string 字符串
 *  @return YES, 包含;
 */
- (BOOL)containsaString:(NSString *)string;

#pragma mark - url Encode
- (NSString *)urlEncodedString;

#pragma mark - url Decoded
- (NSString *)urlDecodedString;

#pragma mark - 格式化系统内存容量显示 B KB MB GB
+ (NSString *)lgf_FileSizeFormat:(CGFloat)bsize;

/**
 阿拉伯数字转成中文
 @param arebic 阿拉伯数字
 @return 返回的中文数字
 */
+ (NSString *)wh_translation:(NSString *)arebic;

/**
 *  @brief:在是数组中查找字符串
 *  @paramsource:执行查找操作的数组
 *  @paramstring:需要查找的字符串
 *  @return:查找成功返回YES,否则NO
 */
+ (BOOL)stringInArray:(NSArray *)source string:(NSString *)string;

/**
 *  搜索两个字符之间的字符串。
 *  例如: "This is a test" 的开始字符'h'和结束字符't'将返回"his is a "
 */
+ (NSString *)searchInString:(NSString *)string charStart:(char)start charEnd:(char)end;

//获取字符数量
- (int)wordsCount;

//反转字符串
- (NSString *)reverseString;

/*! 获取字符串占多少字节 */
- (NSUInteger)ba_getLength;

/**
 *  查找一个字符串在另一个字符串中的位置和长度
 *
 *  @param searchString 查找的字符串.
 *  @param mask         查找方式
 *  @param range        查找范围.
 *
 *  @return Ranges.
 */
- (NSArray <NSValue *> *)ba_rangesOfString:(NSString *)searchString options:(NSStringCompareOptions)mask serachRange:(NSRange)range;

/*! 手机号码格式化样式：344【中间空格】，示例：13855556666 --> 138 5555 6666 */
- (NSString *)ba_phoneNumberFormatterSpace;

/*! 手机号码格式化样式：3*4【中间4位为*】，示例：13855556666 --> 138****6666 */
- (NSString *)ba_phoneNumberFormatterCenterStar;

/*! 数字格式化样式，带小数点、货币样式、货币会计样式、货币多样式、货币ISO代码样式、序数样式、英文输出样式、科学计数样式、百分比样式
    示例：12345678.89 --> 12,345,678.89
    示例：字符串转成金钱格式  如 57823092.9  结果 57,823,092.90
 */
+ (NSString *)ba_stringFormatterWithStyle:(NSNumberFormatterStyle)numberStyle
                                   number:(NSNumber *)value;

//字符串转成金钱格式  如 57823092.9  结果 57,823,092.9
- (NSString *)changeFormatwithMoneyAmount;

/*! 保留纯数字 */
- (NSString *)ba_removeStringSaveNumber;

/*! 是否是纯数字 */
- (BOOL)isVAlidateNumber:(NSString *)number;

/*! 是否是纯汉字 */
- (BOOL)isValidChinese;

/*! 是否包含汉字 */
-(BOOL)isContainSChinese;

/*! 是否是纯字母 */
- (BOOL)ba_regularIsEnglishAlphabet;

#pragma mark - 是否是整型
- (BOOL)isPureInt;

#pragma mark - 是否是浮点型
- (BOOL)isPureFloat;

//判断由数字和26个英文字母或下划线组成的字符串
- (BOOL)isNumAndword;

//判断都是小写字母
- (BOOL)isOnlyHaveSmallLetters;

//判断都是大写字母
- (BOOL)isOnlyHaveCapitalLetters;

//过滤特殊字符
- (NSString *)removeSpecialCharacter;

//解析路径,返回构成路径的各个部分
+ (NSArray *)pathComponents:(NSString *)filePath;

//手机号码的有效性:分电信、联通、移动和小灵通
- (BOOL)isMobileNumberClassification;

//邮箱的有效性
- (BOOL)isEmailAddress;

//精确的身份证号码有效性检测
- (BOOL)accurateVerifyIDCardNumber;

/**
 判断是否是有效的中文名，姓名
 @return 如果是在如下规则下符合的中文名则返回`YES`，否则返回`NO`
 限制规则：
    1. 首先是名字要大于2个汉字，小于8个汉字
    2. 如果是中间带`{•|·}`的名字，则限制长度15位（新疆人的名字有15位左右的，之前公司实名认证就遇到过），如果有更长的，请自行修改长度限制
    3. 如果是不带小点的正常名字，限制长度为8位，若果觉得不适，请自行修改位数限制
 *PS: `•`或`·`具体是那个点具体处理需要注意*
 */
- (BOOL)isVaildRealName;

//车牌号的有效性
- (BOOL)isCarNumber;

/*!
 *  车型验证
 *  @return 返回检测结果 是或者不是
 */
- (BOOL)ba_regularIsValidateCarType;

//银行卡的有效性
- (BOOL)bankCardluhmCheck;

//验证IP地址（15位或18位数字）
- (BOOL)ba_regularIsIPAddress;

//IP地址有效性
- (BOOL)isIPAddress;
- (BOOL)isValidatIP;

//Mac地址有效性
- (BOOL)isMacAddress;

//网址有效性
- (BOOL)isValidUrl;

//邮政编码
- (BOOL)isValidPostalcode;

//工商税号
- (BOOL)isValidTaxNo;

//根据正则表达式判断是否符合条件
//regex：正则表达式
- (BOOL)isValidateByRegex:(NSString *)regex;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     containDigtal   包含数字
 @param     containLetter   包含字母
 @param     containOtherCharacter   其他字符
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
              containDigtal:(BOOL)containDigtal
              containLetter:(BOOL)containLetter
      containOtherCharacter:(NSString *)containOtherCharacter
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/*!
 *  检测用户输入密码是否以字母开头，长度在6-18之间，只能包含字符、数字和下划线。
 *
 *  @return 返回检测结果 是或者不是
 */
- (BOOL)ba_regularIsPassword;

/**
 *  检查密码强度级别
 */
- (PasswordStrengthLevel)passwordCheckStrength;

/*
 *  @brief:通过unicode编码转换为字符串必须以\u开头
 *  @param unicode:unicode编码字符串
 *  @param prefix:前缀
 *  @return:返回一个实际的字符串
 */
+ (NSString *)stringFromUnicode:(NSString *)unicode
                         prefix:(NSString *)prefix;

/*
 *  @brief:通过字符串获取unicode的编码串
 *  @param string:字符串
 *  @param prefix:前缀
 *  @return:返回一个unicode的编码串
 */
+ (NSString *)unicodeFromString:(NSString *)string
                         prefix:(NSString *)prefix
                          align:(BOOL)align;

/*
 @brief:返回一个去掉前缀和后缀后的类的抽象名称
 @param clsName:定义的类名
 @param prefix:前缀
 @param suffix:后缀
 @return:实体抽象名称
 */
+ (NSString *)className:(NSString *)clsName
                 prefix:(NSString *)prefix
                 suffix:(NSString *)suffix;

/*
 *  @brief:通过16进制字符串返回一个整形值
 *  @param string:字符串
 *  @param hex:string所表示的进制
 *  @return:返回一个无符号长整型值
 */
+ (unsigned long long)strToLong:(nonnull NSString *)string hex:(NSInteger)hex;

//查看里面有几个换行符
- (NSUInteger)lineCount;

//取第几个换行符之前的字符串
- (NSString *)subStringToLineIndex:(NSUInteger)lineIndex;

//取第几个换行符之前的字符串的长度
- (NSUInteger)lengthToLineIndex:(NSUInteger)lineIndex;

//判断最后一个字符是否是换行符
- (BOOL)isNewlineCharacterAtEnd;

//判断字符串是否有中文
- (BOOL)isContainChinese;

/// 获取字符串中 @用户 的 NSTextCheckingResult 数组, result.range 就是 @用户 的range
- (NSMutableArray *)findAtRange;

/// 获取字符串中 topic 的 NSTextCheckingResult 数组, result.range 就是 topic 的range
- (NSMutableArray *)findTopicRange;

/// 获取字符串中 url 的 NSTextCheckingResult 数组, result.range 就是 rul 的range
- (NSMutableArray *)findURLRange;

/// 获取字符串中 email 的 NSTextCheckingResult 数组, result.range 就是 email 的range
- (NSMutableArray *)findEmailRange;

/// 获取字符串中 phone 的 NSTextCheckingResult 数组, result.range 就是 phone 的range
- (NSMutableArray *)findPhoneRange;

//将字符串中的文字和表情解析出来
- (NSMutableArray *)decorate;

/**
根据字符串生成随机密码字符串
@param alphabet 从它字符串中随机抽取，如：@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
@param length 生成的密码位数
@return 随机密码
*/
+ (NSString *)randomKeyWithAlphabet:(NSString *)alphabet
                          keyLength:(NSUInteger)length;
+ (NSString *)randomKeyWithkeyLength:(NSUInteger)length;

//计算文字宽高
- (CGSize)boundingRectWithSize:(CGSize)size
                          font:(UIFont *)font;

//计算有行间距的文字宽高
- (CGSize)boundingRectWithSize:(CGSize)size
                          font:(UIFont *)font
                   lineSpacing:(CGFloat)lineSpacing;

//计算有行间距的文字宽高，并设置最大行数
- (CGFloat)boundingRectWithSize:(CGSize)size
                           font:(UIFont *)font
                    lineSpacing:(CGFloat)lineSpacing
                       maxLines:(NSInteger)maxLines;

//计算是否超过一行赋值attribute text的时候 超过一行设置lineSpace
- (BOOL)isMoreThanOneLineWithSize:(CGSize)size
                             font:(UIFont *)font
                     lineSpaceing:(CGFloat)lineSpacing;

//计算有行间距和字间距的文字宽高
- (CGSize)boundingRectWithSize:(CGSize)size
                          font:(UIFont *)font
                   lineSpacing:(CGFloat)lineSpacing
                   wordSpacing:(CGFloat)wordSpacing;

//获取每行内容
- (NSArray *)getLinesArrayWihtFont:(UIFont *)font
                          maxWidth:(CGFloat)width;
                              

NS_ASSUME_NONNULL_END

@end
