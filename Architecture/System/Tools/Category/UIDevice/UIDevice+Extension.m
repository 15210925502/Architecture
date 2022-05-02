
#import "UIDevice+Extension.h"
#import <sys/types.h>
#import <sys/sysctl.h>
#import <sys/socket.h>
#import <mach/mach.h>
#import <sys/utsname.h>
#import <net/if_dl.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <arpa/inet.h>
#import "OpenUDID.h"
#import <mach-o/arch.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <net/if.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation UIDevice (Extension)

+ (NSString *)devicePlatform{
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

+ (NSString *)devicePlatformString{
    static NSString *name;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *platform = [self devicePlatform];
        if (!platform){
            return;
        }
        NSDictionary *dic = @{
            // iPhone
            @"iPhone1,1" : @"iPhone 2G (A1203)",
            @"iPhone1,2" : @"iPhone 3G (A1241/A1324)",
            @"iPhone2,1" : @"iPhone 3GS (A1303/A1325)",
            @"iPhone3,1" : @"iPhone 4 (A1332)",
            @"iPhone3,2" : @"iPhone 4 (A1332)",
            @"iPhone3,3" : @"iPhone 4 (CDMA) (A1349)",
            @"iPhone4,1" : @"iPhone 4S (A1387/A1431)",
            @"iPhone5,1" : @"iPhone 5 (GSM) (A1428)",
            @"iPhone5,2" : @"iPhone 5 (CDMA) (A1429/A1442)",
            @"iPhone5,3" : @"iPhone 5C (GSM) (A1456/A1532)",
            @"iPhone5,4" : @"iPhone 5C (Global) (A1507/A1516/A1526/A1529)",
            @"iPhone6,1" : @"iPhone 5S (GSM) (A1453/A1533)",
            @"iPhone6,2" : @"iPhone 5S (Global) (A1457/A1518/A1528/A1530)",
            @"iPhone7,1" : @"iPhone 6 Plus (A1522/A1524)",
            @"iPhone7,2" : @"iPhone 6 (A1549/A1586)",
            @"iPhone8,1" : @"iPhone_6S",
            @"iPhone8,2" : @"iPhone_6S_Plus",
            @"iPhone8,4" : @"iPhone_SE",
            // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
            @"iPhone9,1" : @"Chinese_iPhone_7",
            @"iPhone9,2" : @"Chinese_iPhone_7_Plus",
            @"iPhone9,3" : @"American_iPhone_7",
            @"iPhone9,4" : @"American_iPhone_7_Plus",
            @"iPhone10,1" : @"iPhone_8",
            @"iPhone10,2" : @"iPhone_8_Plus",
            @"iPhone10,3" : @"iPhone_X",
            @"iPhone10,4" : @"iPhone_8",
            @"iPhone10,5" : @"iPhone_8_Plus",
            @"iPhone10,6" : @"iPhone_X",
            @"iPhone11,2" : @"iPhone_XS",
            @"iPhone11,4" : @"iPhone_XS_Max",
            @"iPhone11,6" : @"iPhone_XS_Max",
            @"iPhone11,8" : @"iPhone_XR",
            @"iPhone12,1" : @"iPhone_11",
            @"iPhone12,3" : @"iPhone_11_Pro",
            @"iPhone12,5" : @"iPhone_11_Pro_Max",
            // iPod
            @"iPod1,1" : @"iPod Touch 1G (A1213)",
            @"iPod2,1" : @"iPod Touch 2G (A1288)",
            @"iPod3,1" : @"iPod Touch 3G (A1318)",
            @"iPod4,1" : @"iPod Touch 4G (A1367)",
            @"iPod5,1" : @"iPod Touch 5G (A1421/A1509)",
            @"iPod7,1" : @"iPod_Touch_6G",
            @"iPod9,1" : @"iPod 7",
            // iPad
            @"iPad1,1" : @"iPad 1 (A1219/A1337)",
            @"iPad2,1" : @"iPad 2 (WiFi) (A1395)",
            @"iPad2,2" : @"iPad 2 (GSM) (A1396)",
            @"iPad2,3" : @"iPad 2 (CDMA) (A1397)",
            @"iPad2,4" : @"iPad 2 (32nm) (A1395+New Chip)",
            @"iPad2,5" : @"iPad mini (WiFi) (A1432)",
            @"iPad2,6" : @"iPad mini (GSM) (A1454)",
            @"iPad2,7" : @"iPad mini (CDMA) (A1455)",
            @"iPad3,1" : @"iPad 3 (WiFi) (A1416)",
            @"iPad3,2" : @"iPad 3 (CDMA) (A1403)",
            @"iPad3,3" : @"iPad 3 (GSM) (A1430)",
            @"iPad3,4" : @"iPad 4 (WiFi) (A1458)",
            @"iPad3,5" : @"iPad 4 (GSM) (A1459)",
            @"iPad3,6" : @"iPad 4 (CDMA) (A1460)",
            @"iPad4,1" : @"iPad Air (WiFi) (A1474)",
            @"iPad4,2" : @"iPad Air (Cellular) (A1475)",
            @"iPad4,3" : @"iPad Air (China) (A1476)",
            @"iPad4,4" : @"iPad mini 2",
            @"iPad4,5" : @"iPad mini 2",
            @"iPad4,6" : @"iPad mini 2",
            @"iPad4,7" : @"iPad mini 3",
            @"iPad4,8" : @"iPad mini 3",
            @"iPad4,9" : @"iPad mini 3",
            @"iPad5,1" : @"iPad_Mini_4_WiFi",
            @"iPad5,2" : @"iPad_Mini_3_Cellular",
            @"iPad5,3" : @"iPad Air 2 (WiFi)",
            @"iPad5,4" : @"iPad Air 2 (Cellular)",
            @"iPad6,3" : @"iPad Pro (9.7 inch)",
            @"iPad6,4" : @"iPad Pro (9.7 inch)",
            @"iPad6,7" : @"iPad Pro (12.9 inch)",
            @"iPad6,8" : @"iPad Pro (12.9 inch)",
            @"iPad6,11" : @"iPad 5",
            @"iPad6,12" : @"iPad 5",
            @"iPad7,1" : @"iPad Pro 2",
            @"iPad7,2" : @"iPad Pro 2",
            @"iPad7,3" : @"iPad Pro",
            @"iPad7,4" : @"iPad Pro",
            @"iPad7,5" : @"iPad 6",
            @"iPad7,6" : @"iPad 6",
            @"iPad8,1" : @"iPad Pro 3",
            @"iPad8,2" : @"iPad Pro 3",
            @"iPad8,3" : @"iPad Pro 3",
            @"iPad8,4" : @"iPad Pro 3",
            @"iPad8,5" : @"iPad Pro 3",
            @"iPad8,6" : @"iPad Pro 3",
            @"iPad8,7" : @"iPad Pro 3",
            @"iPad8,8" : @"iPad Pro 3",
            @"iPad11,1" : @"iPad Mini 5",
            @"iPad11,2" : @"iPad Mini 5",
            @"iPad11,3" : @"iPad Air 3",
            @"iPad11,4" : @"iPad Air 3",
     
            //TV
            @"AppleTV2,1" : @"appleTV2",
            @"AppleTV3,1" : @"appleTV3",
            @"AppleTV3,2" : @"appleTV3",
            @"AppleTV5,3" : @"appleTV4",
            //Watch
            @"Watch1,1" : @"Apple Watch 38mm",
            @"Watch1,2" : @"Apple Watch 42mm",
            @"Watch2,3" : @"Apple Watch Series 2 38mm",
            @"Watch2,4" : @"Apple Watch Series 2 42mm",
            @"Watch2,6" : @"Apple Watch Series 1 38mm",
            @"Watch2,7" : @"Apple Watch Series 1 42mm",
            // 模拟器
            @"i386"     : @"Simulator x86",
            @"x86_64"   : @"Simulator x64"
        };
        name = [dic objectForKey:platform];
        if (!name){
            name = @"unknown";
        }
    });
    return name;
}

+ (NSString *)screenResolution {
    return [NSString stringWithFormat:@"%ld * %ld",(long)(BaseTools.screenWidth * [UIScreen mainScreen].scale),(long)(BaseTools.screenHeight * [UIScreen mainScreen].scale)];
}

+ (BOOL)isJailbroken{
    // Dont't check simulator
    if ([self isSimulator]){
        return NO;
    }
    // iOS9 URL Scheme query changed ...
    // NSURL *cydiaURL = [NSURL URLWithString:@"cydia://package"];
    // if ([[UIApplication sharedApplication] canOpenURL:cydiaURL]) return YES;
    NSArray *paths = @[@"/Applications/Cydia.app",
                       @"/private/var/lib/apt/",
                       @"/private/var/lib/cydia",
                       @"/private/var/stash"];
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
            return YES;
        }
    }
    FILE *bash = fopen("/bin/bash", "r");
    if (bash != NULL) {
        fclose(bash);
        return YES;
    }
    NSString *path = [NSString stringWithFormat:@"/private/%@", [OpenUDID value]];
    if ([@"test" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return YES;
    }
    return NO;
}

+ (BOOL)isiPad{
    if([[[self devicePlatform] substringToIndex:4] isEqualToString:@"iPad"]){
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isiPhone{
    if([[[self devicePlatform] substringToIndex:6] isEqualToString:@"iPhone"]){
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isiPod{
    if([[[self devicePlatform] substringToIndex:4] isEqualToString:@"iPod"]){
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isSimulator{
    if([[self devicePlatform] isEqualToString:@"i386"]
       || [[self devicePlatform] isEqualToString:@"x86_64"]){
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isRetina{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0 || [UIScreen mainScreen].scale == 3.0)){
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isRetinaHD{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 3.0)){
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)languageCode{
    return [NSLocale preferredLanguages].firstObject ?: @"Unknown";
}

+ (CGFloat)systemVersion{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSString *)deviceName{
    return [[UIDevice currentDevice] name] ? : @"Unknown";
}

+ (NSUInteger)getSysInfo:(uint)typeSpecifier{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

+ (float)cpuUsage{
    kern_return_t          kr;
    task_info_data_t       tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if(kr != KERN_SUCCESS){
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    thread_basic_info_t    basic_info_th;
    
    basic_info = (task_basic_info_t)tinfo;
    
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if(kr != KERN_SUCCESS){
        return -1;
    }
    float tot_cpu = 0;
    for(int j = 0; j < thread_count; j++){
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,(thread_info_t)thinfo, &thread_info_count);
        if(kr != KERN_SUCCESS){
            return -1;
        }
        basic_info_th = (thread_basic_info_t)thinfo;
        if(!(basic_info_th->flags & TH_FLAGS_IDLE)){
            tot_cpu += basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
    }
    vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    return tot_cpu;
}

+ (float)currentCpuUsage {
    float cpu = 0;
    NSArray *cpus = [self cpuUsagePerProcessor];
    if (cpus.count == 0){
        return -1;
    }
    for (NSNumber *n in cpus) {
        cpu += n.floatValue;
    }
    return cpu;
}

+ (NSArray *)cpuUsagePerProcessor {
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if (_status){
        _numCPUs = 1;
    }
    _cpuUsageLock = [[NSLock alloc] init];
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if (err == KERN_SUCCESS) {
        [_cpuUsageLock lock];
        NSMutableArray *cpus = [[NSMutableArray alloc] init];
        for (unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if (_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            [cpus addObject:@(_inUse / _total)];
        }
        [_cpuUsageLock unlock];
        if (_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        return cpus;
    } else {
        return nil;
    }
}

+ (NSString *)cpuType{
    return [NSString stringWithUTF8String:NXGetLocalArchInfo()->description] ?: @"Unknown";
}

+ (NSUInteger)cpuCount {
    return [NSProcessInfo processInfo].activeProcessorCount;
}

+ (NSUInteger)cpuFrequency{
    return [self getSysInfo:HW_CPU_FREQ];
}

+ (NSUInteger)busFrequency{
    return [self getSysInfo:HW_BUS_FREQ];
}

+ (NSUInteger)cpuNumber{
    return [self getSysInfo:HW_NCPU];
}

+ (int64_t)memorySizeWithState:(MemoryState)state {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    int64_t result = -1;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS){
        return result;
    }
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS){
        return result;
    }
    switch (state) {
        case  MemoryUsed:{
            result = page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
        }
            break;
        case  MemoryFree:{
            result = page_size * vm_stat.free_count;
        }
            break;
        case  MemoryActive:{
            result = page_size * vm_stat.active_count;
        }
            break;
        case  MemoryInactive:{
            result = page_size * vm_stat.inactive_count;
        }
            break;
        case  MemoryWired:{
            result = page_size * vm_stat.wire_count;
        }
            break;
        case  MemoryPurgable:{
            result = page_size * vm_stat.purgeable_count;
        }
            break;
        default:
            break;
    }
    return result;
}

+ (NSString *)getMemorysWithSpaceState:(SpaceState)State{
    struct mstats stat = mstats();
    unsigned long long memory;
    switch (State) {
        case SpaceUsed:
            memory = stat.bytes_used;
            break;
        case SpaceFree:
            memory = stat.bytes_free;
            break;
        default:
            memory = stat.bytes_total;
            break;
    }
    return [NSByteCountFormatter stringFromByteCount:memory countStyle:NSByteCountFormatterCountStyleMemory];
}

+ (NSString *)batteryLevel{
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    float batteryLevel = device.batteryLevel;
    return batteryLevel != -1 ? [NSString stringWithFormat:@"%ld%%",(long)(batteryLevel * 100)] : @"Unknown";
}

+ (BOOL)hasCamera{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (NSUInteger)totalMemory{
    return [self getSysInfo:HW_PHYSMEM];
}

+ (NSUInteger)ramSize{
    return [self getSysInfo:HW_MEMSIZE];
}

+ (int64_t)memoryTotal {
    int64_t mem = [[NSProcessInfo processInfo] physicalMemory];
    if (mem < -1){
        mem = -1;
    }
    return mem;
}

+ (NSUInteger)userMemory{
    return [self getSysInfo:HW_USERMEM];
}

+ (NSString *)getDiskSpaceWithSpaceState:(SpaceState)state{
    int64_t result = [self diskSpaceWithSpaceState:state];
    NSString *space;
    if (result != -1) {
        space = [NSByteCountFormatter stringFromByteCount:result countStyle:NSByteCountFormatterCountStyleFile];
    }else{
        space = @"0.0 GB";
    }
    return space;
}

+ (int64_t)diskSpaceWithSpaceState:(SpaceState)state{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    int64_t space = -1;
    if (!error){
        if (state == SpaceTotal) {
            space = [[attrs objectForKey:NSFileSystemSize] longLongValue];
        }else if (state == SpaceFree) {
            space = [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
        }else if (state == SpaceUsed) {
            int64_t total = [self diskSpaceWithSpaceState:SpaceTotal];
            int64_t free = [self diskSpaceWithSpaceState:SpaceFree];
            if (total > 0 && free > 0){
                space = total - free;
            }
        }
        if (space < 0){
            space = -1;
        }
    }
    return space;
}

+ (NSString *)macAddress{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm; // 从sysctl和路由套接字的接口中获取信息使用的消息格式
    struct sockaddr_dl  *sdl; // 一个链路层的sockaddr结构
    
    mib[0] = CTL_NET; /* network, see socket.h */
    mib[1] = AF_ROUTE; /* Internal Routing Protocol */
    mib[2] = 0;
    mib[3] = AF_LINK; /* Link layer interface */
    mib[4] = NET_RT_IFLIST; /* survey interface list */
    
    if((mib[5] = if_nametoindex("en0")) == 0){
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if(sysctl(mib, 6, NULL, &len, NULL, 0) < 0){
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if((buf = malloc(len)) == NULL){
        printf("Could not allocate memory. Rrror!\n");
        return NULL;
    }
    
    if(sysctl(mib, 6, buf, &len, NULL, 0) < 0){
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    // NSString *outstring = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X",
    //                       *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+ (void)changeOrientation:(UIInterfaceOrientation)orientation{
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[self currentDevice]];
    NSInteger val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}

+ (void)ba_deviceInterfaceOrientation:(UIInterfaceOrientation)orientation{
    // arc下
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]){
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        NSInteger val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

+ (NSString *)getDeviceOS{
    return [NSString stringWithFormat:@"%@%f", [UIDevice currentDevice].systemName, [self systemVersion]];
}

+ (NSString *)getDeviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithUTF8String:systemInfo.machine];
}

+ (NSString *)getIPAddress{
    NSString *ipAddress = @"0.0.0.0";
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    if (getifaddrs(&addrs) == 0) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0){
                if (strcmp(cursor->ifa_name, "en0") == 0) {
                    char *zIPAddress = inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr);
                    if (zIPAddress) {
                        ipAddress = [NSString stringWithUTF8String:zIPAddress];
                        break;
                    }
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return ipAddress;
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop){
        address = addresses[key];
        //筛选出IP地址格式
        if([address isValidatIP]){
            *stop = YES;
        }
    }];
    return address ? address : @"0.0.0.0";
}

+ (NSString *)getWaiWangIPAddress{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"%@",ip);
    if ([ip rangeOfString:@"var returnCitySN = "].location != NSNotFound) {
        ip = [[ip componentsSeparatedByString:@"var returnCitySN = "] lastObject];
        ip = [[ip componentsSeparatedByString:@";"] firstObject];
        NSDictionary *dic = [NSString dictionaryWithJsonString:ip];
        ip = dic[@"cip"];
    } else {
        ip = @"0.0.0.0";
    }
    NSLog(@"%@",ip);
    return ip;
}

+ (NSDictionary *)getIPAddresses{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

+ (NSString *)currentWifiSSID{
#if TARGET_OS_SIMULATOR
    return @"(simulator)";
#else
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    NSString *ssid = [dctySSID objectForKey:@"SSID"] ;
    return ssid;
#endif
}

+ (NSString *)lookupHostIPAddressForURL:(NSURL *)url{
    NSLock *lock = [[NSLock alloc] init];
    [lock lock];
    // Ask the unix subsytem to query the DNS
    struct hostent *remoteHostEnt = gethostbyname([[url host] UTF8String]);
    // Get address info from host entry
    struct in_addr *remoteInAddr = (struct in_addr *) remoteHostEnt->h_addr_list[0];
    // Convert numeric addr to ASCII string
    char *sRemoteInAddr = inet_ntoa(*remoteInAddr);
    // hostIP
    NSString* hostIP = [NSString stringWithUTF8String:sRemoteInAddr];
    [lock unlock];
    return hostIP;
}

+ (NSString *)wifiName {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    return info[@"SSID"];
}

+ (NSString *)getWifiName{
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    return wifiName;
}

+ (NSString *)getIPWithHostName:(const NSString *)hostName{
    const char *hostN = [hostName UTF8String];
    struct hostent *phot;
    @try {
        phot = gethostbyname(hostN);
    }
    @catch (NSException *exception) {
        return nil;
    }
    struct in_addr ip_addr;
    memcpy(&ip_addr, phot->h_addr_list[0], 4);
    char ip[20] = {0};
    inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    NSString *strIPAddress = [NSString stringWithUTF8String:ip];
    return strIPAddress;
}

+ (Boolean)haveNet {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    return type;
}

+ (float)batteryQuantity {
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    return [[UIDevice currentDevice] batteryLevel];
}

+ (uint64_t)getNetworkTrafficBytes:(NetworkTrafficType)types {
    static dispatch_semaphore_t lock;
    static NSMutableDictionary *sharedInCounters;
    static NSMutableDictionary *sharedOutCounters;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInCounters = [[NSMutableDictionary alloc] init];
        sharedOutCounters = [[NSMutableDictionary alloc] init];
        lock = dispatch_semaphore_create(1);
    });
    
    net_interface_counter counter = {0};
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    if (getifaddrs(&addrs) == 0) {
        cursor = addrs;
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        while (cursor) {
            if (cursor->ifa_addr->sa_family == AF_LINK) {
                const struct if_data *data = cursor->ifa_data;
                NSString *name = cursor->ifa_name ? [NSString stringWithUTF8String:cursor->ifa_name] : nil;
                if (name) {
                    uint64_t counter_in = ((NSNumber *)sharedInCounters[name]).unsignedLongLongValue;
                    counter_in = [self net_counter_add:counter_in bytes:data->ifi_ibytes];
                    sharedInCounters[name] = @(counter_in);
                    uint64_t counter_out = ((NSNumber *)sharedOutCounters[name]).unsignedLongLongValue;
                    counter_out = [self net_counter_add:counter_out bytes:data->ifi_obytes];
                    sharedOutCounters[name] = @(counter_out);
                    if ([name hasPrefix:@"en"]) {
                        counter.en_in += counter_in;
                        counter.en_out += counter_out;
                    } else if ([name hasPrefix:@"awdl"]) {
                        counter.awdl_in += counter_in;
                        counter.awdl_out += counter_out;
                    } else if ([name hasPrefix:@"pdp_ip"]) {
                        counter.pdp_ip_in += counter_in;
                        counter.pdp_ip_out += counter_out;
                    }
                }
            }
            cursor = cursor->ifa_next;
        }
        dispatch_semaphore_signal(lock);
        freeifaddrs(addrs);
    }
    return [self net_counter_get_by_type:&counter type:types];
}

+ (uint64_t)net_counter_get_by_type:(net_interface_counter *)counter type:(NetworkTrafficType)type {
    uint64_t bytes = 0;
    if (type & NetworkTrafficTypeWWANSent){
        bytes += counter->pdp_ip_out;
    }else if (type & NetworkTrafficTypeWWANReceived){
        bytes += counter->pdp_ip_in;
    }else if (type & NetworkTrafficTypeWIFISent){
        bytes += counter->en_out;
    }else if (type & NetworkTrafficTypeWIFIReceived){
        bytes += counter->en_in;
    }else if (type & NetworkTrafficTypeAWDLSent){
        bytes += counter->awdl_out;
    }else if (type & NetworkTrafficTypeAWDLReceived){
        bytes += counter->awdl_in;
    }
    return bytes;
}

+ (uint64_t)net_counter_add:(uint64_t)counter bytes:(uint64_t)bytes {
    if (bytes < (counter % 0xFFFFFFFF)) {
        counter += 0xFFFFFFFF - (counter % 0xFFFFFFFF);
        counter += bytes;
    } else {
        counter = bytes;
    }
    return counter;
}

+ (long long)getCurrentInterfaceBytes {
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) {
        return 0;
    }
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family){
            continue;
        }
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING)){
            continue;
        }
        if (ifa->ifa_data == 0){
            continue;
        }
        /* Not a loopback device. */
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
        }
    }
    freeifaddrs(ifa_list);
    NSLog(@"\n[getInterfaceBytes-Total]%d,%d",iBytes,oBytes);
    return iBytes + oBytes;
}

+ (LLNetworkStatus)networkStateFromStatebar {
    __block LLNetworkStatus returnValue = LLNetworkStatusNotReachable;
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            returnValue = [self networkStateFromStatebar];
        });
        return returnValue;
    }
    UIView *statusBarModern = [UIView getUIStatusBarModern];
    if (@available(iOS 13.0, *)) {
#ifdef __IPHONE_13_0
        if (statusBarModern) {
            // _UIStatusBarDataCellularEntry
            id currentData = [[statusBarModern valueForKeyPath:@"_statusBar"] valueForKeyPath:@"currentData"];
            id _wifiEntry = [currentData valueForKeyPath:@"wifiEntry"];
            id _cellularEntry = [currentData valueForKeyPath:@"cellularEntry"];
            if (_wifiEntry && [[_wifiEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                // If wifiEntry is enabled, is WiFi.
                returnValue = LLNetworkStatusReachableViaWiFi;
            } else if (_cellularEntry && [[_cellularEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                NSNumber *type = [_cellularEntry valueForKeyPath:@"type"];
                if (type != nil) {
                    switch (type.integerValue) {
                        case 5:
                            returnValue = LLNetworkStatusReachableViaWWAN4G;
                            break;
                        case 4:
                            returnValue = LLNetworkStatusReachableViaWWAN3G;
                            break;
                            //                        case 1: // Return 1 when 1G.
                            //                            break;
                        case 0:
                            // Return 0 when no sim card.
                            returnValue = LLNetworkStatusNotReachable;
                        default:
                            returnValue = LLNetworkStatusReachableViaWWAN;
                            break;
                    }
                }
            }
        }
#endif
    } else {
        if ([statusBarModern isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
            // For iPhoneX
            NSArray *children = [[[statusBarModern valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
            for (UIView *view in children) {
                for (id child in view.subviews) {
                    if ([child isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                        returnValue = LLNetworkStatusReachableViaWiFi;
                        break;
                    }
                    if ([child isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
                        NSString *originalText = [child valueForKey:@"_originalText"];
                        if ([originalText containsString:@"G"]) {
                            if ([originalText isEqualToString:@"2G"]) {
                                returnValue = LLNetworkStatusReachableViaWWAN2G;
                            } else if ([originalText isEqualToString:@"3G"]) {
                                returnValue = LLNetworkStatusReachableViaWWAN3G;
                            } else if ([originalText isEqualToString:@"4G"]) {
                                returnValue = LLNetworkStatusReachableViaWWAN4G;
                            } else {
                                returnValue = LLNetworkStatusReachableViaWWAN;
                            }
                            break;
                        }
                    }
                }
                if (returnValue != LLNetworkStatusNotReachable) {
                    break;
                }
            }
        } else {
            // For others iPhone
            NSArray *children = [[statusBarModern valueForKeyPath:@"foregroundView"] subviews];
            int type = -1;
            for (id child in children) {
                if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                    type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
                }
            }
            switch (type) {
                case 0:
                    returnValue = LLNetworkStatusNotReachable;
                    break;
                case 1:
                    returnValue = LLNetworkStatusReachableViaWWAN2G;
                    break;
                case 2:
                    returnValue = LLNetworkStatusReachableViaWWAN3G;
                    break;
                case 3:
                    returnValue = LLNetworkStatusReachableViaWWAN4G;
                    break;
                case 4:
                    returnValue = LLNetworkStatusReachableViaWWAN;
                    break;
                case 5:
                    returnValue = LLNetworkStatusReachableViaWiFi;
                    break;
            }
        }
    }
    return returnValue;
}

/// 获取电话运营商信息
+ (NSString *)telephonyInfo {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier carrierName]];
    return mCarrier;
}

@end
