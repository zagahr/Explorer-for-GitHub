//
//  GitHubService.swift
//  Explorer
//
//  Created by Zagahr on 16/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import Foundation
import FirebaseFunctions
import CodableFirebase

enum TrendingPeroid: CaseIterable {
    case daily
    case weekly
    case monthly
    
    var title: String {
        switch self {
        case .daily:
            return "Today"
        case .weekly:
            return "Week"
        case .monthly:
            return "Month"
        }
    }
    
    var query: String {
        switch self {
        case .daily:
            return "daily"
        case .weekly:
            return "weekly"
        case .monthly:
            return "monthly"
        }
    }
}

class GitHubService {
    lazy var functions = Functions.functions()
    
    func trendingRepositories(language: String, period: TrendingPeroid,
                              completion: @escaping (_ error: String?, _ result: [RepositoryModel]?) -> Void ) {
        
        functions.httpsCallable("repositories?language=\(language)&since=\(period.query)").call { (result, error) in
            if error != nil {
                completion("Unable to load data \n Please retry ", nil)
            } else {
                do {
                    if let result = result, let fragments = try? FirebaseDecoder().decode(TrendingRepos.self, from: result.data) {
                        let models = fragments.compactMap { RepositoryModel(element: $0) }
                        completion(nil, models)

                    } else {
                        completion("Unable to load data \n Please retry ", nil)
                    }
                }
            }
        }
    }
    
    func collaboratorsForRepository(owner: String, name: String) {
        
    }
}
