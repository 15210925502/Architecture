//
//  UIButton+BAState.m
//  BAButton
//
//  Created by 任子丰 on 17/5/25.
//  Copyright © 2017年 boai. All rights reserved.
//

#define BABackgroundColorKEY(state) [NSString stringWithFormat:@"backgroundColor%zd",state]
#define BABorderColorKEY(state) [NSString stringWithFormat:@"borderColor%zd",state]

#import "UIButton+BAState.h"
#import "UIButton_ConfigurationDefine.h"
#import <objc/runtime.h>

// Model
@interface BAPropertyModel : NSObject

@property (nonatomic, assign) UIControlState state;
@property (nonatomic, copy)   NSString *keyPath;
@property (nonatomic, weak)   id value;

+ (instancetype)propertyModelWithValue:(nullable id)value
                               keyPath:(NSString *)keyPath
                                 state:(UIControlState)state;

@end

@implementation BAPropertyModel

+ (instancetype)propertyModelWithValue:(id)value
                               keyPath:(NSString *)keyPath
                                 state:(UIControlState)state {
    BAPropertyModel *model = [BAPropertyModel new];
    model.value = value;
    model.keyPath = keyPath;
    model.state = state;
    return model;
}

@end

@interface UIButton ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *animates;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIColor *> *borderColors;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIColor *> *backgroundColors;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIFont *> *titleLabelFonts;
@property (nonatomic, strong) NSMutableArray<BAPropertyModel *> *subViewPropertyArr;
@property (nonatomic, assign) NSInteger subViewTag;

@end

@implementation UIButton (BAState)

#pragma mark - lefe cycle

+ (void)load {
    [self swizzleInstanceMethodWithOriginSel:@selector(setHighlighted:)
                                 swizzledSel:@selector(ba_setHighlighted:)];
    [self swizzleInstanceMethodWithOriginSel:@selector(setEnabled:)
                                 swizzledSel:@selector(ba_setEnabled:)];
    [self swizzleInstanceMethodWithOriginSel:@selector(setSelected:)
                                 swizzledSel:@selector(ba_setSelected:)];
}

#pragma mark - public method

- (UIColor *)ba_currentBorderColor {
    UIColor *color = [self ba_buttonBorderColorForState:self.state];
    if (!color) {
        color = [UIColor colorWithCGColor:self.layer.borderColor];
    }
    return color;
}

- (UIColor *)ba_currentBackgroundColor {
    UIColor *color = [self ba_buttonBackgroundColorForState:self.state];
    if (!color) {
        color = self.backgroundColor;
    }
    return color;
}

- (UIFont *)ba_currentTitleLabelFont {
    UIFont *font = [self ba_buttonTitleLabelFontForState:(self.state-1)];
    if (!font) {
        font = self.titleLabel.font;
    }
    return font;
}

- (void)ba_buttonSetBackgroundColor:(UIColor *)backgroundColor
                           forState:(UIControlState)state animated:(BOOL)animated {
    if (backgroundColor) {
        [self.backgroundColors setObject:backgroundColor forKey:@(state)];
        [self.animates setObject:@(animated) forKey:BABackgroundColorKEY(state)];
    }
    if(self.state == state) {
        self.backgroundColor = backgroundColor;
    }
}

- (void)ba_buttonSetborderColor:(UIColor *)borderColor
                       forState:(UIControlState)state animated:(BOOL)animated {
    if (borderColor) {
        [self.borderColors setObject:borderColor forKey:@(state)];
        [self.animates setObject:@(animated) forKey:BABorderColorKEY(state)];
    }
    if(self.state == state) {
        self.layer.borderColor = borderColor.CGColor;
    }
}

- (void)ba_buttonSetTitleLabelFont:(UIFont *)titleLabelFont
                          forState:(UIControlState)state {
    if (titleLabelFont) {
        [self.titleLabelFonts setObject:titleLabelFont forKey:@(state)];
    }
    if(self.state == state) {
        self.titleLabel.font = titleLabelFont;
    }
}

- (UIColor *)ba_buttonBorderColorForState:(UIControlState)state {
    return [self.borderColors objectForKey:@(state)];
}

- (UIColor *)ba_buttonBackgroundColorForState:(UIControlState)state {
    return [self.backgroundColors objectForKey:@(state)];
}

- (UIFont *)ba_buttonTitleLabelFontForState:(UIControlState)state {
    return [self.titleLabelFonts objectForKey:@(state)];
}

- (void)ba_buttonConfigBorderColors:(NSDictionary <NSNumber *,UIColor *>*)borderColors {
    self.borderColors = [borderColors mutableCopy];
    [borderColors enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.animates setObject:@(NO) forKey:BABorderColorKEY(key.integerValue)];
    }];
    [self updateButton];
}

- (void)ba_buttonConfigBackgroundColors:(NSDictionary <NSNumber *,UIColor *>*)backgroundColors {
    self.backgroundColors = [backgroundColors mutableCopy];
    [backgroundColors enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.animates setObject:@(NO) forKey:BABackgroundColorKEY(key.integerValue)];
    }];
    [self updateButton];
}

- (void)ba_buttonConfigTitleLabelFont:(NSDictionary<NSNumber *,UIFont *> *)titleLabelFonts {
    self.titleLabelFonts = [titleLabelFonts mutableCopy];
    [self updateButton];
}

#pragma mark - override

- (void)ba_setSelected:(BOOL)selected {
    [self ba_setSelected:selected];
    [self updateButton];
}

- (void)ba_setEnabled:(BOOL)enabled {
    [self ba_setEnabled:enabled];
    [self updateButton];
}

- (void)ba_setHighlighted:(BOOL)highlighted {
    [self ba_setHighlighted:highlighted];
    [self updateButton];
}

#pragma mark - private method

- (void)updateButton {
    // updateBackgroundColor
    UIColor *backgroundColor = [self ba_buttonBackgroundColorForState:self.state];
    if (backgroundColor) {
        [self updateBackgroundColor:backgroundColor];
    } else {
        UIColor *normalColor = [self ba_buttonBackgroundColorForState:UIControlStateNormal];
        if (normalColor) {
            [self updateBackgroundColor:normalColor];
        }
    }
    
    // updateBorderColor
    UIColor *borderColor = [self ba_buttonBorderColorForState:self.state];
    if (borderColor) {
        [self updateBorderColor:borderColor];
    } else {
        UIColor *normalColor = [self ba_buttonBorderColorForState:UIControlStateNormal];
        if (normalColor) {
            [self updateBorderColor:normalColor];
        }
    }
    
    // updateTitleLabelFont
    UIFont *titleLabelFont = [self ba_buttonTitleLabelFontForState:self.state];
    if (titleLabelFont) {
        self.titleLabel.font = titleLabelFont;
    } else {
        UIFont *normalFont = [self ba_buttonTitleLabelFontForState:UIControlStateNormal];
        if (normalFont) {
            self.titleLabel.font = normalFont;
        }
    }
    
    // updateSubViewProperty
    UIView *subView = [self viewWithTag:self.subViewTag];
    if (subView && self.subViewPropertyArr.count>0) {
        [self.subViewPropertyArr enumerateObjectsUsingBlock:^(BAPropertyModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            //点击一次,方法多次调用,model.value可能为nil,此时不应进入赋值,否则覆盖掉之前的值
            if (self.state == model.state && model.value) {
                //转换成nil
                id nullableValue = (model.value == [NSNull null]) ? nil : model.value;
                [subView setValue:nullableValue forKeyPath:model.keyPath];
            }
        }];
    }
}

- (void)updateBackgroundColor:(UIColor *)backgroundColor {
    NSNumber *animateValue = [self.animates objectForKey:BABackgroundColorKEY(self.state)];
    if (!animateValue) return;//不存在
    
    if (animateValue.integerValue == self.subViewTag) {
        self.backgroundColor = backgroundColor;
    } else { //等于1
        [UIView animateWithDuration:self.ba_animatedDuration animations:^{
            self.backgroundColor = backgroundColor;
        }];
    }
}

- (void)updateBorderColor:(UIColor *)borderColor {
    NSNumber *animateValue = [self.animates objectForKey:BABorderColorKEY(self.state)];

    if (!animateValue) return;//不存在
    
    if (animateValue.integerValue == 0) {
        self.layer.borderColor = borderColor.CGColor;
        [self.layer removeAnimationForKey:@"KEYAnimation"];
    } else {//等于1
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        animation.fromValue = (__bridge id _Nullable)(self.layer.borderColor);
        animation.toValue = (__bridge id _Nullable)(borderColor.CGColor);
        animation.duration = self.ba_animatedDuration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [self.layer addAnimation:animation forKey:@"KEYAnimation"];
        self.layer.borderColor = borderColor.CGColor;
    }
}

#pragma mark - getters and setters

- (void)setAnimates:(NSMutableDictionary *)animates {
    objc_setAssociatedObject(self, @selector(animates), animates, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)animates {
    NSMutableDictionary *animates = objc_getAssociatedObject(self, _cmd);
    if (!animates) {
        animates = [NSMutableDictionary new];
        self.animates = animates;
    }
    return animates;
}

- (void)setBorderColors:(NSMutableDictionary *)borderColors {
    objc_setAssociatedObject(self, @selector(borderColors), borderColors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)borderColors {
    NSMutableDictionary *borderColors = objc_getAssociatedObject(self, _cmd);
    if (!borderColors) {
        borderColors = [NSMutableDictionary new];
        self.borderColors = borderColors;
    }
    return borderColors;
}

- (void)setBackgroundColors:(NSMutableDictionary *)backgroundColors {
    objc_setAssociatedObject(self, @selector(backgroundColors), backgroundColors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)backgroundColors {
    NSMutableDictionary *backgroundColors = objc_getAssociatedObject(self, _cmd);
    if(!backgroundColors) {
        backgroundColors = [[NSMutableDictionary alloc] init];
        self.backgroundColors = backgroundColors;
    }
    return backgroundColors;
}

- (void)setTitleLabelFonts:(NSMutableDictionary *)titleLabelFonts {
    objc_setAssociatedObject(self, @selector(titleLabelFonts), titleLabelFonts, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)titleLabelFonts {
    NSMutableDictionary *titleLabelFonts = objc_getAssociatedObject(self, _cmd);
    if(!titleLabelFonts) {
        titleLabelFonts = [[NSMutableDictionary alloc] init];
        self.titleLabelFonts = titleLabelFonts;
    }
    return titleLabelFonts;
}

- (void)setBa_animatedDuration:(NSTimeInterval)ba_animatedDuration {
    objc_setAssociatedObject(self, @selector(ba_animatedDuration), @(ba_animatedDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)ba_animatedDuration {
    NSTimeInterval duartion = [objc_getAssociatedObject(self, _cmd) doubleValue];
    if (duartion == 0) {
        duartion = 0.25;
    }
    return duartion;
}

- (void)setSubViewPropertyArr:(NSMutableArray<BAPropertyModel *> *)subViewPropertyArr {
    objc_setAssociatedObject(self, @selector(subViewPropertyArr), subViewPropertyArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<BAPropertyModel *> *)subViewPropertyArr {
    NSMutableArray *subViewPropertyArr = objc_getAssociatedObject(self, _cmd);
    if(!subViewPropertyArr) {
        subViewPropertyArr = [[NSMutableArray alloc] init];
        self.subViewPropertyArr = subViewPropertyArr;
    }
    return subViewPropertyArr;
}

- (void)setSubViewTag:(NSInteger)subViewTag {
    objc_setAssociatedObject(self, @selector(subViewTag), @(subViewTag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)subViewTag {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

@end
