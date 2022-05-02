
#import "UIImage+Extension.h"
#import <Accelerate/Accelerate.h>

#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)
#else
#define toCF (CFTypeRef)
#define fromCF (id)
#endif

typedef struct {
    UIRectCorner corners;
    CGFloat radius;
} PathKey;

static int pairGCD(int a, int b) {
    if (a < b)
        return pairGCD(b, a);
    while (true) {
        int const r = a % b;
        if (r == 0)
            return b;
        a = b;
        b = r;
    }
}

static void releaseImages(size_t const count, CGImageRef const images[count]) {
    for (size_t i = 0; i < count; ++i) {
        CGImageRelease(images[i]);
    }
}

@implementation UIImage (Extension)

+ (UIImage *)pd_imageWithFileName:(NSString *)name inBundlePath:(NSString *)path {
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"PDProject.bundle/%@/%@", path, name]];
    return image;
}

+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)data {
    CGImageSourceRef source = CGImageSourceCreateWithData(toCF data, NULL);
    if (source) {
        size_t const count = CGImageSourceGetCount(source);
        CGImageRef images[count];
        int delayCentiseconds[count];
        for (size_t i = 0; i < count; ++i) {
            images[i] = CGImageSourceCreateImageAtIndex(source, i, NULL);
            int delayCentisecond = 1;
            CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
            if (properties) {
                CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
                CFRelease(properties);
                if (gifProperties) {
                    CFNumberRef const number = CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
                    delayCentisecond = (int)lrint([fromCF number doubleValue] * 100);
                }
            }
            delayCentiseconds[i] = delayCentisecond;
        }
        int totalDurationCentiseconds = 0;
        for (size_t i = 0; i < count; ++i) {
            totalDurationCentiseconds += delayCentiseconds[i];
        }
        int gcd = delayCentiseconds[0];
        for (size_t i = 1; i < count; ++i) {
            gcd = pairGCD(delayCentiseconds[i], gcd);
        }
        size_t const frameCount = totalDurationCentiseconds / gcd;
        UIImage *frames1[frameCount];
        for (size_t i = 0, f = 0; i < count; ++i) {
            UIImage *const frame = [UIImage imageWithCGImage:images[i]];
            for (size_t j = delayCentiseconds[i] / gcd; j > 0; --j) {
                frames1[f++] = frame;
            }
        }
        NSArray *const frames = [NSArray arrayWithObjects:frames1 count:frameCount];
        UIImage *const image = [UIImage animatedImageWithImages:frames duration:(NSTimeInterval)totalDurationCentiseconds / 100.0];
        releaseImages(count, images);
        CFRelease(source);
        return image;
    } else {
        return nil;
    }
}

+ (UIImage *)animatedImageWithAnimatedGIFURL:(NSURL *)url {
    CGImageSourceRef source = CGImageSourceCreateWithData(toCF url, NULL);
    if (source) {
        size_t const count = CGImageSourceGetCount(source);
        CGImageRef images[count];
        int delayCentiseconds[count];
        for (size_t i = 0; i < count; ++i) {
            images[i] = CGImageSourceCreateImageAtIndex(source, i, NULL);
            int delayCentisecond = 1;
            CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
            if (properties) {
                CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
                CFRelease(properties);
                if (gifProperties) {
                    CFNumberRef const number = CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
                    delayCentisecond = (int)lrint([fromCF number doubleValue] * 100);
                }
            }
            delayCentiseconds[i] = delayCentisecond;
        }
        int totalDurationCentiseconds = 0;
        for (size_t i = 0; i < count; ++i) {
            totalDurationCentiseconds += delayCentiseconds[i];
        }
        int gcd = delayCentiseconds[0];
        for (size_t i = 1; i < count; ++i) {
            gcd = pairGCD(delayCentiseconds[i], gcd);
        }
        size_t const frameCount = totalDurationCentiseconds / gcd;
        UIImage *frames1[frameCount];
        for (size_t i = 0, f = 0; i < count; ++i) {
            UIImage *const frame = [UIImage imageWithCGImage:images[i]];
            for (size_t j = delayCentiseconds[i] / gcd; j > 0; --j) {
                frames1[f++] = frame;
            }
        }
        NSArray *const frames = [NSArray arrayWithObjects:frames1 count:frameCount];
        UIImage *const image = [UIImage animatedImageWithImages:frames duration:(NSTimeInterval)totalDurationCentiseconds / 100.0];
        releaseImages(count, images);
        CFRelease(source);
        return image;
    } else {
        return nil;
    }
}

- (UIImage *)removeAlpha{
    if(![self hasAlpha]){
        return self;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, self.size.width, self.size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    UIImage *returnImage = [UIImage imageWithCGImage:mainViewContentBitmapContext];
    CGImageRelease(mainViewContentBitmapContext);
    
    return returnImage;
}

+ (UIImage *)imageWithColor:(UIColor *)fillColor {
    return [self imageWithColor:fillColor
                   cornerRadius:0.0
                    cornerColor:nil
                    borderColor:nil
                    borderWidth:0.0
                 roundedCorners:UIRectCornerAllCorners
                          scale:0.0];
}

+ (UIImage *)imageWithColor:(UIColor *)fillColor
               cornerRadius:(CGFloat)cornerRadius
                cornerColor:(UIColor *)cornerColor {
    return [self imageWithColor:fillColor
                   cornerRadius:cornerRadius
                    cornerColor:cornerColor
                    borderColor:nil
                    borderWidth:1.0
                 roundedCorners:UIRectCornerAllCorners
                          scale:0.0];
}

+ (UIImage *)imageWithColor:(UIColor *)fillColor
               cornerRadius:(CGFloat)cornerRadius
                cornerColor:(UIColor *)cornerColor
                borderColor:(UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth {
    return [self imageWithColor:fillColor
                   cornerRadius:cornerRadius
                    cornerColor:cornerColor
                    borderColor:borderColor
                    borderWidth:borderWidth
                 roundedCorners:UIRectCornerAllCorners
                          scale:0.0];
}

+ (UIImage *)imageWithColor:(UIColor *)fillColor
               cornerRadius:(CGFloat)cornerRadius
                cornerColor:(UIColor *)cornerColor
                borderColor:(UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth
             roundedCorners:(UIRectCorner)roundedCorners
                      scale:(CGFloat)scale {
    static NSCache *__pathCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __pathCache = [[NSCache alloc] init];
        __pathCache.countLimit = 20;
    });
    
    if ([cornerColor isEqual:[UIColor clearColor]]) {
        cornerColor = nil;
    }
    
    CGFloat dimension = (cornerRadius * 2) + 1;
    CGRect bounds = CGRectMake(0, 0, dimension, dimension);
    PathKey key = {roundedCorners, cornerRadius};
    NSValue *pathKeyObject = [[NSValue alloc] initWithBytes:&key objCType:@encode(PathKey)];
    
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath *path = [__pathCache objectForKey:pathKeyObject];
    if (path == nil) {
        path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:roundedCorners cornerRadii:cornerRadii];
        [__pathCache setObject:path forKey:pathKeyObject];
    }
    UIGraphicsBeginImageContextWithOptions(bounds.size, cornerColor != nil, scale);
    BOOL contextIsClean = YES;
    if (cornerColor) {
        contextIsClean = NO;
        [cornerColor setFill];
        UIRectFillUsingBlendMode(bounds, kCGBlendModeCopy);
    }
    
    BOOL canUseCopy = contextIsClean || (CGColorGetAlpha(fillColor.CGColor) == 1);
    [fillColor setFill];
    [path fillWithBlendMode:(canUseCopy ? kCGBlendModeCopy : kCGBlendModeNormal) alpha:1];
    
    if (borderColor) {
        [borderColor setStroke];
        CGRect strokeRect = CGRectInset(bounds, borderWidth / 2.0, borderWidth / 2.0);
        UIBezierPath *strokePath = [UIBezierPath bezierPathWithRoundedRect:strokeRect
                                                         byRoundingCorners:roundedCorners
                                                               cornerRadii:cornerRadii];
        [strokePath setLineWidth:borderWidth];
        BOOL canUseCopy = (CGColorGetAlpha(borderColor.CGColor) == 1);
        [strokePath strokeWithBlendMode:(canUseCopy ? kCGBlendModeCopy : kCGBlendModeNormal) alpha:1];
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius);
    result = [result resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
    
    return result;
}

/**
 *  @brief  如果没有alpha通道 增加alpha通道
 *
 *  @return 如果没有alpha通道 增加alpha通道
 */
- (UIImage *)imageWithAlpha {
    if ([self hasAlpha]) {
        return self;
    }
    
    CGImageRef imageRef = self.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height, 8, 0, CGImageGetColorSpace(imageRef), kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
    
    // Clean up
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);
    
    return imageWithAlpha;
}

+ (NSData *)compressOriginalImage:(UIImage *)image{
    return [self compressOriginalImage:image
                    toMaxDataSizeBytes:60000];
}

+ (NSData *)compressOriginalImage:(UIImage *)image
              toMaxDataSizeBytes:(CGFloat)maxBytes{
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    //NSLog(@“Before compressing quality, image size = %ld KB”,data.length/1024);
    //判断“压处理”的结果是否符合要求，符合要求就over
    if (data.length < maxBytes){
        return data;
    }
    //原图大小超过范围，先进行“压处理”，这里 压缩比 采用二分法进行处理，6次二分后的最小压缩比是0.015625，已经够小了
    CGFloat max = 1;
    CGFloat min = 0;
    //通过二分法优化
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        //NSLog(@“Compression = %.1f”, compression);
        //NSLog(@“In compressing quality loop, image size = %ld KB”, data.length / 1024);
        if (data.length < maxBytes * 0.9) {
            min = compression;
        } else if (data.length > maxBytes) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@“After compressing quality, image size = %ld KB”, data.length / 1024);
    if (data.length < maxBytes){
        return data;
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    //缩处理，直接用大小的比例作为缩处理的比例进行处理，因为有取整处理，所以一般是需要两次处理
    NSUInteger lastDataLength = 0;
    while (data.length > maxBytes && data.length != lastDataLength) {
        lastDataLength = data.length;
        //获取处理后的尺寸
        CGFloat ratio = (CGFloat)maxBytes / data.length;
        //NSLog(@“Ratio = %.1f”, ratio);
        // Use NSUInteger to prevent white blank
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        //通过图片上下文进行处理图片
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //获取处理后图片的大小
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@“In compressing size loop, image size = %ld KB”, data.length / 1024);
    }
    //NSLog(@“After compressing size loop, image size = %ld KB”, data.length / 1024);
    return data;
}

+ (UIImage *)ba_IMGCompressed:(UIImage *)sourceImage
                  targetWidth:(CGFloat)defineWidth{
    if (!sourceImage) {
        return nil;
    }
    CGFloat targetHeight = sourceImage.size.height / (sourceImage.size.width / defineWidth);
    CGSize size = CGSizeMake(defineWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = defineWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(sourceImage.size, size) == NO){
        CGFloat widthFactor = defineWidth / sourceImage.size.width;
        CGFloat heightFactor = targetHeight / sourceImage.size.height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaledWidth = sourceImage.size.width * scaleFactor;
        scaledHeight = sourceImage.size.height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (defineWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSAssert(!newImage,@"图片压缩失败");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

+ (instancetype)ba_image:(UIImage *)image borderWith:(CGFloat)borderWith borderColor:(UIColor *)borderColor{
    if (!image){
        return nil;
    }
    // 1. 创建一个bitmap图形上下文
    CGSize size = CGSizeMake(image.size.height + borderWith, image.size.height + borderWith);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0); //  YES：不透明 NO:透明
    
    // 2. 获得当前的图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 3. 绘制大圆
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, size.width, size.height));
    [borderColor set];
    CGContextFillPath(ctx);
    
    // 4. 绘制小圆
    CGFloat smallX = borderWith;
    CGFloat smallY = borderWith;
    CGFloat smallW = size.width - 2 * borderWith;
    CGFloat smallH = size.height - 2 * borderWith;
    
    CGContextAddEllipseInRect(ctx, CGRectMake(smallX, smallY, smallW, smallH));
    // 4.1 指定可以绘图的范围, 这个只会影响后面再绘制的图片
    CGContextClip(ctx);
    
    // 5. 绘制图片
    [image drawInRect:CGRectMake(smallX, smallY, smallW, smallH)];
    
    // 6. 取出yuan图片
    UIImage *lastImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 7. 关闭图形上下文
    UIGraphicsEndImageContext();
    // 8. 返回
    return lastImage;
}

- (BOOL)hasAlpha {
    if (self.CGImage == NULL){
        return NO;
    }
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage) & kCGBitmapAlphaInfoMask;
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

+ (UIImage *)captureWithView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    } else {
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

+ (UIImage *)screenshot:(CGFloat)maxWidth view:(UIView *)aView{
    CGAffineTransform oldTransform = aView.transform;
    CGAffineTransform scaleTransform = CGAffineTransformIdentity;
    if (!isnan(maxWidth) && maxWidth > 0) {
        CGFloat maxScale = maxWidth/CGRectGetWidth(aView.frame);
        CGAffineTransform transformScale = CGAffineTransformMakeScale(maxScale, maxScale);
        scaleTransform = CGAffineTransformConcat(oldTransform, transformScale);
    }
    if(!CGAffineTransformEqualToTransform(scaleTransform, CGAffineTransformIdentity)){
        aView.transform = scaleTransform;
    }
    
    CGRect actureFrame = aView.frame; //已经变换过后的frame
    CGRect actureBounds= aView.bounds;//CGRectApplyAffineTransform();
    
    UIGraphicsBeginImageContextWithOptions(actureFrame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context,actureFrame.size.width/2, actureFrame.size.height/2);
    CGContextConcatCTM(context, aView.transform);
    CGPoint anchorPoint = aView.layer.anchorPoint;
    CGContextTranslateCTM(context, -actureBounds.size.width * anchorPoint.x, -actureBounds.size.height * anchorPoint.y);
    if([aView respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        [aView drawViewHierarchyInRect:aView.bounds afterScreenUpdates:NO];
    }else{
        [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    aView.transform = oldTransform;
    return screenshot;
}

//在iOS 7后，苹果提供了UIApplicationUserDidTakeScreenshotNotification通知来告诉App用户做了截屏操作
+ (void)registerScreenshot {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUserDidTakeScreenshotNotification:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)unregisterScreenshot {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

#pragma mark - UIApplicationUserDidTakeScreenshotNotification
- (void)receiveUserDidTakeScreenshotNotification:(NSNotification *)notification {
    [[[UIAlertView alloc] initWithTitle:nil message:@"截屏有风险，请确保是本人操作~"
                               delegate:nil
                      cancelButtonTitle:@"知道了"
                      otherButtonTitles:nil, nil] show];
}

+ (UIImage *)screenshotWithScale:(CGFloat)scale{
    [self registerScreenshot];
    /* 获取屏幕尺寸 */
    CGSize imageSize = CGSizeMake(BaseTools.screenWidth, BaseTools.screenHeight);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
#pragma clang diagnostic pop
    // 开启UIImage上下文
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, scale);
    // 获取当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication] windows]];
    UIView *statusBar = nil;
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        // We can still get statusBar using the following code, but this is not recommended.
        UIWindow *tempWindow = [BaseTools getKeyWindow];
        UIStatusBarManager *statusBarManager = tempWindow.windowScene.statusBarManager;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
            UIView *_localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
            if ([_localStatusBar respondsToSelector:@selector(statusBar)]) {
                statusBar = [_localStatusBar performSelector:@selector(statusBar)];
            }
        }
#pragma clang diagnostic pop
    }
#endif
    statusBar = [[UIApplication sharedApplication] valueForKey:@"_statusBar"];
    if ([statusBar isKindOfClass:[UIView class]]) {
        [windows addObject:statusBar];
    }
    for (UIView *tempView in windows){
        if (!tempView.isHidden) {
            // 保存上下文状态
            CGContextSaveGState(context);
            // 设置平移坐标
            CGContextTranslateCTM(context, tempView.center.x, tempView.center.y);
            // 设置连接平移坐标
            CGContextConcatCTM(context, tempView.transform);
            // 设置平移坐标
            CGContextTranslateCTM(context, -tempView.bounds.size.width * tempView.layer.anchorPoint.x, -tempView.bounds.size.height * tempView.layer.anchorPoint.y);
            if (orientation == UIInterfaceOrientationLandscapeLeft){
                CGContextRotateCTM(context, -M_PI_2);
                // 设置平移坐标
                CGContextTranslateCTM(context, -imageSize.height, 0);
            }else if (orientation == UIInterfaceOrientationLandscapeRight){
                CGContextRotateCTM(context, M_PI_2);
                // 设置平移坐标
                CGContextTranslateCTM(context, 0, -imageSize.width);
            } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
                CGContextRotateCTM(context, M_PI);
                // 设置平移坐标
                CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
            }
            if ([tempView respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
                // 获取快照到当前上下文中
                [tempView drawViewHierarchyInRect:tempView.bounds afterScreenUpdates:YES];
            }else{
                // 渲染上下文
                [tempView.layer renderInContext:context];
            }
            // 恢复当前图形状态
            CGContextRestoreGState(context);
        }
    }
    // 获取当前图像上下文
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭UIImage上下文
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)screenshotWithView:(UIView *)aView limitWidth:(CGFloat)maxWidth{
    CGAffineTransform oldTransform = aView.transform;
    
    CGAffineTransform scaleTransform = CGAffineTransformIdentity;
    if (!isnan(maxWidth) && maxWidth > 0) {
        CGFloat maxScale = maxWidth/CGRectGetWidth(aView.frame);
        CGAffineTransform transformScale = CGAffineTransformMakeScale(maxScale, maxScale);
        scaleTransform = CGAffineTransformConcat(oldTransform, transformScale);
    }
    if(!CGAffineTransformEqualToTransform(scaleTransform, CGAffineTransformIdentity)){
        aView.transform = scaleTransform;
    }
    
    CGRect actureFrame = aView.frame; //已经变换过后的frame
    CGRect actureBounds= aView.bounds;//CGRectApplyAffineTransform();
    
    //begin
    UIGraphicsBeginImageContextWithOptions(actureFrame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context,actureFrame.size.width/2, actureFrame.size.height/2);
    CGContextConcatCTM(context, aView.transform);
    CGPoint anchorPoint = aView.layer.anchorPoint;
    CGContextTranslateCTM(context,
                          -actureBounds.size.width * anchorPoint.x,
                          -actureBounds.size.height * anchorPoint.y);
    if([aView respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        [aView drawViewHierarchyInRect:aView.bounds afterScreenUpdates:NO];
    }else{
        [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //end
    aView.transform = oldTransform;
    
    return screenshot;
}

+ (UIImage *)pd_captureAtRect:(CGRect)rect fromImage:(UIImage *)image{
    //定义myImageRect，截图的区域
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    CGSize size;
    size.width = CGRectGetWidth(rect);
    size.height = CGRectGetHeight(rect);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, subImageRef);
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return smallImage;
}

+ (CGSize)getImageSizeWithURL:(id)URL{
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    if (imageSourceRef) {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        if (imageProperties != NULL) {
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}

+ (UIImage *)needCompressImage:(UIImage *)image
                          size:(CGSize)size
                         scale:(CGFloat)scale{
    UIImage *newImage = nil;
    //创建画板
    UIGraphicsBeginImageContext(size);
    //写入图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //得到新的图片
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    //释放画板
    UIGraphicsEndImageContext();
    //比例压缩
    newImage = [UIImage imageWithData:UIImageJPEGRepresentation(newImage, scale)];
    return newImage;
}

//保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image
                                       size:(CGSize)asize{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width / asize.height > oldsize.width / oldsize.height) {
            rect.size.width = asize.height * oldsize.width / oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width) / 2;
            rect.origin.y = 0;
        }else{
            rect.size.width = asize.width;
            rect.size.height = asize.width * oldsize.height / oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height) / 2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        //clear background
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

// 等比例压缩
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage
                       targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
    
}

+ (UIImage *)needCompressImageData:(NSData *)imageData
                              size:(CGSize)size
                             scale:(CGFloat)scale{
    UIImage *image = [UIImage imageWithData:imageData];
    return [UIImage needCompressImage:image
                                 size:size
                                scale:scale];
}

+ (UIImage *)makeArrowImageWithSize:(CGSize)imageSize
                              image:(UIImage *)image
                           isSender:(BOOL)isSender{
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [self getBezierPath:isSender imageSize:imageSize];
    CGContextAddPath(contextRef, path.CGPath);
    CGContextEOClip(contextRef);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *arrowImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return arrowImage;
}

+ (UIBezierPath *)getBezierPath:(BOOL)isSender imageSize:(CGSize)imageSize{
    CGFloat arrowWidth = 6;
    CGFloat marginTop = 13;
    CGFloat arrowHeight = 10;
    UIBezierPath *path;
    if (isSender) {
        path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, imageSize.width - arrowWidth, imageSize.height) cornerRadius:6];
        [path moveToPoint:CGPointMake(imageSize.width - arrowWidth, 0)];
        [path addLineToPoint:CGPointMake(imageSize.width - arrowWidth, marginTop)];
        [path addLineToPoint:CGPointMake(imageSize.width, marginTop + 0.5 * arrowHeight)];
        [path addLineToPoint:CGPointMake(imageSize.width - arrowWidth, marginTop + arrowHeight)];
    } else {
        path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(arrowWidth, 0, imageSize.width - arrowWidth, imageSize.height) cornerRadius:6];
        [path moveToPoint:CGPointMake(arrowWidth, 0)];
        [path addLineToPoint:CGPointMake(arrowWidth, marginTop)];
        [path addLineToPoint:CGPointMake(0, marginTop + 0.5 * arrowHeight)];
        [path addLineToPoint:CGPointMake(arrowWidth, marginTop + arrowHeight)];
    }
    [path closePath];
    return path;
}

- (UIImage *)imageCroppedAndScaledToSize:(CGSize)size
                             contentMode:(UIViewContentMode)contentMode
                                padToFit:(BOOL)padToFit{
    //calculate rect
    CGRect rect = CGRectZero;
    switch (contentMode){
        case UIViewContentModeScaleAspectFit:
        {
            CGFloat aspect = self.size.width / self.size.height;
            if (size.width / aspect <= size.height){
                rect = CGRectMake(0.0f, (size.height - size.width / aspect) / 2.0f, size.width, size.width / aspect);
            }else{
                rect = CGRectMake((size.width - size.height * aspect) / 2.0f, 0.0f, size.height * aspect, size.height);
            }
            break;
        }
        case UIViewContentModeScaleAspectFill:
        {
            CGFloat aspect = self.size.width / self.size.height;
            if (size.width / aspect >= size.height){
                rect = CGRectMake(0.0f, (size.height - size.width / aspect) / 2.0f, size.width, size.width / aspect);
            } else{
                rect = CGRectMake((size.width - size.height * aspect) / 2.0f, 0.0f, size.height * aspect, size.height);
            }
            break;
        }
        case UIViewContentModeCenter:
        {
            rect = CGRectMake((size.width - self.size.width) / 2.0f, (size.height - self.size.height) / 2.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeTop:
        {
            rect = CGRectMake((size.width - self.size.width) / 2.0f, 0.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeBottom:
        {
            rect = CGRectMake((size.width - self.size.width) / 2.0f, size.height - self.size.height, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeLeft:
        {
            rect = CGRectMake(0.0f, (size.height - self.size.height) / 2.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeRight:
        {
            rect = CGRectMake(size.width - self.size.width, (size.height - self.size.height) / 2.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeTopLeft:
        {
            rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeTopRight:
        {
            rect = CGRectMake(size.width - self.size.width, 0.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeBottomLeft:
        {
            rect = CGRectMake(0.0f, size.height - self.size.height, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeBottomRight:
        {
            rect = CGRectMake(size.width - self.size.width, size.height - self.size.height, self.size.width, self.size.height);
            break;
        }
        default:
        {
            rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
            break;
        }
    }
    
    if (!padToFit){
        //remove padding
        if (rect.size.width < size.width){
            size.width = rect.size.width;
            rect.origin.x = 0.0f;
        }
        if (rect.size.height < size.height){
            size.height = rect.size.height;
            rect.origin.y = 0.0f;
        }
    }
    
    //avoid redundant drawing
    if (CGSizeEqualToSize(self.size, size)){
        return self;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [self drawInRect:rect];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

- (UIImage *)imageWithShadowColor:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur{
    //get size
    //CGSize border = CGSizeMake(fabsf(offset.width) + blur, fabsf(offset.height) + blur);
    CGSize border = CGSizeMake(fabs(offset.width) + blur, fabs(offset.height) + blur);
    
    CGSize size = CGSizeMake(self.size.width + border.width * 2.0f, self.size.height + border.height * 2.0f);
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //set up shadow
    CGContextSetShadowWithColor(context, offset, blur, color.CGColor);
    
    //draw with shadow
    [self drawAtPoint:CGPointMake(border.width, border.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

+ (UIImage *)sd_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage;
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    } else {
        NSMutableArray *images = [NSMutableArray array];
        NSTimeInterval duration = 0.0f;
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            duration += [self sd_frameDurationAtIndex:i source:source];
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(source);
    return animatedImage;
}

+ (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

+ (UIImage *)sd_animatedGIFNamed:(NSString *)name {
    CGFloat scale = [UIScreen mainScreen].scale;
    if (scale > 1.0f) {
        NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:retinaPath];
        if (data) {
            return [UIImage sd_animatedGIFWithData:data];
        }
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        data = [NSData dataWithContentsOfFile:path];
        if (data) {
            return [UIImage sd_animatedGIFWithData:data];
        }
        return [UIImage imageNamed:name];
    }else {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            return [UIImage sd_animatedGIFWithData:data];
        }
        return [UIImage imageNamed:name];
    }
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees{
    return [self imageRotatedByRadians:[UIImage degreesToRadians:degrees] fitSize:YES];
}

- (UIImage *)imageRotatedByRadians:(CGFloat)radians fitSize:(BOOL)fitSize{
    size_t width = (size_t)CGImageGetWidth(self.CGImage);
    size_t height = (size_t)CGImageGetHeight(self.CGImage);
    CGRect newRect = CGRectApplyAffineTransform(CGRectMake(0., 0., width, height),
                                                fitSize ? CGAffineTransformMakeRotation(radians) : CGAffineTransformIdentity);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 (size_t)newRect.size.width,
                                                 (size_t)newRect.size.height,
                                                 8,
                                                 (size_t)newRect.size.width * 4,
                                                 colorSpace,
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context){
        return nil;
    }
    
    CGContextSetShouldAntialias(context, true);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextTranslateCTM(context, +(newRect.size.width * 0.5), +(newRect.size.height * 0.5));
    CGContextRotateCTM(context, -radians);
    
    CGContextDrawImage(context, CGRectMake(-(width * 0.5), -(height * 0.5), width, height), self.CGImage);
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    CGContextRelease(context);
    return img;
}

- (UIImage *)flipHorizontal:(BOOL)horizontal vertical:(BOOL)vertical {
    if (!self.CGImage){
        return nil;
    }
    size_t width = (size_t)CGImageGetWidth(self.CGImage);
    size_t height = (size_t)CGImageGetHeight(self.CGImage);
    size_t bytesPerRow = width * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context){
        return nil;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    UInt8 *data = (UInt8 *)CGBitmapContextGetData(context);
    if (!data) {
        CGContextRelease(context);
        return nil;
    }
    vImage_Buffer src = { data, height, width, bytesPerRow };
    vImage_Buffer dest = { data, height, width, bytesPerRow };
    if (vertical) {
        vImageVerticalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    if (horizontal) {
        vImageHorizontalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    return img;
}

+ (CGFloat)degreesToRadians:(CGFloat)degrees{
    return degrees * M_PI / 180;
}

+ (CGFloat)radiansToDegrees:(CGFloat)radians{
    return radians * 180 / M_PI;
}

/**
 *  @brief  倒影
 */
+ (void)reflectWithImageView:(UIImageView *)imageView {
    CGRect frame = imageView.frame;
    frame.origin.y += (frame.size.height + 1);
    
    UIImageView *reflectionImageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.clipsToBounds = TRUE;
    reflectionImageView.contentMode = imageView.contentMode;
    [reflectionImageView setImage:imageView.image];
    reflectionImageView.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    CALayer *reflectionLayer = [reflectionImageView layer];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = reflectionLayer.bounds;
    gradientLayer.position = CGPointMake(reflectionLayer.bounds.size.width / 2, reflectionLayer.bounds.size.height * 0.5);
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor clearColor] CGColor],
                            (id)[[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3] CGColor], nil];
    
    gradientLayer.startPoint = CGPointMake(0.5,0.5);
    gradientLayer.endPoint = CGPointMake(0.5,1.0);
    reflectionLayer.mask = gradientLayer;
    [imageView.superview addSubview:reflectionImageView];
}

+ (UIImage *)gradientFromColor:(UIColor *)c1 toColor:(UIColor *)c2 withHeight:(int)height{
    CGSize size = CGSizeMake(1, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray* colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageToTransparent:(UIImage *) image{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t *rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        uint8_t* ptr = (uint8_t*)pCurPtr;
        if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00) {
            // 此处把白色背景颜色给变为透明
            ptr[0] = 0;
        }else{
            // 改成下面的代码，会将图片转成想要的颜色
            ptr[3] = 0; //0~255
            ptr[2] = 0;
            ptr[1] = 0;
        }
    }
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight,8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast |kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true,kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return resultUIImage;
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void *)data);
}

+ (UIImage *)changeAlphaOfImageWith:(CGFloat)alpha withImage:(UIImage *)image{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 对图片进行模糊处理
// CIGaussianBlur ---> 高斯模糊

// CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)
// CIDiscBlur    ---> 环形卷积模糊(Available in iOS 9.0 and later)
// CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
// CIMotionBlur  ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter;
    if (name.length != 0) {
        filter = [CIFilter filterWithName:name];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        if (![name isEqualToString:@"CIMedianFilter"]) {
            [filter setValue:@(radius) forKey:@"inputRadius"];
        }
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
        UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        return resultImage;
    }else{
        return nil;
    }
}

+ (UIImage *)imageWithView:(UIView *)view
                    radius:(CGFloat)radius
                      size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size,NO, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    for(UIView *subview in view.subviews){
        [subview drawViewHierarchyInRect:subview.bounds afterScreenUpdates:YES];
    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //添加毛玻璃效果
    img = [img applyBlurWithRadius:radius tintColor:[UIColor colorWithWhite:1 alpha:0.2] saturationDeltaFactor:1.8 maskImage:nil];
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)xlsn0w_getBlurImage:(UIImage *)image blur:(CGFloat)blur {
    // 模糊度越界
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            unsigned int radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

#pragma mark - 对图片进行滤镜处理
// 怀旧 --> CIPhotoEffectInstant                        单色 --> CIPhotoEffectMono
// 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
// 色调 --> CIPhotoEffectTonal                          冲印 --> CIPhotoEffectProcess
// 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
// CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:name];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return resultImage;
}

/**
 调整图片饱和度, 亮度, 对比度
 
 @param image 目标图片
 @param saturation 饱和度
 @param brightness 亮度   -1.0 ~ 1.0
 @param contrast 对比度
 */
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    [filter setValue:@(saturation) forKey:@"inputSaturation"];
    [filter setValue:@(brightness) forKey:@"inputBrightness"];// 0.0 ~ 1.0
    [filter setValue:@(contrast) forKey:@"inputContrast"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return resultImage;
}

- (UIImage *)imageSnapshotWithWebView:(UIView *)webView {
    UIGraphicsBeginImageContextWithOptions(webView.bounds.size,YES,webView.contentScaleFactor);
    [webView drawViewHierarchyInRect:webView.bounds afterScreenUpdates:YES];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)zx_imageRotatedByDegrees:(CGFloat)degrees{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation((degrees) * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, (degrees) * M_PI / 180);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSUInteger)imageSize:(UIImage *)image{
    //    s1是保存到文件时.png图像的大小 得到的是KB
    NSUInteger s1 = UIImagePNGRepresentation(image).length / 1000;
    //    s2是保存到文件时.jpg图像的大小质量最好 得到的是KB
    NSUInteger s2 = UIImageJPEGRepresentation(image,1).length / 1000;
    
    CGFloat cgImageBytesPerRow = CGImageGetBytesPerRow(image.CGImage);
    CGFloat cgImageHeight = CGImageGetHeight(image.CGImage);
    NSUInteger size = cgImageHeight * cgImageBytesPerRow;
    return size;
}

//图片大小
+ (NSUInteger)picSize:(UIImage *)image{
    //获取原始的二进制数
    CFDataRef rawData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    NSLog(@"%lu",sizeof(uint8_t));
    NSLog(@"%lu",sizeof(uint32_t));
    NSLog(@"%ld",[(__bridge NSData *)rawData length]);
    NSUInteger size = image.size.height * image.size.width * 4;
    NSLog(@"%lu",(unsigned long)size);
    return size;
}

//图片处理-强制解压缩操作-把元数据绘制到当前的上下文-压缩图片
+ (UIImage *)imageDetail:(UIImage *)image{
    //获取当前图片数据源
    CGImageRef imageRef = image.CGImage;
    //设置大小改变压缩图片
    NSUInteger width = CGImageGetWidth(imageRef) / 3;
    NSUInteger height = CGImageGetHeight(imageRef) / 3;
    //创建颜色空间
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    /*
     创建绘制当前图片的上下文
     CGBitmapContextCreate(void * __nullable data,
     size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow,
     CGColorSpaceRef cg_nullable space, uint32_t bitmapInfo)
     data：所需要的内存空间 传nil会自动分配
     width/height：当前画布的大小
     bitsPerComponent：每个颜色分量的大小 RGBA 每一个分量占1个字节
     bytesPerRow：每一行使用的字节数 4*width
     bitmapInfo：RGBA绘制的顺序
     */
    CGContextRef contextRef =
    CGBitmapContextCreate(nil,
                          width,
                          height,
                          8,
                          4 * width,
                          colorSpace,
                          kCGImageAlphaNoneSkipLast);
    //根据数据源在上下文（画板）绘制图片
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
    
    imageRef = CGBitmapContextCreateImage(contextRef);
    CGContextRelease(contextRef);
    return [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];
}

//灰度图片,把图片变成黑白的
+ (UIImage *)grayImage:(UIImage *)image{
    CGImageRef imageRef = image.CGImage;
    //1、获取图片宽高
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetWidth(imageRef);
    //2、创建颜色空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //3、根据像素点个数创建一个所需要的空间
    UInt32 *imagePiexl = (UInt32 *)calloc(width*height, sizeof(UInt32));
    CGContextRef contextRef = CGBitmapContextCreate(imagePiexl, width, height, 8, 4 * width, colorSpaceRef, kCGImageAlphaNoneSkipLast);
    //4、根据图片数据源绘制上下文
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), image.CGImage);
    //5、将彩色图片像素点重新设置颜色
    //取平均值 R=G=B=(R+G+B)/3
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            //计算平均值重新存储像素点-直接操作像素点
            uint8_t *rgbPiexl = (uint8_t *)&imagePiexl[y * width + x];
            //rgbPiexl[0],rgbPiexl[1],rgbPiexl[2];
            //(rgbPiexl[0]+rgbPiexl[1]+rgbPiexl[2])/3;
            uint32_t gray = rgbPiexl[0] * 0.3 + rgbPiexl[1] * 0.59 + rgbPiexl[2] * 0.11;
            rgbPiexl[0] = gray;
            rgbPiexl[1] = gray;
            rgbPiexl[2] = gray;
        }
    }
    //根据上下文绘制
    CGImageRef finalRef = CGBitmapContextCreateImage(contextRef);
    //释放用过的内存
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpaceRef);
    free(imagePiexl);
    return [UIImage imageWithCGImage:finalRef scale:image.scale orientation:UIImageOrientationUp];
}

//图片调色
+ (UIImage *)setRGBImage:(UIImage *)image R:(CGFloat)rk G:(CGFloat)gk B:(CGFloat)bk{
    CGImageRef imageRef = image.CGImage;
    //1、获取图片宽高
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetWidth(imageRef);
    //2、创建颜色空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //3、根据像素点个数创建一个所需要的空间
    UInt32 *imagePiexl = (UInt32 *)calloc(width * height, sizeof(UInt32));
    CGContextRef contextRef = CGBitmapContextCreate(imagePiexl, width, height, 8, 4 * width, colorSpaceRef, kCGImageAlphaNoneSkipLast);
    //4、根据图片数据源绘制上下文
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
    //5、将彩色图片像素点重新设置颜色
    //取平均值 R=G=B=(R+G+B)/3
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            //操作像素点
            uint8_t *rgbPiexl = (uint8_t *)&imagePiexl[y * width + x];
            //该色值下不做处理
            if (rgbPiexl[0] > 245 && rgbPiexl[1] > 245 && rgbPiexl[2] > 245) {
                
            }else{
                rgbPiexl[0] = rgbPiexl[0] * rk;
                rgbPiexl[1] = rgbPiexl[1] * gk;
                rgbPiexl[2] = rgbPiexl[2] * bk;
            }
            
        }
    }
    //根据上下文绘制
    CGImageRef finalRef = CGBitmapContextCreateImage(contextRef);
    //释放用过的内存
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpaceRef);
    free(imagePiexl);
    return [UIImage imageWithCGImage:finalRef scale:image.scale orientation:UIImageOrientationUp];
}

//设置马赛克
+ (UIImage *)mosaicWithImage:(UIImage *)image{
    CGImageRef imageRef = image.CGImage;
    //1、获取图片宽高
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetWidth(imageRef);
    //2、创建颜色空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //3、根据像素点个数创建一个所需要的空间
    UInt32 *imagePiexl = (UInt32 *)calloc(width * height, sizeof(UInt32));
    CGContextRef contextRef = CGBitmapContextCreate(imagePiexl, width, height, 8, 4 * width, colorSpaceRef, kCGImageAlphaNoneSkipLast);
    //4、根据图片数据源绘制上下文
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
    //5、获取像素数组
    UInt8 *bitmapPixels = CGBitmapContextGetData(contextRef);
    UInt8 *pixels[4] = {0};
    NSUInteger currentPixels = 0;//当前的像素点
    NSUInteger preCurrentPiexls = 0;//
    NSUInteger mosaicSize = 20;//马赛克尺寸
    for (NSUInteger i = 0;  i < height - 1; i++) {
        for (NSUInteger j = 0 ; j < width - 1; j++) {
            currentPixels = i * width + j;
            if (i % mosaicSize == 0) {
                if (j % mosaicSize == 0) {
                    /*
                     第一个参数：指向用于存储复制内容的目标数组；
                     第二个参数：指向要复制的数据源；
                     第三个参数：要复制的字节数。
                     */
                    memcpy(pixels, bitmapPixels + 4 * currentPixels, 4);
                }else{
                    memcpy(bitmapPixels + 4 * currentPixels, pixels, 4);
                }
            }else{
                preCurrentPiexls = (i - 1) * width + j;
                memcpy(bitmapPixels + 4 * currentPixels, bitmapPixels + 4 * preCurrentPiexls, 4);
            }
        }
    }
    //根据上下文创建图片数据源
    CGImageRef finalRef = CGBitmapContextCreateImage(contextRef);
    //释放用过的内存
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpaceRef);
    free(imagePiexl);
    return [UIImage imageWithCGImage:finalRef scale:image.scale orientation:UIImageOrientationUp];
}

@end
