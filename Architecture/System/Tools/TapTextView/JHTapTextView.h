//
//  JHTapTextView.h
//  JHKit
//
//  Created by HaoCold on 2019/1/11.
//  Copyright © 2019 HaoCold. All rights reserved.
//
//  MIT License
//
//  Copyright (c) 2019 xjh093
//

#import <UIKit/UIKit.h>

@class JHTapTextView;

typedef void(^JHTapTextBlock)(NSString *text, NSRange range);

@protocol JHTapTextViewDelegate <NSObject>

- (void)tapTextView:(JHTapTextView *)tapTextView
       didClickText:(NSString *)text
              range:(NSRange)range;

@end

/**
 A subclass of UITextView with text clickable.
 */
@interface JHTapTextView : UITextView

@property (nonatomic,    weak) id<JHTapTextViewDelegate>tapDelegate;

/**
 'YES' is default.
 */
@property (nonatomic,  assign) BOOL  autoHeight;

/**
 'NO' is default.
 */
@property (nonatomic,  assign) BOOL  autoWidth;

/**
 'nil' is default.
 Background color of clickable text.
 */
@property (nonatomic,  strong) UIColor *highlightedBackgroundColor;

/**
 Use block.
 Call this method before 'setText:'
 */
- (void)addTapTexts:(NSArray *)texts
           callback:(JHTapTextBlock)callback;

/**
 You should set the 'tapDelegate' when call this method before or after.
 Call this method before 'setText:'
 */
- (void)addTapTexts:(NSArray *)texts;

/**
 Remove text clickable.
 */
- (void)removeTapText:(NSArray *)texts;

/**
 Remove all text clickable.
 */
- (void)removeAllTapText;

@end

