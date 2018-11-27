//
//  User.swift
//  Explorer
//
//  Created by Zagahr on 21/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import Foundation

public struct User: Codable {
    var language: Language
    
    init(language: Language) {
        self.language = language
    }
}
