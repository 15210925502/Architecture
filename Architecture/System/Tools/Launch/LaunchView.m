//
//  LaunchView.m
//  LaunchView
//
//  Created by TuBo on 2018/11/8.
//  Copyright © 2018 TuBur. All rights reserved.
//

#import "LaunchView.h"
#import "LaunchOperation.h"

#define MSHidden_TIME 1.0

@interface LaunchView()<UIScrollViewDelegate>{
    UIImageView *launchView;//获取到最后一个imageView 添加自定义按钮
    CGFloat oldlastContentOffset;
    CGFloat newlastContentOffset;
    BOOL isScrollOut;//是否左滑推出
    CGRect guideFrame;
    CGRect videoFrame;
    UIImage *gbgImage;//按钮背景图片
    BOOL isFirstLoginState; //是否是首次登陆
}
@property (nonatomic, strong) UIButton *skipButton;//跳过按钮
@property (nonatomic, strong) UIButton *guideButton;//立即进入按钮
@property (nonatomic, strong) UIPageControl           *imagePageControl;
@property (nonatomic, strong) AVPlayerViewController  *playerController;//视频播放
@property (nonatomic, copy) NSArray<NSString *> *dataImages; //图片数据
@property (nonatomic, strong) NSURL *videoUrl;

@end

static NSString *const kAppVersion = @"appVersion";

@implementation LaunchView

#pragma mark - 创建对象-->>不带button 左滑动消失
+ (instancetype)launchWithImages:(NSArray <NSString *>*)images{
    return [[LaunchView alloc] initWithVideoframe:CGRectZero
                                       guideFrame:CGRectZero
                                           images:images
                                           gImage:nil
                                           sbName:nil
                                         videoUrl:nil
                                      isScrollOut:YES];
}

#pragma mark - 创建对象-->>带button 左滑动不消失
+ (instancetype)launchWithImages:(NSArray <NSString *>*)images
                      guideFrame:(CGRect)gframe
                          gImage:(UIImage *)gImage{
    return [[LaunchView alloc] initWithVideoframe:CGRectZero
                                       guideFrame:gframe
                                           images:images
                                           gImage:gImage
                                           sbName:nil
                                         videoUrl:nil
                                      isScrollOut:NO];
}

#pragma mark - 用storyboard创建的项目时调用，不带button 左滑动消失
+ (instancetype)launchWithImages:(NSArray <NSString *>*)images
                          sbName:(NSString *)sbName{
    return [[LaunchView alloc] initWithVideoframe:CGRectZero
                                       guideFrame:CGRectZero
                                           images:images
                                           gImage:nil
                                           sbName:![LaunchView isBlankString:sbName] ?  sbName : @"Main"
                                         videoUrl:nil
                                      isScrollOut:YES];
}

#pragma mark - 用storyboard创建的项目时调用，带button左滑动不消失
+(instancetype)launchWithImages:(NSArray <NSString *>*)images
                         sbName:(NSString *)sbName
                     guideFrame:(CGRect)gframe
                         gImage:(UIImage *)gImage{
    return [[LaunchView alloc] initWithVideoframe:CGRectZero
                                       guideFrame:gframe
                                           images:images
                                           gImage:nil
                                           sbName:![LaunchView isBlankString:sbName] ?  sbName : @"Main"
                                         videoUrl:nil
                                      isScrollOut:NO];
}

#pragma  mark - 关于Video引导页
#pragma mark - 创建对象，不带button 左滑动消失
+ (instancetype)launchWithVideo:(CGRect)videoFrame
                       videoURL:(NSURL *)videoURL{
    return [[LaunchView alloc] initWithVideoframe:videoFrame
                                       guideFrame:CGRectZero
                                           images:nil
                                           gImage:nil
                                           sbName:nil
                                         videoUrl:videoURL
                                      isScrollOut:YES];
}

#pragma mark - 创建对象，不带button 左滑动不消失
+ (instancetype)launchWithVideo:(CGRect)videoFrame
                       videoURL:(NSURL *)videoURL
                     guideFrame:(CGRect)gframe
                         gImage:(UIImage *)gImage{
    return [[LaunchView alloc] initWithVideoframe:videoFrame
                                       guideFrame:gframe
                                           images:nil
                                           gImage:gImage
                                           sbName:nil
                                         videoUrl:videoURL
                                      isScrollOut:NO];
}


#pragma mark - 用storyboard创建的项目时调用，不带button左滑动消失
+ (instancetype)launchWithVideo:(CGRect)videoFrame
                       videoURL:(NSURL *)videoURL
                         sbName:(NSString *)sbName{
    return [[LaunchView alloc] initWithVideoframe:videoFrame
                                       guideFrame:CGRectZero
                                           images:nil
                                           gImage:nil
                                           sbName:![LaunchView isBlankString:sbName] ? sbName : @"Main"
                                         videoUrl:videoURL
                                      isScrollOut:YES];
}

#pragma mark - 用storyboard创建的项目时调用，带button左滑动不消失
+ (instancetype)launchWithVideo:(CGRect)videoFrame
                       videoURL:(NSURL *)videoURL
                         sbName:(NSString *)sbName
                     guideFrame:(CGRect)gframe
                         gImage:(UIImage *)gImage {
    return [[LaunchView alloc] initWithVideoframe:videoFrame
                                       guideFrame:gframe
                                           images:nil
                                           gImage:gImage
                                           sbName:![LaunchView isBlankString:sbName] ?  sbName:@"Main" videoUrl:videoURL isScrollOut:NO];
}


#pragma mark - 初始化
- (instancetype)initWithVideoframe:(CGRect)frame
                        guideFrame:(CGRect)gframe
                            images:(NSArray <NSString *>*)images
                            gImage:(UIImage *)gImage
                            sbName:(NSString *)sbName
                          videoUrl:(NSURL *)videoUrl
                       isScrollOut:(BOOL)isScrollOut{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, BaseTools.screenWidth, BaseTools.screenHeight);
        self.backgroundColor = [UIColor whiteColor];
        isFirstLoginState = [self isFirstLauch];
        if (isFirstLoginState) {
            if (images.count > 0) {
                self.dataImages = [NSMutableArray arrayWithArray:images];
            }
        }else{
//            self.dataImages = @[@"Untitled-7.gif"];
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"BridgeLoop-640p" ofType:@"mp4"];
//            if (path) {
//                self.videoUrl = [NSURL fileURLWithPath:path];
//            }
            self.dataImages = @[@"LaunchScreenImageIcon"];
            [self performSelector:@selector(hideGuidView) withObject:nil afterDelay:1.0f];
        }
        
        videoFrame = CGRectGetWidth(frame) > 0 ? frame : self.bounds;
        guideFrame = gframe;
        gbgImage = gImage;
        isScrollOut = isScrollOut;
        self.isPalyEndOut = YES;
        self.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
        if (sbName != nil) {
            UIStoryboard *story = [UIStoryboard storyboardWithName:sbName bundle:nil];
            UIViewController * vc = story.instantiateInitialViewController;
            window.rootViewController = vc;
            [vc.view addSubview:self];
        }
        if (self.videoUrl) {
            [self addVideo];
        }else{
            [self addImages];
        }
    }
    return self;
}

#pragma mark - 判断是不是首次登录或者版本更新
- (BOOL)isFirstLauch{
    self.isHiddenSkipBtn = YES;
    //获取当前版本号
    NSString *currentAppVersion = [[NSBundle mainBundle] appVersion];
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersion];
    //版本升级或首次登录
    if ([LaunchView isBlankString:version] ||
        ![version isEqualToString:currentAppVersion]) {
        [NSUserDefaults saveUserDefaultsObject:currentAppVersion forKey:kAppVersion];
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 创建滚动视图、添加引导页图片
- (void)addImages{
    UIScrollView *launchScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    launchScrollView.showsHorizontalScrollIndicator = NO;
    launchScrollView.bounces = NO;
    launchScrollView.pagingEnabled = YES;
    launchScrollView.delegate = self;
    launchScrollView.contentSize = CGSizeMake(BaseTools.screenWidth * self.dataImages.count, BaseTools.screenHeight);
    [self addSubview:launchScrollView];
    
    for (int i = 0; i < self.dataImages.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * BaseTools.screenWidth, 0, BaseTools.screenWidth, BaseTools.screenHeight)];
        if ([[LaunchOperation ms_contentTypeForImageData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.dataImages[i] ofType:nil]]] isEqualToString:@"gif"]) {
            NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.dataImages[i] ofType:nil]];
            imageView = (UIImageView *)[[LaunchOperation alloc] initWithFrame:imageView.frame gifImageData:localData];
        } else {
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.image = [UIImage imageNamed:self.dataImages[i]];
        }
        [launchScrollView addSubview:imageView];
        if (i == self.dataImages.count - 1) {
            //拿到最后一个图片，添加自定义体验按钮
            launchView = imageView;
            launchView.userInteractionEnabled = YES;
            //判断要不要添加button
            if (!isScrollOut) {
                [imageView setUserInteractionEnabled:YES];
                [imageView addSubview:self.guideButton];
            }
        }
    }
    
    [self addSubview:self.skipButton];
    if (self.dataImages.count > 1) {
        [self addSubview:self.imagePageControl];
    }
}

#pragma mark - APP视频新特性页面(新增测试模块内容)
- (void)addVideo{
    [self addSubview:self.playerController.view];
    [self addSubview:self.guideButton];
    
    [UIView animateWithDuration:MSHidden_TIME animations:^{
        [self.guideButton setAlpha:1.0];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideGuidView) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [self addSubview:self.skipButton];
    
}

#pragma mark -- >> 自定义属性设置

#pragma mark - 跳过按钮的简单设置
- (void)setSkipTitle:(NSString *)skipTitle{
    [self.skipButton setTitle:skipTitle forState:UIControlStateNormal];
}

- (void)setSkipBackgroundClolr:(UIColor *)skipBackgroundClolr{
    [self.skipButton setBackgroundColor:skipBackgroundClolr];
}

- (void)setIsHiddenSkipBtn:(BOOL)isHiddenSkipBtn{
    self.skipButton.hidden = isHiddenSkipBtn;
}

- (void)skipBtnCustom:(UIButton *(^)(void))btn{
    [self.skipButton removeFromSuperview];
    [self addSubview:btn()];
}

#pragma mark - 立即体验按钮的简单设置
- (void)setGuideTitle:(NSString *)guideTitle{
    [self.guideButton setTitle:guideTitle forState:UIControlStateNormal];
}

- (void)setGuideBackgroundImage:(UIImage *)guideBackgroundImage{
    [self.guideButton setBackgroundImage:guideBackgroundImage forState:UIControlStateNormal];
}

- (void)setGuideTitleColor:(UIColor *)guideTitleColor{
    [self.guideButton setTitleColor:guideTitleColor forState:UIControlStateNormal];
}

#pragma mark - 自定义进入按钮
- (void)guideBtnCustom:(UIButton *(^)(void))btn{
    if(guideFrame.size.height || guideFrame.origin.x || !isFirstLoginState){
        return;
    }
    
    //移除当前的体验按钮
    [self.guideButton removeFromSuperview];
    if (_videoUrl) {
        [self addSubview:btn()];
    }else{
        [launchView addSubview:btn()];
    }
}

#pragma mark - UIPageControl简单设置

- (void)setCurrentColor:(UIColor *)currentColor{
    self.imagePageControl.currentPageIndicatorTintColor = currentColor;
}

- (void)setNomalColor:(UIColor *)nomalColor{
    self.imagePageControl.pageIndicatorTintColor = nomalColor;
}

- (void)setIsHiddenPageControl:(BOOL)isHiddenPageControl{
    self.imagePageControl.hidden = isHiddenPageControl;
}

#pragma mark - UIPageControl简单设置
- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity{
    self.playerController.videoGravity = videoGravity;
}

- (void)setIsPalyEndOut:(BOOL)isPalyEndOut{
    if (!isPalyEndOut) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark - 隐藏引导页
- (void)hideGuidView{
    [UIView animateWithDuration:MSHidden_TIME animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MSHidden_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSelector:@selector(removeGuidePageHUD) withObject:nil afterDelay:1];
        });
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    HLDTabBarController *tabBarController = [[HLDTabBarController alloc] init];
    
    HomeVC *homeVC = [[HomeVC alloc] initWithQuery:nil];
    [tabBarController addChildController:homeVC title:@"首页" normalImageName:@"Home_Normal" selectedImageName:@"Home_Select"];
    
    CentVC *centVC = [[CentVC alloc] initWithQuery:nil];
    [tabBarController addCenterController:centVC title:nil normalImageName:@"plus" selectedImageName:@"plus" bulgeHeight:20];
    
    MineVC *mineVC = [[MineVC alloc] initWithQuery:nil];
    [tabBarController addChildController:mineVC title:@"我的" normalImageName:@"Home_Normal" selectedImageName:@"Home_Select"];
    
    [BaseTools getKeyWindow].rootViewController = tabBarController;
}

- (void)removeGuidePageHUD {
    //解决第二次进入视屏不显示还能听到声音的BUG
    if (self.videoUrl) {
        self.playerController = nil;
    }
}

#pragma mark - ScrollerView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    oldlastContentOffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    newlastContentOffset = scrollView.contentOffset.x;
    int cuttentIndex = (int)(oldlastContentOffset / BaseTools.screenWidth);
    
    if (cuttentIndex == self.dataImages.count - 1) {
        if ([self isScrolltoLeft:scrollView]) {
            if (!isScrollOut) {
                return;
            }
            [self hideGuidView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int cuttentIndex = (int)(scrollView.contentOffset.x / BaseTools.screenWidth);
    self.imagePageControl.currentPage = cuttentIndex;
}


#pragma mark - 判断滚动方向
- (BOOL)isScrolltoLeft:(UIScrollView *)scrollView{
    if (oldlastContentOffset - newlastContentOffset > 0){
        return NO;
    }
    return YES;
}

#pragma mark - prvite void
//判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stripInPlace] length] == 0) {
        return YES;
    }
    return NO;
}

#pragma mark - >> 懒加载部分
#pragma mark - 跳过按钮
- (UIButton *)skipButton{
    if (!_skipButton) {
        // 设置引导页上的跳过按钮
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.frame = CGRectMake(BaseTools.screenWidth * 0.8, BaseTools.screenWidth * 0.1, 50, 25);
        [_skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipButton.titleLabel setFont:[UIFont setFontSizeWithValue:14.0]];
        [_skipButton setBackgroundColor:[UIColor grayColor]];
        [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_skipButton.layer setCornerRadius:(_skipButton.frame.size.height * 0.5)];
        [_skipButton addTarget:self action:@selector(hideGuidView) forControlEvents:UIControlEventTouchUpInside];
        _skipButton.adjustsImageWhenHighlighted = NO;
    }
    return _skipButton;
}

#pragma mark - 进入按钮
- (UIButton *)guideButton{
    if (_guideButton) {
        // 设置引导页上的跳过按钮
        //CGRectMake(MSScreenW*0.3, MSScreenH*0.8, MSScreenW*0.4, MSScreenH*0.08)
        _guideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _guideButton.frame = guideFrame;
        [_guideButton setTitle:@"开始体验" forState:UIControlStateNormal];
        [_guideButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_guideButton setBackgroundImage:gbgImage forState:UIControlStateNormal];
        [_guideButton.titleLabel setFont:[UIFont setFontSizeWithValue:21]];
        [_guideButton addTarget:self action:@selector(hideGuidView) forControlEvents:UIControlEventTouchUpInside];
        _guideButton.adjustsImageWhenHighlighted = NO;
    }
    return _guideButton;
}

- (UIPageControl *)imagePageControl{
    if (_imagePageControl) {
        _imagePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, BaseTools.screenHeight - 50, BaseTools.screenWidth, 30)];
        _imagePageControl.numberOfPages = self.dataImages.count;
        _imagePageControl.backgroundColor = [UIColor clearColor];
        _imagePageControl.currentPage = 0;
        _imagePageControl.defersCurrentPageDisplay = YES;
        _imagePageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _imagePageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    return _imagePageControl;
}

#pragma mark - 视频播放VC
- (AVPlayerViewController *)playerController{
    if (_playerController) {
        _playerController = [[AVPlayerViewController alloc] init];
        _playerController.view.frame = videoFrame;
        _playerController.view.backgroundColor = [UIColor whiteColor];
        [_playerController.view setAlpha:1.0];
        _playerController.player = [[AVPlayer alloc] initWithURL:self.videoUrl];
        _playerController.videoGravity = self.videoGravity;
        _playerController.showsPlaybackControls = NO;
        [_playerController.player play];
    }
    return _playerController;
}

@end
