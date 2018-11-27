//
//  ContributeViewModel.swift
//  Explorer
//
//  Created by Zagahr on 14/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import Foundation

protocol ContributeViewModelDelegate: class {
    func onFetchCompleted()
    func onFetchFailed(message: String)
}

final class ContributeViewModel {
    fileprivate let loadingQueue = OperationQueue()
    fileprivate var loadingOperations = [IndexPath: RepositoryLoadingOperation]()
    
    weak var delegate: ContributeViewModelDelegate?
    weak var coordinatorDelegate: ContributeCoordinator?
    
    private var models: [ContributeModel] = []
    
    var numberOfElements: Int {
        return models.count
    }
    
    func removeModels() {
        models = []
    }
    
    func model(at index: IndexPath) -> ContributeModel? {
        return models[safe: index.row]
    }
    
    func fetchModels(forceRefresh: Bool = false) {
        func load() {
            let internalModels = RCValues.shared.contributeContent()
            fetchRepository(for: internalModels)
        }
        
        if forceRefresh {
            models.removeAll()
        }
        
        if models.isEmpty {
            if RCValues.shared.fetchComplete {
                load()
            }
            
            RCValues.shared.loadingDoneCallback = load
        }
    }
    
    func fetchRepository(for internalModels: [ContributeModel]) {
        let group = DispatchGroup()
            
        internalModels.forEach({ (element) in
            group.enter()
            let loadOperation = RepositoryLoadingOperation(query: element.query , items: 10)
            
            loadOperation.completionHandler = {(repositories) in
                var modelCopy = element
                modelCopy.addRepositories(repositories)
                self.models.append(modelCopy)
                group.leave()
            }
            
            loadOperation.errorHandler = { (_) in
                group.leave()
            }
            
            loadOperation.start()
        })
        
        group.notify(queue: .main) {
            if !self.models.isEmpty {
                self.delegate?.onFetchCompleted()
            } else {
                self.delegate?.onFetchFailed(message: "Unable to load data \n Please retry")
            }
        }
    }
}
