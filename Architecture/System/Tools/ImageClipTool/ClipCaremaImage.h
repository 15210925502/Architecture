//
//  ClipCaremaImage.h
//  HHWallet
//
//  Created by 华令冬 on 2019/12/3.
//  Copyright © 2019 com.cn.HLD. All rights reserved.
//

#import <UIKit/UIKit.h>

//比率
#define kScreenRatio      (UIScreen.mainScreen.bounds.size.width / 320.0f)
//宽和高
#define Adapted(value)    ceilf((value) * kScreenRatio)

#define CaremX       Adapted(10)
#define CaremY       Adapted(50)
#define CaremWIDTH   ([BaseTools screenWidth] - CaremX * 2)
#define CaremHIGHT   (CaremWIDTH / 1.6)

@interface ClipCaremaImage : UIView<UIAlertViewDelegate>

- (void)startCamera;
- (void)stopCamera;
- (void)takePhotoWithCommit:(void (^)(UIImage *image))commitBlock;

/*
返回中间框大小
*/
- (CGRect)makeScanReaderInterrestRect;

@end
