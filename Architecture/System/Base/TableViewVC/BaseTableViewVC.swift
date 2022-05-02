//
//  BaseTableViewVC.swift
//  Architecture
//
//  Created by HLD on 2020/5/25.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit

class BaseTableViewVC: BaseVC {
    //是否可以下拉刷线
    var canHeaderRereshing : Bool?
    //是否可以上拉加载
    var canFooterRereshing : Bool?
    
    private var header : RefreshHeader?
    private var footer : MJRefreshAutoGifFooter?
    
    //    重载父类的init()
    override init(query : Dictionary<String, Any>?){
        super.init(query: query)
        self.canHeaderRereshing = true
        self.canFooterRereshing = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        
        if self.canHeaderRereshing ?? false {
            self.header = RefreshHeader()
            self.header?.setRefreshingTarget(self, refreshingAction: #selector(headerRequestRereshing))
            self.setupHeaderRefresh()
        }
        
        if self.canFooterRereshing ?? false {
            self.footer = MJRefreshAutoGifFooter()
            self.footer?.setRefreshingTarget(self, refreshingAction: #selector(footerRequestRereshing))
            self.setupFooterRefresh()
        }
    }
    
    private func setupHeaderRefresh() {
        self.tableView.mj_header = self.header
    }
    
    private func setupFooterRefresh() {
        self.footer?.setTitle("上拉可以加载更多数据了", for: .idle)
        self.footer?.setTitle("松开马上加载更多数据了", for: .willRefresh)
        self.footer?.setTitle("MJ哥正在帮你加载中,不客气", for: .refreshing)
        self.tableView.mj_footer = self.footer
    }
    
    //下拉刷新
    func headerRereshing() {
        self.tableView.mj_header?.beginRefreshing()
    }
    
    //上拉加载
    func footerRereshing() {
        self.tableView.mj_footer?.beginRefreshing()
    }
    
    //取消下拉刷新
    func endHeaderRefreshing() {
        self.tableView.mj_header?.endRefreshing()
    }
    
    //取消上拉加载
    func endFooterRefreshing() {
        self.tableView.mj_footer?.endRefreshing()
    }
    
    @objc func headerRequestRereshing() {
        
    }
    
    @objc func footerRequestRereshing() {
        
    }
    
    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
//        以下方法解决tableView上下有空余部分
        tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: BaseTools.screenWidth, height: 0.001))
        tableView.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: BaseTools.screenWidth, height: 0.001))
        tableView.contentInset = UIEdgeInsetsMake(0, 0, -20, 0)
        return tableView
    }()
    
    private lazy var dataViewModel : BaseTableViewViewModel = {
        return BaseTableViewViewModel.createViewModel(with: self.tableView)
    }()
}
