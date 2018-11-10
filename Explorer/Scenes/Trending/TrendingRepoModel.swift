//
//  TrendingRepoModel.swift
//  Explorer
//
//  Created by Zagahr on 11/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import Foundation

typealias TrendingRepos = [TrendingRepoElement]

struct TrendingRepoElement: Codable {
    let author, name: String
    let url: String
    let description, language: String
    let stars, forks, currentPeriodStars: Int
    let builtBy: [BuiltBy]
}

struct BuiltBy: Codable {
    let username: String
    let href, avatar: String
}
