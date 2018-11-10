//
//  RepositoriesListViewModel.swift
//  Explorer
//
//  Created by Zagahr on 16/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import Foundation


protocol RepositoriesListViewModelDelegate: class {
    func onFetchCompleted()
    func onFetchFailed(message: String)
}

final class RepositoriesListViewModel {
    
    enum ModelType {
        case trending, detail
    }
    
    weak var delegate: RepositoriesListViewModelDelegate?
    weak var coordinatorDelegate: RepositoryDetailCoordinatorDelegate?
   
    private var service: GitHubService?
    private var period: TrendingPeroid?
    private var models: [RepositoryModel] = []
    private var query: String?
    private var loadingOpertaion: RepositoryLoadingOperation?
    private var endIndex = IndexPath(row: 0, section: 0)
    let type: ModelType

    var title: String?
    
    init(period: TrendingPeroid, service: GitHubService) {
        self.period = period
        self.service = service
        self.type = .trending
        self.title = period.title
    }
    
    init(model: ContributeModel) {
        self.query = model.query
        self.title = model.title
        self.type = .detail
        self.models = model.repositories
    }
    
    var numberOfElements: Int {
       return models.count
    }
    
    var canLoadMore: Bool {
        return models.count >= 10 && models.count < 30
    }
    
    func removeModels() {
        models.removeAll()
    }
    
    func model(at index: IndexPath) -> RepositoryModel? {
        return models[safe: index.row]
    }
    
    func fetchRepositories(forceRefresh: Bool = false, indexPath: IndexPath = IndexPath(row: 0, section: 0)) {
        
        if forceRefresh {
            models.removeAll()
        }
        
        if !models.isEmpty && type == .trending {
            return
        }
        
        switch self.type {
            case .detail:
                self.fetchDetailRepositories(forceRefresh: forceRefresh)
            case .trending:
                self.fetchTrendingRepositories()
        }
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        if let model = model(at: indexPath) {
            coordinatorDelegate?.showRepositoryDetail(model)
        }
    }
    
    private func alreadyFetchingCellFor(_ currentIndex: IndexPath) -> Bool {
        if 0...endIndex.row ~= currentIndex.row {
            return true
        } else {
            return false
        }
    }
    
    private func fetchTrendingRepositories() {
        guard
            let service = service,
            let period = period
        else {
            return
        }

        let language = UserCoordinator.shared.user?.language.urlParam ?? ""
        service.trendingRepositories(language: language, period: period) { (errorMessage, repositories) in
            if let errorMessage = errorMessage {
                self.delegate?.onFetchFailed(message: errorMessage)
            } else if let repositories = repositories {
                self.models = repositories
                self.delegate?.onFetchCompleted()
            }
        }
    }
    
    private func fetchDetailRepositories(forceRefresh: Bool) {
        guard let query = query else { return }
        
        if !forceRefresh {
            if loadingOpertaion?.isExecuting ?? false || !canLoadMore {
                return
            }
        }
        
        let itemsToFetch = 10
        
        let previusCurser = models.last?.endCurser
        loadingOpertaion = RepositoryLoadingOperation(query: query, items: itemsToFetch, after: previusCurser)
        
        guard let loadingOpertaion = loadingOpertaion else { return }
        
        loadingOpertaion.completionHandler = { [weak self] (repositories) in
            guard let self = self else { return }
            
            self.models.append(contentsOf: repositories)
            self.delegate?.onFetchCompleted()
        }
        
        loadingOpertaion.errorHandler = {[weak self] (errorMessage) in
            guard let self = self else { return }
            self.delegate?.onFetchCompleted()
        }
        
        let lastIndex = models.count
        endIndex = IndexPath(row: lastIndex + itemsToFetch , section: 0)
        
        loadingOpertaion.start()
    }
}
