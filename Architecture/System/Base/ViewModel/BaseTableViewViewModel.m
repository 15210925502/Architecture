//
//  BaseTableViewViewModel.m
//  RebateProject
//
//  Created by HLD on 2019/6/17.
//  Copyright © 2019 com.cn.HLD. All rights reserved.
//

#import "BaseTableViewViewModel.h"
#import "BaseTableViewCell.h"

@implementation BaseTableViewViewModel

+ (instancetype)createViewModelWithTableView:(UITableView *)tableView{
    BaseTableViewViewModel *tableViewViewModel = [[self alloc] init];
    tableView.dataSource = tableViewViewModel;
    tableView.delegate = tableViewViewModel;
    return tableViewViewModel;
}

#pragma makr UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableViewCell *cell = [BaseTableViewCell getCellWithTableView:tableView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectCallBlock) {
        self.didSelectCallBlock(nil,indexPath);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scrollViewDidScrollCallBlock) {
        self.scrollViewDidScrollCallBlock(scrollView);
    }
}

@end
