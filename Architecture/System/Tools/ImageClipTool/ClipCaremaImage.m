//
//  ClipCaremaImage.m
//  HHWallet
//
//  Created by 华令冬 on 2019/12/3.
//  Copyright © 2019 com.cn.HLD. All rights reserved.
//

#import "ClipCaremaImage.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ClipCaremaImage()

@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic,strong) AVCaptureStillImageOutput *imageOutput;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *VPlayer;
@property (nonatomic,strong) AVCaptureDevice *captureDevice;

@end

@implementation ClipCaremaImage

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        //相机权限无权限访问
        if (authStatus == AVAuthorizationStatusRestricted ||
            authStatus == AVAuthorizationStatusDenied) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"app需用您打开相机权限"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        }
        self.captureSession = [[AVCaptureSession alloc] init];
        [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
        [device lockForConfiguration:nil];
        //设置闪光灯为自动
        [device setFlashMode:AVCaptureFlashModeAuto];
        [device unlockForConfiguration];
        
        self.deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
        AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
        self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
        //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
        NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
        [self.imageOutput setOutputSettings:outputSettings];
        
        if ([self.captureSession canAddInput:self.deviceInput]) {
            [self.captureSession addInput:self.deviceInput];
        }
        if ([self.captureSession canAddOutput:captureOutput]) {
            [self.captureSession addOutput:captureOutput];
        }
        if ([self.captureSession canAddOutput:self.imageOutput]) {
            [self.captureSession addOutput:self.imageOutput];
        }
        //初始化预览图层
        self.VPlayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        [self.VPlayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [self.layer addSublayer:self.VPlayer];
        self.VPlayer.frame = [self makeScanReaderInterrestRect];
    }
    return self;
}

/*
 返回中间框大小
 */
- (CGRect)makeScanReaderInterrestRect {
    CGRect scanRect = CGRectMake(CaremX, CaremY, CaremWIDTH, CaremHIGHT);
    return scanRect;
}

/*
 拍照事件
 */
- (void)takePhotoWithCommit:(void (^)(UIImage *image))commitBlock {
        AVCaptureConnection *stillImageConnection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    AVCaptureVideoOrientation avcaptureOrientation = AVCaptureVideoOrientationPortrait;
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:1.0];
    
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *tempImage = [UIImage imageWithData:imageData];
        
        //截取照片，截取到自定义框内的照片
         UIImage *imageIm = [self image:tempImage scaleToSize:CGSizeMake([BaseTools screenWidth], [BaseTools screenHeight])];
         //应为在展开相片时放大的两倍，截取时也要放大两倍
        if ([[UIApplication sharedApplication] statusBarFrame].size.height == 44.0f) {
            imageIm = [self imageFromImage:imageIm inRect:CGRectMake(CaremX - Adapted(30), [BaseTools screenHeight] - CaremHIGHT - Adapted(51), CaremWIDTH * 2 + Adapted(54), CaremHIGHT * 2 + Adapted(104))];
        }else{
            imageIm = [self imageFromImage:imageIm inRect:CGRectMake(CaremX - Adapted(10), [BaseTools screenHeight] - CaremHIGHT - Adapted(10), CaremWIDTH * 2 + Adapted(51), CaremHIGHT * 2 + Adapted(20))];
        }
        commitBlock(imageIm);
    }];
}

//截取图片
- (UIImage *)image:(UIImage *)imageI scaleToSize:(CGSize)size{
   /*
    UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale)
    CGSize size：指定将来创建出来的bitmap的大小
    BOOL opaque：设置透明YES代表透明，NO代表不透明
    CGFloat scale：代表缩放,0代表不缩放
    创建出来的bitmap就对应一个UIImage对象
    */
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0); //此处将画布放大两倍，这样在retina屏截取时不会影响像素
    [imageI drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)imageFromImage:(UIImage *)imageI inRect:(CGRect)rect{
    CGImageRef sourceImageRef = [imageI CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

- (void)startCamera{
    if (self.captureSession) {
        [self.captureSession startRunning];
    }
}

- (void)stopCamera {
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //引导开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)dealloc{
    [self stopCamera];
}

@end
