//
//  ViewShadows.swift
//  Explorer
//
//  Created by Zagahr on 04.11.18.
//  Copyright (c) 2014 Explorer. All rights reserved.
//

import UIKit

extension UIView {
    func addShadowWithOffset(_ offset: CGSize, color: UIColor, opacity: Float, shadowRadius: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func applyDefaultShadow() {
        addShadowWithOffset(CGSize(width: 1.0, height: 1.0), color: UIColor.gray, opacity: 0.1, shadowRadius: 1.0)
    }
}
