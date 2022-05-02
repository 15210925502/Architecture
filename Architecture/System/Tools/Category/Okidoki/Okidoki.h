//
//  Okidoki.h
//  JHKit
//
//  Created by HaoCold on 2018/9/19.
//  Copyright © 2018年 HaoCold. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Okidoki : NSObject

#pragma mark - UIView

/** NSNumber */
- (Okidoki*(^)(id))tag;
/** NSValue */
- (Okidoki*(^)(id))frame;
/** NSNumber */
- (Okidoki*(^)(id))alpha;
/** UIColor,NSString(eg.#FFFEEE,0xFFFEEE,0XFFFEEE) */
- (Okidoki*(^)(id))bgColor;
/** UIColor,NSString(eg.#FFFEEE,0xFFFEEE,0XFFFEEE) */
- (Okidoki*(^)(id))bdColor;
/** NSNumber */
- (Okidoki*(^)(id))bdWidth;
/** NSNumber */
- (Okidoki*(^)(id))cnRadius;
/** @(YES) or @(NO) */
- (Okidoki*(^)(id))mtBounds;

#pragma mark - UILabel & UITextView & UITextField

/** NSString */
- (Okidoki*(^)(id))text;
/** UIFont */
- (Okidoki*(^)(id))font;
/** UIColor,NSString(eg.#FFFEEE,0xFFFEEE,0XFFFEEE) */
- (Okidoki*(^)(id))color;
/** NSNumber: @0,@1,@2 */
- (Okidoki*(^)(id))align;
/** NSNumber(CGFloat) */
- (Okidoki*(^)(id))lineSpaceWithTextView;
/** substring: NSString, value:color or font. */
- (Okidoki*(^)(id,id))attributedSubstring;
/** substring: NSString, value:color or font, range: NSValue. */
- (Okidoki*(^)(id,id,id))attributedSubstringInRange;

#pragma mark - UILabel

/** NSNumber(NSInteger) */
- (Okidoki*(^)(id))lines;
/** adjustsFontSizeToFitWidth: @(YES) or @(NO) */
- (Okidoki*(^)(id))adjust;
/** NSNumber(CGFloat) */
- (Okidoki*(^)(id))lineSpace;
/** NSNumber(CGFloat), 0 means no max width limit. */
- (Okidoki*(^)(id))autoWidth;
/** NSNumber(CGFloat), 0 means no max height limit. */
- (Okidoki*(^)(id))autoHeight;

#pragma mark - UIButton

/** title: NSString, state: NSNumber */
- (Okidoki*(^)(id,id))titleForState;
/** color: UIColor,NSString(eg.#FFFEEE,0xFFFEEE,0XFFFEEE) , state: NSNumber */
- (Okidoki*(^)(id,id))colorForState;
/** image: UIImage, state: NSNumber */
- (Okidoki*(^)(id,id))imageForState;
/** bgImage: UIImage, state: NSNumber */
- (Okidoki*(^)(id,id))bgImageForState;
/** lineSpace: NSNumber, state: NSNumber */
- (Okidoki*(^)(id,id))lineSpaceForState;
/** space: NSNumber */
- (Okidoki*(^)(id))imageUpTitleDown;
/** space: NSNumber */
- (Okidoki*(^)(id))imageDownTitleUp;
/** space: NSNumber */
- (Okidoki*(^)(id))imageRightTitleLeft;
/** space: NSNumber */
- (Okidoki*(^)(id))imageLeftTitleRight;
/** all center */
- (Okidoki*(^)(void))imageCenterTitleCenter;
/** substring: NSString, value:color or font, state: NSNumber */
- (Okidoki*(^)(id,id,id))attributedSubstringForState;
/** substring: NSString, value:color or font, range: NSValue, state: NSNumber */
- (Okidoki*(^)(id,id,id,id))attributedSubstringInRangeForState;

#pragma mark - UIImageView

/** image: UIImage, NSString */
- (Okidoki*(^)(id))image;
/** image: UIImage,NSString, color: UIColor */
- (Okidoki*(^)(id,id))imageForTintColor;


#pragma mark - UITextField

/** borderStyle, NSNumber: @1,@2,@3,@4 */
- (Okidoki*(^)(id))bdStyle;
/** placeholder, NSString */
- (Okidoki*(^)(id))pHolder;
/** placeholder color, UIColor,NSString(eg.#FFFEEE,0xFFFEEE,0XFFFEEE) */
- (Okidoki*(^)(id))pHColor;
/** placeholder font, UIFont */
- (Okidoki*(^)(id))pHFont;
/** clearButtonMode, NSNumber: @1,@2,@3,@4 */
- (Okidoki*(^)(id))cbMode;
/** leftViewMode, NSNumber: @1,@2,@3,@4 */
- (Okidoki*(^)(id))lvMode;
/** rightViewMode, NSNumber: @1,@2,@3,@4 */
- (Okidoki*(^)(id))rvMode;
/** leftView, UIView */
- (Okidoki*(^)(id))lfView;
/** rightView, UIView */
- (Okidoki*(^)(id))rtView;
/** secureTextEntry, BOOL: @YES, @NO */
- (Okidoki*(^)(id))secure;

@end

@interface UIView (Okidoki)

@property (nonatomic,  strong) Okidoki *okidoki;

@end
