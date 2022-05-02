//
//  String+Extension.swift
//
//  Created by HLD on 2020/5/27.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit

extension String {
    /// 截取到任意位置
    func subString(to: Int) -> String {
        if to >= self.count {
            return String(self[..<self.index(self.startIndex, offsetBy: self.count)])
        }
        let index: String.Index = self.index(startIndex, offsetBy: to)
        return String(self[..<index])
    }
    /// 从任意位置开始截取
    func subString(from: Int) -> String {
        if from >= self.count {
            return String(self[self.index(self.startIndex, offsetBy: self.count)...])
        }
        let index: String.Index = self.index(startIndex, offsetBy: from)
        return String(self[index ..< endIndex])
    }
    /// 从任意位置开始截取到任意位置
    func subString(from: Int, to: Int) -> String {
        let begin = self.subString(from: from)
        let str = begin.subString(to: to)
        return str
    }
    ///   使用下标截取到任意位置
    subscript(to: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: to)
        return String(self[..<index])
    }
    ///   使用下标从任意位置开始截取到任意位置
    subscript(from: Int, to: Int) -> String {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
    ///    截取‘XX’前面所有的字符串(结果不包含‘XX’)
    func subStingBefore(_ subSting : String) -> String{
        let range: Range = self.range(of: subSting)!
        let location: Int = self.distance(from: self.startIndex, to: range.lowerBound)
        return String(self.prefix(location))
    }
    ///    截取‘XX’前面所有的字符串(结果包含‘XX’)
    func subStingBeforeContains(_ subSting : String) -> String{
        let range: Range = self.range(of: subSting)!
        let location: Int = self.distance(from: self.startIndex, to: range.upperBound)
        return String(self.prefix(location))
    }
    ///    截取'xx'后面的所有字符串(结果不包含‘XX’)
    func subStingAfter(_ subSting : String) -> String{
        let range: Range = self.range(of: subSting)!
        let location: Int = self.distance(from: self.startIndex, to: range.upperBound)
        return String(self.suffix(self.count - location))
    }
    ///    截取'XX'后面的所有字符串(结果包含‘XX’)
    func subStingAfterContains(_ subSting : String) -> String{
        let range: Range = self.range(of: subSting)!
        let location: Int = self.distance(from: self.startIndex, to: range.lowerBound)
        return String(self.suffix(self.count - location))
    }
    ///   double转字符串
    static func doubleToString(_ value : Double, _ jingDu : Int) -> (String){
        return String.init(format: "%.\(jingDu)f", value)
    }
    ///    字符串转float
    func stringToFloat() -> (CGFloat){
        var cgFloat:CGFloat = 0
        if let doubleValue = Double(self){
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    ///    字符串转整型
    func stringToInt()->(Int){
        var cgInt: Int = 0
        if let doubleValue = Double(self){
            cgInt = Int(doubleValue)
        }
        return cgInt
    }
    /// range转换为NSRange
    func id_range(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }
    ///    获取每行文字
    func getLinesArrayWidth(_ font: UIFont, _ maxWidth: CGFloat) -> [String]? {
        var linesArr = [String]()
        let myFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        let attStr = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        attStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, self.count))
        attStr.addAttribute( NSAttributedString.Key(kCTFontAttributeName as String), value: myFont, range: NSMakeRange(0, self.count))
        let frameSetter = CTFramesetterCreateWithAttributedString(attStr)
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        if let lines = CTFrameGetLines(frame) as? [CTLine] {
            lines.forEach { (line: CTLine) in
                let lineRange = CTLineGetStringRange(line)
                let lineStr = (self as NSString).substring(with: NSMakeRange(lineRange.location, lineRange.length))
                CFAttributedStringSetAttribute(attStr, lineRange, kCTKernAttributeName, NSNumber(value: 0) as CFTypeRef)
                CFAttributedStringSetAttribute(attStr, lineRange, kCTKernAttributeName, NSNumber(value: 0) as CFTypeRef)
                linesArr.append(lineStr)
            }
        }
        return linesArr
    }
}
