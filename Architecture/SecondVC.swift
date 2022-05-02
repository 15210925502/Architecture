//
//  SecondVC.swift
//  Architecture
//
//  Created by HLD on 2022/1/4.
//

import UIKit

let IMAGE_HEIGHT1 = 260
let NAVBAR_COLORCHANGE_POINT1 = -80
let NAVBAR_COLORCHANGE_POINT2 = 160
let SCROLL_DOWN_LIMIT1 = 100
let LIMIT_OFFSET_Y1 =  -(IMAGE_HEIGHT1 + SCROLL_DOWN_LIMIT1)

class SecondVC: BaseTableViewVC {
        
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

        self.title(title: "第二页")
        self.navigationView.titleLabel.theme_textColor = "000000"
        self.navigationView.setNavigationBackgroundAlpha(0)
        
        self.navigationView.navigationSmoothScroll(self.tableView, start: CGFloat(NAVBAR_COLORCHANGE_POINT2), speed: 0.3, stopToStatusBar: false)
        
        if #available(iOS 10.0, *) {
            self.tabBarItem.badgeColor = UIColor.orange
        } else {
            // 这里替换角标颜色的图片，需要注意的时：这个图片size=(36px,36px)，圆的
        }
        self.tabBarItem.badgeValue = "1234"
        
        self.tableView.contentInset = UIEdgeInsetsMake(CGFloat(IMAGE_HEIGHT1 - 64), 0, 0, 0)
        self.tableView.addSubview(self.advView)
        weak var weakSelf = self
        self.dataViewModel.scrollViewDidScrollCallBlock = {(scrollView) in
            weakSelf?.scrollViewDidScroll(scrollView!)
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
        
        if offsetY > CGFloat(NAVBAR_COLORCHANGE_POINT1) {
            self.changeNavBarAnimateWithIsClear(isClear: false)
        }else{
            self.changeNavBarAnimateWithIsClear(isClear: true)
        }
        
        //限制下拉的距离
        if offsetY < CGFloat(LIMIT_OFFSET_Y1) {
            scrollView.contentOffset = CGPoint(x: 0, y: LIMIT_OFFSET_Y1)
        }
        
        // 改变图片框的大小 (上滑的时候不改变)
        // 这里不能使用offsetY，因为当（offsetY < LIMIT_OFFSET_Y）的时候，y = LIMIT_OFFSET_Y 不等于 offsetY
        let newOffsetY = scrollView.contentOffset.y;
        if newOffsetY < -CGFloat(IMAGE_HEIGHT1){
            self.advView.frame = CGRect(x: 0, y: newOffsetY, width: BaseTools.screenWidth, height: -newOffsetY);
        }
    }
    
    func changeNavBarAnimateWithIsClear(isClear : Bool) {
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3) {
            if isClear {
                weakSelf?.navigationView.setNavigationBackgroundAlpha(0)
                weakSelf?.navigationView.setNavigationBackgroundColor(UIColor.clear)
            } else {
                weakSelf?.navigationView.setNavigationBackgroundAlpha(1.0)
                weakSelf?.navigationView.setNavigationBackgroundColor(UIColor.orange)
            }
        }
    }
    
    lazy var advView : UIImageView = {
        var advView = UIImageView()
        advView.contentMode = .scaleAspectFill
        advView.clipsToBounds = true
        advView.frame = CGRect(x: 0, y: -CGFloat(IMAGE_HEIGHT1), width: BaseTools.screenWidth, height: CGFloat(IMAGE_HEIGHT1))
        advView.isUserInteractionEnabled = true
        advView.image = self.imageWithImageSimple(image: UIImage.sd_image(withName: "lb1"), newSize: CGSize(width: BaseTools.screenWidth, height: CGFloat(IMAGE_HEIGHT1 + SCROLL_DOWN_LIMIT1)))
        advView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pageAction)))
        return advView
    }()
    
    @objc func pageAction() {
        print("点击事件")
    }
    
    func imageWithImageSimple(image:UIImage, newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContext(CGSize(width: newSize.width * 2, height: newSize.height * 2))
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width * 2, height: newSize.height * 2))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage();
    }
    
    private lazy var dataViewModel : MineViewModel = {
        var dataViewModl : MineViewModel = MineViewModel.createViewModel(with: self.tableView)
        return dataViewModl
    }()

    deinit {
        print("对象已被释放")
    }
    
}
