//
//  UpdateAlert.h
//  SelUpdateAlert
//
//  Created by zhuku on 2018/2/7.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateAlert : UIView

/**
 添加版本更新提示
 
 @param model 更新信息model

 */
+ (void)showUpdateAlertWithModel:(id)model;

@end
