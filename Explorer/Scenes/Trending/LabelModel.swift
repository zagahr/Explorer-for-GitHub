//
//  LabelModel.swift
//  Explorer
//
//  Created by Zagahr on 13/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

enum Label: CaseIterable {
    case allvalues
    case help
    case enhancement
    case bug
    case question
    case documentation
    
    
    static func getBt(_ string: String) -> Label? {
        return Label.allCases.filter { $0.title.lowercased().contains(string) }.first
    }
    
    var title: String {
        switch self {
        case .allvalues:
            return "All values"
        case .help:
            return "Help wanted"
        case .enhancement:
            return "Enhancement"
        case .bug:
            return "Bug"
        case .question:
            return "Question"
        case .documentation:
            return "Documentation"
        }
    }
    
    var color: UIColor {
        switch self {
        case .allvalues:
            return UIColor.white
        case .help:
            return UIColor(red:0.16, green:0.59, blue:0.12, alpha:1.0)
        case .enhancement:
            return UIColor(red:0.55, green:0.71, blue:0.92, alpha:1.0)
        case .bug:
            return UIColor(red:0.96, green:0.18, blue:0.20, alpha:1.0)
        case .question:
            return UIColor(red:0.78, green:0.20, blue:0.49, alpha:1.0)
        case .documentation:
            return UIColor(red:0.96, green:0.78, blue:0.78, alpha:1.0)
        }
    }
}
