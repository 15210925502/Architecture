//
//  MSAnimatedDotView.h
//  MSCycleScrollView
//
//  Created by TuBo on 2018/12/26.
//  Copyright © 2018 turBur. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSAbstractDotView : UIView

//当前选中颜色
@property (nonatomic, strong) UIColor *currentPageDotColor;
//未选中颜色
@property (nonatomic, strong) UIColor *pageDotColor;
//当前选中大小
@property (nonatomic, assign) CGSize currentPageDotSize;
//未选中大小
@property (nonatomic, assign) CGSize pageDotSize;

/**
 改变dot的活动状态
 
 @param active <#active description#>
 */
- (void)changeActivityState:(BOOL)active
                    dotView:(MSAbstractDotView *)dotView
                pageDotSize:(CGSize)pageDotSize;

@end

//定制一个默认的dotView样式
@interface MSAnimatedDotView : MSAbstractDotView

@end

NS_ASSUME_NONNULL_END
