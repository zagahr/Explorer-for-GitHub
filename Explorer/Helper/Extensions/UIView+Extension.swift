//
//  UIView+Extension.swift
//  Explorer
//
//  Created by Zagahr on 15/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
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

    func addBorder(_ edges: UIRectEdge, color: UIColor = UIColor.lightGray, margins: UIEdgeInsets = UIEdgeInsets.zero, thickness: CGFloat = 0.5) {
        
        func border() -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        let metrics: [String: CGFloat] = [
            "marginleft": margins.left,
            "marginright":  margins.right,
            "margintop":  margins.top,
            "marginbottom":  margins.bottom,
            "thickness": thickness
        ]
        
        if edges.contains(.top) || edges.contains(.all) {
            
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(margintop)-[top(thickness)]",
                                               options: [],
                                               metrics: metrics,
                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(marginleft)-[top]-(marginright)-|",
                                               options: [],
                                               metrics: metrics,
                                               views: ["top": top]))
        }
        
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(thickness)]-(marginbottom)-|",
                                               options: [],
                                               metrics: metrics,
                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(marginleft)-[bottom]-(marginright)-|",
                                               options: [],
                                               metrics: metrics,
                                               views: ["bottom": bottom]))
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(margintop)-[left]",
                                               options: [],
                                               metrics: metrics,
                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(marginleft)-[left(thickness)]-(marginright)-|",
                                               options: [],
                                               metrics: metrics,
                                               views: ["left": left]))
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(margintop)-[right]",
                                               options: [],
                                               metrics: metrics,
                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(marginleft)-[right(thickness)]-(marginright)-|",
                                               options: [],
                                               metrics: metrics,
                                               views: ["right": right]))
            
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}
