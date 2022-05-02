//
//  MineVC.swift
//  Architecture
//
//  Created by HLD on 2022/1/4.
//

import UIKit

let IMAGE_HEIGHT = 260
let NAV_HEIGHT = 64
let NAVBAR_COLORCHANGE_POINT = (-IMAGE_HEIGHT + NAV_HEIGHT * 2)
let SCROLL_DOWN_LIMIT = 70
let LIMIT_OFFSET_Y =  -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

class MineVC: BaseTableViewVC {
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(query: Dictionary<String, Any>?) {
        super.init(query: query)
        self.canHeaderRereshing = false
        self.canFooterRereshing = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title(title: "我的")
        self.navigationView.setNavigationBackgroundAlpha(0)
        
        self.tableView.contentInset = UIEdgeInsetsMake(CGFloat(IMAGE_HEIGHT - 64), 0, 0, 0)
        self.tableView.addSubview(self.advView)
        weak var weakSelf = self
        self.dataViewModel.scrollViewDidScrollCallBlock = {(scrollView) in
            weakSelf?.scrollViewDidScroll(scrollView!)
        }
        self.dataViewModel.didSelectCallBlock = {(model,indexPath) in
            let oneVC = OneVC.init(query: nil)
            oneVC.hld_interactivePopDisabled = true
            weakSelf?.navigationController?.pushViewController(oneVC, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.mas_makeConstraints { (make) in
            make?.top.left().right().equalTo()(0)
            make?.bottom.equalTo()(-BaseTools.tabBarHeight)
        }
    }
    
//    下拉图片变大
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y;
        
        if offsetY > CGFloat(NAVBAR_COLORCHANGE_POINT){
            let alpha = (offsetY - CGFloat(NAVBAR_COLORCHANGE_POINT)) / CGFloat(NAV_HEIGHT);
            self.navigationView.setNavigationBackgroundAlpha(alpha)
        }else{
            self.navigationView.setNavigationBackgroundAlpha(0)
        }
        
        //限制下拉的距离
        if offsetY < CGFloat(LIMIT_OFFSET_Y) {
            scrollView.contentOffset = CGPoint(x: 0, y: LIMIT_OFFSET_Y)
        }
        
        // 改变图片框的大小 (上滑的时候不改变)
        // 这里不能使用offsetY，因为当（offsetY < LIMIT_OFFSET_Y）的时候，y = LIMIT_OFFSET_Y 不等于 offsetY
        let newOffsetY = scrollView.contentOffset.y;
        if newOffsetY < -CGFloat(IMAGE_HEIGHT){
            self.advView.frame = CGRect(x: 0, y: newOffsetY, width: BaseTools.screenWidth, height: -newOffsetY);
        }
    }
    
    lazy var advView : MSCycleScrollView = {
        let model1 = CycleModel()
        model1.title = "disableScrollGesture可以设置禁止拖动"
        model1.imageUrl = "lb1_White"
        
        let model2 = CycleModel()
        model2.title = "disableScrollGesture可以设置禁止拖动"
        model2.imageUrl = "lb2_White"
        
        let model3 = CycleModel()
        model3.title = "disableScrollGesture可以设置禁止拖动"
        model3.imageUrl = "lb3_White"
        
        let tempArray = [model1,model2,model3]
        
        var advView = MSCycleScrollView()
        
        advView.pageControlStyle = kMSPageContolStyleCustomer
        advView.pageControlAliment = kMSPageContolAlimentRight
        advView.modelArray = tempArray
        advView.bannerImageViewContentMode = .scaleAspectFill
        advView.frame = CGRect(x: 0, y: -CGFloat(IMAGE_HEIGHT), width: BaseTools.screenWidth, height: CGFloat(IMAGE_HEIGHT))
        
        return advView
    }()
    
    private lazy var dataViewModel : MineViewModel = {
        var dataViewModl : MineViewModel = MineViewModel.createViewModel(with: self.tableView)
        return dataViewModl
    }()

    deinit {
        print("对象已被释放")
    }
    
}
