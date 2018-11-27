//
//  UISearchBar+Extension.swift
//  Explorer
//
//  Created by Zagahr on 11/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    private var textField: UITextField? {
        return subviews.first?.subviews.compactMap { $0 as? UITextField }.first
    }
    
    private var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator = UIActivityIndicatorView(style: .gray)
                    newActivityIndicator.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    newActivityIndicator.startAnimating()
                    newActivityIndicator.backgroundColor = UIColor(red: 0.9373, green: 0.9373, blue: 0.9412, alpha: 1.0)
                    textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero
                    newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }
}

