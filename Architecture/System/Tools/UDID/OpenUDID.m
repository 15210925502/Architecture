//
//  OpenUDID.m
//  openudid
//
//  initiated by Yann Lechelle (cofounder @Appsfire) on 8/28/11.
//  Copyright 2011, 2012 OpenUDID.org
//

#define kOpenUDIDErrorNone          0
#define kOpenUDIDErrorOptedOut      1
#define kOpenUDIDErrorCompromised   2

#import "OpenUDID.h"
#import "SFHFKeychainUtils.h"
#import <CommonCrypto/CommonDigest.h>
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIPasteboard.h>
#import <UIKit/UIKit.h>
#else
#import <AppKit/NSPasteboard.h>
#endif

static char *__uuidkey__ = NULL;
static NSString * const STUniqueIdentifierDefaultsKey = @"STUniqueIdentifier";

static NSString * kOpenUDIDSessionCache = nil;
static NSString * const kOpenUDIDDescription = @"OpenUDID_with_iOS6_Support";
static NSString * const kOpenUDIDKey = @"OpenUDID";
static NSString * const kOpenUDIDSlotKey = @"OpenUDID_slot";
static NSString * const kOpenUDIDAppUIDKey = @"OpenUDID_appUID";
static NSString * const kOpenUDIDTSKey = @"OpenUDID_createdTS";
static NSString * const kOpenUDIDOOTSKey = @"OpenUDID_optOutTS";
static NSString * const kOpenUDIDDomain = @"org.OpenUDID";
static NSString * const kOpenUDIDSlotPBPrefix = @"org.OpenUDID.slot.";
static int const kOpenUDIDRedundancySlots = 100;

@interface OpenUDID (Private)

+ (void)_setDict:(id)dict forPasteboard:(id)pboard;
+ (NSMutableDictionary *)_getDictFromPasteboard:(id)pboard;
+ (NSString *)_generateFreshOpenUDID;

@end

@implementation OpenUDID

+ (void)_setDict:(id)dict forPasteboard:(id)pboard {
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR		
    [pboard setData:[NSKeyedArchiver archivedDataWithRootObject:dict] forPasteboardType:kOpenUDIDDomain];
#else
    [pboard setData:[NSKeyedArchiver archivedDataWithRootObject:dict] forType:kOpenUDIDDomain];
#endif
}

+ (NSMutableDictionary *)_getDictFromPasteboard:(id)pboard {
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR	
    id item = [pboard dataForPasteboardType:kOpenUDIDDomain];
#else
    id item = [pboard dataForType:kOpenUDIDDomain];
#endif	
    if (item) {
        @try{
            item = [NSKeyedUnarchiver unarchiveObjectWithData:item];
        } @catch(NSException* e) {
            NSLog(@"Unable to unarchive item %@ on pasteboard!", [pboard name]);
            item = nil;
        }
    }
    return [NSMutableDictionary dictionaryWithDictionary:(item == nil || [item isKindOfClass:[NSDictionary class]]) ? item : nil];
}

+ (NSString *)_generateFreshOpenUDID {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    const char *cStr = CFStringGetCStringPtr(cfstring,CFStringGetFastestEncoding(cfstring));
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    CFRelease(uuid);
    CFRelease(cfstring);
    NSString *_openUDID = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15],
                           (NSUInteger)(arc4random() % NSUIntegerMax)];
    return _openUDID;
}

+ (NSString *)valueForMD5 {
    NSData *d = [[OpenUDID value] dataUsingEncoding:NSUTF8StringEncoding];
    if (d.length > 0) {
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5(d.bytes, (CC_LONG)d.length, result);
        return [NSString stringWithFormat:
                @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                result[0], result[1], result[2], result[3],
                result[4], result[5], result[6], result[7],
                result[8], result[9], result[10], result[11],
                result[12], result[13], result[14], result[15]
                ];
    }
    return [OpenUDID value];
}

+ (NSString *)value {
    return [OpenUDID valueWithError:nil];
}

+ (NSString *)valueWithError:(NSError **)error {
    if (kOpenUDIDSessionCache) {
        if (error)
            *error = [NSError errorWithDomain:kOpenUDIDDomain
                                         code:kOpenUDIDErrorNone
                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"OpenUDID in cache from first call",@"description", nil]];
        return kOpenUDIDSessionCache;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *appUID = [defaults objectForKey:kOpenUDIDAppUIDKey];
    if(!appUID){
        // 生成一个新的uuid并将其存储在用户默认值中
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        appUID = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
        CFRelease(uuid);
    }
    NSString *openUDID = nil;
    NSString *myRedundancySlotPBid = nil;
    NSDate *optedOutDate = nil;
    BOOL optedOut = NO;
    BOOL saveLocalDictToDefaults = NO;
    BOOL isCompromised = NO;

    id localDict = [defaults objectForKey:kOpenUDIDKey];
    if ([localDict isKindOfClass:[NSDictionary class]]) {
        localDict = [NSMutableDictionary dictionaryWithDictionary:localDict];
        openUDID = [localDict objectForKey:kOpenUDIDKey];
        myRedundancySlotPBid = [localDict objectForKey:kOpenUDIDSlotKey];
        optedOutDate = [localDict objectForKey:kOpenUDIDOOTSKey];
        optedOut = optedOutDate != nil;
        NSLog(@"localDict = %@",localDict);
    }

    NSString *availableSlotPBid = nil;
    NSMutableDictionary* frequencyDict = [NSMutableDictionary dictionaryWithCapacity:kOpenUDIDRedundancySlots];
    for (int n = 0; n < kOpenUDIDRedundancySlots; n++) {
        NSString *slotPBid = [NSString stringWithFormat:@"%@%d",kOpenUDIDSlotPBPrefix,n];
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
        UIPasteboard *slotPB = [UIPasteboard pasteboardWithName:slotPBid create:NO];
#else
        NSPasteboard *slotPB = [NSPasteboard pasteboardWithName:slotPBid];
#endif
        NSLog(@"SlotPB name = %@",slotPBid);
        if (slotPB) {
            NSDictionary *dict = [OpenUDID _getDictFromPasteboard:slotPB];
            NSString *oudid = [dict objectForKey:kOpenUDIDKey];
            NSLog(@"SlotPB dict = %@",dict);
            if (oudid) {
                // increment the frequency of this oudid key
                int count = [[frequencyDict valueForKey:oudid] intValue];
                [frequencyDict setObject:[NSNumber numberWithInt:++count] forKey:oudid];
                
            } else {
                // availableSlotPBid could inside a non null slot where no oudid can be found
                if (!availableSlotPBid){
                    availableSlotPBid = slotPBid;
                }
            }
            // if we have a match with the app unique id,
            // then let's look if the external UIPasteboard representation marks this app as OptedOut
            NSString *gid = [dict objectForKey:kOpenUDIDAppUIDKey];
            if (gid && [gid isEqualToString:appUID]) {
                myRedundancySlotPBid = slotPBid;
                if (optedOut) {
                    optedOutDate = [dict objectForKey:kOpenUDIDOOTSKey];
                    optedOut = optedOutDate != nil;
                }
            }
        } else {
            // assign availableSlotPBid to be the first one available
            if (!availableSlotPBid){
                availableSlotPBid = slotPBid;
            }
        }
    }

    NSArray *arrayOfUDIDs = [frequencyDict keysSortedByValueUsingSelector:@selector(compare:)];
    NSString *mostReliableOpenUDID = (arrayOfUDIDs && [arrayOfUDIDs count] > 0) ? [arrayOfUDIDs lastObject] : nil;
    NSLog(@"Freq Dict = %@\nMost reliable %@",frequencyDict,mostReliableOpenUDID);
    
    // if openUDID was not retrieved from the local preferences, then let's try to get it from the frequency dictionary above
    //
    if (openUDID) {
        if (mostReliableOpenUDID && ![mostReliableOpenUDID isEqualToString:openUDID]){
            isCompromised = YES;
        }
    }else {
        if (mostReliableOpenUDID) {
            openUDID = mostReliableOpenUDID;
        } else {
            openUDID = [OpenUDID _generateFreshOpenUDID];
        }
        if (!localDict) {
            localDict = [NSMutableDictionary dictionaryWithCapacity:4];
            [localDict setObject:openUDID forKey:kOpenUDIDKey];
            [localDict setObject:appUID forKey:kOpenUDIDAppUIDKey];
            [localDict setObject:[NSDate date] forKey:kOpenUDIDTSKey];
            if (optedOut){
                [localDict setObject:optedOutDate forKey:kOpenUDIDTSKey];
            }
            saveLocalDictToDefaults = YES;
        }
    }
    NSLog(@"Available Slot %@ Existing Slot %@",availableSlotPBid,myRedundancySlotPBid);
    if (availableSlotPBid && (!myRedundancySlotPBid || [availableSlotPBid isEqualToString:myRedundancySlotPBid])) {
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
        UIPasteboard *slotPB = [UIPasteboard pasteboardWithName:availableSlotPBid create:YES];
        [slotPB setPersistent:YES];
#else
        NSPasteboard *slotPB = [NSPasteboard pasteboardWithName:availableSlotPBid];
#endif
        if (localDict) {
            [localDict setObject:availableSlotPBid forKey:kOpenUDIDSlotKey];
            saveLocalDictToDefaults = YES;
        }
        if (openUDID && localDict){
            [OpenUDID _setDict:localDict forPasteboard:slotPB];
        }
    }
    if (localDict && saveLocalDictToDefaults)
        [defaults setObject:localDict forKey:kOpenUDIDKey];
    if (optedOut) {
        if (error){
            *error = [NSError errorWithDomain:kOpenUDIDDomain
                                         code:kOpenUDIDErrorOptedOut
                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Application with unique id %@ is opted-out from OpenUDID as of %@",appUID,optedOutDate],@"description", nil]];
        }
        kOpenUDIDSessionCache = [NSString stringWithFormat:@"%040x",0];
        return kOpenUDIDSessionCache;
    }
    if (error) {
        if (isCompromised){
            *error = [NSError errorWithDomain:kOpenUDIDDomain
                                         code:kOpenUDIDErrorCompromised
                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Found a discrepancy between stored OpenUDID (reliable) and redundant copies; one of the apps on the device is most likely corrupting the OpenUDID protocol",@"description", nil]];
        }else{
            *error = [NSError errorWithDomain:kOpenUDIDDomain
                                         code:kOpenUDIDErrorNone
                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"OpenUDID succesfully retrieved",@"description", nil]];
        }
    }
    kOpenUDIDSessionCache = openUDID;
    return kOpenUDIDSessionCache;
}

+ (void)setOptOut:(BOOL)optOutValue {
    [OpenUDID value];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // load the dictionary from local cache or create one
    id dict = [defaults objectForKey:kOpenUDIDKey];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        dict = [NSMutableDictionary dictionaryWithDictionary:dict];
    } else {
        dict = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    // set the opt-out date or remove key, according to parameter
    if (optOutValue){
        [dict setObject:[NSDate date] forKey:kOpenUDIDOOTSKey];
    } else{
       [dict removeObjectForKey:kOpenUDIDOOTSKey];
    }
    // store the dictionary locally
    [defaults setObject:dict forKey:kOpenUDIDKey];
    NSLog(@"Local dict after opt-out = %@",dict);
    // reset memory cache
    kOpenUDIDSessionCache = nil;
}

+ (void)setUUIdKey:(NSString *)uuidKey{
    if (uuidKey) {
        static dispatch_once_t onceToken_UUIDKey;
        dispatch_once(&onceToken_UUIDKey, ^{
            size_t UUIDKeyLen = strlen([uuidKey UTF8String]);
            __uuidkey__ = (char *)malloc(sizeof(char) * (strlen([uuidKey UTF8String]) + 1));
            memset(__uuidkey__, 0, UUIDKeyLen + 1);
            memcpy(__uuidkey__, [uuidKey UTF8String], UUIDKeyLen);
        });
    }
}

/* 返回唯一标识符 */
+ (NSString *)uniqueIdentifier{
    NSString *uuid;
    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]){
        // 获取UUID的字符串描述
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        uuid = [defaults objectForKey:STUniqueIdentifierDefaultsKey];
        if (!uuid) {
            uuid = [self generateUUID];
            [defaults setObject:uuid forKey:STUniqueIdentifierDefaultsKey];
            [defaults synchronize];
        }
    }
    return uuid;
}

/* 生成一个全新的唯一标识符 */
+ (NSString *)generateUUID{
    // 创建一个全新的唯一标识符
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    // 从UUID转换为字符串表示
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)string];
    CFRelease(theUUID);
    CFRelease(string);
    return [uuid lowercaseString];
}

+ (NSString *)pd_UUID {
    //获取BundleID
    NSString *domain = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *service = @"cn.ifreework.app.tools";
    //删除唯一标示
    //[SFHFKeychainUtils deleteItemForUsername:domain andServiceName:service error:nil];
    //通过一个serviceName清空里面所有与serviceName相关的数据
    //[SFHFKeychainUtils purgeItemsForServiceName:service error:nil];
    //获取唯一标示
    NSString *uuid = [SFHFKeychainUtils getPasswordForUsername:domain andServiceName:service error:nil];
    if (uuid == nil || ![uuid hasPrefix:@"iOS_"]) {
        uuid = [@"iOS_" stringByAppendingString:[[NSUUID UUID] UUIDString]];
        //把唯一标示存到钥匙串
        [SFHFKeychainUtils storeUsername:domain andPassword:uuid forServiceName:service updateExisting:YES error:nil];
    }
    return uuid;
}

@end
