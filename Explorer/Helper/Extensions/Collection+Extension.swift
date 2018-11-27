//
//  Collection+Extension.swift
//  Explorer
//
//  Created by Zagahr on 27/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
