//
//  ContributeTableViewModel.swift
//  Explorer
//
//  Created by Zagahr on 19/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import Foundation

protocol ContributeTableViewModelDelegate: class {
    func onFetchCompleted(at indexPath: IndexPath)
    func onFetchFailed(at index: IndexPath, message: String)
}

final class ContributeTableViewModel {
    weak var delegate: ContributeTableViewModelDelegate?
    weak var coordinatorDelegate: ContributeCoordinator?
    
    private var model: ContributeModel?
    private var loadingOpertaion: RepositoryLoadingOperation?
    
    var numberOfElements: Int {
        guard let model = model else { return 3 }
        
        return model.repositories.count
    }
    
    var shoudReload = true
    
    private var query: String? {
        return model?.query
    }

    var initalLoad: Bool {
        return model?.repositories.isEmpty ?? true
    }
    
    var numberOfElementsReached: Bool {
        return model?.repositories.count ?? 0 >= numberOfElements
    }
    
    func swap(with newModel: ContributeModel?) {
        shoudReload = newModel?.query != model?.query
        model = newModel
    }
    
    func model(at index: IndexPath) -> RepositoryModel? {
        guard let model = model else { return nil }
        
        return model.repositories[index.row]
    }
    
    func fetchRepository(after indexPath: IndexPath) {
//        if loadingOpertaion?.isExecuting ?? false || initalLoad || numberOfElementsReached {
//            return
//        }
//
//        let previosIndex = indexPath.row - 1
//        let previusCurser = models.indices.contains(previosIndex) ? models[previosIndex].endCurser : nil
//        loadingOpertaion = RepositoryLoadingOperation(query: query, items: 8, after: previusCurser)
//
//        loadingOpertaion!.completionHandler = { [weak self] (repositories) in
//            guard let self = self else { return }
//
//            self.models.append(contentsOf: repositories)
//            self.delegate?.onFetchCompleted(at: indexPath)
//        }
//
//        loadingOpertaion!.errorHandler = {[weak self] (errorMessage) in
//            guard let self = self else { return }
//
//            self.delegate?.onFetchFailed(at: indexPath, message: errorMessage)
//        }
//
//        loadingOpertaion!.start()
    }
    
    func showRepositoriesTableViewController() {
        guard let model = model else { return }
        
        coordinatorDelegate?.showRepositoriesTableViewController(model: model)
    }
    
    func didSelectCell(at index: IndexPath) {
        if let model = model(at: index) {
            coordinatorDelegate?.showRepositoryDetail(model)
        }
    }
}
