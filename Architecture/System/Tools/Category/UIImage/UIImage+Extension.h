
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <ImageIO/ImageIO.h>

@interface UIImage (Extension)

/**
 *  根据指定bundle中的文件名读取图片
 *
 *  @param name 图片名
 *  @param path bundle中的相对路径
 *  @return 无缓存的图片
 */
+ (UIImage *)pd_imageWithFileName:(NSString *)name
                     inBundlePath:(NSString *)path;

#pragma mark - 生成一个颜色可缩放图像
+ (UIImage *)imageWithColor:(UIColor *)fillColor;

#pragma mark - 生成一个平面颜色圆角可缩放图像
/**
 @param fillColor    背景填充色
 @param cornerRadius 圆角半径
 @param cornerColor  圆角被截取部分填充色
 */
+ (UIImage *)imageWithColor:(UIColor *)fillColor
               cornerRadius:(CGFloat)cornerRadius
                cornerColor:(UIColor *)cornerColor;

#pragma mark - 生成具有边框的平面颜色圆角可缩放图像
/**
 @param fillColor    背景填充色
 @param cornerRadius 圆角半径
 @param cornerColor  圆角被截取部分填充色
 @param borderColor  边框颜色
 @param borderWidth  边框宽度
 */
+ (UIImage *)imageWithColor:(UIColor *)fillColor
               cornerRadius:(CGFloat)cornerRadius
                cornerColor:(UIColor *)cornerColor
                borderColor:(UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth;

#pragma mark - 生成具有边框的平面颜色圆角可缩放图像
/**
 @param fillColor       背景填充色
 @param cornerRadius    圆角半径
 @param cornerColor     圆角被截取部分填充色
 @param borderColor     边框颜色
 @param borderWidth     边框宽度
 @param roundedCorners  设置圆角个数 和 位置 (UIRectCornerTopLeft | UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerBottomLeft)
 @param scale           每个点的缩放像素密度. 设置 0 为和当前屏幕一样.
 */
+ (UIImage *)imageWithColor:(UIColor *)fillColor
               cornerRadius:(CGFloat)cornerRadius
                cornerColor:(UIColor *)cornerColor
                borderColor:(UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth
             roundedCorners:(UIRectCorner)roundedCorners
                      scale:(CGFloat)scale;

//截屏整个屏幕（window） scale默认传0
+ (UIImage *)screenshotWithScale:(CGFloat)scale;

//传入一个View截图成一个图片
+ (UIImage *)captureWithView:(UIView *)view;

/**
 *  @author Jakey
 *  @brief  截图一个view中所有视图 包括旋转缩放效果
 *  @param maxWidth 限制缩放的最大宽度 保持默认传0
 *  @return 截图
 */
+ (UIImage *)screenshot:(CGFloat)maxWidth
                   view:(UIView *)aView;

/**
 *  @brief  截图一个view中所有视图 包括旋转缩放效果
 *  @param aView    指定的view
 *  @param maxWidth 宽的大小 0为view默认大小
 *  @return 截图
 */
+ (UIImage *)screenshotWithView:(UIView *)aView
                     limitWidth:(CGFloat)maxWidth;

/**
 *  在图片中截取一个范围图片
 *
 *  @param rect 裁切范围
 *  @param image 需要裁切的图片
 *  @return 图片
 */
+ (UIImage *)pd_captureAtRect:(CGRect)rect
                    fromImage:(UIImage *)image;

/*!
 *  @brief 使图片压缩后小于指定大小，把照片保存到本地后能看到图片的压缩大小
 *  保存图片到本地的方法
 *  NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:@"MyImage"];
    [UIImageJPEGRepresentation(tempImage, 1) writeToFile:imageFilePath  atomically:YES];
 *
 *  @param image 当前要压缩的图 maxBytes 压缩后的大小
 *  1kb = 1000B;
 *  1MB = 1000kb;
 *
 *  @return 图片对象
 */
//图片质量压缩到某一范围内，如果后面用到多，可以抽成分类或者工具类,这里压缩递减比二分的运行时间长，二分可以限制下限。
//maxBytes:默认为60000
+ (NSData *)compressOriginalImage:(UIImage *)image;
+ (NSData *)compressOriginalImage:(UIImage *)image
              toMaxDataSizeBytes:(CGFloat)maxBytes;

/*!
 *  图片的压缩方法
 *
 *  @param sourceImage   要被压缩的图片
 *  @param defineWidth 要被压缩的尺寸(宽)
 *
 *  @return 被压缩的图片
 */
+ (UIImage *)ba_IMGCompressed:(UIImage *)sourceImage
                  targetWidth:(CGFloat)defineWidth;

//保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image
                                       size:(CGSize)asize;

/**
 *  压缩图片到指定文件大小
 *
 *  @param sourceImage 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage
                       targetSize:(CGSize)size;

//图片处理-强制解压缩操作-把元数据绘制到当前的上下文-压缩图片
+ (UIImage *)imageDetail:(UIImage *)image;

//图像裁剪和缩放大小
- (UIImage *)imageCroppedAndScaledToSize:(CGSize)size
                             contentMode:(UIViewContentMode)contentMode
                                padToFit:(BOOL)padToFit;

/**
 *  传入图片,需要的大小,比例,得到压缩图片大小
 *
 *      @prama image 需要压缩的图片
 *      @prama size  压缩后图片的大小
 *      @prama scale 压缩的比例 0.0 - 1.0
 *
 *      @return 返回新的图片
 */
+ (UIImage *)needCompressImage:(UIImage *)image
                          size:(CGSize)size
                         scale:(CGFloat)scale;
+ (UIImage *)needCompressImageData:(NSData *)imageData
                              size:(CGSize)size
                             scale:(CGFloat)scale;

/**
 *  传入图片,需要的大小,比例,得到压缩图片大小
 *
 *      @prama imageSize 气泡图片大小
 *      @prama image  气泡背景图片
 *      @prama isSender 是发送的还是接收的消息
 *
 *      @return 返回气泡图片
 */
+ (UIImage *)makeArrowImageWithSize:(CGSize)imageSize
                              image:(UIImage *)image
                           isSender:(BOOL)isSender;

/*!
 *  icon        要裁剪的图片
 *  borderWith  头像边框的宽度
 *  borderColor 边框的颜色
 */
+ (instancetype)ba_image:(UIImage *)image
              borderWith:(CGFloat)borderWith
             borderColor:(UIColor *)borderColor;

/*
 UIImage *animation = [UIImage animatedImageWithAnimatedGIFData:theData];
 I interpret `theData` as a GIF.  I create an animated `UIImage` using the source images in the GIF.
 
 The GIF stores a separate duration for each frame, in units of centiseconds (hundredths of a second).  However, a `UIImage` only has a single, total `duration` property, which is a floating-point number.
 
 To handle this mismatch, I add each source image (from the GIF) to `animation` a varying number of times to match the ratios between the frame durations in the GIF.
 
 For example, suppose the GIF contains three frames.  Frame 0 has duration 3.  Frame 1 has duration 9.  Frame 2 has duration 15.  I divide each duration by the greatest common denominator of all the durations, which is 3, and add each frame the resulting number of times.  Thus `animation` will contain frame 0 3/3 = 1 time, then frame 1 9/3 = 3 times, then frame 2 15/3 = 5 times.  I set `animation.duration` to (3+9+15)/100 = 0.27 seconds.
 */
+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)theData;

/*
 UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:theURL];
 
 I interpret the contents of `theURL` as a GIF.  I create an animated `UIImage` using the source images in the GIF.
 
 I operate exactly like `+[UIImage animatedImageWithAnimatedGIFData:]`, except that I read the data from `theURL`.  If `theURL` is not a `file:` URL, you probably want to call me on a background thread or GCD queue to avoid blocking the main thread.
 */
+ (UIImage *)animatedImageWithAnimatedGIFURL:(NSURL *)theURL;

/**
 *  根据图片url获取图片尺寸
 */
+ (CGSize)getImageSizeWithURL:(id)URL;

/**
 *  @brief  角度转弧度
 *  @param degrees 角度
 *  @return 弧度
 */
+ (CGFloat)degreesToRadians:(CGFloat)degrees;

/**
 *  @brief  弧度转角度
 *
 *  @param radians 弧度
 *
 *  @return 角度
 */
+ (CGFloat)radiansToDegrees:(CGFloat)radians;

/**
 *  @brief  旋转图片
 *  @param degrees 角度
 *  @return 旋转后图片
 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/**
 *  @brief  旋转图片
 *  @param radians 弧度
   @param fitSize YES：新图片的大小被扩展到适合所有内容。
                   NO：图片的大小不会改变，内容可能会被剪裁。
 *  @return 旋转后图片
 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians
                           fitSize:(BOOL)fitSize;

/**
 *  @brief              翻转
 *  @param horizontal  水平翻转
    @param vertical    垂直翻转
 *  @return            翻转后图片
 */
- (UIImage *)flipHorizontal:(BOOL)horizontal
                   vertical:(BOOL)vertical;

//阴影颜色和阴影的偏移量
- (UIImage *)imageWithShadowColor:(UIColor *)color
                           offset:(CGSize)offset
                             blur:(CGFloat)blur;

//传入图片或者GIF图片名
+ (UIImage *)sd_animatedGIFNamed:(NSString *)name;
+ (UIImage *)sd_animatedGIFWithData:(NSData *)data;

/**
 *  @brief  倒影
 */
+ (void)reflectWithImageView:(UIImageView *)imageView;

/**
 *  @brief  渐变图片
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param height 渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIImage *)gradientFromColor:(UIColor *)c1
                       toColor:(UIColor *)c2
                    withHeight:(int)height;

/**
 *   改变图片背景为白色
 *
 *  @param image 图片源
 *
 *  @return 返回更改过背景后的图片
 */
+ (UIImage *)imageToTransparent:(UIImage *)image;

/**
 *  改变图片的透明度
 *
 *  @param alpha 透明度
 *  @param image 图片源
 *
 *  @return 返回透明度变化后的图片
 */
+ (UIImage *)changeAlphaOfImageWith:(CGFloat)alpha
                          withImage:(UIImage *)image;

/**
  对图片进行模糊处理 Blurred images
 // CIGaussianBlur ---> 高斯模糊
 // CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)
 // CIDiscBlur    ---> 环形卷积模糊(Available in iOS 9.0 and later)
 // CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
 // CIMotionBlur  ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
 */
+ (UIImage *)blurWithOriginalImage:(UIImage *)image
                          blurName:(NSString *)name
                            radius:(NSInteger)radius;

/**
 *  高斯模糊
 *
 *  @param view   view
 *  @param radius radius
 *  @param size   size
 *
 *  @return image
 */
+ (UIImage *)imageWithView:(UIView *)view
                    radius:(CGFloat)radius
                      size:(CGSize)size;

/**
 *  生成一张高斯模糊的图片
 *
 *  @param image 原图
 *  @param blur  模糊程度 (0~1)
 *
 *  @return 高斯模糊图片
 */
+ (UIImage *)xlsn0w_getBlurImage:(UIImage *)image
                            blur:(CGFloat)blur;

/**
  对图片进行滤镜处理  To filter the image
 // 怀旧 --> CIPhotoEffectInstant                        单色 --> CIPhotoEffectMono
 // 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
 // 色调 --> CIPhotoEffectTonal                          冲印 --> CIPhotoEffectProcess
 // 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
 // CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
 */
+ (UIImage *)filterWithOriginalImage:(UIImage *)image
                          filterName:(NSString *)name;

/**
  调整图片饱和度, 亮度, 对比度 Adjust the picture saturation, brightness, contrast
 @param image 目标图片
 @param saturation 饱和度
 @param brightness 亮度   -1.0 ~ 1.0
 @param contrast 对比度
 */
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast;

//webView 导出图片调用的方法,
- (UIImage *)imageSnapshotWithWebView:(UIView *)webView;

/**
 *  @brief  是否有alpha通道，返回该图片是否有透明度通道
 *
 *  @return 是否有alpha通道，是否有透明度通道
 */
- (BOOL)hasAlpha;

/**
 *  @brief  如果没有alpha通道 增加alpha通道
 *
 *  @return 如果没有alpha通道 增加alpha通道
 */
- (UIImage *)imageWithAlpha;

/**
 *  @brief  删除alpha通道并返回图片
 *
 *  @return 删除alpha通道
 */
- (UIImage *)removeAlpha;

//计算图片大小
+ (NSUInteger)imageSize:(UIImage *)image;

//灰度图片,把图片变成黑白的
+ (UIImage *)grayImage:(UIImage *)image;

//图片调色
+ (UIImage *)setRGBImage:(UIImage *)image R:(CGFloat)rk G:(CGFloat)gk B:(CGFloat)bk;

@end
