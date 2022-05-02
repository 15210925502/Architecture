//
//  ZKVerifyView.m
//  ZKVerifyViewDemo
//
//  Created by bestdew on 2018/11/23.
//  Copyright © 2018 bestdew. All rights reserved.
//

#import "ZKPuzzleVerifyView.h"

//滑块大小
#define codeSize 50
//贝塞尔曲线偏移
#define offsetValue 9

@interface ZKPuzzleVerifyView ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *frontImageView;
@property (nonatomic, strong) UIImageView *puzzleImageView;
@property (nonatomic, strong) UIView *puzzleImageContainerView;

//滑块的位置
@property (nonatomic, assign) CGPoint puzzlePosition;
//空白处的位置
@property (nonatomic, assign) CGPoint blankPosition;
@property (nonatomic, assign) CGPoint containerPosition;
@property (nonatomic, strong) UIBezierPath *originalPath;

@end

@implementation ZKPuzzleVerifyView

#pragma mark --  Init
- (instancetype)init{
    return [self initWithFrame:CGRectZero style:ZKPuzzleVerifyStyleClassic];
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame style:ZKPuzzleVerifyStyleClassic];
}

- (instancetype)initWithFrame:(CGRect)frame style:(ZKPuzzleVerifyStyle)style{
    if (self = [super initWithFrame:frame]) {
        [self initWithStyle:style];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [super initWithCoder:aDecoder];
}

- (void)initWithStyle:(ZKPuzzleVerifyStyle)style{
    self.clipsToBounds = YES;
    self.enable = YES;
    self.style = style;
    self.tolerance = 5.f;
    self.puzzleSize = CGSizeMake(40.f, 40.f);
    self.containerInsert = UIEdgeInsetsZero;
    
    _backImageView = [[UIImageView alloc] init];
    _backImageView.alpha = 0.f;
    [self addSubview:_backImageView];
    
    _frontImageView = [[UIImageView alloc] init];
    [self addSubview:_frontImageView];
    
    _puzzleImageContainerView = [[UIView alloc] init];
    _puzzleImageContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
    _puzzleImageContainerView.layer.shadowRadius = 4.f;
    _puzzleImageContainerView.layer.shadowOpacity = 1.f;
    _puzzleImageContainerView.layer.shadowOffset = CGSizeZero;
    [self addSubview:_puzzleImageContainerView];
    
    _puzzleImageView = [[UIImageView alloc] init];
    [_puzzleImageContainerView addSubview:_puzzleImageView];
}

#pragma mark -- Public Methods
- (void)refresh{
    _enable = YES;
    [self setTranslation:0.f];
    [self setContainerInsert:_containerInsert];
}

- (void)checkVerificationResults:(nullable void (^)(BOOL isVerified))result animated:(BOOL)animated{
    _isVerified = (fabs(_puzzlePosition.x - _blankPosition.x) <= _tolerance);
    if (_isVerified) {
        _enable = NO;
        _frontImageView.layer.mask = nil;
        _puzzleImageContainerView.hidden = YES;
        if (animated){
            [self showSuccessfulAnimation];
        }
    } else {
        if (animated){
            [self showFailedAnimation];
        }
    }
    if (result){
        result(_isVerified);
    }
}

#pragma mark -- Override
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setContainerInsert:_containerInsert];
    
    _backImageView.frame = self.bounds;
    _frontImageView.frame = self.bounds;
    _puzzleImageContainerView.frame = CGRectMake(_containerPosition.x, _containerPosition.y,
                                                 CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    _puzzleImageView.frame = _puzzleImageContainerView.bounds;
    [self updatePuzzleMask];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) [self updatePuzzleMask];
}

#pragma mark -- Setter && Getter
- (void)setImage:(UIImage *)image{
    _image = image;
    _backImageView.image = image;
    _frontImageView.image = image;
    _puzzleImageView.image = image;
    [self updatePuzzleMask];
}

- (void)setTolerance:(CGFloat)tolerance{
    _tolerance = fabs(tolerance);
}

- (void)setContainerInsert:(UIEdgeInsets)containerInsert{
    _containerInsert = containerInsert;
    
    // 计算容器范围
    CGRect containerRect = CGRectMake(containerInsert.left,
                                      containerInsert.top,
                                      CGRectGetWidth(self.bounds) - containerInsert.left - containerInsert.right,
                                      CGRectGetHeight(self.bounds) - containerInsert.top - containerInsert.bottom);
    // 获取随机位置，这里只取整
    CGFloat minimumDistance = 50.f; // 最小间距
    NSInteger intX = (NSInteger)(floorf(CGRectGetWidth(containerRect) - _puzzleSize.width * 2 - minimumDistance));
    NSInteger randomX = containerInsert.left + _puzzleSize.width + minimumDistance + (arc4random() % (intX + 1));
    NSInteger intY = (NSInteger)(floorf(CGRectGetHeight(containerRect) - _puzzleSize.width));
    NSInteger randomY = containerInsert.top + (arc4random() % (intY + 1));
    // 设置滑块和空白处位置
    _puzzlePosition = CGPointMake(containerInsert.left, randomY);
    _blankPosition = CGPointMake(randomX, randomY);
    [self setContainerPosition:CGPointMake(_puzzlePosition.x - _blankPosition.x,
                                           _puzzlePosition.y - _blankPosition.y)];
    [self setStyle:_style];
    [self setPuzzlePath:_originalPath];
}

- (void)setContainerPosition:(CGPoint)containerPosition{
    _containerPosition = containerPosition;
    CGRect frame = _puzzleImageContainerView.frame;
    frame.origin = containerPosition;
    _puzzleImageContainerView.frame = frame;
}

- (void)setPuzzleSize:(CGSize)puzzleSize{
    _puzzleSize = puzzleSize;
    [self setContainerInsert:_containerInsert];
}

- (void)setStyle:(ZKPuzzleVerifyStyle)style{
    _style = style;
    if (style == ZKPuzzleVerifyStyleCustom){
        return;
    }
    UIBezierPath *path = [self pathForStyle:style];
    UIBezierPath *tempPath = [UIBezierPath bezierPathWithCGPath:path.CGPath];
    [tempPath applyTransform:CGAffineTransformMakeScale(_puzzleSize.width / tempPath.bounds.size.width,_puzzleSize.height / tempPath.bounds.size.height)];
    [tempPath applyTransform:CGAffineTransformMakeTranslation(_blankPosition.x - tempPath.bounds.origin.x,_blankPosition.y - tempPath.bounds.origin.y)];
    _puzzlePath = tempPath;
    [self updatePuzzleMask];
}

- (void)setPuzzlePath:(UIBezierPath *)puzzlePath{
    // 保留原始值
    _originalPath = puzzlePath;
    if (_style != ZKPuzzleVerifyStyleCustom){
        return;
    }
    UIBezierPath *tempPath = [UIBezierPath bezierPathWithCGPath:puzzlePath.CGPath];
    [tempPath applyTransform:CGAffineTransformMakeTranslation(_blankPosition.x - tempPath.bounds.origin.x,_blankPosition.y - tempPath.bounds.origin.y)];
    _puzzlePath = tempPath;
    
    [self updatePuzzleMask];
}

- (void)setTranslation:(CGFloat)translation{
    if (!_enable){
        return;
    }
    translation = MAX(0.f, translation);
    translation = MIN(1.f, translation);
    _translation = translation;
    _puzzlePosition.x = _containerInsert.left + translation * (CGRectGetWidth(self.bounds) - _containerInsert.left - _puzzleSize.width);
    [self setContainerPosition:CGPointMake(_puzzlePosition.x - _blankPosition.x,
                                           _puzzlePosition.y - _blankPosition.y)];
}

#pragma mark -- Other
- (void)updatePuzzleMask{
    if (self.superview == nil){
        return;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    [maskPath appendPath:[UIBezierPath bezierPathWithCGPath:_puzzlePath.CGPath]];
    maskPath.usesEvenOddFillRule = YES;
    
    CAShapeLayer *backMaskLayer = [CAShapeLayer new];
    backMaskLayer.frame = self.bounds;
    backMaskLayer.path = _puzzlePath.CGPath;
    backMaskLayer.fillRule = kCAFillRuleEvenOdd;
    
    CAShapeLayer *frontMaskLayer = [CAShapeLayer new];
    frontMaskLayer.frame = self.bounds;
    frontMaskLayer.path = maskPath.CGPath;
    frontMaskLayer.fillRule = kCAFillRuleEvenOdd;
    
    CAShapeLayer *puzzleMaskLayer = [CAShapeLayer new];
    puzzleMaskLayer.frame = self.bounds;
    puzzleMaskLayer.path = _puzzlePath.CGPath;
    
    _backImageView.layer.mask = backMaskLayer;
    _frontImageView.layer.mask = frontMaskLayer;
    _puzzleImageView.layer.mask = puzzleMaskLayer;
}

- (void)showSuccessfulAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 0.2;
    animation.autoreverses = YES;
    animation.fromValue = @(1);
    animation.toValue = @(0);
    [self.layer addAnimation:animation forKey:@"successfulAnimation"];
}

- (void)showFailedAnimation{
    CGFloat positionX = _puzzleImageContainerView.layer.position.x;
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    animation.duration = 0.2;
    animation.repeatCount = 2;
    animation.values = @[@(positionX), @(positionX - 3), @(positionX + 3), @(positionX)];
    [_puzzleImageContainerView.layer addAnimation:animation forKey:@"failedAnimation"];
}

- (UIBezierPath *)pathForStyle:(ZKPuzzleVerifyStyle)style{
    switch (style) {
        case ZKPuzzleVerifyStyleClassic:
            return [self classicPuzzlePath];
        case ZKPuzzleVerifyStyleSquare:
            return [self squarePuzzlePath];
        case ZKPuzzleVerifyStyleCircle:
            return [self circlePuzzlePath];
        case ZKPuzzleVerifyStyleCustom:
            return nil;
    }
}

//配置滑块贝塞尔曲线
- (UIBezierPath *)classicPuzzlePath {
    static UIBezierPath *path = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(codeSize * 0.5 - offsetValue,0)];
        [path addQuadCurveToPoint:CGPointMake(codeSize * 0.5 + offsetValue, 0) controlPoint:CGPointMake(codeSize * 0.5, -offsetValue * 2)];
        [path addLineToPoint:CGPointMake(codeSize, 0)];
        
        [path addLineToPoint:CGPointMake(codeSize,codeSize * 0.5 - offsetValue)];
        [path addQuadCurveToPoint:CGPointMake(codeSize, codeSize * 0.5 + offsetValue) controlPoint:CGPointMake(codeSize + offsetValue * 2, codeSize * 0.5)];
        [path addLineToPoint:CGPointMake(codeSize, codeSize)];
        
        [path addLineToPoint:CGPointMake(codeSize * 0.5 + offsetValue,codeSize)];
        [path addQuadCurveToPoint:CGPointMake(codeSize * 0.5 - offsetValue, codeSize) controlPoint:CGPointMake(codeSize * 0.5, codeSize - offsetValue * 2)];
        [path addLineToPoint:CGPointMake(0, codeSize)];
        
        [path addLineToPoint:CGPointMake(0,codeSize * 0.5 + offsetValue)];
        [path addQuadCurveToPoint:CGPointMake(0, codeSize * 0.5 - offsetValue) controlPoint:CGPointMake(0 + offsetValue * 2, codeSize * 0.5)];
        [path addLineToPoint:CGPointMake(0, 0)];
        
        [path stroke];
    });
    return path;
}

- (UIBezierPath *)squarePuzzlePath{
    static UIBezierPath *squarePath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        squarePath = [UIBezierPath bezierPathWithRect:CGRectMake(0.f, 0.f, 100.f, 100.f)];
    });
    return squarePath;
}

- (UIBezierPath *)circlePuzzlePath{
    static UIBezierPath *circlePath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.f, 0.f, 100.f, 100.f)];
    });
    return circlePath;
}

@end
