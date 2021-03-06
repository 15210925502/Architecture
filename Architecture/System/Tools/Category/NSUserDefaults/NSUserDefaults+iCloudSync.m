//
//  NSUserDefaults+iCloudSync.h
//
//  Created by Riccardo Paolillo on 09/05/13.
//  Copyright (c) 2013. All rights reserved.
//

#import "NSUserDefaults+iCloudSync.h"

@implementation NSUserDefaults (iCloudSync)

-(void)setValue:(id)value forKey:(NSString *)key iCloudSync:(BOOL)sync{
    if (sync)
        [[NSUbiquitousKeyValueStore defaultStore] setValue:value forKey:key];
    [self setValue:value forKey:key];
}

-(id)valueForKey:(NSString *)key iCloudSync:(BOOL)sync{
    if (sync){
        //Get value from iCloud
        id value = [[NSUbiquitousKeyValueStore defaultStore] valueForKey:key];
        
        //Store locally and synchronize
        [self setValue:value forKey:key];
        [self synchronize];
        
        return value;
    }
    return [self valueForKey:key];
}

- (void)removeValueForKey:(NSString *)key iCloudSync:(BOOL)sync{
    [self removeObjectForKey:key iCloudSync:sync];
}

-(void)setObject:(id)value forKey:(NSString *)defaultName iCloudSync:(BOOL)sync{
    if (sync)
        [[NSUbiquitousKeyValueStore defaultStore] setObject:value forKey:defaultName];
    [self setObject:value forKey:defaultName];
}

-(id)objectForKey:(NSString *)key iCloudSync:(BOOL)sync{
    if (sync){
        //Get value from iCloud
        id value = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:key];
        
        //Store to NSUserDefault and synchronize
        [self setObject:value forKey:key];
        [self synchronize];
        return value;
    }
    return [self objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)key iCloudSync:(BOOL)sync{
    if (sync)
        [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:key];
    //Remove from NSUserDefault
    return [self removeObjectForKey:key];
}

- (BOOL)synchronizeAlsoiCloudSync:(BOOL)sync{
    BOOL res = true;
    if (sync)
        res &= [self synchronize];
    res &= [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    return res;
}

+ (NSString *)stringForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] stringForKey:defaultName];
}

+ (NSArray *)arrayForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:defaultName];
}

+ (NSDictionary *)dictionaryForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:defaultName];
}

+ (NSData *)dataForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] dataForKey:defaultName];
}

+ (NSArray *)stringArrayForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] stringArrayForKey:defaultName];
}

+ (NSInteger)integerForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] integerForKey:defaultName];
}

+ (float)floatForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] floatForKey:defaultName];
}

+ (double)doubleForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:defaultName];
}

+ (BOOL)boolForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}

+ (NSURL *)URLForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] URLForKey:defaultName];
}

#pragma mark - WRITE ARCHIVE FOR STANDARD
+ (void)setArcObject:(id)value forKey:(NSString *)defaultName {
    [self saveUserDefaultsObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:defaultName];
}

#pragma mark - WRITE FOR STANDARD
+ (void)saveUserDefaultsObject:(id)value forKey:(NSString *)defaultName {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - READ ARCHIVE FOR STANDARD
+ (id)getUserDefaultsforKey:(NSString *)key {
    id result = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (result == nil) {
        result = @"";
    }
    return result;
}

@end
