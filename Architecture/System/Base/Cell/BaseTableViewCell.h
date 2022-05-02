//
//  BaseTableViewCell.h
//  RebateProject
//
//  Created by HLD on 2019/6/5.
//  Copyright © 2019 com.cn.HLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

//创建cell以类名为ID
+ (instancetype)createCell;

//从复用池里获取cell没有就创建cell以类名为ID
+ (instancetype)getCellWithTableView:(UITableView *)tableView;

//计算cell的高度
+ (CGFloat)heightForModel:(id)model;

@end
