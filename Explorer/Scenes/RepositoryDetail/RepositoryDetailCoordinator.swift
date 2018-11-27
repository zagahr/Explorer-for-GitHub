//
//  RepositoryDetailCoordinator.swift
//  Explorer
//
//  Created by Zagahr on 22/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

protocol RepositoryDetailCoordinatorDelegate: class {
    func showRepositoryDetail(_ model: RepositoryModel)
}

final class RepositoryDetailCoordinator: Coordinator {
    let rootViewController: UIViewController
    let storyboard = UIStoryboard(name: "RepositoryDetail", bundle: nil)
    
    lazy var viewModel: RepositoryDetailViewModel = {
        let model = RepositoryDetailViewModel()
        
        return model
    }()
    
    override init() {
        rootViewController = storyboard.initialViewController()
    }
    
    override func start() {
        guard let repositoryDetailVC = rootViewController as? RepositoryDetailVC else { return }
        repositoryDetailVC.viewModel = viewModel
    }
}
