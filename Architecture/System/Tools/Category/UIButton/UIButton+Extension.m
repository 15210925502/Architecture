//
//  UIButton+Extension.m
//  BAButtonDemo
//
//  Created by boai on 2017/5/17.
//  Copyright © 2017年 博爱之家. All rights reserved.
//

#import "UIButton+Extension.h"
#import "UIButton_ConfigurationDefine.h"

@implementation UIButton (Extension)

- (void)setupButtonLayout{
    CGFloat image_w = self.imageView.bounds.size.width;
    CGFloat image_h = self.imageView.bounds.size.height;
    
    CGFloat title_w = self.titleLabel.intrinsicContentSize.width;
    CGFloat title_h = self.titleLabel.intrinsicContentSize.height;
    
    UIEdgeInsets imageEdge = UIEdgeInsetsZero;
    UIEdgeInsets titleEdge = UIEdgeInsetsZero;
    
    if (self.ba_padding_inset == 0){
        self.ba_padding_inset = 5;
    }
    
    switch (self.ba_buttonLayoutType) {
        case BAKit_ButtonLayoutTypeNormal:
        {
            titleEdge = UIEdgeInsetsMake(0, self.ba_padding, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, 0, 0, self.ba_padding);
        }
            break;
        case BAKit_ButtonLayoutTypeCenterImageRight:
        {
            titleEdge = UIEdgeInsetsMake(0, -image_w - self.ba_padding, 0, image_w);
            imageEdge = UIEdgeInsetsMake(0, title_w + self.ba_padding, 0, -title_w);
        }
            break;
        case BAKit_ButtonLayoutTypeCenterImageTop:
        {
            titleEdge = UIEdgeInsetsMake(0, -image_w, -image_h - self.ba_padding, 0);
            imageEdge = UIEdgeInsetsMake(-title_h - self.ba_padding, 0, 0, -title_w);
        }
            break;
        case BAKit_ButtonLayoutTypeCenterImageBottom:
        {
            titleEdge = UIEdgeInsetsMake(-image_h - self.ba_padding, -image_w, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, 0, -title_h - self.ba_padding, -title_w);
        }
            break;
        case BAKit_ButtonLayoutTypeLeftImageLeft:
        {
            titleEdge = UIEdgeInsetsMake(0, self.ba_padding + self.ba_padding_inset, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, self.ba_padding_inset, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
            break;
        case BAKit_ButtonLayoutTypeLeftImageRight:
        {
            titleEdge = UIEdgeInsetsMake(0, -image_w + self.ba_padding_inset, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, title_w + self.ba_padding + self.ba_padding_inset, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
            break;
        case BAKit_ButtonLayoutTypeRightImageLeft:
        {
            imageEdge = UIEdgeInsetsMake(0, 0, 0, self.ba_padding + self.ba_padding_inset);
            titleEdge = UIEdgeInsetsMake(0, 0, 0, self.ba_padding_inset);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
            break;
        case BAKit_ButtonLayoutTypeRightImageRight:
        {
            titleEdge = UIEdgeInsetsMake(0, 0, 0, image_w + self.ba_padding + self.ba_padding_inset);
            imageEdge = UIEdgeInsetsMake(0, 0, 0, -title_w + self.ba_padding_inset);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
            break;
            
        default:
            break;
    }
    self.imageEdgeInsets = imageEdge;
    self.titleEdgeInsets = titleEdge;
}

#pragma mark - 快速创建 button

+ (instancetype)ba_buttonWithFrame:(CGRect)frame
                             title:(NSString * __nullable)title
                        titleColor:(UIColor * __nullable)titleColor
                         titleFont:(UIFont * __nullable)titleFont{
    return [UIButton ba_buttonWithFrame:frame title:title titleColor:titleColor titleFont:titleFont backgroundColor:nil];
}

+ (instancetype)ba_buttonWithFrame:(CGRect)frame
                             title:(NSString * __nullable)title
                   backgroundColor:(UIColor * __nullable)backgroundColor{
    return [UIButton ba_buttonWithFrame:frame title:title titleColor:nil titleFont:nil backgroundColor:backgroundColor];
}

+ (instancetype)ba_buttonWithFrame:(CGRect)frame
                             title:(NSString * __nullable)title
                        titleColor:(UIColor * __nullable)titleColor
                         titleFont:(UIFont * __nullable)titleFont
                   backgroundColor:(UIColor * __nullable)backgroundColor{
    return [UIButton ba_buttonWithFrame:frame title:title titleColor:titleColor titleFont:titleFont image:nil backgroundColor:backgroundColor];
}

+ (instancetype)ba_buttonWithFrame:(CGRect)frame
                             title:(NSString * __nullable)title
                   backgroundImage:(UIImage * __nullable)backgroundImage{
    return [UIButton ba_buttonWithFrame:frame title:title titleColor:nil titleFont:nil image:nil backgroundImage:backgroundImage];
}

+ (instancetype)ba_buttonWithFrame:(CGRect)frame
                             title:(NSString * __nullable)title
                        titleColor:(UIColor * __nullable)titleColor
                         titleFont:(UIFont * __nullable)titleFont
                             image:(UIImage * __nullable)image
                   backgroundColor:(UIColor * __nullable)backgroundColor{
    return [UIButton ba_buttonWithFrame:frame title:title selectedTitle:nil highlightedTitle:nil titleColor:titleColor selectedTitleColor:nil highlightedTitleColor:nil titleFont:titleFont image:image selectedImage:nil highlightedImage:nil backgroundImage:nil selectedBackgroundImage:nil highlightedBackgroundImage:nil backgroundColor:backgroundColor];
}

+ (instancetype)ba_buttonWithFrame:(CGRect)frame
                             title:(NSString * __nullable)title
                        titleColor:(UIColor * __nullable)titleColor
                         titleFont:(UIFont * __nullable)titleFont
                             image:(UIImage * __nullable)image
                   backgroundImage:(UIImage * __nullable)backgroundImage{
    return [UIButton ba_buttonWithFrame:frame title:title selectedTitle:nil highlightedTitle:nil titleColor:titleColor selectedTitleColor:nil highlightedTitleColor:nil titleFont:titleFont image:image selectedImage:nil highlightedImage:nil backgroundImage:backgroundImage selectedBackgroundImage:nil highlightedBackgroundImage:nil backgroundColor:nil];
}

+ (instancetype __nonnull)ba_creatButtonWithFrame:(CGRect)frame
                                            title:(NSString * __nullable)title
                                         selTitle:(NSString * __nullable)selTitle
                                       titleColor:(UIColor * __nullable)titleColor
                                        titleFont:(UIFont * __nullable)titleFont
                                            image:(UIImage * __nullable)image
                                         selImage:(UIImage * __nullable)selImage
                                          padding:(CGFloat)padding
                              buttonPositionStyle:(BAKit_ButtonLayoutType)buttonLayoutType
                               viewRectCornerType:(BAKit_ViewRectCornerType)viewRectCornerType
                                 viewCornerRadius:(CGFloat)viewCornerRadius
                                           target:(id __nullable)target
                                         selector:(SEL __nullable)sel{
    UIButton *button = [UIButton ba_buttonWithFrame:frame title:title selectedTitle:selTitle highlightedTitle:nil titleColor:titleColor selectedTitleColor:nil highlightedTitleColor:nil titleFont:titleFont image:image selectedImage:selImage highlightedImage:nil backgroundImage:nil selectedBackgroundImage:nil highlightedBackgroundImage:nil backgroundColor:nil];
    [button ba_button_setButtonLayoutType:buttonLayoutType padding:padding];
    [button ba_button_setViewRectCornerType:viewRectCornerType viewCornerRadius:viewCornerRadius];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (instancetype)ba_buttonWithFrame:(CGRect)frame
                             title:(NSString * __nullable)title
                     selectedTitle:(NSString * __nullable)selectedTitle
                  highlightedTitle:(NSString * __nullable)highlightedTitle
                        titleColor:(UIColor * __nullable)titleColor
                selectedTitleColor:(UIColor * __nullable)selectedTitleColor
             highlightedTitleColor:(UIColor * __nullable)highlightedTitleColor
                         titleFont:(UIFont * __nullable)titleFont
                             image:(UIImage * __nullable)image
                     selectedImage:(UIImage * __nullable)selectedImage
                  highlightedImage:(UIImage * __nullable)highlightedImage
                   backgroundImage:(UIImage * __nullable)backgroundImage
           selectedBackgroundImage:(UIImage * __nullable)selectedBackgroundImage
        highlightedBackgroundImage:(UIImage * __nullable)highlightedBackgroundImage
                   backgroundColor:(UIColor * __nullable)backgroundColor{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button ba_buttonSetTitle:title selectedTitle:selectedTitle highlightedTitle:highlightedTitle];
    if (!titleColor){
        titleColor = [UIColor blackColor];
    }
    [button ba_buttonSetTitleColor:titleColor selectedTitleColor:selectedTitleColor highlightedTitleColor:highlightedTitleColor disabledTitleColor:nil];
    button.titleLabel.font = titleFont ? titleFont : [UIFont setFontSizeWithValue:15.0f];
    [button ba_buttonSetImage:image selectedImage:selectedImage highlightedImage:highlightedImage disabledImage:nil];
    [button ba_buttonSetBackgroundImage:backgroundImage selectedBackgroundImage:selectedBackgroundImage highlightedBackgroundImage:highlightedBackgroundImage];
    [button ba_buttonSetBackgroundColor:backgroundColor];
    return button;
}

+ (UIButton *)ba_buttonLabelButtonWithFrame:(CGRect)frame
                                      title:(NSString *)title
                                       font:(UIFont *)font
                        horizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment
                          verticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment
                          contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
                                     target:(id)target
                                     action:(SEL)action
                           normalTitleColor:(UIColor *)normalStateColor
                      highlightedTitleColor:(UIColor *)highlightedStateColor
                         disabledTitleColor:(UIColor *)disabledStateColor{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.contentHorizontalAlignment = horizontalAlignment;
    button.contentVerticalAlignment   = verticalAlignment;
    button.contentEdgeInsets          = contentEdgeInsets;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button ba_buttonSetTitleColor:normalStateColor selectedTitleColor:nil highlightedTitleColor:highlightedStateColor disabledTitleColor:disabledStateColor];
    return button;
}

+ (UIButton *)ba_buttonImageButtonWithFrame:(CGRect)frame
                        horizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment
                          verticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment
                          contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
                                normalImage:(UIImage *)normalImage
                             highlightImage:(UIImage *)highlightImage
                              disabledImage:(UIImage *)disabledImage
                                     target:(id)target
                                     action:(SEL)action{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.contentHorizontalAlignment = horizontalAlignment;
    button.contentVerticalAlignment   = verticalAlignment;
    button.contentEdgeInsets          = contentEdgeInsets;
    [button ba_buttonSetImage:normalImage selectedImage:nil highlightedImage:highlightImage disabledImage:disabledImage];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - 自定义：button

- (void)ba_buttonSetBackgroundColor:(UIColor * __nullable)backgroundColor{
    if (backgroundColor){
        self.backgroundColor = backgroundColor;
    }
}

- (void)ba_buttonBackgroundColorWithNormalStateColor:(UIColor *)normalStateColor
                               highlightedStateColor:(UIColor *)highlightedStateColor
                                  disabledStateColor:(UIColor *)disabledStateColor{
    if (normalStateColor){
        [self setBackgroundImage:[self ba_image_Color:normalStateColor size:CGSizeMake(5, 5)] forState:UIControlStateNormal];
    }
    if (highlightedStateColor){
        [self setBackgroundImage:[self ba_image_Color:highlightedStateColor size:CGSizeMake(5, 5)] forState:UIControlStateHighlighted];
    }
    if (disabledStateColor){
        [self setBackgroundImage:[self ba_image_Color:disabledStateColor size:CGSizeMake(5, 5)] forState:UIControlStateDisabled];
    }
}

/**
 UIImage：创建一个 纯颜色 图片【可以设置 size】
 
 @param color color
 @param size size
 @return 纯颜色 图片
 */
- (UIImage *)ba_image_Color:(UIColor *)color
                       size:(CGSize)size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)ba_buttonSetBackgroundImage:(UIImage * __nullable)backgroundImage
            selectedBackgroundImage:(UIImage * __nullable)selectedBackgroundImage
         highlightedBackgroundImage:(UIImage * __nullable)highlightedBackgroundImage{
    if (backgroundImage){
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
    if (selectedBackgroundImage){
        [self setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
    }
    if (highlightedBackgroundImage){
        [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
    }
}

- (void)ba_buttonSetImage:(UIImage * __nullable)image
            selectedImage:(UIImage * __nullable)selectedImage
         highlightedImage:(UIImage * __nullable)highlightedImage
            disabledImage:(UIImage * __nullable)disabledImage{
    if (image){
        [self setImage:image forState:UIControlStateNormal];
    }
    if (selectedImage){
        [self setImage:selectedImage forState:UIControlStateSelected];
    }
    if (highlightedImage){
        [self setImage:highlightedImage forState:UIControlStateHighlighted];
    }
}

- (void)ba_buttonSetTitle:(NSString * __nullable)title
            selectedTitle:(NSString * __nullable)selectedTitle
         highlightedTitle:(NSString * __nullable)highlightedTitle{
    [self setTitle:title forState:UIControlStateNormal];
    if (selectedTitle){
        [self setTitle:selectedTitle forState:UIControlStateSelected];
    }else{
        [self setTitle:highlightedTitle forState:UIControlStateHighlighted];
    }
}

- (void)ba_buttonSetTitleColor:(UIColor * __nullable)titleColor
            selectedTitleColor:(UIColor * __nullable)selectedTitleColor
         highlightedTitleColor:(UIColor * __nullable)highlightedTitleColor
            disabledTitleColor:(UIColor * __nullable)disabledTitleColor{
    if (titleColor){
        [self setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (selectedTitleColor){
        [self setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    }
    if (highlightedTitleColor){
        [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
    }
    if (disabledTitleColor){
        [self setTitleColor:disabledTitleColor forState:UIControlStateDisabled];
    }
}

- (void)ba_buttonSetTitleFontName:(NSString *)fontName size:(CGFloat)size{
    [self.titleLabel setFont:[UIFont fontWithName:fontName size:size]];
}

- (void)ba_button_setButtonLayoutType:(BAKit_ButtonLayoutType)type padding:(CGFloat)padding{
    self.ba_buttonLayoutType = type;
    self.ba_padding = padding;
}

- (void)ba_button_setViewRectCornerType:(BAKit_ViewRectCornerType)type viewCornerRadius:(CGFloat)viewCornerRadius{
    [self ba_view_setViewRectCornerType:type viewCornerRadius:viewCornerRadius];
}

- (void)ba_button_setViewRectCornerType:(BAKit_ViewRectCornerType)type
                       viewCornerRadius:(CGFloat)viewCornerRadius
                            borderWidth:(CGFloat)borderWidth
                            borderColor:(UIColor *)borderColor{
    [self ba_view_setViewRectCornerType:type viewCornerRadius:viewCornerRadius borderWidth:borderWidth borderColor:borderColor];
}

- (void)ba_buttonTitleLabelHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment
                             verticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment
                             contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets{
    self.contentHorizontalAlignment = horizontalAlignment;
    self.contentVerticalAlignment   = verticalAlignment;
    self.contentEdgeInsets          = contentEdgeInsets;
}

- (void)ba_buttonPlaySoundEffectWithFileName:(NSString *)name
                                 isNeedShock:(BOOL)isNeedShock{
    [self ba_viewPlaySoundEffectWithFileName:name isNeedShock:isNeedShock];
}

#pragma mark - setter / getter
- (void)setBa_buttonLayoutType:(BAKit_ButtonLayoutType)ba_buttonLayoutType{
    objc_setAssociatedObject(self, @selector(ba_buttonLayoutType), @(ba_buttonLayoutType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setupButtonLayout];
}

- (BAKit_ButtonLayoutType)ba_buttonLayoutType{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setBa_padding:(CGFloat)ba_padding{
    objc_setAssociatedObject(self, @selector(ba_padding), @(ba_padding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setupButtonLayout];
}

- (CGFloat)ba_padding{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setBa_padding_inset:(CGFloat)ba_padding_inset{
    objc_setAssociatedObject(self, @selector(ba_padding_inset), @(ba_padding_inset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setupButtonLayout];
}

- (CGFloat)ba_padding_inset{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setupButtonLayout];
}

@end
