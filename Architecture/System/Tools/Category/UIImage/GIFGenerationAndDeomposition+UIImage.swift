//
//  GIFGenerationAndDeomposition+UIImage.swift
//
//  Created by HLD on 2020/5/27.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit
import MobileCoreServices

enum imageType {
    case png
    case jpg
}

extension UIImage {
    
    /// 根据传入图片数组创建gif动图
    ///
    /// - Parameters:
    ///   - images: 源图片数组
    ///   - gifName: 生成gif图片名称
    ///   _ savePath: 保存gif图片路径
    class func compositionImage(_ images: NSMutableArray, _ gifName: String, _ savePath: String = "") {
        let directory = self.appendSavePath(savePath)
        let gifPath = directory + "\(gifName)" + ".gif"
        guard let url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, gifPath as CFString, .cfurlposixPathStyle, false), let destinaiton = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil) else {
            return
        }
        
        //设置每帧图片播放时间
        let cgimageDic = [kCGImagePropertyGIFDelayTime as String: 0.1]
        let gifDestinaitonDic = [kCGImagePropertyGIFDictionary as String: cgimageDic]
        
        //添加gif图像的每一帧元素
        for cgimage in images {
            CGImageDestinationAddImage(destinaiton, (cgimage as AnyObject).cgImage!!, gifDestinaitonDic as CFDictionary)
        }
        
        // 设置gif的彩色空间格式、颜色深度、执行次数
        let gifPropertyDic = NSMutableDictionary()
        gifPropertyDic.setValue(kCGImagePropertyColorModelRGB, forKey: kCGImagePropertyColorModel as String)
        gifPropertyDic.setValue(16, forKey: kCGImagePropertyDepth as String)
        gifPropertyDic.setValue(1, forKey: kCGImagePropertyGIFLoopCount as String)
        
        //设置gif属性
        let gifDicDest = [kCGImagePropertyGIFDictionary as String: gifPropertyDic]
        CGImageDestinationSetProperties(destinaiton, gifDicDest as CFDictionary)
        
        //生成gif
        CGImageDestinationFinalize(destinaiton)
        
        print(gifPath)
    }
    
    /// 把gif动图分解成每一帧图片
    ///
    /// - Parameters:
    ///   - imageType: 分解后的图片格式
    ///   - path: gif路径
    ///   - locatioin: 分解后图片保存路径（如果为空则保存在默认路径）
    ///   - imageName: 分解后图片名称
    class func decompositionImage( _ imageType: imageType, _ path: String, _ locatioin: String = "", _ imageName: String = "") {
        
        //把图片转成data
        let gifDate = try! Data(contentsOf: URL(fileURLWithPath: path))
        guard let gifSource = CGImageSourceCreateWithData(gifDate as CFData, nil) else {
            return
        }
        //计算图片张数
        let count = CGImageSourceGetCount(gifSource)
        let directory = self.appendSavePath(locatioin)
        var imagePath = ""
        //逐一取出
        for i in 0...count-1 {
            guard let imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, nil) else { return
            }
            let image = UIImage(cgImage: imageRef, scale: UIScreen.main.scale, orientation: .up)
            
            //根据选择不同格式生成对应图片已经路径
            switch imageType {
            case .jpg:
                guard let imageData = UIImageJPEGRepresentation(image, 1) else {
                    return
                }
                if imageName.isEmpty {
                    imagePath = directory + "\(i)" + ".jpg"
                }else {
                    imagePath = directory + "\(imageName)" + "_" + "\(i)" + ".jpg"
                }
                try? imageData.write(to: URL.init(fileURLWithPath: imagePath), options: .atomic)
            case .png:
                guard let imageData = UIImagePNGRepresentation(image) else {
                    return
                }
                if imageName.isEmpty {
                    imagePath = directory + "\(i)" + ".png"
                }else {
                    imagePath = directory + "\(imageName)" + "_" + "\(i)" + ".png"
                }
                //生成图片
                try? imageData.write(to: URL.init(fileURLWithPath: imagePath), options: .atomic)
            }
            print(imagePath)
        }
    }
    
     class func appendSavePath( _ savePath: String) -> (String){
        var dosc: [String] = []
        var directory = ""
        
        //判断是否传入路径，如果没有则使用默认路径
        if savePath.isEmpty {
            dosc = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            directory = dosc[0] + "/"
        }else{
            let index = savePath.index(savePath.endIndex, offsetBy: -1)
            
            if String(savePath[index...]) != "/" {
                directory = savePath + "/"
            }else{
                directory = savePath
            }
        }
        return directory
    }
}
