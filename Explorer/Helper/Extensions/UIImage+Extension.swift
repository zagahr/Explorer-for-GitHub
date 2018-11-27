//
//  UIImage+Extension.swift
//  Explorer
//
//  Created by Zagahr on 18/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

extension UIImage{
    class func imageFromSystemBarButton(_ systemItem: UIBarButtonItem.SystemItem, renderingMode:UIImage.RenderingMode = .automatic)-> UIImage {
        
        let tempItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
        
        // add to toolbar and render it
        let bar = UIToolbar()
        bar.setItems([tempItem], animated: false)
        bar.snapshotView(afterScreenUpdates: true)
        
        // got image from real uibutton
        let itemView = tempItem.value(forKey: "view") as! UIView
        
        for view in itemView.subviews {
            if view is UIButton {
                let button = view as! UIButton
                let image = button.imageView!.image!
                image.withRenderingMode(renderingMode)
                return image
            }
        }
        
        return UIImage()
    }
}
