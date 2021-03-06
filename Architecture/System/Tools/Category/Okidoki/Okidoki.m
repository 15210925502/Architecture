//
//  Okidoki.m
//  JHKit
//
//  Created by HaoCold on 2018/9/19.
//  Copyright © 2018年 HaoCold. All rights reserved.
//
//  MIT License
//

#import "Okidoki.h"
#import <objc/runtime.h>

#define kOkidoki_imp(sel,imp) \
- (Okidoki*(^)(id))sel{ \
    return ^id(id sel){ \
        UIView *view = self.view; \
        do { \
            imp; \
        } while (0); \
        return view.okidoki; \
    }; \
}

@interface Okidoki ()

@property (nonatomic,weak) UIView *view;

@end

@implementation Okidoki

#pragma mark - UIView

kOkidoki_imp(tag, ({
    if ([tag isKindOfClass:[NSNumber class]]) {
        view.tag = [tag integerValue];
    }
}))

kOkidoki_imp(frame, ({
    if ([frame isKindOfClass:[NSValue class]]) {
        view.frame = [frame CGRectValue];
    }
}))

kOkidoki_imp(alpha, ({
    if ([alpha isKindOfClass:[NSNumber class]]) {
        view.alpha = [alpha floatValue];
    }
}))

kOkidoki_imp(bgColor, ({
    view.backgroundColor = [UIColor colorWithHexString:bgColor];
}))

kOkidoki_imp(bdColor, ({
    view.layer.borderColor = [[UIColor colorWithHexString:bdColor] CGColor];
}))

kOkidoki_imp(bdWidth, ({
    if([bdWidth isKindOfClass:[NSNumber class]]){
        view.layer.borderWidth = [bdWidth floatValue];
    }
}))

kOkidoki_imp(cnRadius, ({
    if([cnRadius isKindOfClass:[NSNumber class]]){
        view.layer.cornerRadius = [cnRadius floatValue];
    }
}))

kOkidoki_imp(mtBounds, ({
    if([mtBounds isKindOfClass:[NSNumber class]]){
        view.layer.masksToBounds = [mtBounds boolValue];
    }
}))

kOkidoki_imp(text, ({
    if([text isKindOfClass:[NSString class]]){
        if ([view respondsToSelector:@selector(setText:)]) {
            [view performSelector:@selector(setText:) withObject:text];
        }
    }
}))

kOkidoki_imp(font, ({
    if ([font isKindOfClass:[UIFont class]]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            button.titleLabel.font = font;
        }else if ([view respondsToSelector:@selector(setFont:)]) {
            [view performSelector:@selector(setFont:) withObject:font];
        }
    }
}))

kOkidoki_imp(color, ({
    if([view respondsToSelector:@selector(setTextColor:)]){
        [view performSelector:@selector(setTextColor:) withObject:[UIColor colorWithHexString:color]];
    }
}))

kOkidoki_imp(align, ({
    if([align isKindOfClass:[NSNumber class]]){
        if([view respondsToSelector:@selector(setTextAlignment:)]){
            [view performSelector:@selector(setTextAlignment:) withObject:align];
        }
    }
}))

kOkidoki_imp(lineSpaceWithTextView, ({
    if([view isKindOfClass:[UITextView class]] &&
       [lineSpaceWithTextView isKindOfClass:[NSNumber class]]){
        UITextView *label = (UITextView *)view;
        CGFloat space = [lineSpaceWithTextView floatValue];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:label.attributedText ? : [[NSAttributedString alloc] initWithString:label.text]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:space < 0 ? 0 : space];
        paragraphStyle.alignment = label.textAlignment;
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
        label.attributedText = attStr;
    }
}))

kOkidoki_imp(lines, ({
    if([view isKindOfClass:[UILabel class]] &&
       [lines isKindOfClass:[NSNumber class]]){
        [(UILabel *)view setNumberOfLines:[lines integerValue]];
    }
}))

kOkidoki_imp(adjust, ({
    if([view isKindOfClass:[UILabel class]] &&
       [adjust isKindOfClass:[NSNumber class]]){
        [(UILabel *)view setNumberOfLines:[adjust boolValue]];
    }
}))

kOkidoki_imp(lineSpace, ({
    if([view isKindOfClass:[UILabel class]] &&
       [lineSpace isKindOfClass:[NSNumber class]]){
        UILabel *label = (UILabel *)view;
        CGFloat space = [lineSpace floatValue];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:label.attributedText?:[[NSAttributedString alloc] initWithString:label.text]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:space < 0 ? 0 : space];
        paragraphStyle.alignment = label.textAlignment;
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
        label.attributedText = attStr;
    }
}))

kOkidoki_imp(autoWidth, ({
    if([view isKindOfClass:[UILabel class]]){
        UILabel *label = (UILabel *)view;
        CGRect frame = label.frame;
        label.numberOfLines = 1;
        [label sizeToFit];
        if ([autoWidth floatValue] > 0 &&
            label.frame.size.width > [autoWidth floatValue]){
            frame.size.width = [autoWidth floatValue];
        }else{
            frame.size.width = label.frame.size.width;
        }
        label.frame = frame;
    }
}))

kOkidoki_imp(autoHeight, ({
    if([view isKindOfClass:[UILabel class]]){
        UILabel *label = (UILabel *)view;
        CGRect frame = label.frame;
        label.numberOfLines = 0;
        [label sizeToFit];
        if ([autoHeight floatValue] > 0 &&
            label.frame.size.height > [autoHeight floatValue]) {
            frame.size.height = [autoHeight floatValue];
        }else{
            frame.size.height = label.frame.size.height;
        }
        label.frame = frame;
    }
}))

- (Okidoki*(^)(id,id))attributedSubstring{
    return ^id(id string, id value){
        UIView *view = self.view;
        if ([view respondsToSelector:@selector(attributedText)]) {
            NSString *text = [view performSelector:@selector(text)];
            NSAttributedString *attributedText = [view performSelector:@selector(attributedText)];
            if (!attributedText) {
                attributedText = [[NSAttributedString alloc] initWithString:text];
            }
            
            // color
            if ([value isKindOfClass:[UIColor class]]) {
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
                [attStr addAttribute:NSForegroundColorAttributeName value:value range:[text rangeOfString:string]];
                [view performSelector:@selector(setAttributedText:) withObject:attStr];
            }
            // font
            else if ([value isKindOfClass:[UIFont class]]){
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
                [attStr addAttribute:NSFontAttributeName value:value range:[text rangeOfString:string]];
                [view performSelector:@selector(setAttributedText:) withObject:attStr];
            }
        }
        return view.okidoki;
    };
}

- (Okidoki*(^)(id,id,id))attributedSubstringInRange{
    return ^id(id string, id value, id range){
        UIView *view = self.view;
        if ([view respondsToSelector:@selector(attributedText)]) {
            NSString *text = [view performSelector:@selector(text)];
            NSAttributedString *attributedText = [view performSelector:@selector(attributedText)];
            if (!attributedText) {
                attributedText = [[NSAttributedString alloc] initWithString:text];
            }
            
            // color
            if ([value isKindOfClass:[UIColor class]] &&
                [range isKindOfClass:[NSValue class]]) {
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
                [attStr addAttribute:NSForegroundColorAttributeName value:value range:[range rangeValue]];
                [view performSelector:@selector(setAttributedText:) withObject:attStr];
            }
            // font
            else if ([value isKindOfClass:[UIFont class]] &&
                     [range isKindOfClass:[NSValue class]]){
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
                [attStr addAttribute:NSFontAttributeName value:value range:[range rangeValue]];
                [view performSelector:@selector(setAttributedText:) withObject:attStr];
            }
        }
        return view.okidoki;
    };
}

#pragma mark - UIButton
- (Okidoki*(^)(id,id))titleForState{
    return ^id(id title, id state){
        UIView *view = self.view;
        if ([view isKindOfClass:[UIButton class]] &&
            [title isKindOfClass:[NSString class]] &&
            [state isKindOfClass:[NSNumber class]]) {
            [(UIButton *)view setTitle:title forState:[state integerValue]];
        }
        return view.okidoki;
    };
}

- (Okidoki*(^)(id,id))colorForState{
    return ^id(id color, id state){
        UIView *view = self.view;
        if ([view isKindOfClass:[UIButton class]]&&
            [state isKindOfClass:[NSNumber class]]) {
            [(UIButton *)view setTitleColor:[UIColor colorWithHexString:color] forState:[state integerValue]];
        }
        return view.okidoki;
    };
}

- (Okidoki*(^)(id,id))imageForState{
    return ^id(id image, id state){
        UIView *view = self.view;
        if ([view isKindOfClass:[UIButton class]] &&
            [image isKindOfClass:[NSString class]] &&
            [state isKindOfClass:[NSNumber class]]) {
            [(UIButton *)view setImage:image forState:[state integerValue]];
        }
        return view.okidoki;
    };
}

- (Okidoki*(^)(id,id))bgImageForState{
    return ^id(id bgImage, id state){
        UIView *view = self.view;
        if ([view isKindOfClass:[UIButton class]] &&
            [bgImage isKindOfClass:[NSString class]] &&
            [state isKindOfClass:[NSNumber class]]) {
            [(UIButton *)view setBackgroundImage:bgImage forState:[state integerValue]];
        }
        return view.okidoki;
    };
}

- (Okidoki*(^)(id,id))lineSpaceForState{
    return ^id(id lineSpace, id state){
        UIView *view = self.view;
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            CGFloat space = [lineSpace integerValue];
            NSAttributedString *attributedString = [button attributedTitleForState:[state integerValue]]?:[[NSAttributedString alloc] initWithString:button.currentTitle];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:space < 0 ? 0 : space];
            paragraphStyle.alignment = button.titleLabel.textAlignment;
            [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [button.currentAttributedTitle.string length])];
            [button setAttributedTitle:attStr forState:[state integerValue]];
        }
        return view.okidoki;
    };
}

- (Okidoki*(^)(id))imageUpTitleDown{
    return ^id(id offsetY){
        UIView *view = self.view;
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            CGFloat Y = [offsetY floatValue];
            [button layoutSubviews];
            [button setImageEdgeInsets:UIEdgeInsetsMake(-button.titleLabel.intrinsicContentSize.height-Y,0,0,-button.titleLabel.intrinsicContentSize.width)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0,-CGRectGetWidth(button.imageView.frame),-CGRectGetHeight(button.imageView.frame)-Y,0)];
            
        }
        return view.okidoki;
    };
}

- (Okidoki*(^)(id))imageDownTitleUp{
    return ^id(id offsetY){
        UIView *view = self.view;
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            CGFloat Y = [offsetY floatValue];
            [button layoutSubviews];
            [button setImageEdgeInsets:UIEdgeInsetsMake(button.titleLabel.intrinsicContentSize.height+Y,0,0,-button.titleLabel.intrinsicContentSize.width)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(-CGRectGetWidth(button.imageView.frame)-Y,-CGRectGetWidth(button.imageView.frame),0,0)];
        }
        return view.okidoki;
    };
}

- (Okidoki*(^)(id))imageRightTitleLeft{
    return ^id(id offsetX){
        UIView *view = self.view;
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            CGFloat X = [offsetX floatValue];
            [button layoutSubviews];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,-button.titleLabel.intrinsicContentSize.width*2-X)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0,-button.imageView.frame.size.width*2-X,0,0)];
        }
        return view.okidoki;
    };
}

- (Okidoki*(^)(id))imageLeftTitleRight{
    return ^id(id offsetX){
        UIView *view = self.view;
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            CGFloat X = [offsetX floatValue];
            [button layoutSubviews];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,X)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0,X,0,0)];
        }
        return view.okidoki;
    };
}

- (Okidoki*(^)(void))imageCenterTitleCenter{
    return ^id(){
        UIView *view = self.view;
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            [button layoutSubviews];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,-button.titleLabel.intrinsicContentSize.width)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0,-button.imageView.frame.size.width,0,0)];
        }
        return view.okidoki;
    };
}

- (Okidoki*(^)(id,id,id))attributedSubstringForState{
    return ^id(id substring, id value, id state){
        UIView *view = self.view;
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            // color
            if ([value isKindOfClass:[UIColor class]]) {
                NSAttributedString *attributedString = [button attributedTitleForState:[state integerValue]]?:[[NSAttributedString alloc] initWithString:button.currentTitle];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
                [attStr addAttribute:NSForegroundColorAttributeName value:value range:[attributedString.string rangeOfString:substring]];
                [button setAttributedTitle:attStr forState:[state integerValue]];
            }
            // font
            else if ([value isKindOfClass:[UIFont class]]){
                NSAttributedString *attributedString = [button attributedTitleForState:[state integerValue]]?:[[NSAttributedString alloc] initWithString:button.currentTitle];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
                [attStr addAttribute:NSFontAttributeName value:value range:[attributedString.string rangeOfString:substring]];
                [button setAttributedTitle:attStr forState:[state integerValue]];
            }
        }
        return view.okidoki;
    };
}

- (Okidoki*(^)(id,id,id,id))attributedSubstringInRangeForState{
    return ^id(id substring, id value, id range, id state){
        UIView *view = self.view;
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            // color
            if ([value isKindOfClass:[UIColor class]] &&
                [range isKindOfClass:[NSValue class]]) {
                NSAttributedString *attributedString = [button attributedTitleForState:[state integerValue]]?:[[NSAttributedString alloc] initWithString:button.currentTitle];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
                [attStr addAttribute:NSForegroundColorAttributeName value:value range:[range rangeValue]];
                [button setAttributedTitle:attStr forState:[state integerValue]];
            }
            // font
            else if ([value isKindOfClass:[UIFont class]] &&
                     [range isKindOfClass:[NSValue class]]){
                NSAttributedString *attributedString = [button attributedTitleForState:[state integerValue]]?:[[NSAttributedString alloc] initWithString:button.currentTitle];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
                [attStr addAttribute:NSFontAttributeName value:value range:[range rangeValue]];
                [button setAttributedTitle:attStr forState:[state integerValue]];
            }
        }
        return view.okidoki;
    };
}

#pragma mark - UIImageView
kOkidoki_imp(image, ({
    if ([view isKindOfClass:[UIImageView class]]) {
        if ([image isKindOfClass:[NSString class]]) {
            [view performSelector:@selector(setImage:) withObject:[UIImage imageNamed:image]];
        }else if ([image isKindOfClass:[UIImage class]]){
            [view performSelector:@selector(setImage:) withObject:image];
        }
    }
}))

- (Okidoki*(^)(id,id))imageForTintColor{
    return ^id(id image, id color){
        UIView *view = self.view;
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)view;
            imageView.tintColor = [UIColor colorWithHexString:color];
            
            if ([image isKindOfClass:[NSString class]]) {
                imageView.image = [[UIImage imageNamed:image]
                                   imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }else if ([image isKindOfClass:[UIImage class]]){
                imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
        }
        return view.okidoki;
    };
}

#pragma mark - UITextField
kOkidoki_imp(bdStyle, ({
    if ([view isKindOfClass:[UITextField class]] &&
        [bdStyle isKindOfClass:[NSNumber class]]) {
        [view performSelector:@selector(setBorderStyle:) withObject:bdStyle];
    }
}))

kOkidoki_imp(pHolder, ({
    if ([view isKindOfClass:[UITextField class]] &&
        [pHolder isKindOfClass:[NSString class]]) {
        [view performSelector:@selector(setPlaceholder:) withObject:pHolder];
    }
}))

kOkidoki_imp(pHColor, ({
    if ([view isKindOfClass:[UITextField class]]) {
        [view setValue:[UIColor colorWithHexString:pHColor] forKeyPath:@"placeholderLabel.textColor"];
    }
}))

kOkidoki_imp(pHFont, ({
    if ([view isKindOfClass:[UITextField class]] &&
        [pHFont isKindOfClass:[UIFont class]]) {
        [self setValue:pHFont forKeyPath:@"placeholderLabel.font"];
    }
}))

kOkidoki_imp(cbMode, ({
    if ([view isKindOfClass:[UITextField class]] &&
        [cbMode isKindOfClass:[NSNumber class]]) {
        [view performSelector:@selector(setClearButtonMode:) withObject:cbMode];
    }
}))

kOkidoki_imp(lvMode, ({
    if ([view isKindOfClass:[UITextField class]] &&
        [lvMode isKindOfClass:[NSNumber class]]) {
        [view performSelector:@selector(setLeftViewMode:) withObject:lvMode];
    }
}))

kOkidoki_imp(rvMode, ({
    if ([view isKindOfClass:[UITextField class]] &&
        [rvMode isKindOfClass:[NSNumber class]]) {
        [view performSelector:@selector(setRightViewMode:) withObject:rvMode];
    }
}))

kOkidoki_imp(lfView, ({
    if ([view isKindOfClass:[UITextField class]] &&
        [lfView isKindOfClass:[UIView class]]) {
        [view performSelector:@selector(setLeftView:) withObject:lfView];
    }
}))

kOkidoki_imp(rtView, ({
    if ([view isKindOfClass:[UITextField class]] &&
        [rtView isKindOfClass:[UIView class]]) {
        [view performSelector:@selector(setRightView:) withObject:rtView];
    }
}))

kOkidoki_imp(secure, ({
    if ([view isKindOfClass:[UITextField class]] &&
        [secure isKindOfClass:[NSNumber class]]) {
        [view performSelector:@selector(setSecureTextEntry:) withObject:secure];
    }
}))

@end

@implementation UIView (Okidoki)

- (void)setOkidoki:(Okidoki *)okidoki{
    objc_setAssociatedObject(self, @selector(okidoki), okidoki, OBJC_ASSOCIATION_RETAIN);
}

- (Okidoki *)okidoki{
    Okidoki *okidoki = objc_getAssociatedObject(self, _cmd);
    if (!okidoki) {
        okidoki = [[Okidoki alloc] init];
        [okidoki setValue:self forKey:@"view"];
        self.okidoki = okidoki;
    }
    return okidoki;
}

@end
