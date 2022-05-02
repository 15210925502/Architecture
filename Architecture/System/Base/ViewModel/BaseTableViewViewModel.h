//
//  BaseTableViewViewModel.h
//  RebateProject
//
//  Created by HLD on 2019/6/17.
//  Copyright © 2019 com.cn.HLD. All rights reserved.
//

#import "BaseViewModel.h"

@interface BaseTableViewViewModel : BaseViewModel<UITableViewDelegate,UITableViewDataSource>

// 点击cell回调
@property (nonatomic, strong) void(^didSelectCallBlock)(id model,NSIndexPath *indexPath);

// UIScrollView的scrollViewDidScroll:方法回调
@property (nonatomic, strong) void(^scrollViewDidScrollCallBlock)(UIScrollView *scrollView);

//创建viewModel
+ (instancetype)createViewModelWithTableView:(UITableView *)tableView;

@end
