
#import <UIKit/UIKit.h>

@interface BAButton : UIButton

//按钮是否正在提交中
@property(nonatomic, readonly, getter=isSubmitting) NSNumber * _Nullable submitting;

/**
 *  @brief  按钮点击后，禁用按钮并在按钮上显示ActivityIndicator，以及title
 *
 *  @param title 按钮上显示的文字
 */
- (void)beginSubmitting:(NSString *_Nullable)title;

//按钮上显示等待菊花，并修改按钮标题文字
- (void) showIndicator:(NSString *_Nullable)title;

//按钮点击后，恢复按钮点击前的状态
- (void)endSubmitting;

//隐藏按钮上的等待菊花，并恢复原文字
- (void)hideIndicator;

- (void)startTime:(NSInteger )timeout
            title:(NSString *_Nullable)tittle
       waitTittle:(NSString *_Nullable)waitTittle;

@end
