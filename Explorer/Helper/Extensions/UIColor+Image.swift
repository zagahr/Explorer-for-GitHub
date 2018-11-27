//
//  UIImage+ImageWithColor.swift
//  Explorer
//
//  Created by Zagahr on 21.01.15.
//  Copyright (c) 2015 Explorer. All rights reserved.
//

import UIKit

extension UIColor {
    
    func image() -> UIImage {
        return imageWithSize(CGSize(width: 1, height: 1))
    }
    
    func imageWithSize(_ size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
