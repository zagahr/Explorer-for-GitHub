//
//  StyleGuide.swift
//  Explorer
//
//  Created by Zagahr on 24.06.15.
//  Copyright © 2015 Zagahr. All rights reserved.
//

import UIKit

extension UIColor {
    
    func colorWithHexString(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {

        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        let scanner: Scanner = Scanner(string: hexStr)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
    
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF)
        let green = CGFloat((hex >> 8) & 0xFF)
        let blue = CGFloat(hex & 0xFF)
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
    struct Explorer {
        static let lightPrimaryBackgroundColor = UIColor.white
        static let lightSecondaryBackgroundColor = UIColor(hex: 0xEDEEF1)
        
        static let primaryIconColor = UIColor(hex: 0x9AA1AE)
        static let secondaryIconColor = UIColor(hex: 0xFCCF7B)
        
        static let primaryTextColor = UIColor(hex: 0x363C3F)
        static let secondaryTextColor = UIColor(hex: 0xA4A7A8)
        static let tertiaryTextColor = UIColor(hex: 0xFEFFFF)
        
        static let highlightColor = UIColor(hex: 0x24292e)
    }
}

typealias Languages = [Language]

struct Language: Codable {
    let name: String
    let color: String
    let urlParam: String
}

class StyleGuide {
    static var primaryBackgoundColor: UIColor = .clear
    static var secondaryBackgroundColor: UIColor = .clear
    
    static var primaryIconColor: UIColor = .clear
    static var secondaryIconColor: UIColor = .clear
    
    static var primaryTextColor: UIColor = .clear
    static var secondaryTextColor: UIColor = .clear
    static var tertiaryTextColor: UIColor = .clear
    
    static var highlightColor: UIColor = .clear
    static var elementColor: UIColor = .white
    static let blueTextColor = UIColor(hex: 0x0266D6)
    static let loadingColor = UIColor().colorWithHexString(hexString: "#f0f0f0")
    
    static func setupAppearence() {
        if true {
            primaryBackgoundColor = UIColor.Explorer.lightPrimaryBackgroundColor
            secondaryBackgroundColor = UIColor.Explorer.lightSecondaryBackgroundColor
            
            primaryIconColor = UIColor.Explorer.primaryIconColor
            secondaryIconColor = UIColor.Explorer.secondaryIconColor
            
            primaryTextColor = UIColor.Explorer.primaryTextColor
            secondaryTextColor = UIColor.Explorer.secondaryTextColor
            tertiaryTextColor = UIColor.Explorer.tertiaryTextColor
            
            highlightColor = UIColor.Explorer.highlightColor
        }
        
        UINavigationBar.appearance().isOpaque = true
        UINavigationBar.appearance().isTranslucent = false
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().tintColor = StyleGuide.tertiaryTextColor
        UINavigationBar.appearance().barTintColor = StyleGuide.highlightColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: StyleGuide.tertiaryTextColor]
        UINavigationBar.appearance().shadowImage = UIImage()
        
        UIImageView.appearance().tintColor = StyleGuide.secondaryTextColor
        
        // TableView cell
        UITableViewCell.appearance().layoutMargins = UIEdgeInsets.zero
        UITableViewCell.appearance().preservesSuperviewLayoutMargins = false
        UITableViewCell.appearance().separatorInset = UIEdgeInsets.zero
    }
}
