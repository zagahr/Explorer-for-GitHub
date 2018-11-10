//
//  TrendingCoordinator.swift
//  Explorer
//
//  Created by Zagahr on 10.09.18.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit

final class TrendingCoordinator: Coordinator {
    
    let rootViewController: UINavigationController
    let storyboard = UIStoryboard(name: "Trending", bundle: nil)
    
    lazy var tabBarItem: UITabBarItem = {
         return UITabBarItem(title: "Trending", image: UIImage(named: "trend"), selectedImage: nil)
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
        guard let trendingVC = storyboard.initialViewController() as? TrendingVC else {
            return
        }
        
        trendingVC.tabBarItem = tabBarItem
        trendingVC.coordinatorDelegate = self
        rootViewController.setViewControllers([trendingVC], animated: true)
    }
}

extension TrendingCoordinator: RepositoryDetailCoordinatorDelegate {
    func showRepositoryDetail(_ model: RepositoryModel) {
        repositoryDetailCoordinator.viewModel.addRepository(model)
        
        let vc = repositoryDetailCoordinator.rootViewController
        vc.title = model.name
        rootViewController.pushViewController(vc, animated: true)
    }
}
