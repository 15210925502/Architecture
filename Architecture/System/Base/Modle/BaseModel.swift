//
//  BaseModel.swift
//  Architecture
//
//  Created by HLD on 2020/5/25.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit

@objcMembers
class BaseModel: NSObject,NSCoding {
    
    override init() {
        super.init()
    }
    
    // MARK: - 归档
    func encode(with aCoder: NSCoder) {
        for name in getAllPropertys() {
            guard let value = self.value(forKey: name) else {
                return
            }
            aCoder.encode(value, forKey: name)
        }
    }
    // MARK: - 解档
    internal required init?(coder aDecoder: NSCoder){
        super.init()
        for name in getAllPropertys() {
            guard let value = aDecoder.decodeObject(forKey: name) else {
                return
            }
            setValue(value, forKeyPath: name)
        }
    }
    // MARK: - 获取属性数组
    func getAllPropertys() -> [String] {
        var count: UInt32 = 0 // 这个类型可以使用CUnsignedInt,对应Swift中的UInt32
        let properties = class_copyPropertyList(self.classForCoder, &count)
        var propertyNames: [String] = []
        for i in 0..<Int(count) { // Swift中类型是严格检查的，必须转换成同一类型
            if let property = properties?[i] { // UnsafeMutablePointer<objc_property_t>是可变指针，因此properties就是类似数组一样，可以通过下标获取
                let name = property_getName(property)
                // 这里还得转换成字符串
                let strName = String(cString: name)
                propertyNames.append(strName)
            }
        }
        // 不要忘记释放内存，否则C语言的指针很容易成野指针的
        free(properties)
        return propertyNames
    }
}
