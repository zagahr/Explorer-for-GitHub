//
//  RepositoryLoadingOperation.swift
//  Explorer
//
//  Created by Zagahr on 18/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit
import Apollo

typealias RepositoryLoadingCompletionHandlerType = (([RepositoryModel]) -> ())?
typealias RepositoryLoadingErrorHandlerType = ((String) -> ())?

class RepositoryLoadingOperation: Operation {
    var query: String
    var completionHandler: RepositoryLoadingCompletionHandlerType
    var errorHandler: RepositoryLoadingErrorHandlerType
    var request: Cancellable?
    var items: Int
    var after: String?
    
    init(query: String, items: Int = 3, after: String? = nil) {
        self.query = query
        self.items = items
        self.after = after
    }
    
    override func main() {
        if isCancelled {
            return
        }
       
       request = apollo.fetch(query: SearchQuery(searchTerm: self.query, first: self.items, after: self.after)) { (result, error) in
        
            if error != nil {
                self.errorHandler?("Unable to load data \n Please retry")
            } else {
                guard let nodes = result?.data?.search.nodes else {
                    self.errorHandler?("Unable to load data \n Please retry")
                    return
                }
                
                let cursor = result?.data?.search.pageInfo.endCursor
                let fragments = nodes.compactMap { $0?.fragments.repository }
                let models = fragments.compactMap { RepositoryModel(fragment: $0, endCurser: cursor) }
            
                if !models.isEmpty {
                    self.completionHandler?(models)
                } else {
                    self.errorHandler?("Unable to load data \n Please retry")
                }
            }
        }
    }
    
    override func cancel() {
        super.cancel()
        
        request?.cancel()
    }
}
