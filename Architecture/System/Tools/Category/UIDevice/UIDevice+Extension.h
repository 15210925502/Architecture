
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MemoryState) {
    MemoryUsed            = 0,         //字节中正在使用（活动+不活动+有限）内存. (-1 when error occurs)
    MemoryFree,                        //字节中的空闲内存
    MemoryActive,                      //字节中的活动内存
    MemoryInactive,                    //字节中的非活动内存
    MemoryWired,                       //字节中的有限内存
    MemoryPurgable                     //可清除的字节内存
};

typedef NS_ENUM(NSInteger, SpaceState) {
    SpaceUsed            = 0,         //文件系统使用空间
    SpaceFree,                        //文件系统剩余空间
    SpaceTotal                        //文件系统总空间
};

/**
 网络流量类型：
   WWAN：无线广域网。例如：3G / 4G
   WIFI：Wi-Fi
   AWDL：Apple Wireless Direct Link（点对点连接）例如：AirDrop, AirPlay, GameKit
 */
typedef NS_OPTIONS(NSUInteger, NetworkTrafficType) {
    NetworkTrafficTypeWWANSent     = 1 << 0,
    NetworkTrafficTypeWWANReceived = 1 << 1,
    NetworkTrafficTypeWIFISent     = 1 << 2,
    NetworkTrafficTypeWIFIReceived = 1 << 3,
    NetworkTrafficTypeAWDLSent     = 1 << 4,
    NetworkTrafficTypeAWDLReceived = 1 << 5,
    NetworkTrafficTypeWWAN = NetworkTrafficTypeWWANSent | NetworkTrafficTypeWWANReceived,
    NetworkTrafficTypeWIFI = NetworkTrafficTypeWIFISent | NetworkTrafficTypeWIFIReceived,
    NetworkTrafficTypeAWDL = NetworkTrafficTypeAWDLSent | NetworkTrafficTypeAWDLReceived,
    NetworkTrafficTypeALL = NetworkTrafficTypeWWAN | NetworkTrafficTypeWIFI | NetworkTrafficTypeAWDL
};

typedef NS_ENUM(NSUInteger, LLNetworkStatus) {
    LLNetworkStatusNotReachable = 0,
    LLNetworkStatusReachableViaWiFi,
    LLNetworkStatusReachableViaWWAN,
    LLNetworkStatusReachableViaWWAN2G,
    LLNetworkStatusReachableViaWWAN3G,
    LLNetworkStatusReachableViaWWAN4G
};

typedef struct {
    uint64_t en_in;
    uint64_t en_out;
    uint64_t pdp_ip_in;
    uint64_t pdp_ip_out;
    uint64_t awdl_in;
    uint64_t awdl_out;
} net_interface_counter;

@interface UIDevice (Extension)

/**
 *  返回平台设备
 */
+ (NSString *)devicePlatform;

/**
 *  返回平台设备字符串
 */
+ (NSString *)devicePlatformString;

/**
 *  设备的屏幕分辨率
 */
+ (NSString *)screenResolution;

#pragma mark 该设备是否越狱.
+ (BOOL)isJailbroken;

/**
 *  检查是否是IPAD
 */
+ (BOOL)isiPad;

/**
 *  检查是否是iPhone
 */
+ (BOOL)isiPhone;

/**
 *  检查是否是iPod
 */
+ (BOOL)isiPod;

/**
 *  检查是否是simulator
 */
+ (BOOL)isSimulator;

/**
 *  检查是否是a Retina display
 */
+ (BOOL)isRetina;

/**
 *  检查是否是a Retina HD display
 */
+ (BOOL)isRetinaHD;

/**
*  获取手机电池电量百分比
*/
+ (NSString *)batteryLevel;

/**
 *  系统版本语言
 */
+ (NSString *)languageCode;

/**
 *  系统版本
 */
+ (CGFloat)systemVersion;

/**
 *  返回手机名称
 */
+ (NSString *)deviceName;

/**
 *  返回CPU频率
 */
+ (NSUInteger)cpuFrequency;

/**
 *  返回的CPU使用率
 */
+ (float)cpuUsage;

#pragma mark 目前的CPU使用率，1.0意味着100％。 (-1 when error occurs)
+ (float)currentCpuUsage;

#pragma mark 当前每个处理器的CPU使用率（NSNumber数组），1.0表示100％。 (nil when error occurs)
+ (NSArray *)cpuUsagePerProcessor;

//CPU类型
+ (NSString *)cpuType;

/**
 *  返回CPU数
 */
+ (NSUInteger)cpuNumber;

#pragma mark 可用的CPU处理器数量.
+ (NSUInteger)cpuCount;

/**
 *  返回总线频率
 */
+ (NSUInteger)busFrequency;

/** 是否有摄像头 */
+ (BOOL)hasCamera;

//内存
//返回物理内存大小
+ (NSUInteger)ramSize;
//总物理内存
+ (int64_t)memoryTotal;
//返回总内存
+ (NSUInteger)totalMemory;
//返回非内核内存
+ (NSUInteger)userMemory;
//内存的大小,可用内存大小等
+ (int64_t)memorySizeWithState:(MemoryState)state;

//获取内存内存大小
+ (NSString *)getMemorysWithSpaceState:(SpaceState)State;

//硬盘
#pragma mark 字节中的总磁盘空间. (-1 when error occurs)
//获取硬盘控件大小
+ (NSString *)getDiskSpaceWithSpaceState:(SpaceState)state;

/**
 *  返回当前设备的mac地址
 */
+ (NSString *)macAddress;

/**
 *  @brief:取得当前的ip地址,这种方法拿到的ip地址，仅限于wifi情况下拿到ip，如果手机是处于4G或3G状态，拿不到ip。
 */
+ (NSString *)getIPAddress;
/****************************
函数描述：获取IP地址，比上个方法高级，4G或3G状态可以拿到ip
输入参数：是否Ipv4的IP
输出参数：IP地址
****************************/
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
//获取外网ip地址
+ (NSString *)getWaiWangIPAddress;
//获取所有相关IP信息
+ (NSDictionary *)getIPAddresses;

+ (NSString *)currentWifiSSID;

+ (NSString *)lookupHostIPAddressForURL:(NSURL *)url;

#pragma mark - 取得当前网速
+ (long long)getCurrentInterfaceBytes;

/**
 *  @brief:取得当前的wifi名
 */
+ (NSString *)wifiName;
+ (NSString *)getWifiName;

+ (NSString *)getIPWithHostName:(const NSString *)hostName;

/**是否有网*/
+ (Boolean)haveNet;

#pragma mark - 电池 信息
+ (float)batteryQuantity;

/*! 调用私有方法实现强制屏幕旋转 */
+ (void)changeOrientation:(UIInterfaceOrientation)orientation;

/*!
 *  强制锁定屏幕方向
 *  @param orientation 屏幕方向
 */
+ (void)ba_deviceInterfaceOrientation:(UIInterfaceOrientation)orientation;

/**
 *  @brief:设备相关,取设备os信息，return sample: iOS7.1
 */
+ (NSString *)getDeviceOS;

/**
 *  @brief:设备相关,取设备信息，return sample :iPhone5,1
 */
+ (NSString *)getDeviceModel;

/**
 获取设备网络流量字节。
   @discussion 这是自设备上次启动以来的计数器。
   用法：
   uint64_t bytes = [[UIDevice currentDevice] getNetworkTrafficBytes：lgf_NetworkTrafficTypeALL];
   NSTimeInterval time = CACurrentMediaTime（）
   uint64_t bytesPerSecond =（bytes - _lastBytes）/（time - _lastTime）;
    _lastBytes = bytes;
    _lastTime = 时间;
   @param types 流量类型
   @return 字节计数器。
 */
+ (uint64_t)getNetworkTrafficBytes:(NetworkTrafficType)types;

//获取网络类型
+ (LLNetworkStatus)networkStateFromStatebar;

/// 获取电话运营商信息
+ (NSString *)telephonyInfo;

@end
