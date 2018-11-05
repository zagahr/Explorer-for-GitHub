//
//  RepositoryModel.swift
//  Explorer
//
//  Created by Zagahr on 18/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import Foundation
import Apollo

struct RepositoryModel: Codable {
    var id: String
    var owner: Person
    var name: String
    var description: String?
    var primaryLanguage: String?
    var languageColor: String?
    var forkCount: Int
    var starCount: Int
    var endCurser: String?
    
    
    init(fragment: Repository, endCurser: String?) {
        self.id = fragment.id
        self.owner = Person(fragment: fragment.owner)
        self.name = fragment.name
        self.description = fragment.description
        self.primaryLanguage = fragment.primaryLanguage?.name
        self.languageColor = fragment.primaryLanguage?.color
        self.forkCount = fragment.forkCount
        self.starCount = fragment.stargazers.totalCount
        self.endCurser = endCurser
    }
    
    init(element: TrendingRepoElement) {
        self.id = element.url
        self.owner = Person(element: element.builtBy.first)
        self.name = element.name
        self.description = element.description
        self.primaryLanguage = element.language
        
        let language = RCValues.shared.languages.filter { $0.name == element.language}.first
        
        if let language = language {
            self.languageColor = language.color
        }
        
        self.forkCount = element.forks
        self.starCount = element.stars
    }
    
}


struct Person: Codable {
    var id: String
    var username: String
    
    init(fragment: Repository.Owner) {
        self.id = fragment.id
        self.username = fragment.login
    }
    
    init(element: BuiltBy?) {
        self.id = element?.href ?? "UNKNOWN"
        self.username = element?.username ?? "UNKNOWN"
    }
}
