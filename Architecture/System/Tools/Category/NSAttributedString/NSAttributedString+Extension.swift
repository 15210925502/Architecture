//
//  NSAttributedString+Extension.swift
//  Architecture
//
//  Created by HLD on 2020/5/29.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import Foundation

extension NSAttributedString {
    //    oc调用swift方法前面要添加一个@objc
    ///设置行间距
    @objc class func getLineSpaceAttributedString(str: String, lineSpacing: CGFloat, alignment: NSTextAlignment) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string: str)
        self.setWordAndLineSpaceAttributedString(attrStr: attrStr, wordSpace: 0.0, lineSpacing: lineSpacing, alignment: alignment)
        return attrStr
    }
    ///设置字间距
    @objc class func getWordSpaceAttributedString(str: String, wordSpace: CGFloat, alignment: NSTextAlignment) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string: str)
        self.setWordAndLineSpaceAttributedString(attrStr: attrStr, wordSpace: wordSpace, lineSpacing: 0.0, alignment: alignment)
        return attrStr
    }
    ///设置字间距和行间距
    @objc class func getWordAndLineSpaceAttributedString(str: String, wordSpace: CGFloat, lineSpacing: CGFloat, alignment: NSTextAlignment) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string: str)
        self.setWordAndLineSpaceAttributedString(attrStr: attrStr, wordSpace: wordSpace, lineSpacing: lineSpacing, alignment: alignment)
        return attrStr
    }
    ///设置字体大小、颜色
    class func getFontAndColorAttributedString(titleArray: Array<String>, colorArray: Array<String>, fontArray: Array<CGFloat>, alignment: NSTextAlignment? = nil)-> NSMutableAttributedString {
        return self.getFontColorWordAndLineSpaceAttributedString(titleArray: titleArray, colorArray: colorArray, fontArray: fontArray, wordSpace: 0.0, lineSpacing: 0.0, alignment: alignment)
    }
    ///设置字体大小、颜色、行间距、字间距
    class func getFontColorWordAndLineSpaceAttributedString(titleArray: Array<String>, colorArray: Array<String>, fontArray: Array<CGFloat>, wordSpace: CGFloat? = nil, lineSpacing: CGFloat? = nil, alignment: NSTextAlignment? = nil)-> NSMutableAttributedString {
        var title: String?
        
        for titleIndex in 0..<titleArray.count {
            title = (title ?? "") + String(titleArray.safeIndex(titleIndex)!)
        }
        
        let attStr = NSMutableAttributedString.init(string: title ?? "")
        var titleCount = 0
        
        for colorIndex in 0..<titleArray.count {
            let titleStr : String = titleArray.safeIndex(colorIndex)!
            let colorStr : String = colorArray.safeIndex(colorIndex) ?? colorArray.last ?? "000000"
            let fontStr: CGFloat = fontArray.safeIndex(colorIndex) ?? fontArray.last ?? BaseTools.adapted(value: 12)
            let textColor: UIColor = UIColor.sd_color(withID: colorStr)
            let textFont = UIFont.systemFont(ofSize: fontStr)
            attStr.addAttributes([NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: textFont], range: NSRange.init(location: titleCount, length: titleStr.count))
            titleCount += titleStr.count
        }
        self.setWordAndLineSpaceAttributedString(attrStr: attStr, wordSpace: wordSpace, lineSpacing: lineSpacing, alignment: alignment)
        return attStr
    }
    
    ///设置字间距和行间距
    class func setWordAndLineSpaceAttributedString(attrStr: NSMutableAttributedString, wordSpace: CGFloat? = nil, lineSpacing: CGFloat? = nil, alignment: NSTextAlignment? = nil) {
        //设置行间距
        let style:NSMutableParagraphStyle  = NSMutableParagraphStyle()
        //行间距（垂直上的间距）
        style.lineSpacing = lineSpacing ?? 0.0
        // 分割模式，英文字符拆开显示，byWordWrapping表示不拆开显示
        /*
         NSLineBreakByWordWrapping = 0,      // Wrap at word boundaries, default
         NSLineBreakByCharWrapping,  // Wrap at character boundaries
         NSLineBreakByClipping,  // Simply clip
         NSLineBreakByTruncatingHead, // Truncate at head of line: "...wxyz"
         NSLineBreakByTruncatingTail, // Truncate at tail of line: "abcd..."
         NSLineBreakByTruncatingMiddle // Truncate middle of line:  "ab...yz"
         */
        style.lineBreakMode = .byCharWrapping
        //居中显示（如果要设置alignment，这个必须设置，因为label的textAlignment会无效）
        style.alignment = alignment ?? .left
        //设置首行字符缩进距离
        //        style.firstLineHeadIndent = 25.0
        //每行的左右间距
        //        style.headIndent = 5
        //段与段之间的间距
        //        style.paragraphSpacing = 15
        //段首行空白空间
        //        style.paragraphSpacingBefore = 0.0
        //从左到右的书写方向（一共三种）
        //        style.baseWritingDirection = .leftToRight
        // 行高倍数（1.5倍行高）
        //        style.lineHeightMultiple = 1.5
        // 默认Tab 宽度
        //        style.defaultTabInterval = 144
        // 结束 x位置（不是右边间距，与inset 不一样）
        //        style.tailIndent = 320
        //        style.hyphenationFactor = 1.0
        attrStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSRange(location: 0, length: attrStr.length))
        //设置字间距
        attrStr.addAttribute(NSAttributedStringKey.kern, value: wordSpace ?? 0.0, range: NSRange(location: 0, length: attrStr.length))
    }
}
