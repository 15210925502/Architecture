//
//  UpdateAlert.m
//  UpdateAlert
//
//  Created by zhuku on 2018/2/7.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "UpdateAlert.h"

@interface UpdateAlert()

@property (nonatomic, strong) UpdateVersionModel *model;

//backgroundView
@property (nonatomic,strong) UIImageView *updateIconBackImage;
@property (nonatomic,strong) UILabel *titleLabel;
//更新内容
@property (nonatomic,strong) UITextView *descTextView;
//取消按钮
@property (nonatomic,strong) UIButton *cancleButton;
//更新按钮
@property (nonatomic,strong) UIButton *updateButton;

@end

@implementation UpdateAlert

+ (void)showUpdateAlertWithModel:(UpdateVersionModel *)model{
    /**
     判断是否是强制更新
     0：不提示升级：不弹窗提示，用户需要主动更新
     1：强制升级：用户不升级无法使用APP
     2：强提示升级：每天都提示用户升级，直到用户升级完成
     3：弱提示升级：有新版本时提示一次，直到再有新版本时在提示
     */
    if (model.versionNo != model.versionNoLocal){
        if ([@"1" isEqualToString:model.isForce]){
            UpdateAlert *updateAlert = [[UpdateAlert alloc] initModel:model];
            [[BaseTools getKeyWindow] addSubview:updateAlert];
        }else if([@"2" isEqualToString:model.isForce]){
            NSDate *data = [NSUserDefaults getUserDefaultsforKey:@"showDate"];
            BOOL isTodayShow = [NSDate isSameDayWithDate:data unitFlag:PDDateFormatUnitDay];
            if (!isTodayShow){
                UpdateAlert *updateAlert = [[UpdateAlert alloc] initModel:model];
                [[BaseTools getKeyWindow] addSubview:updateAlert];
                [NSUserDefaults saveUserDefaultsObject:[NSDate date] forKey:@"showDate"];
            }
        }else if([@"3" isEqualToString:model.isForce]){
            NSString *updateVersion = [NSUserDefaults getUserDefaultsforKey:@"updateVersion"];
            if (![model.versionNo isEqualToString:updateVersion]){
                UpdateAlert *updateAlert = [[UpdateAlert alloc] initModel:model];
                [[BaseTools getKeyWindow] addSubview:updateAlert];
                [NSUserDefaults saveUserDefaultsObject:model.versionNo forKey:@"updateVersion"];
            }
        }
    }
}

- (instancetype)initModel:(UpdateVersionModel *)model{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
        
        self.model = model;
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI{
    //backgroundView
    self.updateIconBackImage = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.descTextView = [[UITextView alloc] init];
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.updateButton = [UIButton buttonWithType:UIButtonTypeCustom];

    self.updateIconBackImage.userInteractionEnabled = YES;
    
    self.titleLabel.font = [UIFont setBoldSystemFontOfSizeWithValue:16];
    self.descTextView.font = [UIFont setFontSizeWithValue:14];
    
    self.titleLabel.theme_textColor = @"444D54";
    self.descTextView.theme_textColor = @"444D54";
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"升级到新版本";
    
//    去除内边距
    self.descTextView.textContainer.lineFragmentPadding = 0;
    self.descTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    NSMutableAttributedString *attStr = [NSAttributedString getLineSpaceAttributedStringWithStr:self.model.content
                                                                                    lineSpacing:[BaseTools adaptedWithValue:2]
                                                                                      alignment:NSTextAlignmentLeft];
    [attStr addAttribute:NSFontAttributeName
                   value:self.descTextView.font
                   range:NSMakeRange(0,self.model.content.length)];

    self.descTextView.attributedText = attStr;
    self.descTextView.editable = NO;
    self.descTextView.selectable = NO;
    self.descTextView.showsHorizontalScrollIndicator = NO;
    
    [self.cancleButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.updateButton addTarget:self action:@selector(updateVersion) forControlEvents:UIControlEventTouchUpInside];
    
    [self.cancleButton setTitle:@"以后再说" forState:UIControlStateNormal];
    [self.updateButton setTitle:@"立即升级" forState:UIControlStateNormal];
    
    [self.cancleButton theme_setTitleColor:@"ED4138" forState:UIControlStateNormal];
    [self.updateButton theme_setTitleColor:@"FFFFFF" forState:UIControlStateNormal];
    
    self.updateButton.theme_backgroundColor = @"ED4138";
    
    self.cancleButton.layer.borderWidth = [BaseTools adaptedWithValue:0.8];
    self.cancleButton.layer.theme_borderColor = @"ED4138";
    
    [self addSubview:self.updateIconBackImage];
    [self.updateIconBackImage addSubview:self.titleLabel];
    [self.updateIconBackImage addSubview:self.descTextView];
    [self.updateIconBackImage addSubview:self.cancleButton];
    [self.updateIconBackImage addSubview:self.updateButton];
    
    CGFloat backViewLeft = [BaseTools adaptedWithValue:50];
    CGFloat textLeft = [BaseTools adaptedWithValue:20];
    
    //获取更新内容高度
    CGFloat descHeight = [self.model.content boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame) - (backViewLeft + textLeft) * 2, MAXFLOAT)
                                                    font:self.descTextView.font
                                             lineSpacing:[BaseTools adaptedWithValue:2]].height;
    descHeight += [BaseTools adaptedWithValue:1];
    //更新内容可否滑动显示
    BOOL scrollEnabled = NO;
    //bgView最大高度
    CGFloat maxHeight = [BaseTools adaptedWithValue:200];
    //重置bgView最大高度 设置更新内容可否滑动显示
    if (descHeight > maxHeight) {
        scrollEnabled = YES;
    }else{
        maxHeight = descHeight;
    }
    self.descTextView.scrollEnabled = scrollEnabled;
    self.descTextView.showsVerticalScrollIndicator = scrollEnabled;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.updateIconBackImage);
        make.top.equalTo(@(0)).offset([BaseTools adaptedWithValue:130]);
        make.left.equalTo(@(textLeft));
        make.height.equalTo(@(20));
    }];
    [self.descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.updateIconBackImage);
        make.left.equalTo(@(textLeft));
        make.top.equalTo(self.titleLabel.mas_bottom).offset([BaseTools adaptedWithValue:15]);
        make.height.equalTo(@(maxHeight));
    }];
    CGFloat buttonLeft = 0.0;
    
    /**
     判断是否是强制更新
     0：不提示升级：不弹窗提示，用户需要主动更新
     1：强制升级：用户不升级无法使用APP
     2：强提示升级：每天都提示用户升级，直到用户升级完成
     3：弱提示升级：有新版本时提示一次，直到再有新版本时在提示
     */
    if ([@"1" isEqualToString:self.model.isForce]) {
        buttonLeft = [BaseTools adaptedWithValue:50];
        [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.descTextView.mas_bottom).offset([BaseTools adaptedWithValue:30]);
            make.left.equalTo(@(buttonLeft));
            make.height.equalTo(@([BaseTools adaptedWithValue:40]));
            make.right.equalTo(@(-buttonLeft));
        }];
    }else if([@"2" isEqualToString:self.model.isForce] ||
             [@"3" isEqualToString:self.model.isForce]){
        buttonLeft = [BaseTools adaptedWithValue:15];
        [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.descTextView.mas_bottom).offset([BaseTools adaptedWithValue:30]);
            make.left.equalTo(@(buttonLeft));
            make.width.equalTo(self.updateButton.mas_width);
            make.height.equalTo(@([BaseTools adaptedWithValue:40]));
            make.right.equalTo(self.updateButton.mas_left).offset(-buttonLeft);
        }];
        [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cancleButton);
            make.left.equalTo(self.cancleButton.mas_right).offset(buttonLeft);
            make.right.equalTo(@(-buttonLeft));
            make.width.height.equalTo(self.cancleButton);
        }];
    }
    [self.updateIconBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(@(backViewLeft));
        make.bottom.equalTo(self.updateButton.mas_bottom).offset([BaseTools adaptedWithValue:30]);
    }];
    
    UIImage *image = [UIImage sd_imageWithName:@"VersionUpdate_Icon"];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake([BaseTools adaptedWithValue:100], [BaseTools adaptedWithValue:1], [BaseTools adaptedWithValue:20], [BaseTools adaptedWithValue:1]);
    // 拉伸图片
    image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    self.updateIconBackImage.image = image;
    
    //显示更新
    [self showWithAlert];
}

/**
 添加Alert入场动画
 */
- (void)showWithAlert{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.6;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.updateIconBackImage.layer addAnimation:animation forKey:nil];
}

/** 取消按钮点击事件 */
- (void)cancelAction{
    [self dismissAlert];
}

/** 更新按钮点击事件 跳转AppStore更新 */
- (void)updateVersion{
//    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@", @"111111"];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:self.model.url];
    if ([application canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [application openURL:url options:@{@"":@""} completionHandler:nil];
        }else{
            [application openURL:url];
        }
    }
}

/** 添加Alert出场动画 */
- (void)dismissAlert{
    [UIView animateWithDuration:0.6 animations:^{
        self.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    } ];
}

@end
