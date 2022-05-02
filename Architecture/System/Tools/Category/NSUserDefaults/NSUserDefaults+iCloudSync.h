
#import <Foundation/Foundation.h>

@interface NSUserDefaults (iCloudSync)

//NSUserDefaults保存
+ (void)saveUserDefaultsObject:(id)value forKey:(NSString *)defaultName;
+ (void)setArcObject:(id)value forKey:(NSString *)defaultName;

//NSUserDefaults获取值
+ (id)getUserDefaultsforKey:(NSString *)key;

//是否同步到iCloud上
- (void)setValue:(id)value  forKey:(NSString *)key iCloudSync:(BOOL)sync;
- (void)setObject:(id)value forKey:(NSString *)key iCloudSync:(BOOL)sync;

- (id)valueForKey:(NSString *)key  iCloudSync:(BOOL)sync;
- (id)objectForKey:(NSString *)key iCloudSync:(BOOL)sync;

- (BOOL)synchronizeAlsoiCloudSync:(BOOL)sync;

+ (NSString *)stringForKey:(NSString *)defaultName;

+ (NSArray *)arrayForKey:(NSString *)defaultName;

+ (NSDictionary *)dictionaryForKey:(NSString *)defaultName;

+ (NSData *)dataForKey:(NSString *)defaultName;

+ (NSArray *)stringArrayForKey:(NSString *)defaultName;

+ (NSInteger)integerForKey:(NSString *)defaultName;

+ (float)floatForKey:(NSString *)defaultName;

+ (double)doubleForKey:(NSString *)defaultName;

+ (BOOL)boolForKey:(NSString *)defaultName;

+ (NSURL *)URLForKey:(NSString *)defaultName;

@end
