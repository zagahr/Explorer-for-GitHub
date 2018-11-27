//
//  RepositoryDetailViewModel.swift
//  Explorer
//
//  Created by Zagahr on 24/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import Foundation

protocol RepositoryDetailViewDelegate: class {
    func onFetchCompleted()
    func onFetchFailed()
}

final class RepositoryDetailViewModel {
    private var repositoryModel: RepositoryModel?
    private var model: RepositoryDetail?
    weak var delegate: RepositoryDetailViewDelegate?
    
    func addRepository(_ model: RepositoryModel) {
        self.repositoryModel = model
        print(model.id)
    }
    
    func fetchRepositoryDetail() {
        guard let owner = repositoryModel?.owner.username, let name = repositoryModel?.name else { return }
        
        apollo.fetch(query: RepositoryDetailQuery(owner: owner, name: name)) { (result, error) in
            if error != nil {
                self.delegate?.onFetchFailed()
                return
            } else {
                guard let detail = result?.data?.repository?.fragments.repositoryDetail else {
                    self.delegate?.onFetchFailed()
                    return
                }
                
                self.model = detail
                self.delegate?.onFetchCompleted()
            }
        }
    }
}
