//
//  HLDTextField+Extension.m
//  Architecture
//
//  Created by HLD on 2020/6/2.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

#import "HLDTextField+Extension.h"

@implementation HLDTextField (Extension)

@end

@implementation HLDTextField (RegularVaild)

- (BOOL)validateMaxLenght:(NSString *)text {
    if (!self.isCheckEnable){
        return YES;
    }
    if (text.length > 0) {
        NSInteger maxLength = (self.maxLength > 0) ? self.maxLength : [tf_dict[@"maxLength"][self.typeKeys[self.textFieldType]] integerValue];
        if (text.length > maxLength - 1){
            return NO;
        }
    }
    return YES;
}

- (BOOL)validateMaxLenght:(NSString *)text aString:(NSString *)aString {
    if (!self.isCheckEnable){
        return YES;
    }
    if (text.length > 0) {
        NSInteger maxLength = (self.maxLength > 0) ? self.maxLength : [tf_dict[@"maxLength"][self.typeKeys[self.textFieldType]] integerValue];
        if (text.length > maxLength - 1){
            return NO;
        }
    }
    BOOL result = YES;
    self.regexChar = (self.regexChar) ? self.regexChar : tf_dict[@"charRegx"][self.typeKeys[self.textFieldType]];
    if (self.regexChar.length > 0) {
        NSError *error = nil;
        NSRegularExpression *regx = [[NSRegularExpression alloc]initWithPattern:self.regexChar options:NSRegularExpressionCaseInsensitive error:&error];
        if (!error){
            result = ([regx numberOfMatchesInString:aString options:NSMatchingAnchored range:NSMakeRange(0, aString.length)] > 0);
        }
    }
    return result;
}

- (BOOL)validateWholeCharacters:(NSString *)text{
    if (!self.isCheckEnable)  {
        self.verifyOK = YES;
        return YES;
    }
    NSString *regx = self.regx ? self.regx : tf_dict[@"regx"][self.typeKeys[self.textFieldType]];
    BOOL result = YES;
    NSPredicate *valiatePre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regx];
    result = [valiatePre evaluateWithObject:self.realText];
    self.verifyOK = result;
    return result;
}

@end

@implementation HLDTextField (HandleSpaceText)

- (NSString *)getRealTextWithSperetorRegx:(NSString *)seRegx {
    if ([self.text isEqualToString:@""]){
        return @"";
    }
    if (self.regexSeperator){
        seRegx = self.regexSeperator;
    }
    seRegx = seRegx ? seRegx : tf_dict[@"seperatorRegx"][self.typeKeys[self.textFieldType]];
    NSString *realStr = [self.text mutableCopy];
    if (seRegx.length > 0) {
        NSMutableString *mutableStr = [self.text mutableCopy];
        [mutableStr replaceOccurrencesOfString:seRegx withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, mutableStr.length)];
        realStr = [mutableStr copy];
    }
    return realStr;
}

- (NSString *)separateTextWithSperator:(NSString *)seperator {
    if (self.regexSeperator){
        seperator = self.seperator;
    }
    seperator = seperator ? seperator :tf_dict[@"seperator"][self.typeKeys[self.textFieldType]];
    NSMutableString *mutableStr = [[self getRealTextWithSperetorRegx:nil] mutableCopy];
    if (seperator.length > 0) {
        NSArray *seperators = self.seperators ? self.seperators : tf_dict[@"seperators"][self.typeKeys[self.textFieldType]];
        NSInteger index = 0;
        for (int i = 0; i < seperators.count; i++) {
            index += [seperators[i] integerValue];
            if ((index + i * (seperator.length)) >= mutableStr.length){
                break;
            }
            [mutableStr insertString:seperator atIndex:(index + i * seperator.length)];
        }
    }
    return [mutableStr copy];
}

@end

@implementation HLDTextField (HandleMoneyText)

- (NSString *)getCreditAmountWithTag:(int)tag {
    if ([self.text isEqualToString:@""]){
        return @"";
    }
    NSMutableString *mutableStr = [self.text mutableCopy];
    if  ([mutableStr containsString:@"¥"]){
        [mutableStr replaceOccurrencesOfString:@"¥" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mutableStr.length-1)];
    }
    if  ([mutableStr containsString:@","]){
        [mutableStr replaceOccurrencesOfString:@"," withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mutableStr.length-1)];
    }
    if  (![mutableStr containsString:@"."]){
        [mutableStr appendString:@".00"];
    }
    NSRange sperateRange = [mutableStr rangeOfString:@"."];
    NSMutableString *rightStr = [[mutableStr substringToIndex:sperateRange.location] mutableCopy];
    
    NSString *leftStr = [mutableStr substringFromIndex:sperateRange.location + 1];
    if (leftStr.length < 2){
        leftStr = [@"00" mutableCopy];
    }
    
    NSString *tagStr = (tag == 0) ? @"¥" : @"$";
    int count = (int)rightStr.length / 3;
    int mod = rightStr.length % 3;
    if(mod > 0){
        for(int index = 1;index <= count;index++){
            [rightStr insertString:@"," atIndex:rightStr.length - 1 - (index * 3 - 1 + (index - 1))];
        }
    }else{
        for(int index = 1;index <= count - 1;index++){
            [rightStr insertString:@"," atIndex:rightStr.length - 1 - (index * 3 - 1 + (index - 1))];
        }
    }
    NSString *finalStr = [NSString stringWithFormat:@"%@%@.%@",tagStr,rightStr,leftStr];
    return finalStr;
}

- (NSString *)getRealCreditAmountWithTag:(int)tag {
    if (HLDTextFieldType_money != self.textFieldType){
        return self.text;
    }
    NSString *tagStr = (tag == 0) ? @"¥" : @"$";
    NSMutableString *mutableStr = [self.text mutableCopy];
    if  ([mutableStr containsString:@"¥"]){
        [mutableStr replaceOccurrencesOfString:tagStr withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mutableStr.length - 1)];
    }
    if  ([mutableStr containsString:@","]){
        [mutableStr replaceOccurrencesOfString:@"," withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mutableStr.length - 1)];
    }
    if  ([mutableStr containsString:@"."]){
        NSInteger locaiton = [mutableStr rangeOfString:@"."].location;
        [mutableStr replaceCharactersInRange:NSMakeRange(locaiton, mutableStr.length - locaiton) withString:@""];
    }
    return [mutableStr copy];
}

- (NSString *)getRealAmountHasDecimal:(BOOL)hasPot {
    NSMutableString *mutableStr = [self.text mutableCopy];
    [mutableStr replaceOccurrencesOfString:@"[$¥,]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, mutableStr.length)];
    if (mutableStr.length == 0){
        return nil;
    }
    NSMutableString *left,*pot,*right;
    NSInteger potLocaiton;
    pot = [mutableStr containsString:@"."] ? [@"." mutableCopy ] : nil;
    if (pot) {
        potLocaiton = [mutableStr rangeOfString:pot].location;
        left   = [[mutableStr substringToIndex:potLocaiton] mutableCopy];
        right  = [[mutableStr substringFromIndex:potLocaiton] mutableCopy];
        if (right.length == 0) {
            [right appendString:@"00"];
        }else {
            int     ri  = [right intValue];
            CGFloat rf  = ri / (10 * right.length) * 0.f;
            right       = [NSMutableString stringWithFormat:@"%0.2f",rf];
        }
        if (left.length == 0){
            left = [@"0" mutableCopy];
        }
    }
    return hasPot ? [NSString stringWithFormat:@"%@,%@,%@",left,pot,right] : [mutableStr copy];
}

- (NSString *)seperatorMoneyWithPrefix:(NSString *)prefix
                              sperator:(NSString *)seperator
                            hasDecimal:(BOOL)hasPot {
    NSMutableString *mutableStr = [[self getRealAmountHasDecimal:hasPot] mutableCopy];
    NSMutableString  *left = [NSMutableString string];
    NSMutableString *right = [NSMutableString string];
    if (hasPot) {
        NSInteger potLocaiton = [mutableStr rangeOfString:@"."].location;
        left  = [[mutableStr substringToIndex:potLocaiton] mutableCopy];
        right = [[mutableStr substringFromIndex:potLocaiton+1] mutableCopy];
    }else{
        left = [mutableStr copy];
    }
    
    if (!prefix){
        prefix = @"¥";
    }
    if (!seperator){
        seperator = @",";
    }
    NSInteger space = 3;
    NSInteger mod = left.length % space;
    const char *ch = [left UTF8String];
    NSMutableString *tempString = [NSMutableString string];
    int j = 0;
    for (int index = 0; index < left.length; index++) {
        [tempString appendString:[NSString stringWithFormat:@"%c",ch[index]]];
        j++;
        if (index == left.length - 1 && mod == 0) {
            continue;
        }
        if (j / space == 1 ) {
            [tempString appendString:seperator];
            j = 0;
        }
    }
    return [NSString stringWithFormat:@"%@%@%@",prefix,tempString,hasPot?right:@""];
}

@end

@implementation HLDTextField (handleErrorAnimation)

- (void)showErrorType:(ErrorType)errorType notice:(NSString *)notice{
    __weak typeof(*&self) weaKSelf = self;
    UIColor *errorColor = [UIColor redColor];
    weaKSelf.textColor = errorColor;
    switch (errorType) {
        case ErrorType_shake:
            [self shakeAnimation:0.1];
            break;
        case ErrorType_tips:
            [self shakeAnimation:0.1];
            break;
        case ErrorType_charError:
            NSLog(@"弹窗：%@",notice);
            // [self shakeAnimation:0.1];
            break;
        case ErrorType_finalVadilateError:
            NSLog(@"弹窗：%@",notice);
            //  [self shakeAnimation:0.1];
            break;
        default:
            break;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weaKSelf.layer removeAllAnimations];
        weaKSelf.textColor = [UIColor blackColor];
        [self setNeedsDisplay];
    });
}

- (void)shakeAnimation:(NSTimeInterval)duration {
    if (!self.isShakeEnable){
        return;
    }
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.fromValue = @0;
    shake.toValue = @5;
    shake.repeatCount  = MAXFLOAT;
    shake.autoreverses = YES;
    shake.duration = duration;
    [self.layer addAnimation:shake forKey:@"shake"];
}

@end
