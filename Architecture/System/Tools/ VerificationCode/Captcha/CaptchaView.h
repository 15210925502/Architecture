//
//  CaptchaView.h
//  yanZhengCode
//
//  Created by 王双龙 on 16/8/3.
//  Copyright © 2016年 王双龙. All rights reserved.
//

//识别图中字符
//识别图中字符
//识别图中字符
#import <UIKit/UIKit.h>

typedef enum {
    DefaultType,   //字符串验证码界面
    CountType     //算数验证码
} IdentifyingCodeType;

@interface CaptchaView : UIView

@property (nonatomic,assign) IdentifyingCodeType codeType;    //验证码类型

- (instancetype)initWithFrame:(CGRect)frame WithType:(IdentifyingCodeType)type;

@end
