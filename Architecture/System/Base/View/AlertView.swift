//
//  AlertView.swift
//  Architecture
//
//  Created by 华令冬 on 2020/7/3.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit

@objcMembers
class AlertView: BaseView {
    
    //    警告框,普通文字
    ///    没有标题,只有一个按钮
    class func presentHiddenTitleOneButtonAlert(_ message : String,_ buttonTitle : String, _ view : UIView? = nil, _ handler: (() -> Void)? = nil) -> (AlertView){
        return self.presentAttribtedAlert(nil, [message], ["444D54"], [16.0], 0, nil, nil, buttonTitle, view, nil, nil, handler)
    }
    ///    没有标题，有两个按钮
    class func presentHiddenTitleTwoButtonAlert(_ message : String,_ cancelButtonTitle : String,_ okButtonTitle : String, _ view : UIView? = nil, _ cancelHandler: (() -> Void)? = nil,_ okHandler: (() -> Void)? = nil) -> (AlertView){
        return self.presentAttribtedAlert(nil, [message], ["444D54"], [16.0], 0, nil, cancelButtonTitle, okButtonTitle, view, nil, cancelHandler, okHandler)
    }
    ///    有标题，只有一个按钮
    class func presentShowTitleOneButtonAlert(_ title : String,_ message : String,_ buttonTitle : String, _ view : UIView? = nil, _ handler: (() -> Void)? = nil) -> (AlertView){
        return self.presentAttribtedAlert(title, [message], ["444D54"], [16.0], 0, nil, nil, buttonTitle, view, nil, nil, handler)
    }
    ///    有标题，有两个按钮
    class func presentShowTitleTwoButtonAlert(_ title : String, _ message : String,_ cancelButtonTitle : String,_ okButtonTitle : String, _ view : UIView? = nil, _ cancelHandler: (() -> Void)? = nil,_ okHandler: (() -> Void)? = nil) -> (AlertView){
        return self.presentAttribtedAlert(title, [message], ["444D54"], [16.0], 0, nil, cancelButtonTitle, okButtonTitle, view, nil, cancelHandler, okHandler)
    }
    
    ///    有标题，有两个按钮,并设置行间距
    class func presentShowTitleLineSpaceTwoButtonAlert(_ title : String, _ message : String, _ lineSpace : CGFloat,_ cancelButtonTitle : String,_ okButtonTitle : String, _ view : UIView? = nil, _ cancelHandler: (() -> Void)? = nil,_ okHandler: (() -> Void)? = nil) -> (AlertView){
        return self.presentAttribtedAlert(title, [message], ["444D54"], [16.0], lineSpace, nil, cancelButtonTitle, okButtonTitle, view, nil, cancelHandler, okHandler)
    }
    
    //    警告框,内容富文本
    ///    没有标题,只有一个按钮
    class func presentHiddenTitleOneButtonAttributedAlert(_ messageArray : Array<String>, _ colorArray : Array<String>, _ fontArray : Array<CGFloat>, _ buttonTitle : String, _ view : UIView? = nil, _ handler: (() -> Void)? = nil) -> (AlertView){
        return self.presentAttribtedAlert(nil, messageArray, colorArray, fontArray, 0, nil, nil, buttonTitle, view, nil, nil, handler)
    }
    
    ///    没有标题，有两个按钮
    class func presentHiddenTitleTwoButtonAttributedAlert(_ messageArray : Array<String>, _ colorArray : Array<String>, _ fontArray : Array<CGFloat>, _ cancelButtonTitle : String,_ okButtonTitle : String, _ view : UIView? = nil, _ cancelHandler: (() -> Void)? = nil,_ okHandler: (() -> Void)? = nil) -> (AlertView){
        return self.presentAttribtedAlert(nil, messageArray, colorArray, fontArray, 0, nil, cancelButtonTitle, okButtonTitle, view, nil, cancelHandler, okHandler)
    }
    
    ///    有标题，只有一个按钮
    class func presentShowTitleOneButtonAttributedAlert(_ title : String, _ messageArray : Array<String>, _ colorArray : Array<String>, _ fontArray : Array<CGFloat>, _ lineSpace : CGFloat, _ buttonTitle : String, _ view : UIView? = nil,_ handler: (() -> Void)? = nil) -> (AlertView){
        return presentAttribtedAlert(title, messageArray, colorArray, fontArray, lineSpace, nil, nil, buttonTitle, view, nil, nil, handler)
    }
    
    ///    有标题，有两个按钮
    class func presentShowTitleTwoButtonAttributedAlert(_ title : String, _ messageArray : Array<String>, _ colorArray : Array<String>, _ fontArray : Array<CGFloat>, _ lineSpace : CGFloat , _ cancelButtonTitle : String,_ okButtonTitle : String, _ view : UIView? = nil, _ cancelHandler: (() -> Void)? = nil,_ okHandler: (() -> Void)? = nil) -> (AlertView){
        return self.presentAttribtedAlert(title, messageArray, colorArray, fontArray, lineSpace, nil, cancelButtonTitle, okButtonTitle, view, nil, cancelHandler, okHandler)
    }
    
    ///富文本 右上角有个图标，图标自定义，下面没有按钮
    class func presentShowTitleCustomButtonAttributedAlert(_ title : String, _ messageArray : Array<String>, _ colorArray : Array<String>, _ fontArray : Array<CGFloat>, _ lineSpace : CGFloat,_ customImageName : String? = nil, _ view : UIView? = nil, _ customHandler: ((AlertView) -> Void)? = nil) -> (AlertView){
        return self.presentAttribtedAlert(title, messageArray, colorArray, fontArray, lineSpace, customImageName, nil, nil, view, customHandler, nil, nil)
    }
    ///富文本 右上角有个图标，图标自定义，下面有两个按钮
    class func presentShowTitleCustomButtonTwoButtonAttributedAlert(_ title : String, _ messageArray : Array<String>, _ colorArray : Array<String>, _ fontArray : Array<CGFloat>, _ lineSpace : CGFloat,_ customImageName : String? = nil, _ cancelButtonTitle : String, _ okButtonTitle : String, _ view : UIView? = nil, _ customHandler: ((AlertView) -> Void)? = nil, _ cancelHandler: (() -> Void)? = nil,_ okHandler: (() -> Void)? = nil) -> (AlertView){
        return self.presentAttribtedAlert(title, messageArray, colorArray, fontArray, lineSpace, customImageName, cancelButtonTitle, okButtonTitle, view, customHandler, cancelHandler, okHandler)
    }
    
    ///不是富文本 右上角有个图标，图标自定义，下面有两个按钮
    class func presentShowTitleCustomButtonTwoButtonAlert(_ title : String, _ message : String, _ lineSpace : CGFloat,_ customImageName : String? = nil, _ cancelButtonTitle : String, _ okButtonTitle : String, _ view : UIView? = nil, _ customHandler: ((AlertView) -> Void)? = nil, _ cancelHandler: (() -> Void)? = nil,_ okHandler: (() -> Void)? = nil) -> (AlertView){
        return self.presentAttribtedAlert(title, [message], ["444D54"], [16.0], lineSpace, customImageName, cancelButtonTitle, okButtonTitle, view, customHandler, cancelHandler, okHandler)
    }
    
    class func presentAttribtedAlert(_ title : String? = nil, _ messageArray : Array<String>, _ colorArray : Array<String>, _ fontArray : Array<CGFloat>, _ lineSpace : CGFloat, _ customImageName : String? = nil, _ cancelButtonTitle : String? = nil,_ okButtonTitle : String? = nil, _ view : UIView? = nil,_ customHandler: ((AlertView) -> Void)? = nil, _ cancelHandler: (() -> Void)? = nil,_ okHandler: (() -> Void)? = nil) -> (AlertView){
        let alert = AlertView()
        
        alert.addSubview(alert.backView)
        if customImageName != nil {
            alert.backView.addSubview(alert.customButton)
            alert.customButton.setBackgroundImage(UIImage.sd_image(withName: customImageName), for: .normal)
            alert.customHandler = customHandler
        }
        if title != nil{
            alert.backView.addSubview(alert.titleLabel)
            alert.titleLabel.text = title
        }
        alert.backView.addSubview(alert.contentLabel)
        if cancelButtonTitle != nil{
            alert.backView.addSubview(alert.cancelButton)
            alert.cancelButton.setTitle(cancelButtonTitle, for: .normal)
            alert.cancelHandler = cancelHandler
        }
        if okButtonTitle != nil {
            alert.backView.addSubview(alert.okButton)
            alert.okButton.setTitle(okButtonTitle, for: .normal)
            alert.okHandler = okHandler
        }
        var message : String = messageArray.first ?? ""
        for index in 1..<messageArray.count{
            message = message + (messageArray.safeIndex(index) ?? "")
        }
        alert.contentLabel.text = message
        for index in 0..<messageArray.count{
            let temp : String = messageArray.safeIndex(index) ?? ""
            let color : String = colorArray.safeIndex(index) ?? colorArray.last ?? "000000"
            let font : CGFloat = fontArray.safeIndex(index) ?? fontArray.last ?? BaseTools.adapted(value: 12)
            alert.contentLabel.okidoki
                .attributedSubstring()(temp,UIColor.sd_color(withID: color))?
                .attributedSubstring()(temp,UIFont.setFontSizeWithValue(font))?
                .lineSpaceWithTextView()(lineSpace)
        }
        
        AlertView.addSuperView(alert,view)
        
        let left = BaseTools.adapted(value: 20)
        let alertWidth = view?.widthValue ?? BaseTools.screenWidth
        let alertHeight = view?.heightValue ?? BaseTools.screenHeight
        let backViewLeft = BaseTools.adapted(value: 30)
        alert.mas_makeConstraints { (make) in
            make?.left.top()?.equalTo()(0)
            make?.width.equalTo()(alertWidth)
            make?.height.equalTo()(alertHeight)
        }
        if customImageName != nil {
            alert.customButton.mas_makeConstraints { (make) in
                make?.top.equalTo()(BaseTools.adapted(value: 10))
                make?.right.equalTo()(-BaseTools.adapted(value: 10))
            }
        }
        if title != nil {
            if customImageName != nil {
                alert.titleLabel.mas_makeConstraints { (make) in
                    make?.centerX.equalTo()(alert.backView)
                    make?.left.equalTo()(left)
                    make?.top.equalTo()(alert.customButton.mas_bottom)?.offset()(BaseTools.adapted(value: 10))
                }
            }else{
                alert.titleLabel.mas_makeConstraints { (make) in
                    make?.centerX.equalTo()(alert.backView)
                    make?.left.equalTo()(left)
                    make?.top.equalTo()(BaseTools.adapted(value: 25))
                }
            }
            alert.contentLabel.mas_makeConstraints { (make) in
                make?.centerX.equalTo()(alert.backView)
                make?.top.equalTo()(alert.titleLabel.mas_bottom)?.offset()(BaseTools.adapted(value: 20))
                make?.left.equalTo()(alert.titleLabel.mas_left)
            }
        }else{
            if customImageName != nil {
                alert.contentLabel.mas_makeConstraints { (make) in
                    make?.centerX.equalTo()(alert.backView)
                    make?.left.equalTo()(left)
                    make?.top.equalTo()(alert.customButton.mas_bottom)?.offset()(BaseTools.adapted(value: 10))
                }
            }else{
                alert.contentLabel.mas_makeConstraints { (make) in
                    make?.centerX.equalTo()(alert.backView)
                    make?.left.equalTo()(left)
                    make?.top.equalTo()(BaseTools.adapted(value: 30))
                }
            }
        }
        if cancelButtonTitle != nil ||
            okButtonTitle != nil{
            if cancelButtonTitle != nil &&
                okButtonTitle != nil{
                alert.cancelButton.mas_makeConstraints { (make) in
                    make?.top.equalTo()(alert.contentLabel.mas_bottom)?.offset()(BaseTools.adapted(value: 25))
                    make?.left.equalTo()(left)
                    make?.width.equalTo()(alert.okButton.mas_width)
                    make?.height.equalTo()(BaseTools.adapted(value: 44))
                }
                alert.okButton.mas_makeConstraints { (make) in
                    make?.top.with()?.height().equalTo()(alert.cancelButton)
                    make?.left.equalTo()(alert.cancelButton.mas_right)?.offset()(left)
                    make?.right.equalTo()(alert.backView)?.offset()(-left)
                }
                alert.backView.mas_makeConstraints { (make) in
                    make?.center.equalTo()(alert)
                    make?.left.equalTo()(backViewLeft)
                    make?.bottom.equalTo()(alert.okButton.mas_bottom)?.offset()(BaseTools.adapted(value: 20))
                }
            }else if cancelButtonTitle != nil {
                alert.cancelButton.mas_makeConstraints { (make) in
                    make?.centerX.equalTo()(alert.backView)
                    make?.top.equalTo()(alert.contentLabel.mas_bottom)?.offset()(BaseTools.adapted(value: 25))
                    make?.left.equalTo()(left)
                    make?.height.equalTo()(BaseTools.adapted(value: 44))
                }
                alert.backView.mas_makeConstraints { (make) in
                    make?.center.equalTo()(alert)
                    make?.left.equalTo()(backViewLeft)
                    make?.bottom.equalTo()(alert.cancelButton.mas_bottom)?.offset()(BaseTools.adapted(value: 20))
                }
            }else if okButtonTitle != nil {
                alert.okButton.mas_makeConstraints { (make) in
                    make?.centerX.equalTo()(alert.backView)
                    make?.top.equalTo()(alert.contentLabel.mas_bottom)?.offset()(BaseTools.adapted(value: 25))
                    make?.left.equalTo()(left)
                    make?.height.equalTo()(BaseTools.adapted(value: 44))
                }
                alert.backView.mas_makeConstraints { (make) in
                    make?.center.equalTo()(alert)
                    make?.left.equalTo()(backViewLeft)
                    make?.bottom.equalTo()(alert.okButton.mas_bottom)?.offset()(BaseTools.adapted(value: 20))
                }
            }
        }else{
            alert.backView.mas_makeConstraints { (make) in
                make?.center.equalTo()(alert)
                make?.left.equalTo()(backViewLeft)
                make?.bottom.equalTo()(alert.contentLabel.mas_bottom)?.offset()(BaseTools.adapted(value: 40))
            }
        }
        let contentLabelMaxWidth = alertWidth - left * 2 - backViewLeft * 2
        let flag : Bool = message.isMoreThanOneLine(with: CGSize(width: contentLabelMaxWidth, height: CGFloat.greatestFiniteMagnitude), font: alert.contentLabel.font!, lineSpaceing: lineSpace)
        if  flag {
            alert.contentLabel.textAlignment = .left
        }else{
            alert.contentLabel.textAlignment = .center
        }
        return alert
    }
    
    class func addSuperView(_ alert : AlertView, _ view : UIView? = nil){
        if view == nil {
            let window = BaseTools.getKeyWindow()
            window?.addSubview(alert)
        }else{
            view?.addSubview(alert)
        }
    }
    
    var customHandler: ((AlertView) -> Void)? = nil
    var cancelHandler: (() -> Void)? = nil
    var okHandler: (() -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView : UIView = {
        var backView : UIView = UIView.init()
        backView.theme_backgroundColor = "FFFFFF"
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = BaseTools.adapted(value: 6)
        return backView
    }()
    
    lazy var titleLabel : UILabel = {
        var titleLabel = UILabel.init()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.setBoldSystemFontOfSizeWithValue(18)
        titleLabel.theme_textColor = "444D54"
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = UIColor.clear
        return titleLabel
    }()
    
    lazy var contentLabel : JHTapTextView = {
        var contentLabel = JHTapTextView.init()
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.setFontSizeWithValue(16)
        contentLabel.theme_textColor = "444D54"
        contentLabel.backgroundColor = UIColor.clear
        return contentLabel
    }()
    
    lazy var customButton : UIButton = {
        var customButton = UIButton.init(type: .custom)
        customButton.addTarget(self, action: #selector(customClick(_:)), for: .touchUpInside)
        customButton.adjustsImageWhenHighlighted = false
        return customButton
    }()
    
    lazy var cancelButton : UIButton = {
        var cancelButton = UIButton.init(type: .custom)
        cancelButton.addTarget(self, action: #selector(cancelClick(_:)), for: .touchUpInside)
        cancelButton.theme_setTitleColor("E0514C", for: .normal)
        cancelButton.theme_backgroundColor = "FFFFFF"
        cancelButton.layer.borderWidth = BaseTools.adapted(value: 0.8)
        cancelButton.layer.theme_borderColor = "E0514C"
        cancelButton.adjustsImageWhenHighlighted = false
        return cancelButton
    }()
    
    lazy var okButton : UIButton = {
        var okButton = UIButton.init(type: .custom)
        okButton.addTarget(self, action: #selector(okClick(_:)), for: .touchUpInside)
        okButton.theme_setTitleColor("FFFFFF", for: .normal)
        okButton.theme_backgroundColor = "E0514C"
        okButton.adjustsImageWhenHighlighted = false
        return okButton
    }()
    
    @objc func cancelClick(_ button : UIButton) {
        if (self.cancelHandler != nil) {
            self.cancelHandler!()
        }
        self.removeFromSuperview()
    }
    
    @objc func okClick(_ button : UIButton) {
        if (self.okHandler != nil) {
            self.okHandler!()
        }
        self.removeFromSuperview()
    }
    
    @objc func customClick(_ button : UIButton) {
        if (self.customHandler != nil) {
            self.customHandler!(self)
        }
    }
}
