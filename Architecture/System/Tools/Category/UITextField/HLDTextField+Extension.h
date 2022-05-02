//
//  HLDTextField+Extension.h
//  Architecture
//
//  Created by HLD on 2020/6/2.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "HLDTextField.h"

typedef NS_ENUM(NSInteger,ErrorType){
    ErrorType_shake              = 1,
    ErrorType_tips               = 2,
    ErrorType_charError          = 3,
    ErrorType_finalVadilateError = 4,
};

@interface HLDTextField (Extension)

@end

@interface HLDTextField (RegularVaild)

- (BOOL)validateMaxLenght:(NSString *)text
                  aString:(NSString *)aString;
- (BOOL)validateWholeCharacters:(NSString *)text;

@end

@interface HLDTextField (HandleSpaceText)

- (NSString *)getRealTextWithSperetorRegx:(NSString *)seRegx;
- (NSString *)separateTextWithSperator:(NSString *)seperator;

@end

@interface HLDTextField (HandleMoneyText)

- (NSString *)getRealAmountHasDecimal:(BOOL)hasPot;
- (NSString *)seperatorMoneyWithPrefix:(NSString *)prefix
                              sperator:(NSString *)seperator
                            hasDecimal:(BOOL)hasPot;
- (NSString *)getCreditAmountWithTag:(int)tag;
- (NSString *)getRealCreditAmountWithTag:(int)tag;

@end

@interface HLDTextField (handleErrorAnimation)

- (void)showErrorType:(ErrorType)errorType
               notice:(NSString *)notice;

@end
