//
//  HLDTextField.m
//
//  Created by longxiang on 16/11/13.
//  Copyright © 2016年 longxiang. All rights reserved.
//

#import "HLDTextField.h"

@interface HLDTextField()<UITextFieldDelegate>

@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIView *leftTempView;
@property (nonatomic,strong) UIView *rightTempView;
//下划线
@property (nonatomic,strong) UIView *speratorLineView;

/** 对所有绑定的文本框变化事件进行监听*/
@property (strong, nonatomic)void(^allTextChangeBlock)(HLDTextField *textField);
/** 对指定的文本框变化事件进行监听*/
@property (strong, nonatomic)void(^optionTextChangeBlock)(HLDTextField *textField);
/** 对指定的文本框结束编辑事件进行监听*/
@property (strong, nonatomic)void(^optionTextEndEditBlock)(HLDTextField *textField);

@end

@implementation HLDTextField

+ (instancetype)creatTextFieldType:(HLDTextFieldType)type{
    return [self creatTextFieldType:type
                          left:nil
                         right:nil];
}

+ (instancetype)creatTextFieldType:(HLDTextFieldType)type
                         left:(UIView *)lv{
    return [self creatTextFieldType:type
                          left:lv
                         right:nil];
}

+ (instancetype)creatTextFieldType:(HLDTextFieldType)type
                        right:(UIView *)rv{
    return [self creatTextFieldType:type
                          left:nil
                         right:rv];
}

+ (instancetype)creatTextFieldType:(HLDTextFieldType)type
                         left:(UIView *)lv
                        right:(UIView *)rv {
    return [[self alloc] initWithType:type
                                 left:lv
                                right:rv];
}

- (instancetype)initWithType:(HLDTextFieldType)type
                        left:(UIView *)lv
                       right:(UIView *)rv {
    if (self = [super init]) {
        self.textFieldType = type;
        self.leftTempView = lv;
        self.rightTempView  = rv;
        [self setUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setUI{
    [self initConfigData];
    [self initDefaultControls];
    [self setupDefaultStauts];
    [self setupDefaultStyles];
    [self setupUserDefineStyles];
    [self setupLeftView];
    [self setupRightView];
    [self setupEventsTarget];
    [self registerKVO];
    self.delegate = self;
}

#pragma mark init config data
- (void)initConfigData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = nil;
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"textFieldConfig" ofType:@"json"];;
        NSError *error = nil;
        if (path) {
            NSString *jsonString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            tf_dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
            if (error){
                NSAssert(nil, @"配置文件解析错误");
            }
        }
    });
    self.typeKeys = tf_dict[@"typeKeys"];
}

- (void)initDefaultControls {
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.userInteractionEnabled = NO;
    
    self.speratorLineView = [[UIView alloc] init];
    self.speratorLineView.theme_backgroundColor = @"F1F1F1";
    self.speratorLineEnable = YES;
    [self addSubview:self.speratorLineView];
}

- (void)setSperatorLineEnable:(BOOL)enable{
    _speratorLineEnable = enable;
    self.speratorLineView.hidden = !enable;
}

- (void)setBorderWidth:(NSUInteger)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

#pragma mark set properties
- (HLDTextField *)textFieldBeginEdit:(void(^)(HLDTextField *textField))textFieldBeginEdit{
    if (textFieldBeginEdit) {
        self.textFieldBeginEdit = textFieldBeginEdit;
    }
    return self;
}

- (HLDTextField *)textFieldChangeCharacter:(void(^)(HLDTextField *textField,BOOL sucess))textFieldChangeCharacter {
    if (textFieldChangeCharacter) {
        self.textFieldChangeCharacter = textFieldChangeCharacter;
    }
    return self;
}

- (HLDTextField *)textFieldEditChange:(void(^)(HLDTextField *textField))textFieldEditChange{
    if (textFieldEditChange) {
        self.textFieldEditChange = textFieldEditChange;
    }
    return self;
}

- (HLDTextField *)textFieldEditEnd:(void(^)(HLDTextField *textField))textFieldEditEnd  {
    if (textFieldEditEnd) {
        self.textFieldEditEnd = textFieldEditEnd;
    }
    return self;
}

- (HLDTextField *)textFieldDidEndOnExit:(void(^)(HLDTextField *textField))textFieldDidEndOnExit {
    if (textFieldDidEndOnExit) {
        self.textFieldDidEndOnExit = textFieldDidEndOnExit;
    }
    return self;
}

#pragma mark setup textField
- (void)setupDefaultStauts {
    /**
     1. 默认均不支持报错震动,且均不能为空
     2. Mobile,idCard,BankNum,Money均需要中间插入逗号,且不能未空
     */
    self.checkEnable    = YES;
    self.AllowEmptyForBtnClick  = NO;
    self.shakeEnbale    = YES;
    self.canEditing = YES;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (void)setupLeftView {
    if (self.leftTempView) {
        self.clearButtonMode = UITextFieldViewModeNever;
        self.leftView = self.leftTempView;
        return;
    }
    //使用系统默认的leftBtn
    if (_leftTitle.length <= 0){
        _leftTitle = tf_dict[@"leftTitle"][self.typeKeys[self.textFieldType]];
    }
    if (_leftImage.length <= 0){
        _leftImage = tf_dict[@"leftImageName"][_typeKeys[self.textFieldType]];
    }
    UIColor *color = !_leftColor ? [UIColor blackColor] :_leftColor;
    UIFont *font  = !_textfont ? [UIFont setFontSizeWithValue:16] : _textfont;
    if (_leftImage.length > 0) {
        [self.leftBtn setImage:[UIImage imageNamed:_leftImage] forState:UIControlStateNormal];
        if (_leftTitle.length > 0) {
            self.leftBtn.contentHorizontalAlignment = NSTextAlignmentLeft;
            self.leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
            self.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
        }
    }
    if (_leftTitle.length > 0) {
        [self.leftBtn setTitle:[NSString stringWithFormat:@"%@ : ",_leftTitle] forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:color forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = font;
    }
    if (_leftImage.length > 0 || _leftTitle.length > 0) {
        [self.leftBtn sizeToFit];
        self.leftBtn.bounds = CGRectMake(0, 0, self.leftBtn.bounds.size.width + 15, self.leftBtn.bounds.size.height);
        self.leftView = self.leftBtn;
    }
}

- (void)setupRightView {
    if (self.rightTempView){
        self.clearButtonMode = UITextFieldViewModeNever;
        self.rightView = self.rightTempView;
    }
}

- (void)setPaddingWith:(CGFloat)paddingWith {
    _paddingWith = paddingWith;
    [self setNeedsDisplay];
}

- (void)setPaddingHeight:(CGFloat)paddingHeight {
    _paddingHeight = paddingHeight;
    [self setNeedsDisplay];
}

- (CGRect)caretRectForPosition:(UITextPosition *)position{
    CGRect originalRect = [super caretRectForPosition:position];
    if (_cursorHeight) {
        originalRect.size.height = _cursorHeight;
    }else {
        originalRect.size.height = self.font.lineHeight + 4;
    }
    if (_cursorWidth) {
        originalRect.size.width = _cursorWidth;
    }else {
        originalRect.size.width = 2;
    }
    return originalRect;
}

#pragma mark security actions
- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender{
    //禁止粘贴
    if (action == @selector(paste:)){
        return !_forbidPaste;
    }else if (action == @selector(select:)){// 禁止选择
        return NO;
    }else if (action == @selector(selectAll:)){// 禁止全选
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

- (void)setupDefaultStyles {
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.returnKeyType   = UIReturnKeyNext;
    
    self.theme_textColor = @"444D54";
    NSString *placeHd = tf_dict[@"placeHolder"][self.typeKeys[self.textFieldType]];
    self.placeholder = placeHd;
    
    if (self.textFieldType == HLDTextFieldType_pwd){
        self.secureTextEntry = YES;
    }
    
    /** 关闭联想记忆,防止选择字符串出现bug*/
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    switch (self.textFieldType) {
        case HLDTextFieldType_moblie:
        case HLDTextFieldType_idCardNum:
        case HLDTextFieldType_bankNum:
        case HLDTextFieldType_money: //这里仅限值不能输入特殊符号,实际最后结果可以拼接特殊符号
            self.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case HLDTextFieldType_default:
        case HLDTextFieldType_pwd:
        case HLDTextFieldType_imageCode:
            self.keyboardType = UIKeyboardTypeDefault;
            break;
        case HLDTextFieldType_phoneCode:
            self.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case HLDTextFieldType_mail:
            self.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        default:
            break;
    }
}

- (void)setClearButtonNormalImageName:(NSString *)clearButtonNormalImageName {
    _clearButtonNormalImageName = clearButtonNormalImageName;
    UIButton *clearButton = [self valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage sd_imageWithName:clearButtonNormalImageName] forState:UIControlStateNormal];
}

- (void)setClearButtonHighlightedImageName:(NSString *)clearButtonHighlightedImageName {
    _clearButtonHighlightedImageName = clearButtonHighlightedImageName;
    UIButton *clearButton = [self valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage sd_imageWithName:clearButtonHighlightedImageName] forState:UIControlStateHighlighted];
}

- (void)setupUserDefineStyles {
    if (_placeHolderColor){
        [self setValue:_placeHolderColor forKeyPath:@"placeholderLabel.textColor"];
    }
    if (_placeHolderFont){
        [self setValue:_placeHolderFont forKeyPath:@"placeholderLabel.font"];
    }
}

- (void)setupEventsTarget {
    [self addTarget:self action:@selector(hldRegx_textFieldDidChangeEdit:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(hldRegx_textFieldDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

#pragma mark edit events
- (BOOL)textFieldShouldBeginEditing:(HLDTextField *)textField {
    if (self.canEditing) {
        if (self.textFieldType == HLDTextFieldType_money){
            self.text = nil;
        }
        if (self.textFieldBeginEdit){
            self.textFieldBeginEdit(textField);
        }
    }
    return self.canEditing;
}

- (void)textFieldDidEndEditing:(HLDTextField *)textField{
    [self hldRegx_textFieldEditingDidEnd:textField];
}

- (void)hldRegx_textFieldDidChangeEdit:(HLDTextField *)textField {
    if (self.textFieldEditChange){
        self.textFieldEditChange(textField);
    }
    if (self.allTextChangeBlock){
        self.allTextChangeBlock(textField);
    }
    if (self.optionTextChangeBlock){
        self.optionTextChangeBlock(textField);
    }
}

- (void)hldRegx_textFieldEditingDidEnd:(HLDTextField *)textField {
    if (self.textFieldEditEnd){
        self.textFieldEditEnd(textField);
    }
    NSString *valiateDes = self.verifyOK ? @"" : tf_dict[@"notice"][self.typeKeys[self.textFieldType]];
    self.errorNote = valiateDes;
    if (self.optionTextEndEditBlock){
        self.optionTextEndEditBlock(textField);
    }
}

- (void)hldRegx_textFieldDidEndOnExit:(HLDTextField *)textField {
    [self hldRegx_textFieldEditingDidEnd:textField];
    if (self.textFieldDidEndOnExit){
        self.textFieldDidEndOnExit(textField);
    }
    if (self.returnKeyType == UIReturnKeyDone) {
        [self endEditing:YES];
    }
}

#pragma mark blind events
+ (void)blindTextFields:(NSArray *)textFields
             editChange:(void (^)(BOOL))setbtnState {
    /** 根据绑定的textFields顺序设置returnKeyType,
     根据点击returnKeyType的回调事件,决定下一响应者,
     对每个textField的change事件进行逐一监听,判断指定的文本是否满足非空条件并回调出去
     */
    __block BOOL isAllTextFieldNotEmpty = YES;
    for (int index = 0; index < textFields.count; index++) {
        HLDTextField *textField = textFields[index];
        if (textField.keyboardType != UIKeyboardTypeNumberPad) {
            if (index < textFields.count - 1) {
                textField.returnKeyType = UIReturnKeyNext;
            }else if (index == textFields.count - 1) {
                textField.returnKeyType = UIReturnKeyDone;
            }
        }
        textField.textFieldDidEndOnExit = ^(HLDTextField *textField) {
            if (textField.returnKeyType == UIReturnKeyDone||
                textField.returnKeyType == UIReturnKeyJoin||
                textField.returnKeyType == UIReturnKeyGo) {
                [textField endEditing:YES];
            }else if(textField.returnKeyType == UIReturnKeyNext){
                if (index < textFields.count - 1) {
                    HLDTextField *nextTextField = textFields[index + 1];
                    [nextTextField becomeFirstResponder];
                }
            }
        };
        textField.allTextChangeBlock = ^(HLDTextField *textField) {
            for (HLDTextField *tempTextField in textFields) {
                if (tempTextField.text.length == 0 && !textField.isAllowEmptyForBtnClick) {
                    isAllTextFieldNotEmpty = NO;
                    break;
                }
            }
            setbtnState(isAllTextFieldNotEmpty);
        };
    }
}

+ (void)blindTextFields:(NSArray *)textFields
              condition:(HLDTextCondition)condition
             complement:(void (^)(BOOL success))complement {
    __block BOOL isAllTextFieldNotEmpty = YES;
    for (int index = 0; index < textFields.count; index++) {
        HLDTextField *textField = textFields[index];
        /** 1.绑定的文本框是否全都不为空 */
        if (condition == HLDTextCondition_notEmpty) {
            textField.optionTextChangeBlock = ^(HLDTextField *textField) {
                for (HLDTextField *tempTextField in textFields) {
                    if (tempTextField.text.length == 0 && !textField.isAllowEmptyForBtnClick) {
                        isAllTextFieldNotEmpty = NO;
                        break;
                    }
                }
                complement(isAllTextFieldNotEmpty);
            };
        }else if(condition == HLDTextCondition_verfiyOK){      /** 2.绑定的文本框是否全部校验成功*/
            textField.optionTextEndEditBlock = ^(HLDTextField *textField) {
                for (HLDTextField *tempTextField in textFields) {
                    if (!tempTextField.verifyOK) {
                        break;
                    }
                }
                complement(isAllTextFieldNotEmpty);
            };
        }
    }
}

#pragma mark kvo events
- (void)registerKVO {
    for (NSString *keyPath in [self keyPaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)unRegisterKVO {
    for (NSString *keyPath in [self keyPaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (NSSet *)keyPaths {
    //    这里添加属性名在下面监听方法中实现
    return [NSSet setWithObjects:@"textfont",@"placeHolderColor",@"placeHolderFont",@"leftTitle",@"leftColor",@"leftImage", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    [self setupUserDefineStyles];
    [self setupLeftView];
    [self setupRightView];
}

//控制 placeHolder 的位置，左右缩进
- (CGRect)textRectForBounds:(CGRect)bounds {
    if (self.paddingWith == 0 && self.paddingHeight == 0) {
        return [super textRectForBounds:bounds];
    }
    return CGRectInset(bounds,self.paddingWith,self.paddingHeight);
}

// 控制文本的位置，左右缩进
- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (self.paddingWith == 0 && self.paddingHeight == 0) {
        return [super editingRectForBounds:bounds];
    }
    return CGRectInset(bounds,self.paddingWith,self.paddingHeight);
}

//文本框 清除按钮 的 位置 及 显示范围
- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGFloat rightValue = [BaseTools adaptedWithValue:15];
    CGFloat width = [BaseTools adaptedWithValue:21];
    return CGRectMake(bounds.size.width - rightValue,(bounds.size.height - width) / 2, width, width);
}

//文本框 左视图 的 位置 及 显示范围
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
//    可以移动到右边，右边可以同时显示两个控件
    CGRect rect = [super leftViewRectForBounds:bounds];
    return CGRectOffset(rect,0, 0);
}

//文本框 右视图 的 位置 及 显示范围
- (CGRect)rightViewRectForBounds:(CGRect)bounds{
//    可以移动到左边，左边可以同时显示两个控件
    CGRect rect = [super leftViewRectForBounds:bounds];
    return CGRectOffset(rect,0, 0);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.speratorLineView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 1, CGRectGetWidth(self.bounds), 1);
}

- (void)dealloc {
    [self unRegisterKVO];
}

@end
