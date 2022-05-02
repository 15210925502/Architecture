//
//  MSCycleScrollView.m
//  MSCycleScrollView
//
//  Created by TuBo on 2018/12/28.
//  Copyright © 2018 turBur. All rights reserved.
//

#import "MSCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "MSCollectionViewCell.h"
#import "MSPageControl.h"
#import "MSAnimatedDotView.h"

NSString * const CellID = @"MSCycleScrollViewCell";

@interface MSCycleScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>

// 显示图片的collectionView
@property (nonatomic, strong) UICollectionView *mainView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray <CycleModel *> *imagePathsGroup;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;
@property (nonatomic, weak) UIControl *pageControl;

@end

@implementation MSCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initialization];
    [self setupMainView];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}

- (void)initialization{
    self.backgroundColor = [UIColor clearColor];
    _pageControlAliment = kMSPageContolAlimentCenter;
    _autoScrollTimeInterval = 2.0;
    _titleLabelTextColor = [UIColor whiteColor];
    _titleLabelTextFont= [UIFont setFontSizeWithValue:12];
    _titleLabelBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _titleLabelHeight = 30;
    _titleLabelTextAlignment = NSTextAlignmentLeft;
    _autoScroll = YES;
    _infiniteLoop = YES;
    _showPageControl = YES;
    _pageControlDotSize = kCycleScrollViewInitialPageControlDotSize;
    _pageControlBottomOffset = 0;
    _pageControlRightOffset = 0;
    _pageControlStyle = kMSPageContolStyleClassic;
    _hidesForSinglePage = YES;
    _currentPageDotColor = [UIColor whiteColor];
    _pageDotColor = [UIColor lightGrayColor];
    _bannerImageViewContentMode = UIViewContentModeScaleToFill;
    _dotViewClass = [MSAnimatedDotView class];
}

// 设置显示图片的collectionView
- (void)setupMainView{
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _mainView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
    _mainView.backgroundColor = [UIColor clearColor];
    _mainView.pagingEnabled = YES;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.showsVerticalScrollIndicator = NO;
    [_mainView registerClass:[MSCollectionViewCell class] forCellWithReuseIdentifier:CellID];
    
    _mainView.dataSource = self;
    _mainView.delegate = self;
    _mainView.scrollsToTop = NO;
    [self addSubview:_mainView];
}

#pragma mark - properties
- (void)setDelegate:(id<MSCycleScrollViewDelegate>)delegate{
    _delegate = delegate;
    if ([self.delegate respondsToSelector:@selector(customCellClassForCycleScrollView:)] && [self.delegate customCellClassForCycleScrollView:self]) {
        [self.mainView registerClass:[self.delegate customCellClassForCycleScrollView:self] forCellWithReuseIdentifier:CellID];
    }else if ([self.delegate respondsToSelector:@selector(customCellNibForCycleScrollView:)] && [self.delegate customCellNibForCycleScrollView:self]) {
        [self.mainView registerNib:[self.delegate customCellNibForCycleScrollView:self] forCellWithReuseIdentifier:CellID];
    }
}

- (void)setPlaceholderImageName:(NSString *)placeholderImageName{
    if (!placeholderImageName) {
        return;
    }
    _placeholderImageName = placeholderImageName;
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize{
    _pageControlDotSize = pageControlDotSize;
    [self setupPageControl];
    if ([self.pageControl isKindOfClass:[MSPageControl class]]) {
        MSPageControl *pageContol = (MSPageControl *)_pageControl;
        pageContol.pageDotSize = pageControlDotSize;
    }
}

- (void)setShowPageControl:(BOOL)showPageControl{
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
}

-(void)setSpacingBetweenDots:(CGFloat)spacingBetweenDots{
    _spacingBetweenDots = spacingBetweenDots;
    [self setupPageControl];
    if ([self.pageControl isKindOfClass:[MSPageControl class]]) {
        MSPageControl *pageControl = (MSPageControl *)_pageControl;
        pageControl.spacingBetweenDots = spacingBetweenDots;
    }
}

- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor{
    _currentPageDotColor = currentPageDotColor;
    if ([self.pageControl isKindOfClass:[MSPageControl class]]) {
        MSPageControl *pageControl = (MSPageControl *)_pageControl;
        pageControl.currentDotColor = currentPageDotColor;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPageIndicatorTintColor = currentPageDotColor;
    }
}

- (void)setPageDotColor:(UIColor *)pageDotColor{
    _pageDotColor = pageDotColor;
    if ([self.pageControl isKindOfClass:[MSPageControl class]]) {
        MSPageControl *pageControl = (MSPageControl *)_pageControl;
        pageControl.dotColor = pageDotColor;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.pageIndicatorTintColor = pageDotColor;
    }
}

- (void)setCurrentPageDotImage:(UIImage *)currentPageDotImage{
    _currentPageDotImage = currentPageDotImage;
    if (self.pageControlStyle != kMSPageContolStyleAnimated) {
        self.pageControlStyle = kMSPageContolStyleAnimated;
    }
    [self setCustomPageControlDotImage:currentPageDotImage isCurrentPageDot:YES];
}

- (void)setPageDotImage:(UIImage *)pageDotImage{
    _pageDotImage = pageDotImage;
    if (self.pageControlStyle != kMSPageContolStyleAnimated) {
        self.pageControlStyle = kMSPageContolStyleAnimated;
    }
    [self setCustomPageControlDotImage:pageDotImage isCurrentPageDot:NO];
}

-(void)setDotViewClass:(Class)dotViewClass{
    _dotViewClass = dotViewClass;
    [self setupPageControl];
    if ([self.pageControl isKindOfClass:[MSPageControl class]]) {
        MSPageControl *pageControl = (MSPageControl *)_pageControl;
        pageControl.dotViewClass = dotViewClass;
    }
}

- (void)setCustomPageControlDotImage:(UIImage *)image isCurrentPageDot:(BOOL)isCurrentPageDot{
    if (!image || !self.pageControl){
        return;
    }
    if ([self.pageControl isKindOfClass:[MSPageControl class]]) {
        MSPageControl *pageControl = (MSPageControl *)_pageControl;
        if (isCurrentPageDot) {
            pageControl.currentDotImage = image;
        } else {
            pageControl.dotImage = image;
        }
    }
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop{
    _infiniteLoop = infiniteLoop;
    if (self.imagePathsGroup.count) {
        self.imagePathsGroup = self.imagePathsGroup;
    }
}

-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    [self invalidateTimer];
    if (_autoScroll) {
        [self setupTimer];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection{
    _scrollDirection = scrollDirection;
    _flowLayout.scrollDirection = scrollDirection;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    [self setAutoScroll:self.autoScroll];
}

-(void)setPageControlStyle:(kMSPageContolStyle)pageControlStyle{
    _pageControlStyle = pageControlStyle;
    [self setupPageControl];
}

- (void)setImagePathsGroup:(NSArray *)imagePathsGroup{
    [self invalidateTimer];
    _imagePathsGroup = imagePathsGroup;
    _totalItemsCount = self.infiniteLoop ? self.imagePathsGroup.count * 1000 : self.imagePathsGroup.count;
    // 由于 !=1 包含count == 0等情况
    if (imagePathsGroup.count > 1) {
        self.mainView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        self.mainView.scrollEnabled = NO;
        [self invalidateTimer];
    }
    [self setupPageControl];
    [self.mainView reloadData];
}

- (void)setModelArray:(NSArray<CycleModel *> *)modelArray{
    _modelArray = modelArray;
    [_modelArray enumerateObjectsUsingBlock:^(CycleModel *obj, NSUInteger idx, BOOL * stop) {
        if ([obj.imageUrl isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)obj.imageUrl;
            obj.imageUrl = [url absoluteString];
        }
    }];
    self.imagePathsGroup = [modelArray copy];
    [self.mainView reloadData];
}

- (void)disableScrollGesture {
    self.mainView.canCancelContentTouches = NO;
    for (UIGestureRecognizer *gesture in self.mainView.gestureRecognizers) {
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            [self.mainView removeGestureRecognizer:gesture];
        }
    }
}

#pragma mark - actions

- (void)setupTimer{
    // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    [self invalidateTimer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer{
    [_timer invalidate];
    _timer = nil;
}

- (void)setupPageControl{
    // 重新加载数据时调整
    if (_pageControl) [_pageControl removeFromSuperview];
    if (!self.showPageControl){
        return;
    }
    if (self.imagePathsGroup.count == 0 || self.onlyDisplayText){
        return;
    }
    if ((self.imagePathsGroup.count == 1) && self.hidesForSinglePage){
        return;
    }
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
    switch (self.pageControlStyle) {
        case kMSPageContolStyleAnimated:
        {
            MSPageControl *pageControl = [[MSPageControl alloc] init];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            pageControl.dotColor = self.pageDotColor;
            pageControl.currentDotColor = self.currentPageDotColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.currentPage = indexOnPageControl;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;

        case kMSPageContolStyleClassic:
        {
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            pageControl.currentPageIndicatorTintColor = self.currentPageDotColor;
            pageControl.pageIndicatorTintColor = self.pageDotColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.currentPage = indexOnPageControl;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
        case kMSPageContolStyleCustomer:
        {
            MSPageControl *pageControl = [[MSPageControl alloc] init];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            pageControl.dotColor = self.pageDotColor;
            pageControl.currentDotColor = self.currentPageDotColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.currentPage = indexOnPageControl;
            pageControl.dotViewClass = self.dotViewClass;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
        default:
            break;
    }
    // 重设pagecontroldot图片
    if (self.currentPageDotImage) {
        self.currentPageDotImage = self.currentPageDotImage;
    }
    if (self.pageDotImage) {
        self.pageDotImage = self.pageDotImage;
    }
}

- (void)automaticScroll{
    if (0 == _totalItemsCount) return;
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(int)targetIndex{
    if (targetIndex >= _totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (int)currentIndex{
    if (CGRectGetWidth(_mainView.frame) == 0 || CGRectGetHeight(_mainView.frame) == 0) {
        return 0;
    }

    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    } else {
        index = (_mainView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }

    return MAX(0, index);
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index{
    return (int)index % self.imagePathsGroup.count;
}

#pragma mark - life circles
- (void)layoutSubviews{
    self.delegate = self.delegate;
    [super layoutSubviews];
    _flowLayout.itemSize = self.frame.size;
    _mainView.frame = self.bounds;
    if (_mainView.contentOffset.x == 0 &&  _totalItemsCount) {
        int targetIndex = 0;
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }else{
            targetIndex = 0;
        }
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }

    CGSize size = CGSizeZero;
    if ([self.pageControl isKindOfClass:[MSPageControl class]]) {
        MSPageControl *pageControl = (MSPageControl *)_pageControl;
        if (!(self.pageDotImage && self.currentPageDotImage && CGSizeEqualToSize(kCycleScrollViewInitialPageControlDotSize, self.pageControlDotSize))) {
            pageControl.pageDotSize = self.pageControlDotSize;
        }
        size = [pageControl sizeForNumberOfPages:self.imagePathsGroup.count];
    } else {
        size = CGSizeMake(self.imagePathsGroup.count * self.pageControlDotSize.width * 1.5, self.pageControlDotSize.height);
    }
    CGFloat x = (CGRectGetWidth(self.frame) - size.width) * 0.5;
    if (self.pageControlAliment == kMSPageContolAlimentRight) {
        x = CGRectGetWidth(self.mainView.frame) - size.width - 10;
    }
    CGFloat y = CGRectGetHeight(self.mainView.frame) - size.height - 10;

    if ([self.pageControl isKindOfClass:[MSPageControl class]]) {
        MSPageControl *pageControl = (MSPageControl *)_pageControl;
        [pageControl sizeToFit];
    }

    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    pageControlFrame.origin.y -= self.pageControlBottomOffset;
    pageControlFrame.origin.x -= self.pageControlRightOffset;
    self.pageControl.frame = pageControlFrame;
    self.pageControl.hidden = !_showPageControl;
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

#pragma mark - public actions
- (void)adjustWhenControllerViewWillAppera{
    long targetIndex = [self currentIndex];
    if (targetIndex < _totalItemsCount) {
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];

    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];

    if ([self.delegate respondsToSelector:@selector(setupCustomCell:forIndex:cycleScrollView:)] &&
        [self.delegate respondsToSelector:@selector(customCellClassForCycleScrollView:)] && [self.delegate customCellClassForCycleScrollView:self]) {
        [self.delegate setupCustomCell:cell forIndex:itemIndex cycleScrollView:self];
        return cell;
    }else if ([self.delegate respondsToSelector:@selector(setupCustomCell:forIndex:cycleScrollView:)] &&
              [self.delegate respondsToSelector:@selector(customCellNibForCycleScrollView:)] && [self.delegate customCellNibForCycleScrollView:self]) {
        [self.delegate setupCustomCell:cell forIndex:itemIndex cycleScrollView:self];
        return cell;
    }

    CycleModel *model = self.imagePathsGroup[itemIndex];

    if (!self.onlyDisplayText && [model.imageUrl isKindOfClass:[NSString class]]) {
        if ([model.imageUrl hasPrefix:@"http"]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage sd_imageWithName:self.placeholderImageName] options:SDWebImageRefreshCached];
        } else {
            UIImage *image = [UIImage imageNamed:model.imageUrl];
            if (!image) {
                image = [UIImage imageWithContentsOfFile:model.imageUrl];
            }
            cell.imageView.image = image;
        }
    } else if (!self.onlyDisplayText && [model.imageUrl isKindOfClass:[UIImage class]]) {
        cell.imageView.image = (UIImage *)model.imageUrl;
    }
    cell.title = model.title;

    if (!cell.hasConfigured) {
        cell.titleLabelBackgroundColor = self.titleLabelBackgroundColor;
        cell.titleLabelHeight = self.titleLabelHeight;
        cell.titleLabelTextAlignment = self.titleLabelTextAlignment;
        cell.titleLabelTextColor = self.titleLabelTextColor;
        cell.titleLabelTextFont = self.titleLabelTextFont;
        cell.hasConfigured = YES;
        cell.imageView.contentMode = self.bannerImageViewContentMode;
        cell.clipsToBounds = YES;
        cell.onlyDisplayText = self.onlyDisplayText;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:[self pageControlIndexWithCurrentCellIndex:indexPath.item]];
    }
    if (self.clickItemOperationBlock) {
        self.clickItemOperationBlock([self pageControlIndexWithCurrentCellIndex:indexPath.item]);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 解决清除timer时偶尔会出现的问题
    if (!self.imagePathsGroup.count){
        return;
    }
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    if ([self.pageControl isKindOfClass:[MSPageControl class]]) {
        MSPageControl *pageControl = (MSPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:self.mainView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // 解决清除timer时偶尔会出现的问题
    if (!self.imagePathsGroup.count){
        return;
    }
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];

    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:indexOnPageControl];
    } else if (self.itemDidScrollOperationBlock) {
        self.itemDidScrollOperationBlock(indexOnPageControl);
    }
}

- (void)makeScrollViewScrollToIndex:(NSInteger)index{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
    if (0 == _totalItemsCount){
        return;
    }
    [self scrollToIndex:(int)(_totalItemsCount * 0.5 + index)];
    if (self.autoScroll) {
        [self setupTimer];
    }
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _mainView.delegate = nil;
    _mainView.dataSource = nil;
}

@end
