//
//  WMZCodeView.m
//  ZKVerifyViewDemo
//
//  Created by 华令冬 on 2019/5/23.
//  Copyright © 2019 bestdew. All rights reserved.
//

//间距
#define margin 10
//背景图片宽度
#define imageHeight 200
//默认需要点击文本的数量
#define codeLabelCount 4
//默认还需要添加的点击文本的数量
#define codeAddLabelCount 3
//字体
#define WMZfont 24

#import "WMZCodeView.h"

@interface WMZCodeView()

@property(nonatomic,copy) callBack block;                      //回调
@property(nonatomic,strong) UILabel *tipLabel;                 //提示文本
@property(nonatomic,strong) UIImageView *mainImage;            //背景图片
@property(nonatomic,copy) NSString *allChinese;                //所显示的所有中文
@property(nonatomic,copy) NSString *factChinese;               //实际需要点击的中文
@property(nonatomic,copy) NSString *selectChinese;             //点击的中文
@property(nonatomic,strong) NSMutableArray *btnArr;            //按钮数组

@end

@implementation WMZCodeView

- (void)addCodeViewWithWitgFrame:(CGRect)rect withBlock:(callBack)block{
    self.block = block;
    self.frame = rect;
    [self refreshAction];
}

//刷新按钮事件
- (void)refreshAction{
    self.selectChinese = @"";
    self.mainImage.image = [UIImage sd_imageWithName:@"lb1_Black"];
    self.factChinese = [self getRandomChineseWithCount:codeLabelCount];
    self.allChinese = [NSString stringWithFormat:@"%@%@",self.factChinese,[self getRandomChineseWithCount:codeAddLabelCount]];
    [self setMyTipLabetText];
    [self addLabelImage];
}

//获取随机数量中文
- (NSString *)getRandomChineseWithCount:(NSInteger)count{
    NSMutableString *mString = [[NSMutableString alloc] initWithString:@""];
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    for (int i = 0; i<count; i++) {
        NSInteger randomH = 0xA1+arc4random()%(0xFE - 0xA1+1);
        NSInteger randomL = 0xB0+arc4random()%(0xF7 - 0xB0+1);
        NSInteger number = (randomH<<8)+randomL;
        NSData *data = [NSData dataWithBytes:&number length:2];
        NSString *string = [[NSString alloc] initWithData:data encoding:gbkEncoding];
        if (string) {
            [mString appendString:string];
        }
    }
    return [NSString stringWithFormat:@"%@",mString];
}

//设置提示文本
- (void)setMyTipLabetText{
    NSString *str = [NSString stringWithFormat:@"按顺序点击‘%@’完成验证",self.factChinese];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:WMZfont + 2] range:[str rangeOfString:self.factChinese]];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:self.factChinese]];
    self.tipLabel.attributedText = attStr;
}

//添加随机位置的文本
- (void)addLabelImage{
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (int i = 0; i< self.allChinese.length; i++) {
        [tempArr addObject:[self.allChinese substringWithRange:NSMakeRange(i, 1)]];
    }
    NSArray *arr = [NSArray arrayWithArray:tempArr];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    
    NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
    for (int i = 0; i < arr.count; i++) {
        [string appendString:arr[i]];
    }
    self.allChinese = [NSString stringWithFormat:@"%@",string];
    CGFloat btnWidth = (self.frame.size.width - 2 * margin - (arr.count - 1) * margin) / arr.count;
    if (self.btnArr.count == 0) {
        UIButton *tempBtn = nil;
        for (int i = 0; i < arr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:20.0];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = btnWidth / 2;
            [btn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
            CGFloat h = [self getRandomNumber:btnWidth to:imageHeight - margin];
            if (!tempBtn) {
                btn.frame = CGRectMake(margin, h, btnWidth, btnWidth);
            }else{
                btn.frame = CGRectMake(CGRectGetMaxX(tempBtn.frame) + margin, h, btnWidth, btnWidth);
            }
            [self addSubview:btn];
            tempBtn = btn;
            [self.btnArr addObject:btn];
        }
    }else{
        for (int i = 0; i < self.btnArr.count; i++) {
            UIButton *btn = self.btnArr[i];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            CGFloat h = [self getRandomNumber:btnWidth to:imageHeight - margin];
            btn.frame = CGRectMake(btn.frame.origin.x, h, btnWidth, btnWidth);
        }
    }
}

//按钮点击事件
- (void)tapAction:(UIButton*)btn{
    self.selectChinese = [NSString stringWithFormat:@"%@%@",self.selectChinese ? : @"",btn.titleLabel.text];
    btn.backgroundColor = [UIColor redColor];
    if (self.factChinese.length == self.selectChinese.length) {
        if ([self.factChinese isEqualToString:self.selectChinese]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __weak WMZCodeView *codeView = self;
                if (codeView.block) {
                    codeView.block(YES);
                }
            });
        }
        [self refreshAction];
    }
}

//获取一个随机整数，范围在[from, to]，包括from，包括to
- (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:WMZfont];
        _tipLabel.frame = CGRectMake(margin, margin, self.frame.size.width - margin * 2, 30);
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [[UIImageView alloc] init];
        _mainImage.frame = CGRectMake(margin, CGRectGetMaxY(self.tipLabel.frame) +  margin, self.frame.size.width - margin * 2, imageHeight);
        _mainImage.contentMode =  UIViewContentModeScaleAspectFill;
        _mainImage.clipsToBounds = YES;
        _mainImage.userInteractionEnabled = YES;
        [self addSubview:_mainImage];
    }
    return _mainImage;
}

- (NSMutableArray *)btnArr{
    if (!_btnArr) {
        _btnArr = [[NSMutableArray alloc] init];
    }
    return _btnArr;
}

@end
