//
//  Configuration.swift
//  Explorer
//
//  Created by Zagahr on 16/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import Foundation


var GitHubApiKey: String {
    guard let key = ProcessInfo.processInfo.environment["GITHUB-KEY"] else {
        fatalError("GITHUB-KEY must be set as environment variable")
    }
    
    return key
}
