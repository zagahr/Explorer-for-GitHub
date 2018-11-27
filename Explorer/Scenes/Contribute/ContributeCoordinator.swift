//
//  ContributeCoordinator.swift
//  Explorer
//
//  Created by Zagahr on 14/11/2018.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

protocol ContributeCoordinatorDelegate: class {
    func showRepositoriesTableViewController(model: ContributeModel)
}

final class ContributeCoordinator: Coordinator {
    deinit {
        print("deinit \(String(describing: self))")
    }
    
    let rootViewController: UINavigationController
    let storyboard = UIStoryboard(name: "Contribute", bundle: nil)
    
    lazy var tabBarItem: UITabBarItem = {
        return UITabBarItem(title: "Contribute", image: UIImage(named: "contribute"), selectedImage: nil)
    }()
    
    lazy var viewModel: ContributeViewModel! = {
        let viewModel = ContributeViewModel()
        viewModel.coordinatorDelegate = self
        
        return viewModel
    }()
    
    lazy var repositoryDetailCoordinator: RepositoryDetailCoordinator = {
        let model = RepositoryDetailCoordinator()
        model.start()
        
        return model
    }()
    
    override init() {
        self.rootViewController = UINavigationController()
    }
    
    override func start() {
        guard let contributeVC = storyboard.initialViewController() as? ContributeVC else {
            return
    }
        
        contributeVC.tabBarItem = tabBarItem
        contributeVC.viewModel = viewModel

        rootViewController.setViewControllers([contributeVC], animated: true)
    }
}

extension ContributeCoordinator: ContributeCoordinatorDelegate {
    func showRepositoriesTableViewController(model: ContributeModel) {
        let viewModel = RepositoriesListViewModel(model: model)
        viewModel.coordinatorDelegate = self
        let repositoriesVC = RepositoriesListController(collectionViewLayout: UICollectionViewFlowLayout())
        repositoriesVC.viewModel = viewModel
        repositoriesVC.title = model.title
        rootViewController.pushViewController(repositoriesVC, animated: true)
    }
}

extension ContributeCoordinator: RepositoryDetailCoordinatorDelegate {
    func showRepositoryDetail(_ model: RepositoryModel) {
        repositoryDetailCoordinator.viewModel.addRepository(model)
        
        let vc = repositoryDetailCoordinator.rootViewController
        vc.title = model.name
        rootViewController.pushViewController(vc, animated: true)
    }
}
