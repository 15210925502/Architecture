//
//  HLDTextField.h
//
//  Created by longxiang on 16/11/13.
//  Copyright © 2016年 longxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HLDTextFieldType) {
    HLDTextFieldType_default  = 0,
    HLDTextFieldType_pwd       = 1,
    HLDTextFieldType_moblie    = 2,
    HLDTextFieldType_phoneCode = 3,
    HLDTextFieldType_imageCode = 4,
    HLDTextFieldType_idCardNum = 5,
    HLDTextFieldType_bankNum   = 6,
    HLDTextFieldType_num       = 7,
    HLDTextFieldType_money     = 8,
    HLDTextFieldType_url       = 9,
    HLDTextFieldType_mail      = 10
};

typedef NS_ENUM(NSInteger,HLDTextCondition){
    HLDTextCondition_notEmpty,      //数据是非空的
    HLDTextCondition_verfiyOK,      //数据是合法的
};

static NSDictionary *tf_dict = nil;

@interface HLDTextField : UITextField

/** 文本框输入完成所有文字进行正则校验*/
@property (strong, nonatomic) NSString *regx;
/** 文本框输入中指单个符校验*/
@property (strong, nonatomic) NSString *regexChar;
/** 文本框中分割符的正则,用于还原真实数据 realText */
@property (strong, nonatomic) NSString *regexSeperator;

/** 文本框中的分割符*/
@property (strong, nonatomic) NSString *seperator;
/** 文本框中分割符插入的位置: ege 185 8843 146X 对应 @[@3,@4,@4]✅*/
@property (strong, nonatomic) NSArray *seperators;

/** 文本框进行长度校验*/
@property (assign, nonatomic) NSInteger maxLength;
/** 文本框字体大小设置*/
@property (strong, nonatomic) UIFont *textfont;
/** 文本框占位字体大小*/
@property (strong, nonatomic) UIFont *placeHolderFont;
/** 文本框占位颜色设置*/
@property (strong, nonatomic) UIColor *placeHolderColor;
/** 文本框左边标题文字*/
@property (strong, nonatomic) NSString *leftTitle;
/** 文本框左边标题颜色*/
@property (strong, nonatomic) UIColor *leftColor;
/** 文本框左边图片设置*/
@property (strong, nonatomic) NSString *leftImage;
/** 左右缩进 */
@property (nonatomic, assign) CGFloat paddingWith;
/** 上下缩进 */
@property (nonatomic, assign) CGFloat paddingHeight;
/** 光标宽度，默认为2 */
@property (nonatomic, assign) NSUInteger cursorWidth;
/** 光标高度，默认为 self.font.lineHeight + 4 */
@property (nonatomic, assign) NSUInteger cursorHeight;
/** 设置边框宽度，默认没有边框 */
@property (nonatomic, assign) NSUInteger borderWidth;
/** 设置边框颜色，默认为亮灰色 */
@property (nonatomic, strong) UIColor *borderColor;
/** 禁止粘贴，默认为NO */
@property (nonatomic, assign) BOOL forbidPaste;
/** 禁止编辑，默认为YES */
@property (nonatomic, assign) BOOL canEditing;
/** clearButton普通状态图片 */
@property (nonatomic, copy) NSString *clearButtonNormalImageName;
/** clearButton高亮状态图片 */
@property (nonatomic, copy) NSString *clearButtonHighlightedImageName;
/** 是否显示下面分割线*/
@property (assign, nonatomic)  BOOL speratorLineEnable;
/** 是否开启正则校验*/
@property (assign, nonatomic,getter = isCheckEnable)     BOOL checkEnable;
/** ⚠️:用于父视图中关联所有不能为非空的textField,关联button的enable事件**/
@property (assign, nonatomic,getter = isAllowEmptyForBtnClick)   BOOL AllowEmptyForBtnClick;
/** 文本框正则校验错误是否震动*/
@property (assign, nonatomic,getter = isShakeEnable)     BOOL shakeEnbale;
/** 文本框结果是否校验成功*/
@property (assign, nonatomic,getter = isVerifyOK)        BOOL verifyOK;
/** 文本框校验错误信息*/
@property (strong, nonatomic) NSString *errorNote;
/** 文本框结束编辑之后,自动保存的真实数据*/
@property (strong, nonatomic) NSString *realText;
/**每个key在数组的下标与文本框的枚举值相同*/
@property (nonatomic,strong) NSArray *typeKeys;
@property(nonatomic,assign) HLDTextFieldType textFieldType;

/** 文本框事件*/
@property (strong, nonatomic) void(^textFieldBeginEdit)(HLDTextField *textField);
@property (strong, nonatomic) void(^textFieldChangeCharacter)(HLDTextField *textField,BOOL changeSucess);
@property (strong, nonatomic) void(^textFieldEditChange)(HLDTextField *textField);
@property (strong, nonatomic) void(^textFieldEditEnd)(HLDTextField *textField);
@property (strong, nonatomic) void(^textFieldDidEndOnExit)(HLDTextField *textField);
@property (strong, nonatomic) void(^setBtnStatus)(BOOL isEnable);

+ (instancetype)creatTextFieldType:(HLDTextFieldType)type;
+ (instancetype)creatTextFieldType:(HLDTextFieldType)type left:(UIView *)lv;
+ (instancetype)creatTextFieldType:(HLDTextFieldType)type right:(UIView *)rv;
+ (instancetype)creatTextFieldType:(HLDTextFieldType)type left:(UIView *)lv right:(UIView *)rv;

/** 当绑定的文本发生变化后,设置btn的是否冻结的状态,‘建议对当前页面的所有文本绑定’*/
+ (void)blindTextFields:(NSArray *)textFields editChange:(void (^)(BOOL isEnable))setBtnStatus;

/** 当绑定的文本变化后,判断所有文本框是否都满足了该条件并将结果回调出来*/
+ (void)blindTextFields:(NSArray *)textFields
              condition:(HLDTextCondition)condition
             complement:(void (^)(BOOL isSuccess))complement;

/** 以下为监听文本框输入的 五个状态 */
- (HLDTextField *)textFieldBeginEdit:(void(^)(HLDTextField *textField))textFieldBeginEdit;
- (HLDTextField *)textFieldChangeCharacter:(void(^)(HLDTextField *textField,BOOL sucess))textFieldChangeCharacter;
- (HLDTextField *)textFieldEditChange:(void(^)(HLDTextField *textField))textFieldEditChange;
- (HLDTextField *)textFieldEditEnd:(void(^)(HLDTextField *textField))textFieldEditEnd;
- (HLDTextField *)textFieldDidEndOnExit:(void(^)(HLDTextField *textField))textFieldDidEndOnExit;

@end
