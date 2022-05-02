//
//  VerifyAppIsInstalled.h
//  Architecture
//
//  Created by HLD on 2022/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VerifyAppIsInstalled : NSObject

//判断手机是否已安装APP
+ (BOOL) verifyAppWithBundle:(NSString *)bundleID;

@end

NS_ASSUME_NONNULL_END
