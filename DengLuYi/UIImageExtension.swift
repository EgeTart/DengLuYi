//
//  UIImageExtension.swift
//  DengLuYi
//
//  Created by Egetart on 2017/3/27.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func compressedImage() -> UIImage {
        
        let scaleFactor = max(size.width / 300, size.height / 300)
        let newSize = CGSize(width: size.width / scaleFactor, height: size.height / scaleFactor)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1)
        self.draw(at: .zero)
        let compressdImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return compressdImage!
    }
}
