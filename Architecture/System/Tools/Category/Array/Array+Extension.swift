//
//  Array+Extension.swift
//  Architecture
//
//  Created by HLD on 2020/5/27.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func removeItem<T: Comparable>(_ item: T) {
        for i in stride(from: 0, to: self.count, by: 1) {
            if let t = self[i] as? T {
                if t == item {
                    remove(at: i)
                    break
                }
            }
        }
    }
    
    func randomItem() -> Element?{
        if self.count <= 0 { return nil }
        let index = arc4random() % UInt32(self.count)
        return self[Int(index)]
    }
    
    public mutating func safeRemove(at index: Int) {
        if !(index < 0) && count > 0 && index < count{
        
            remove(at: index)
        }else {
            print("无效操作, index = \(index), count = \(count)")
        }
    }
    
    public func safeIndex(_ index: Int) -> Element? {
        if !(index < 0) && count > 0 && index < count {
            return self[index]
        }
        return nil
    }
}
